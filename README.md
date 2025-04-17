# SFxLens - Salesforce Automation Explorer

SFxLens is a Salesforce-native tool designed to help developers, admins, and architects understand and optimize automation in Salesforce orgs. It provides a comprehensive view of all automation components (Flows, Apex Triggers, Workflow Rules, Process Builder, etc.) and their relationships.

## Key Features

- **Automation Discovery**: Scan and categorize all automation by object with smart metadata syncing
- **Graphical Visualization**: Interactive schema builder with real-time dependency mapping
- **Impact Analysis**: Predictive dependency tracking between automation components
- **Error & Log Analysis**: AI-powered analysis of automation-related errors
- **Performance Insights**: Monitor automation execution times and identify optimization opportunities

## Modernized Architecture

The project follows a domain-driven, layered architecture designed for scalability:

- **Integration Layer**: Reactive interfaces with Salesforce APIs using streaming and caching
- **Data Layer**: Event-sourced metadata store with real-time updates
- **Service Layer**: Domain-driven services for discovery, analysis, and visualization
- **Presentation Layer**: Composable LWC components with reactive state management
- **User Interfaces**: Context-aware UIs that adapt to user roles and needs

## Microservice Domains

Each domain focuses on a specific business capability:

1. **Automation Discovery Domain**: Responsible for finding and categorizing automations
2. **Dependency Mapping Domain**: Manages relationships between automation components
3. **Performance Analysis Domain**: Analyzes and optimizes automation execution
4. **Visualization Domain**: Renders interactive diagrams and visualizations
5. **Administration Domain**: Handles configuration and security controls

## Development

This project is built using Salesforce DX. To set up your development environment:

1. Clone this repository
2. Set up a Salesforce DX project
3. Create a scratch org: `sf org create scratch -f config/project-scratch-def.json -a SFxLens`
4. Push the source to your scratch org: `sf project deploy start`
5. Assign the permission sets: `sf org assign permset -n SFxLens_Admin`
6. Open the org: `sf org open -r`

## Testing & Quality Assurance

The project uses a comprehensive testing strategy:

- **Unit Tests**: `sf apex test run -c -r human`
- **Integration Tests**: End-to-end test scenarios for key user journeys
- **Performance Tests**: Benchmarking against large orgs
- **Accessibility Tests**: WCAG 2.1 AA compliance validation

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on contributing to this project.

## License

[MIT License](LICENSE.md)
