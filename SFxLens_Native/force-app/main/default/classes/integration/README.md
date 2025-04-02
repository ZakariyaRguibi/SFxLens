# Integration Layer

This layer is responsible for interfacing with Salesforce APIs to retrieve and analyze automation metadata.

## Components:
- **Metadata Retriever**: Interfaces with Salesforce APIs to fetch automation metadata
- **Automation Parser**: Analyzes raw metadata to extract relationships and dependencies
- **Log Analyzer**: Processes debug logs to identify performance patterns and errors

## Recommended Classes

### Metadata Retriever
- `MetadataService.cls` - Core service that handles metadata API interactions
- `ToolingApiService.cls` - Service for interacting with the Tooling API
- `FlowMetadataRetriever.cls` - Retrieves Flow definitions and versions
- `ApexMetadataRetriever.cls` - Retrieves Apex classes and triggers
- `WorkflowMetadataRetriever.cls` - Retrieves Workflow Rules and actions
- `CustomMetadataRetriever.cls` - Retrieves Custom Metadata Types

### Automation Parser
- `AutomationParserService.cls` - Primary service for parsing metadata into usable structures
- `FlowParser.cls` - Parses Flow XML definitions into structured data
- `ApexParser.cls` - Extracts key information from Apex code
- `WorkflowParser.cls` - Parses Workflow Rules into structured data
- `MetadataTransformer.cls` - Transforms API responses into standardized formats

### Log Analyzer
- `LogApiService.cls` - Retrieves and processes debug logs via API
- `LogStreamingService.cls` - Handles real-time log streaming via Platform Events
- `LogExtractor.cls` - Extracts relevant data from raw log files
- `LogDataNormalizer.cls` - Normalizes log data for consistent processing

### Utility Classes
- `ApiRateLimiter.cls` - Manages API call volumes and respects limits
- `AuthenticationManager.cls` - Handles authentication for API calls
- `IntegrationExceptionHandler.cls` - Standardized exception handling for API calls
- `BatchMetadataProcessor.cls` - Processes large metadata sets in batches
