const express = require('express');

const app = express();
const PORT = process.env.PORT || 3000;
const VERSION = process.env.APP_VERSION || 'dev';

app.get('/', (req, res) => {
  res.json({ message: 'Backend service is running',
    version: VERSION });
});

app.get('/health', (req, res) => {
  res.status(200).json({ status: 'UP' });
});

app.get('/version', (req, res) => {
  res.json({ version: VERSION });
});

app.get('/api/hello', (req, res) => {
  res.json({ message: 'Hello from backend service' });
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}, version ${VERSION}`);
});
