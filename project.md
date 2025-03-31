**Salesforce Automation Viewer - Standalone Web App**

## **Project Overview**
This project is a standalone web application designed to fetch, display, and analyze all automation in a Salesforce instance. It will provide a clear overview of flows, Apex triggers, and related classes, along with a log visualization tool to identify errors efficiently.

## **Technology Stack**
To ensure transferable skills within the Salesforce ecosystem, the following technologies will be used:

### **Frontend**
- **React + TypeScript**: Ensures a modern, scalable UI while maintaining a structure similar to Salesforce’s Lightning Web Components (LWC).
- **Salesforce Lightning Design System (SLDS)**: Provides a Salesforce-native look and feel.

### **Backend**
- **Node.js + Express.js**: A lightweight and scalable backend framework, similar in structure to Salesforce Apex.
- **Salesforce REST & Metadata API**: Used to retrieve automation data from the Salesforce instance.
- **GraphQL (Optional via Apollo Server)**: Enables efficient querying of only the required data.

### **Database (Optional for Caching or Logs)**
- **PostgreSQL**: Provides structured storage for automation metadata and logs, aligning with Salesforce’s SOQL model.
- **Redis**: Caches API responses for better performance.

### **Visualization & Logs**
- **D3.js**: Used for creating interactive flowcharts to represent automation execution.
- **Chart.js / Recharts**: Enables graphical representation of error analytics.

## **Key Features**
### **1. Automation Discovery**
- Fetch all flows, Apex triggers, and classes from Salesforce.
- Identify dependencies between automation elements.
- Provide search and filtering options.

### **2. Log Analyzer**
- Retrieve and analyze error logs using the Salesforce Event Monitoring API.
- Visualize execution flow to pinpoint failing automation steps.
- Display error details with a structured UI.

### **3. UI Features**
- Intuitive dashboard with a list of automations.
- Expandable details for each automation element.
- Clickable logs that highlight the failing process.

## **Next Steps**
1. Set up the project structure with the recommended stack.
2. Implement API connections to Salesforce.
3. Develop the UI for automation listing and log analysis.
4. Build interactive data visualization components.
5. Test and optimize for performance.

