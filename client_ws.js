// client_ws.js
(function() {
  const ws = new WebSocket("ws://127.0.0.1:7070");
  ws.addEventListener("open", () => {
    console.log("MDView WS open");
  });

  // send scroll events (throttle)
  let lastSent = 0;
  function sendScroll() {
    const now = Date.now();
    if (now - lastSent < 80) return; // ~12.5 fps
    lastSent = now;
    const doc = document.documentElement;
    const scrollTop = (window.scrollY || doc.scrollTop || 0);
    const height = doc.scrollHeight - window.innerHeight;
    const percent = height > 0 ? scrollTop / height : 0;
    ws.send(JSON.stringify({ type: "scroll", percent }));
  }

  window.addEventListener("scroll", () => {
    sendScroll();
  }, { passive: true });

  // react to messages from server (e.g., Neovim -> browser)
  ws.addEventListener("message", (ev) => {
    try {
      const msg = JSON.parse(ev.data);
      if (msg.type === "scrollTo") {
        const percent = msg.percent || 0;
        const doc = document.documentElement;
        const height = doc.scrollHeight - window.innerHeight;
        window.scrollTo(0, Math.round(height * percent));
      } else if (msg.type === "toggleTheme") {
        document.body.classList.toggle("mdview-dark");
      }
    } catch (e) {
      console.error("bad msg", e);
    }
  });

  // Keyboard shortcut "t" to toggle theme
  window.addEventListener("keydown", (e) => {
    if ((e.key || "").toLowerCase() === "t") {
      document.body.classList.toggle("mdview-dark");
    }
  });

  // Click handler for theme toggle button
  window.addEventListener("DOMContentLoaded", () => {
    const btn = document.getElementById("theme-toggle-btn");
    if (btn) {
      btn.addEventListener("click", () => {
        document.body.classList.toggle("mdview-dark");
      });
    }
  });

  // Enhanced image zoom UI with better error handling
  document.addEventListener("click", (e) => {
    const t = e.target;
    if (t && t.tagName === "IMG") {
      e.preventDefault();
      e.stopPropagation();
      
      const overlayId = "mdview-img-overlay";
      let overlay = document.getElementById(overlayId);
      if (!overlay) {
        overlay = document.createElement("div");
        overlay.id = overlayId;
        overlay.style.position = "fixed";
        overlay.style.left = 0;
        overlay.style.top = 0;
        overlay.style.width = "100%";
        overlay.style.height = "100%";
        overlay.style.display = "flex";
        overlay.style.alignItems = "center";
        overlay.style.justifyContent = "center";
        overlay.style.background = "rgba(0,0,0,0.9)";
        overlay.style.zIndex = 99999;
        overlay.style.cursor = "zoom-out";
        
        // Close on overlay click or ESC key
        overlay.addEventListener("click", () => {
          overlay.remove();
        });
        
        document.addEventListener("keydown", function escHandler(e) {
          if (e.key === "Escape") {
            overlay.remove();
            document.removeEventListener("keydown", escHandler);
          }
        });
        
        document.body.appendChild(overlay);
      }
      
      const clone = t.cloneNode();
      clone.style.maxHeight = "90vh";
      clone.style.maxWidth = "90vw";
      clone.style.objectFit = "contain";
      clone.style.borderRadius = "8px";
      clone.style.boxShadow = "0 4px 20px rgba(0,0,0,0.5)";
      
      // Add error handling for broken images
      clone.addEventListener("error", () => {
        clone.style.display = "none";
        const errorDiv = document.createElement("div");
        errorDiv.style.color = "white";
        errorDiv.style.fontSize = "18px";
        errorDiv.style.textAlign = "center";
        errorDiv.innerHTML = "❌ Image failed to load<br><small>Click to close</small>";
        overlay.innerHTML = "";
        overlay.appendChild(errorDiv);
      });
      
      overlay.innerHTML = "";
      overlay.appendChild(clone);
    }
  });
})();

