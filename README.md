# SFxLens - Salesforce Automation Analyzer

A Salesforce-native application designed to fetch, display, and analyze all automation in your Salesforce org. It provides a clear overview of flows, Apex triggers, and related classes, along with a log visualization tool to identify errors efficiently.

## Prerequisites

- Salesforce Developer Account / Sandbox
- Salesforce CLI
- VS Code with Salesforce Extension Pack
- Git

## Installation

1. Clone the repository
   ```bash
   git clone <your-repo-url>
   cd SFxLens
   ```

2. Authorize your org
   ```bash
   sf org login web -a SFxLensOrg
   ```
   
3. Deploy the application to your org
   ```bash
   sf project deploy start
   ```

4. Assign the permission set to your user
   ```bash
   sf org assign permset -n SFxLens_Admin
   ```

## Development Workflow

1. Create a scratch org
   ```bash
   sf org create scratch -f config/project-scratch-def.json -a SFxLensDev
   ```

2. Push source to the scratch org
   ```bash
   sf project deploy start
   ```

3. Assign the permission set
   ```bash
   sf org assign permset -n SFxLens_Admin
   ```

4. Open the scratch org
   ```bash
   sf org open
   ```

5. Pull your changes when done
   ```bash
   sf project retrieve start
   ```

## Features

### Automation Discovery
- View all flows, Apex triggers, and classes in your org
- Identify dependencies between automation elements
- Search and filter options

### Log Analyzer
- Analyze debug logs directly within Salesforce
- Visualize execution flow to pinpoint failing automation steps
- Display error details with a structured UI

### UI Features
- Lightning App with tabs for different automation types
- Expandable details for each automation element
- Interactive visualizations for dependencies and execution flows

## Project Components

### Apex Classes
- `AutomationService`: Core service for retrieving automation metadata
- `LogAnalyzerService`: Service for analyzing debug logs
- `FlowController`: Controller for Flow-related operations
- `ApexAnalyzerController`: Controller for Apex analysis operations

### Lightning Web Components
- `automationDashboard`: Main dashboard component
- `flowViewer`: Component for viewing and analyzing flows
- `apexViewer`: Component for viewing Apex triggers and classes
- `logAnalyzer`: Component for analyzing debug logs
- `dependencyVisualizer`: Visual representation of automation dependencies

### Custom Objects
- `Automation_Analysis__c`: Stores analysis results
- `Log_Analysis__c`: Stores log analysis data

## Contributing

1. Create a feature branch
2. Make your changes
3. Submit a pull request

## License

[Your License Information]
