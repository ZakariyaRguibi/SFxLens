import axios from 'axios';

const API_BASE_URL = process.env.REACT_APP_API_URL || 'http://localhost:5000/api';

const api = axios.create({
  baseURL: API_BASE_URL,
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json',
  }
});

// Flow endpoints
export const getFlows = () => api.get('/flows');

// Apex endpoints
export const getApexTriggers = () => api.get('/apex/triggers');
export const getApexClasses = () => api.get('/apex/classes');

// Log endpoints
export const getLogs = () => api.get('/logs');
export const getLogById = (id: string) => api.get(`/logs/${id}`);
export const analyzeLog = (logId: string) => api.post('/logs/analyze', { logId });

export default api;
