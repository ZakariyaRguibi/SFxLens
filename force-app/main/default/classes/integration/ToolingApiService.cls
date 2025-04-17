public with sharing class ToolingApiService {
  private static final String TOOLING_API_ENDPOINT = '/services/data/v59.0/tooling/query/';
  private static final String HTTP_GET = 'GET';
  private static final Integer TIMEOUT = 120000; // 2 minutes

  /**
   * Executes a SOQL query against the Tooling API
   * @param query The SOQL query to execute
   * @return List of records as Map<String, Object> where each map represents a record
   * @throws ToolingApiException if there is an error executing the query
   */
  public List<Map<String, Object>> executeQuery(String query) {
    if (String.isBlank(query)) {
      throw new ToolingApiException('Query cannot be null or empty');
    }
    // try {
    //     // Setup HTTP request
    //     HttpRequest req = new HttpRequest();
    //     req.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() +
    //                    TOOLING_API_ENDPOINT +
    //                    '?q=' + EncodingUtil.urlEncode(query, 'UTF-8'));
    //     req.setMethod(HTTP_GET);
    //     req.setTimeout(TIMEOUT);
    //     req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
    //     req.setHeader('Content-Type', 'application/json');

    //     // Execute HTTP request
    //     Http http = new Http();
    //     HttpResponse res = http.send(req);

    //     // Process response
    //     if (res.getStatusCode() >= 200 && res.getStatusCode() < 300) {
    //         return processSuccessResponse(res.getBody());
    //     } else {
    //         throw new ToolingApiException('HTTP error: ' + res.getStatusCode() + ' ' + res.getStatus() + ' - ' + res.getBody());
    //     }
    // } catch (Exception e) {
    //     throw new ToolingApiException('Error executing Tooling API query: ' + e.getMessage(), e);
    // }
    try {
      //execute the query as a normal SOQL query
      List<SObject> records = Database.query(query);
      List<Map<String, Object>> result = new List<Map<String, Object>>();
      for (SObject record : records) {
        Map<String, Object> recordMap = new Map<String, Object>();
        for (
          String fieldName : record.getSObjectType()
            .getDescribe()
            .fields.getMap()
            .keySet()
        ) {
          try {
            recordMap.put(fieldName, record.get(fieldName));
          } catch (Exception e) {
            // Skip fields that can't be accessed
            System.debug(
              'Could not access field: ' + fieldName + ' - ' + e.getMessage()
            );
          }
        }
        result.add(recordMap);
      }
      return result;
    } catch (Exception e) {
      throw new ToolingApiException(
        'Error executing Tooling API query: ' + e.getMessage(),
        e
      );
    }
  }

  // /**
  //  * Process successful API response and convert to list of records
  //  * @param responseBody JSON response body from the API
  //  * @return List of records as Map<String, Object>
  //  */
  // private List<Map<String, Object>> processSuccessResponse(String responseBody) {
  //     List<Map<String, Object>> records = new List<Map<String, Object>>();

  //     // Parse JSON response
  //     Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(responseBody);

  //     // Extract records
  //     if (responseMap.containsKey('records')) {
  //         List<Object> recordsList = (List<Object>)responseMap.get('records');
  //         for (Object record : recordsList) {
  //             records.add((Map<String, Object>)record);
  //         }
  //     }

  //     return records;
  // }

  // /**
  //  * Makes a call to create a record via the Tooling API
  //  * @param objectName The API name of the object to create
  //  * @param fields Map of field names to values
  //  * @return The ID of the created record
  //  * @throws ToolingApiException if there is an error creating the record
  //  */
  // public String createRecord(String objectName, Map<String, Object> fields) {
  //     if (String.isBlank(objectName)) {
  //         throw new ToolingApiException('Object name cannot be null or empty');
  //     }

  //     if (fields == null || fields.isEmpty()) {
  //         throw new ToolingApiException('Fields cannot be null or empty');
  //     }

  //     try {
  //         // Setup HTTP request
  //         HttpRequest req = new HttpRequest();
  //         req.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() +
  //                        '/services/data/v59.0/tooling/sobjects/' + objectName);
  //         req.setMethod('POST');
  //         req.setTimeout(TIMEOUT);
  //         req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
  //         req.setHeader('Content-Type', 'application/json');
  //         req.setBody(JSON.serialize(fields));

  //         // Execute HTTP request
  //         Http http = new Http();
  //         HttpResponse res = http.send(req);

  //         // Process response
  //         if (res.getStatusCode() >= 200 && res.getStatusCode() < 300) {
  //             Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
  //             return (String)responseMap.get('id');
  //         } else {
  //             throw new ToolingApiException('HTTP error: ' + res.getStatusCode() + ' ' + res.getStatus() + ' - ' + res.getBody());
  //         }
  //     } catch (Exception e) {
  //         throw new ToolingApiException('Error creating record via Tooling API: ' + e.getMessage(), e);
  //     }
  // }

  // /**
  //  * Makes a call to update a record via the Tooling API
  //  * @param objectName The API name of the object to update
  //  * @param recordId The ID of the record to update
  //  * @param fields Map of field names to values
  //  * @throws ToolingApiException if there is an error updating the record
  //  */
  // public void updateRecord(String objectName, String recordId, Map<String, Object> fields) {
  //     if (String.isBlank(objectName)) {
  //         throw new ToolingApiException('Object name cannot be null or empty');
  //     }

  //     if (String.isBlank(recordId)) {
  //         throw new ToolingApiException('Record ID cannot be null or empty');
  //     }

  //     if (fields == null || fields.isEmpty()) {
  //         throw new ToolingApiException('Fields cannot be null or empty');
  //     }

  //     try {
  //         // Setup HTTP request
  //         HttpRequest req = new HttpRequest();
  //         req.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() +
  //                        '/services/data/v59.0/tooling/sobjects/' + objectName + '/' + recordId);
  //         req.setMethod('PATCH');
  //         req.setTimeout(TIMEOUT);
  //         req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
  //         req.setHeader('Content-Type', 'application/json');
  //         req.setBody(JSON.serialize(fields));

  //         // Execute HTTP request
  //         Http http = new Http();
  //         HttpResponse res = http.send(req);

  //         // Process response
  //         if (res.getStatusCode() >= 200 && res.getStatusCode() < 300) {
  //             // Success - no return value needed
  //         } else {
  //             throw new ToolingApiException('HTTP error: ' + res.getStatusCode() + ' ' + res.getStatus() + ' - ' + res.getBody());
  //         }
  //     } catch (Exception e) {
  //         throw new ToolingApiException('Error updating record via Tooling API: ' + e.getMessage(), e);
  //     }
  // }

  // /**
  //  * Makes a call to delete a record via the Tooling API
  //  * @param objectName The API name of the object
  //  * @param recordId The ID of the record to delete
  //  * @throws ToolingApiException if there is an error deleting the record
  //  */
  // public void deleteRecord(String objectName, String recordId) {
  //     if (String.isBlank(objectName)) {
  //         throw new ToolingApiException('Object name cannot be null or empty');
  //     }

  //     if (String.isBlank(recordId)) {
  //         throw new ToolingApiException('Record ID cannot be null or empty');
  //     }

  //     try {
  //         // Setup HTTP request
  //         HttpRequest req = new HttpRequest();
  //         req.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() +
  //                        '/services/data/v59.0/tooling/sobjects/' + objectName + '/' + recordId);
  //         req.setMethod('DELETE');
  //         req.setTimeout(TIMEOUT);
  //         req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());

  //         // Execute HTTP request
  //         Http http = new Http();
  //         HttpResponse res = http.send(req);

  //         // Process response
  //         if (res.getStatusCode() >= 200 && res.getStatusCode() < 300) {
  //             // Success - no return value needed
  //         } else {
  //             throw new ToolingApiException('HTTP error: ' + res.getStatusCode() + ' ' + res.getStatus() + ' - ' + res.getBody());
  //         }
  //     } catch (Exception e) {
  //         throw new ToolingApiException('Error deleting record via Tooling API: ' + e.getMessage(), e);
  //     }
  // }

  /**
   * Custom exception for Tooling API errors
   */
  public class ToolingApiException extends Exception {
  }
}