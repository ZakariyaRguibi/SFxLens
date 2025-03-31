import axios from 'axios';

const api = axios.create({
  baseURL: 'https://api.example.com',
  timeout: 1000,
});

export const getData = async () => {
  try {
    const response = await api.get('/data');
    return response.data;
  } catch (error) {
    console.error('Error fetching data:', error);
    throw error;
  }
};

export const postData = async (data: any) => {
  try {
    const response = await api.post('/data', data);
    return response.data;
  } catch (error) {
    console.error('Error posting data:', error);
    throw error;
  }
};

export {};
