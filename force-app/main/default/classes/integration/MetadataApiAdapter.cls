/**
 * @description Adapter class for interacting with Salesforce Metadata API
 * This class provides methods to retrieve and analyze Flow metadata using the Metadata API.
 * It implements a service layer pattern to abstract the complexity of the Metadata API.
 * 
 * @author Zakaria Rguibi
 * @date 2025
 */
public with sharing class MetadataApiAdapter {
  // Constants
  private static final Integer TIMEOUT = 120000; // 2 minutes
  private static final Integer BATCH_SIZE = 10; // Batch size for processing flows
  private static final String FLOW_TYPE = 'Flow';
  private static final Double API_VERSION = 63.0; // API version for metadata operations

  // Class variables
  private MetadataService.MetadataPort metadataPort;
  private static final Logger LOGGER = new Logger(
    MetadataApiAdapter.class.getName()
  );

  /**
   * @description Constructor that initializes the adapter with security validation
   * Creates a new connection to the Metadata API with proper session headers.
   * @throws SecurityUtils.SecurityException if the user doesn't have adequate permissions
   */
  public MetadataApiAdapter() {
    SecurityUtils.verifyMetadataAccess();
    initializeMetadataPort();
  }

  /**
   * @description Initializes the metadata port with proper session headers
   * Sets up the SOAP web service endpoint with the current user's session ID
   * and configures the timeout value for API calls.
   */
  private void initializeMetadataPort() {
    this.metadataPort = new MetadataService.MetadataPort();
    this.metadataPort.sessionHeader = new MetadataService.SessionHeader_element();
    this.metadataPort.sessionHeader.sessionId = UserInfo.getSessionId();
    this.metadataPort.timeout_x = TIMEOUT;
  }

  /**
   * @description Retrieves metadata for specified Flow API names
   * Makes a direct call to the Metadata API to fetch detailed flow information.
   * Filters out blank flow names from the input list before processing.
   * 
   * @param flowApiNames List of Flow API names to retrieve
   * @return Map of Flow API names to their metadata
   * @throws IllegalArgumentException if flowApiNames is null
   * @throws MetadataApiException if there's an error retrieving the flows
   */
  public Map<String, MetadataService.Flow> retrieveFlows(
    List<String> flowApiNames
  ) {
    // Input validation
    if (flowApiNames == null) {
      throw new IllegalArgumentException('Flow API names list cannot be null');
    }

    SecurityUtils.verifyMetadataAccess();

    if (flowApiNames.isEmpty()) {
      return new Map<String, MetadataService.Flow>();
    }

    Map<String, MetadataService.Flow> resultMap = new Map<String, MetadataService.Flow>();
    List<String> flowsToRetrieve = new List<String>();

    // Filter out blank flow names
    for (String flowName : flowApiNames) {
      if (String.isNotBlank(flowName)) {
        flowsToRetrieve.add(flowName);
      }
    }

    try {
      // Retrieve flows using the apex-mdapi utility
      MetadataService.IReadResult readResult = metadataPort.readMetadata(
        FLOW_TYPE,
        flowsToRetrieve
      );
      MetadataService.Flow[] flows = (MetadataService.Flow[]) readResult.getRecords();
      
      // Process results
      if (flows != null) {
        for (MetadataService.Flow flow : flows) {
          if (flow != null) {
            String apiName = flow.fullName;
            resultMap.put(apiName, flow);
          }
        }
      }

      return resultMap;
    } catch (Exception e) {
      logger.error('Error retrieving flows', e);
      throw new MetadataApiException(
        'Error retrieving flows: ' + e.getMessage(),
        e
      );
    }
  }

  /**
   * @description Retrieves all Flows in the org with optional type filtering
   * First lists all flow API names, then retrieves full metadata in batches
   * to avoid governor limits. Can optionally filter by process type.
   * 
   * @param processType The type of Flow to retrieve (null for all types)
   * @return Map of Flow API names to their metadata
   * @throws MetadataApiException if there's an error in the retrieval process
   */
  public Map<String, MetadataService.Flow> retrieveAllFlows(
    String processType
  ) {
    SecurityUtils.verifyMetadataAccess();

    try {
      // First, list all flows in the org
      List<String> flowNames = listFlowApiNames();
      logger.debug('Found ' + flowNames.size() + ' flows to retrieve');

      // Retrieve flows in batches to avoid hitting governor limits
      Map<String, MetadataService.Flow> allFlows = new Map<String, MetadataService.Flow>();

      for (Integer i = 0; i < flowNames.size(); i += BATCH_SIZE) {
        Integer endIndex = Math.min(i + BATCH_SIZE, flowNames.size());
        List<String> batchNames = new List<String>();
        for (Integer j = i; j < endIndex; j++) {
          batchNames.add(flowNames[j]);
        }

        Map<String, MetadataService.Flow> batchFlows = retrieveFlows(
          batchNames
        );
        allFlows.putAll(batchFlows);
      }

      // Apply process type filter if specified
      if (String.isNotBlank(processType)) {
        Map<String, MetadataService.Flow> filteredFlows = new Map<String, MetadataService.Flow>();
        for (String flowName : allFlows.keySet()) {
          MetadataService.Flow flow = allFlows.get(flowName);
          if (
            flow.processType != null &&
            flow.processType.equalsIgnoreCase(processType)
          ) {
            filteredFlows.put(flowName, flow);
          }
        }
        return filteredFlows;
      }

      return allFlows;
    } catch (Exception e) {
      logger.error('Error retrieving all flows', e);
      throw new MetadataApiException(
        'Error retrieving all flows: ' + e.getMessage(),
        e
      );
    }
  }

  /**
   * @description Retrieves active flows of a specific type
   * Combines retrieveAllFlows with filtering for active status.
   * 
   * @param processType The type of Flow to retrieve (e.g., 'AutoLaunchedFlow', 'Flow', 'Workflow')
   * @return Map of active Flow API names to their metadata
   * @throws IllegalArgumentException if processType is blank
   * @throws MetadataApiException if there's an error in the retrieval process
   */
  public Map<String, MetadataService.Flow> retrieveActiveFlowsByType(
    String processType
  ) {
    if (String.isBlank(processType)) {
      throw new IllegalArgumentException('Process type cannot be blank');
    }

    Map<String, MetadataService.Flow> allFlows = retrieveAllFlows(processType);
    Map<String, MetadataService.Flow> activeFlows = new Map<String, MetadataService.Flow>();

    // Filter for active flows only
    for (String flowName : allFlows.keySet()) {
      MetadataService.Flow flow = allFlows.get(flowName);
      if (flow.status == 'Active') {
        activeFlows.put(flowName, flow);
      }
    }

    return activeFlows;
  }

  /**
   * @description Lists the API names of all Flows in the org
   * Uses the listMetadata API call to get basic information about flows.
   * 
   * @return List of Flow API names
   * @throws MetadataApiException if there's an error listing flows
   */
  private List<String> listFlowApiNames() {
    try {
      MetadataService.ListMetadataQuery query = new MetadataService.ListMetadataQuery();
      query.type_x = FLOW_TYPE;

      MetadataService.FileProperties[] fileProperties = metadataPort.listMetadata(
        new List<MetadataService.ListMetadataQuery>{ query },
        API_VERSION
      );
      
      // TODO: Implement caching mechanism for performance optimization
      // Currently, listing flow names retrieves partial metadata that could be cached
      // to reduce API calls when the same flows are requested multiple times
      
      List<String> flowNames = new List<String>();
      if (fileProperties != null) {
        for (MetadataService.FileProperties file : fileProperties) {
          flowNames.add(file.fullName);
        }
      }

      return flowNames;
    } catch (Exception e) {
      logger.error('Error listing flows', e);
      throw new MetadataApiException(
        'Error listing flows: ' + e.getMessage(),
        e
      );
    }
  }

  /**
   * @description Custom exception for Metadata API errors
   * Used to wrap and differentiate exceptions specific to this class.
   */
  public class MetadataApiException extends Exception {
  }
}