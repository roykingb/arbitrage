import http from 'node:http';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

import { runScan } from './src/scanner.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const publicDir = path.join(__dirname, 'public');

const sendJson = (res, code, payload) => {
  res.writeHead(code, { 'Content-Type': 'application/json' });
  res.end(JSON.stringify(payload));
};

const server = http.createServer((req, res) => {
  if (req.method === 'GET' && req.url === '/health') {
    return sendJson(res, 200, { status: 'ok' });
  }

  if (req.method === 'POST' && req.url === '/api/scan') {
    let body = '';
    req.on('data', (chunk) => {
      body += chunk;
    });
    req.on('end', async () => {
      try {
        const payload = body ? JSON.parse(body) : {};
        const result = await runScan(payload);
        return sendJson(res, 200, result);
      } catch {
        return sendJson(res, 400, { error: 'Invalid JSON body' });
      }
    });
    return;
  }

  const staticPath = req.url === '/' ? '/index.html' : req.url;
  const target = path.join(publicDir, staticPath);

  if (!target.startsWith(publicDir)) {
    res.writeHead(403);
    res.end('Forbidden');
    return;
  }

  fs.readFile(target, (err, data) => {
    if (err) {
      res.writeHead(404);
      res.end('Not found');
      return;
    }

    const ext = path.extname(target);
    const contentType =
      ext === '.html'
        ? 'text/html'
        : ext === '.css'
          ? 'text/css'
          : ext === '.js'
            ? 'application/javascript'
            : 'text/plain';

    res.writeHead(200, { 'Content-Type': contentType });
    res.end(data);
  });
});

const PORT = process.env.PORT || 8000;
server.listen(PORT, '0.0.0.0', () => {
  console.log(`Server running on http://0.0.0.0:${PORT}`);
});
