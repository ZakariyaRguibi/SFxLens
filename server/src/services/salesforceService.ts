import jsforce from 'jsforce';
import dotenv from 'dotenv';

dotenv.config();

class SalesforceService {
  private conn: jsforce.Connection;
  private isConnected: boolean = false;

  constructor() {
    this.conn = new jsforce.Connection({
      loginUrl: process.env.SALESFORCE_LOGIN_URL || 'https://login.salesforce.com'
    });
  }

  async connect(): Promise<void> {
    if (this.isConnected) return;

    try {
      await this.conn.login(
        process.env.SALESFORCE_USERNAME as string,
        process.env.SALESFORCE_PASSWORD as string + process.env.SALESFORCE_SECURITY_TOKEN as string
      );
      this.isConnected = true;
      console.log('Connected to Salesforce');
    } catch (error) {
      console.error('Failed to connect to Salesforce:', error);
      throw error;
    }
  }

  async getFlows(): Promise<any[]> {
    await this.connect();
    
    try {
      const result = await this.conn.tooling.query('SELECT Id, ApiName, Label, Description, ProcessType, Status FROM Flow');
      return result.records;
    } catch (error) {
      console.error('Error retrieving flows:', error);
      throw error;
    }
  }

  async getApexTriggers(): Promise<any[]> {
    await this.connect();
    
    try {
      const result = await this.conn.tooling.query('SELECT Id, Name, Body, ApiVersion, Status FROM ApexTrigger');
      return result.records;
    } catch (error) {
      console.error('Error retrieving Apex triggers:', error);
      throw error;
    }
  }

  async getApexClasses(): Promise<any[]> {
    await this.connect();
    
    try {
      const result = await this.conn.tooling.query('SELECT Id, Name, Body, ApiVersion, Status FROM ApexClass');
      return result.records;
    } catch (error) {
      console.error('Error retrieving Apex classes:', error);
      throw error;
    }
  }

  async getDebugLogs(limit: number = 50): Promise<any[]> {
    await this.connect();
    
    try {
      const result = await this.conn.query(`SELECT Id, LogUser.Name, Operation, Status, LogLength, LastModifiedDate FROM ApexLog ORDER BY LastModifiedDate DESC LIMIT ${limit}`);
      return result.records;
    } catch (error) {
      console.error('Error retrieving debug logs:', error);
      throw error;
    }
  }
}

export default new SalesforceService();
