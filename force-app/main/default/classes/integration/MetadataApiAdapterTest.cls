/**
 * @description Test class for MetadataApiAdapter
 * This class tests the functionality of the MetadataApiAdapter which interacts with 
 * the Salesforce Metadata API to retrieve Flow metadata. The tests use WebServiceMock
 * to simulate API responses without making actual callouts.
 * 
 * @author Zakaria Rguibi
 * @date 2025
 */
@IsTest
private class MetadataApiAdapterTest {
  // Constants for testing
  private static final String TEST_FLOW_1 = 'TestFlow_1';
  private static final String TEST_FLOW_2 = 'TestFlow_2';
  private static final String AUTO_LAUNCHED_FLOW = 'AutoLaunchedFlow';


  /**
   * @description Tests the constructor and initialization of the adapter
   * Verifies that the adapter can be instantiated successfully with
   * proper WebServiceMock configuration.
   */
  @IsTest
  static void testConstructor() {
    Test.startTest();
    // Set up WebServiceMock instead of HttpCalloutMock
    Test.setMock(WebServiceMock.class, new MetadataServiceMock());
    
    MetadataApiAdapter adapter = new MetadataApiAdapter();

    System.assertNotEquals(null, adapter, 'Adapter should be initialized');
    Test.stopTest();
  }

  /**
   * @description Tests retrieving flows with success
   * Verifies that the adapter correctly retrieves and maps flow metadata
   * when provided with a list of flow API names.
   */
  @IsTest
  static void testRetrieveFlowsSuccess() {
    Test.startTest();
    // Set up WebServiceMock for retrieving flows
    Test.setMock(WebServiceMock.class, new MetadataServiceMock());
    
    MetadataApiAdapter adapter = new MetadataApiAdapter();
    Map<String, MetadataService.Flow> flows = adapter.retrieveFlows(
      new List<String>{ TEST_FLOW_1, TEST_FLOW_2 }
    );

    System.assertEquals(2, flows.size(), 'Should retrieve 2 flows');
    System.assert(flows.containsKey(TEST_FLOW_1), 'Should contain ' + TEST_FLOW_1);
    System.assert(flows.containsKey(TEST_FLOW_2), 'Should contain ' + TEST_FLOW_2);
    
    // Verify flow properties
    MetadataService.Flow flow1 = flows.get(TEST_FLOW_1);
    System.assertEquals('Active', flow1.status, 'Flow 1 status should be Active');
    System.assertEquals(AUTO_LAUNCHED_FLOW, flow1.processType, 'Flow 1 should be AutoLaunchedFlow');
    
    Test.stopTest();
  }

  /**
   * @description Tests retrieving flows with empty list
   * Verifies that the adapter handles an empty list of flow API names gracefully
   * by returning an empty map without errors.
   */
  @IsTest
  static void testRetrieveFlowsEmptyList() {
    Test.startTest();
    // Set up WebServiceMock
    Test.setMock(WebServiceMock.class, new MetadataServiceMock());
    
    MetadataApiAdapter adapter = new MetadataApiAdapter();
    Map<String, MetadataService.Flow> flows = adapter.retrieveFlows(
      new List<String>{}
    );

    System.assertEquals(
      0,
      flows.size(),
      'Should return empty map for empty input'
    );
    Test.stopTest();
  }

  /**
   * @description Tests retrieving flows with null input
   * Verifies that the adapter throws an appropriate exception with a descriptive
   * message when provided with a null list of flow API names.
   */
  @IsTest
  static void testRetrieveFlowsNullInput() {
    Test.startTest();
    // Set up WebServiceMock
    Test.setMock(WebServiceMock.class, new MetadataServiceMock());
    
    MetadataApiAdapter adapter = new MetadataApiAdapter();

    Boolean exceptionThrown = false;
    try {
      Map<String, MetadataService.Flow> flows = adapter.retrieveFlows(null);
    } catch (IllegalArgumentException e) {
      exceptionThrown = true;
      System.assert(e.getMessage().contains('cannot be null'), 'Exception message should indicate null input');
    }

    System.assert(
      exceptionThrown,
      'Should throw IllegalArgumentException for null input'
    );
    Test.stopTest();
  }

  /**
   * @description Tests retrieving all flows without filtering
   * Verifies that the adapter can retrieve all flows in the org
   * when no process type filter is specified (null parameter).
   */
  @IsTest
  static void testRetrieveAllFlows() {
    Test.startTest();
    // Set up WebServiceMock
    Test.setMock(WebServiceMock.class, new MetadataServiceMock());
    
    MetadataApiAdapter adapter = new MetadataApiAdapter();
    Map<String, MetadataService.Flow> flows = adapter.retrieveAllFlows(null);

    System.assertNotEquals(0, flows.size(), 'Should retrieve flows');
    System.assertEquals(2, flows.size(), 'Should retrieve all flows');
    System.assert(flows.containsKey(TEST_FLOW_1), 'Should contain ' + TEST_FLOW_1);
    System.assert(flows.containsKey(TEST_FLOW_2), 'Should contain ' + TEST_FLOW_2);
    Test.stopTest();
  }

  /**
   * @description Tests retrieving all flows with filter by process type
   * Verifies that when a process type filter is specified, only flows
   * of that type are returned in the result map.
   */
  @IsTest
  static void testRetrieveAllFlowsWithFilter() {
    Test.startTest();
    // Set up WebServiceMock
    Test.setMock(WebServiceMock.class, new MetadataServiceMock());
    
    MetadataApiAdapter adapter = new MetadataApiAdapter();
    Map<String, MetadataService.Flow> flows = adapter.retrieveAllFlows(AUTO_LAUNCHED_FLOW);

    System.assertEquals(1, flows.size(), 'Should retrieve only AutoLaunchedFlow flows');
    System.assert(flows.containsKey(TEST_FLOW_1), 'Should contain ' + TEST_FLOW_1);
    System.assert(!flows.containsKey(TEST_FLOW_2), 'Should not contain ' + TEST_FLOW_2);
    Test.stopTest();
  }

  /**
   * @description Tests retrieving active flows by type
   * Verifies that the adapter correctly filters flows by both
   * process type and active status.
   */
  @IsTest
  static void testRetrieveActiveFlowsByType() {
    Test.startTest();
    // Set up WebServiceMock
    Test.setMock(WebServiceMock.class, new MetadataServiceMock());
    
    MetadataApiAdapter adapter = new MetadataApiAdapter();
    Map<String, MetadataService.Flow> flows = adapter.retrieveActiveFlowsByType(AUTO_LAUNCHED_FLOW);

    System.assertEquals(1, flows.size(), 'Should retrieve active AutoLaunchedFlow flows');
    System.assert(flows.containsKey(TEST_FLOW_1), 'Should contain ' + TEST_FLOW_1);
    Test.stopTest();
  }

  /**
   * @description Tests retrieving active flows by type with blank parameter
   * Verifies that the adapter throws an appropriate exception when
   * provided with a blank process type string.
   */
  @IsTest
  static void testRetrieveActiveFlowsByTypeBlankInput() {
    Test.startTest();
    // Set up WebServiceMock
    Test.setMock(WebServiceMock.class, new MetadataServiceMock());
    
    MetadataApiAdapter adapter = new MetadataApiAdapter();

    Boolean exceptionThrown = false;
    try {
      Map<String, MetadataService.Flow> flows = adapter.retrieveActiveFlowsByType('');
    } catch (IllegalArgumentException e) {
      exceptionThrown = true;
      System.assert(e.getMessage().contains('cannot be blank'), 'Exception message should indicate blank input');
    }

    System.assert(
      exceptionThrown,
      'Should throw IllegalArgumentException for blank input'
    );
    Test.stopTest();
  }

  /**
   * @description Tests error handling in retrieving flows
   * Verifies that the adapter correctly handles and wraps exceptions
   * that occur during the Metadata API callout process.
   */
  @IsTest
  static void testRetrieveFlowsError() {
    Test.startTest();
    // Set up error mock for WebServiceMock
    Test.setMock(WebServiceMock.class, new MetadataServiceErrorMock());
    
    MetadataApiAdapter adapter = new MetadataApiAdapter();
    
    Boolean exceptionThrown = false;
    try {
      Map<String, MetadataService.Flow> flows = adapter.retrieveFlows(
        new List<String>{ TEST_FLOW_1 }
      );
    } catch (MetadataApiAdapter.MetadataApiException e) {
      exceptionThrown = true;
      System.assert(e.getMessage().contains('Error retrieving flows'), 'Exception message should indicate retrieval error');
    }
    
    System.assert(
      exceptionThrown,
      'Should throw MetadataApiException on error'
    );
    Test.stopTest();
  }

  /**
   * @description WebServiceMock implementation for MetadataService
   * This class simulates responses from the Metadata API without making actual callouts.
   * It handles both readMetadata and listMetadata requests by returning predefined mock data.
   */
  public class MetadataServiceMock implements WebServiceMock {
    /**
     * @description Main method that gets invoked by the Salesforce test framework
     * Routes the request to the appropriate handler method based on the request type.
     */
    public void doInvoke(
      Object stub, Object request, Map<String, Object> response,
      String endpoint, String soapAction, String requestName,
      String responseNS, String responseName, String responseType
    ) {
      if (request instanceof MetadataService.readMetadata_element) {
        handleReadMetadataRequest((MetadataService.readMetadata_element)request, response);
      } else if (request instanceof MetadataService.listMetadata_element) {
        handleListMetadataRequest((MetadataService.listMetadata_element)request, response);
      }
    }
    
    /**
     * @description Handles readMetadata requests by creating mock Flow records
     * Creates and returns test Flow metadata with predefined properties.
     */
    private void handleReadMetadataRequest(MetadataService.readMetadata_element request, Map<String, Object> response) {
      // Create response for readMetadata
      MetadataService.readFlowResponse_element readResponse = new MetadataService.readFlowResponse_element();
      
      // Create read result with Flows
      MetadataService.ReadFlowResult result = new MetadataService.ReadFlowResult();
      List<MetadataService.Flow> flowsList = new List<MetadataService.Flow>();
      
      // Create first test Flow
      MetadataService.Flow flow1 = new MetadataService.Flow();
      flow1.fullName = TEST_FLOW_1;
      flow1.apiVersion = 63.0;
      flow1.status = 'Active';
      flow1.processType = AUTO_LAUNCHED_FLOW;
      flow1.label = 'Test Flow 1';
      flow1.description = 'Test Flow 1 Description';
      flowsList.add(flow1);
      
      // Create second test Flow
      MetadataService.Flow flow2 = new MetadataService.Flow();
      flow2.fullName = TEST_FLOW_2;
      flow2.apiVersion = 63.0;
      flow2.status = 'Active';
      flow2.processType = 'Flow';
      flow2.label = 'Test Flow 2';
      flow2.description = 'Test Flow 2 Description';
      flowsList.add(flow2);
      
      // Add flows to the result - convert List to Array properly
      MetadataService.Flow[] flowsArray = new MetadataService.Flow[]{};
      flowsArray.addAll(flowsList);
      result.records = flowsArray;
      
      // Set the result - no cast needed when using the type-specific response element
      readResponse.result = result;
      
      // Set the response
      response.put('response_x', readResponse);
    }
    
    /**
     * @description Handles listMetadata requests by creating mock FileProperties records
     * Creates and returns test FileProperties metadata with predefined properties.
     */
    private void handleListMetadataRequest(MetadataService.listMetadata_element request, Map<String, Object> response) {
      // Create response for listMetadata
      MetadataService.listMetadataResponse_element listResponse = new MetadataService.listMetadataResponse_element();
      
      List<MetadataService.FileProperties> filePropslist = new List<MetadataService.FileProperties>();
      
      // Create first file property
      MetadataService.FileProperties prop1 = new MetadataService.FileProperties();
      prop1.fullName = TEST_FLOW_1;
      prop1.fileName = 'flows/' + TEST_FLOW_1 + '.flow';
      prop1.type_x = 'Flow';
      prop1.createdDate = Datetime.now();
      prop1.lastModifiedDate = Datetime.now();
      filePropslist.add(prop1);
      
      // Create second file property
      MetadataService.FileProperties prop2 = new MetadataService.FileProperties();
      prop2.fullName = TEST_FLOW_2;
      prop2.fileName = 'flows/' + TEST_FLOW_2 + '.flow';
      prop2.type_x = 'Flow';
      prop2.createdDate = Datetime.now();
      prop2.lastModifiedDate = Datetime.now();
      filePropslist.add(prop2);
      
      // Add file properties to the result - convert List to Array properly
      MetadataService.FileProperties[] filePropsArray = new MetadataService.FileProperties[]{};
      filePropsArray.addAll(filePropslist);
      listResponse.result = filePropsArray;
      
      // Set the response
      response.put('response_x', listResponse);
    }
  }
  
  /**
   * @description WebServiceMock implementation to simulate errors
   * This class forces a CalloutException to test error handling in the adapter.
   * 
   * TODO: Consider expanding to simulate different types of errors (timeout, auth failure, etc.)
   */
  public class MetadataServiceErrorMock implements WebServiceMock {
    /**
     * @description Simulates a service failure by throwing an exception
     */
    public void doInvoke(
      Object stub, Object request, Map<String, Object> response,
      String endpoint, String soapAction, String requestName,
      String responseNS, String responseName, String responseType
    ) {
      // Simulate a failure by throwing an exception
      throw new CalloutException('Mock error: Service unavailable');
    }
  }
}