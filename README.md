# SFxLens - Salesforce Automation Viewer

A standalone web application designed to fetch, display, and analyze all automation in a Salesforce instance. It provides a clear overview of flows, Apex triggers, and related classes, along with a log visualization tool to identify errors efficiently.

## Prerequisites

- Node.js (v16 or newer)
- npm or yarn
- Salesforce Developer Account with API access

## Installation

1. Clone the repository
   ```bash
   git clone <your-repo-url>
   cd SFxLens
   ```

2. Set up the server
   ```bash
   cd server
   npm install
   ```

3. Set up the client
   ```bash
   cd ../client
   npm install
   ```

4. Configure environment variables
   ```bash
   cd ../server
   cp .env.example .env
   ```
   Edit the `.env` file with your Salesforce credentials:
   ```
   SALESFORCE_LOGIN_URL=https://login.salesforce.com
   SALESFORCE_USERNAME=your_sf_username
   SALESFORCE_PASSWORD=your_sf_password
   SALESFORCE_SECURITY_TOKEN=your_security_token
   ```

## Running the Application

### Development Mode

1. Start the server
   ```bash
   cd server
   npm run dev
   ```
   This will start the server at http://localhost:5000

2. In a new terminal, start the client
   ```bash
   cd client
   npm start
   ```
   This will start the React app at http://localhost:3000

### Production Build

1. Build the server
   ```bash
   cd server
   npm run build
   ```

2. Build the client
   ```bash
   cd client
   npm run build
   ```

3. Run the server in production mode
   ```bash
   cd server
   npm start
   ```

## Features

### Automation Discovery
- Fetch all flows, Apex triggers, and classes from Salesforce
- Identify dependencies between automation elements
- Search and filter options

### Log Analyzer
- Retrieve and analyze error logs using the Salesforce Event Monitoring API
- Visualize execution flow to pinpoint failing automation steps
- Display error details with a structured UI

### UI Features
- Intuitive dashboard with a list of automations
- Expandable details for each automation element
- Clickable logs that highlight the failing process

## Technology Stack

### Frontend
- React + TypeScript
- Salesforce Lightning Design System (SLDS)
- D3.js & Chart.js for visualizations

### Backend
- Node.js + Express.js
- Salesforce REST & Metadata API

## Contributing

1. Create a feature branch
2. Make your changes
3. Submit a pull request

## License

[Your License Information]
