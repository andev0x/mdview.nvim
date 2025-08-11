const express = require("express");
const { spawnSync } = require("child_process");
const bodyParser = require("body-parser");
const http = require("http");
const WebSocket = require("ws");
const fs = require("fs");
const path = require("path");

const MARKDOWN_FILE = process.argv[2];
const PORT = process.argv[3] ? parseInt(process.argv[3]) : 7070;
if (!MARKDOWN_FILE) {
  console.error("Usage: node server.js <markdown-path> [port]");
  process.exit(1);
}

const app = express();
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// in-memory last event from browser
let lastBrowserEvent = null;

// helper: render markdown with pandoc, return HTML string
function renderMarkdown() {
  try {
    const templatePath = path.join(__dirname, "template.html");
    const args = [
      MARKDOWN_FILE,
      "--template=" + templatePath,
      "-s",
      "-o",
      "-" // output to stdout
    ];
    // spawn pandoc and capture stdout
    const res = spawnSync("pandoc", args, { encoding: "utf8" });
    if (res.error) {
      console.error("pandoc error:", res.error);
      return `<pre>Error running pandoc: ${res.error}</pre>`;
    }
    if (res.status !== 0) {
      console.error("pandoc exit code:", res.status, res.stderr);
      return `<pre>Pandoc failed: ${res.stderr}</pre>`;
    }
    return res.stdout;
  } catch (e) {
    return `<pre>Render error: ${e.message}</pre>`;
  }
}

// root -> render markdown each request (so it's always fresh)
app.get("/", (req, res) => {
  const html = renderMarkdown();
  // inject websocket client script
  const wsClientScript = fs.readFileSync(path.join(__dirname, "client_ws.js"), "utf8");
  // append the script before </body>
  const final = html.replace("</body>", `<script>${wsClientScript}</script></body>`);
  res.setHeader("Content-Type", "text/html; charset=utf-8");
  res.send(final);
});

// endpoint to get raw HTML (for yank)
app.get("/raw", (req, res) => {
  const html = renderMarkdown();
  res.setHeader("Content-Type", "text/html; charset=utf-8");
  res.send(html);
});

// POST /update <- from Neovim, broadcast to browser clients
app.post("/update", (req, res) => {
  const payload = req.body || {};
  // broadcast to ws clients
  const msg = JSON.stringify(payload);
  wss.clients.forEach((c) => {
    if (c.readyState === WebSocket.OPEN) c.send(msg);
  });
  res.json({ ok: true });
});

// endpoint Neovim polls to receive latest browser event
app.get("/events", (req, res) => {
  res.json({ event: lastBrowserEvent });
  // reset after read so polling gets changes
  lastBrowserEvent = null;
});

// start server
const server = http.createServer(app);
const wss = new WebSocket.Server({ server });

wss.on("connection", (ws) => {
  console.log("Browser connected via websocket");
  ws.on("message", (data) => {
    try {
      const msg = JSON.parse(data.toString());
      // store last event for Neovim to poll
      lastBrowserEvent = msg;
      // optionally echo/broadcast
      // broadcast to others
      wss.clients.forEach((c) => {
        if (c !== ws && c.readyState === WebSocket.OPEN) {
          c.send(JSON.stringify(msg));
        }
      });
    } catch (e) {
      console.error("bad ws msg:", e);
    }
  });
  ws.on("close", () => {
    console.log("WS closed");
  });
});

server.listen(PORT, "127.0.0.1", () => {
  console.log("MDView server running at http://127.0.0.1:" + PORT);
});
