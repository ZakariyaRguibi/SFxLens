public with sharing class ApexMetadataRetriever {
  private ToolingApiService toolingApiService;
  //private MetadataService metadataService;

  /**
   * Constructor with dependency injection for testability
   * @param toolingApiService The service for Tooling API interactions
   * @param metadataService The service for Metadata API interactions
   */
  //   public ApexMetadataRetriever(
  //     ToolingApiService toolingApiService,
  //     MetadataService metadataService
  //   ) {
  //     this.toolingApiService = toolingApiService;
  //     this.metadataService = metadataService;
  //   }

  /**
   * Default constructor
   */
  public ApexMetadataRetriever() {
    this.toolingApiService = new ToolingApiService();
    //this.metadataService = new MetadataService();
  }

  /**
   * Retrieves metadata for Apex classes
   * @param maxRecords Maximum number of records to retrieve (default 100)
   * @param offset Pagination offset for retrieving large datasets
   * @return List of metadata information for Apex classes
   * @throws MetadataRetrievalException if there is an error retrieving the metadata
   */
  public List<Map<String, Object>> getApexClasses(
    Integer maxRecords,
    Integer offset
  ) {
    try {
      String query =
        'SELECT Id, Name, Body, ApiVersion, Status, IsValid, ' +
        'NamespacePrefix, LengthWithoutComments ' +
        'FROM ApexClass ' +
        'ORDER BY Name ASC ' +
        'LIMIT :maxRecords OFFSET :offset';

      return toolingApiService.executeQuery(query);
    } catch (Exception e) {
      throw new MetadataRetrievalException(
        'Error retrieving Apex classes: ' + e.getMessage(),
        e
      );
    }
  }

  /**
   * Retrieves metadata for Apex classes (default pagination)
   * @return List of metadata information for Apex classes
   * @throws MetadataRetrievalException if there is an error retrieving the metadata
   */
  public List<Map<String, Object>> getApexClasses() {
    return getApexClasses(100, 0);
  }

  /**
   * Retrieves metadata for Apex triggers
   * @param maxRecords Maximum number of records to retrieve (default 100)
   * @param offset Pagination offset for retrieving large datasets
   * @return List of metadata information for Apex triggers
   * @throws MetadataRetrievalException if there is an error retrieving the metadata
   */
  public List<Map<String, Object>> getApexTriggers(
    Integer maxRecords,
    Integer offset
  ) {
    try {
      String query =
        'SELECT Id, Name, Body, ApiVersion, Status, IsValid, ' +
        'TableEnumOrId, UsageBeforeInsert, UsageAfterInsert, NamespacePrefix, ' +
        'UsageBeforeUpdate, UsageAfterUpdate, UsageBeforeDelete, ' +
        'UsageAfterDelete, UsageAfterUndelete ' +
        'FROM ApexTrigger ' +
        'ORDER BY Name ASC ' +
        'LIMIT ' + maxRecords + ' OFFSET ' + offset;
    
        System.debug('Query: ' + query);
      return toolingApiService.executeQuery(query);
    } catch (Exception e) {
      throw new MetadataRetrievalException(
        'Error retrieving Apex triggers: ' + e.getMessage(),
        e
      );
    }
  }

  /**
   * Retrieves metadata for Apex triggers (default pagination)
   * @return List of metadata information for Apex triggers
   * @throws MetadataRetrievalException if there is an error retrieving the metadata
   */
  public List<Map<String, Object>> getApexTriggers() {
    return getApexTriggers(100, 0);
  }

  /**
   * Retrieves metadata for a specific Apex component by API name
   * @param apiName The API name of the component
   * @param componentType The type of component (Class, Trigger, etc.)
   * @return Metadata information for the specified component
   * @throws MetadataRetrievalException if there is an error retrieving the metadata
   * @throws IllegalArgumentException if apiName or componentType is null or empty
   */
  public Map<String, Object> getComponentByApiName(
    String apiName,
    String componentType
  ) {
    if (String.isBlank(apiName)) {
      throw new IllegalArgumentException('API name cannot be null or empty');
    }

    if (String.isBlank(componentType)) {
      throw new IllegalArgumentException(
        'Component type cannot be null or empty'
      );
    }

    try {
      String soqlTable = determineTableFromComponentType(componentType);
      String query =
        'SELECT Id, Name, Body, ApiVersion, Status, IsValid ' +
        'FROM ' +
        soqlTable +
        ' ' +
        'WHERE Name = :apiName ' +
        'LIMIT 1';

      List<Map<String, Object>> results = toolingApiService.executeQuery(query);
      return !results.isEmpty() ? results[0] : null;
    } catch (Exception e) {
      throw new MetadataRetrievalException(
        'Error retrieving component by API name: ' + e.getMessage(),
        e
      );
    }
  }

  /**
   * Retrieves metadata for a specific Apex class by API name
   * @param apiName The API name of the Apex class
   * @return Metadata information for the specified Apex class
   * @throws MetadataRetrievalException if there is an error retrieving the metadata
   */
  public Map<String, Object> getApexClassByApiName(String apiName) {
    return getComponentByApiName(apiName, 'Class');
  }

  /**
   * Retrieves metadata for a specific Apex trigger by API name
   * @param apiName The API name of the Apex trigger
   * @return Metadata information for the specified Apex trigger
   * @throws MetadataRetrievalException if there is an error retrieving the metadata
   */
  public Map<String, Object> getApexTriggerByApiName(String apiName) {
    return getComponentByApiName(apiName, 'Trigger');
  }

  /**
   * Searches for Apex components matching the specified criteria
   * @param searchCriteria The search criteria to filter components
   * @param componentType The type of component to search (Class, Trigger, or null for both)
   * @param maxRecords Maximum number of records to retrieve
   * @return List of metadata information for matching components
   * @throws MetadataRetrievalException if there is an error retrieving the metadata
   */
  public List<Map<String, Object>> searchComponents(
    Map<String, Object> searchCriteria,
    String componentType,
    Integer maxRecords
  ) {
    if (searchCriteria == null || searchCriteria.isEmpty()) {
      throw new IllegalArgumentException(
        'Search criteria cannot be null or empty'
      );
    }

    try {
      List<String> whereConditions = new List<String>();
      String soqlTable = (String.isBlank(componentType))
        ? 'ApexClass'
        : determineTableFromComponentType(componentType);

      // Build WHERE conditions from search criteria
      for (String key : searchCriteria.keySet()) {
        Object value = searchCriteria.get(key);
        if (value instanceof String) {
          whereConditions.add(
            key +
              ' LIKE \'%' +
              String.escapeSingleQuotes((String) value) +
              '%\''
          );
        } else {
          whereConditions.add(key + ' = ' + value);
        }
      }

      String whereClause = String.join(whereConditions, ' AND ');

      String query =
        'SELECT Id, Name, Body, ApiVersion, Status, IsValid ' +
        'FROM ' +
        soqlTable +
        ' ' +
        'WHERE ' +
        whereClause +
        ' ' +
        'ORDER BY Name ASC ' +
        'LIMIT ' +
        (maxRecords != null ? maxRecords : 100);

      return toolingApiService.executeQuery(query);
    } catch (Exception e) {
      throw new MetadataRetrievalException(
        'Error searching components: ' + e.getMessage(),
        e
      );
    }
  }

  /**
   * Searches for Apex components matching the specified criteria (with default limits)
   * @param searchCriteria The search criteria to filter components
   * @return List of metadata information for matching components
   * @throws MetadataRetrievalException if there is an error retrieving the metadata
   */
  public List<Map<String, Object>> searchComponents(
    Map<String, Object> searchCriteria
  ) {
    return searchComponents(searchCriteria, null, 100);
  }

  /**
   * Finds Apex classes that reference a specific string or pattern
   * @param searchText The text to search for in the body of Apex classes
   * @param maxRecords Maximum number of records to retrieve
   * @return List of Apex classes that contain the search text
   * @throws MetadataRetrievalException if there is an error retrieving the metadata
   */
  public List<Map<String, Object>> findClassesWithReference(
    String searchText,
    Integer maxRecords
  ) {
    if (String.isBlank(searchText)) {
      throw new IllegalArgumentException('Search text cannot be null or empty');
    }

    Map<String, Object> criteria = new Map<String, Object>{
      'Body' => searchText
    };

    return searchComponents(criteria, 'Class', maxRecords);
  }

  /**
   * Finds Apex triggers that reference a specific field or object
   * @param objectName The API name of the object to search for in triggers
   * @return List of Apex triggers associated with the specified object
   * @throws MetadataRetrievalException if there is an error retrieving the metadata
   */
  public List<Map<String, Object>> findTriggersForObject(String objectName) {
    if (String.isBlank(objectName)) {
      throw new IllegalArgumentException('Object name cannot be null or empty');
    }

    try {
      String query =
        'SELECT Id, Name, Body, ApiVersion, Status, IsValid, ' +
        'TableEnumOrId ' +
        'FROM ApexTrigger ' +
        'WHERE TableEnumOrId = :objectName ' +
        'ORDER BY Name ASC';

      return toolingApiService.executeQuery(query);
    } catch (Exception e) {
      throw new MetadataRetrievalException(
        'Error finding triggers for object: ' + e.getMessage(),
        e
      );
    }
  }

  /**
   * Determines the appropriate SOQL table name based on component type
   * @param componentType The type of component (e.g., Class, Trigger)
   * @return The table name to use in SOQL queries
   */
  private String determineTableFromComponentType(String componentType) {
    switch on componentType.toLowerCase() {
      when 'class' {
        return 'ApexClass';
      }
      when 'trigger' {
        return 'ApexTrigger';
      }
      when else {
        throw new IllegalArgumentException(
          'Unsupported component type: ' + componentType
        );
      }
    }
  }

  /**
   * Custom exception for metadata retrieval errors
   */
  public class MetadataRetrievalException extends Exception {
  }
}
