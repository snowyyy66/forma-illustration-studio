import { createServer } from 'node:http';
import { extname, normalize, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const root = fileURLToPath(new URL('../', import.meta.url));
const mime = { '.html':'text/html; charset=utf-8', '.css':'text/css; charset=utf-8', '.js':'text/javascript; charset=utf-8', '.svg':'image/svg+xml', '.json':'application/json; charset=utf-8' };
const server = createServer(async (req, res) => {
  const pathname = decodeURIComponent(new URL(req.url, 'http://localhost').pathname);
  const safe = normalize(pathname).replace(/^([.][.][/\\])+/, '').replace(/^[/\\]+/, '');
  let target = join(root, safe || 'index.html');
  try {
    const data = await readFile(target);
    res.writeHead(200, { 'Content-Type': mime[extname(target)] || 'application/octet-stream', 'Cache-Control':'no-store' });
    res.end(data);
  } catch {
    if (!extname(pathname) || pathname.endsWith('/')) {
      try { const data = await readFile(join(root, 'index.html')); res.writeHead(200, {'Content-Type':mime['.html']}); res.end(data); }
      catch { res.writeHead(404); res.end('Not found'); }
    } else { res.writeHead(404); res.end('Not found'); }
  }
});
const port = Number(process.env.PORT || 4173);
server.listen(port, '127.0.0.1', () => console.log(`Forma is ready at http://127.0.0.1:${port}`));
