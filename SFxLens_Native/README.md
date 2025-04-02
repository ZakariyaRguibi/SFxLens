# SFxLens - Salesforce Automation Explorer

SFxLens is a Salesforce-native tool designed to help developers, admins, and architects understand and optimize automation in Salesforce orgs. It provides a comprehensive view of all automation components (Flows, Apex Triggers, Workflow Rules, etc.) and their relationships.

## Key Features

- **Automation Discovery**: Scan and categorize all automation by object
- **Graphical Visualization**: Interactive schema builder for automation
- **Impact Analysis**: Track dependencies between automation components
- **Error & Log Analysis**: Centralized view of automation-related errors
- **Performance Insights**: Monitor automation execution times and identify inefficiencies

## Project Structure

The project follows a layered architecture:

- **Integration Layer**: Interfaces with Salesforce APIs
- **Data Layer**: Stores metadata and analysis results
- **Service Layer**: Provides discovery, analysis, and visualization services
- **Presentation Layer**: LWC UI components and visualization
- **User Interfaces**: End-user interfaces for exploring and analyzing automation

## Development

This project is built using Salesforce DX. To set up your development environment:

1. Clone this repository
2. Set up a Salesforce DX project
3. Create a scratch org: `sfdx force:org:create -f config/project-scratch-def.json -a SFxLens`
4. Push the source to your scratch org: `sfdx force:source:push`
5. Assign the permission sets: `sfdx force:user:permset:assign -n SFxLens_Admin`
6. Open the org: `sfdx force:org:open`

## Testing

Run tests with: `sfdx force:apex:test:run -r human`

## Contributing

See CONTRIBUTING.md for guidelines on contributing to this project.
