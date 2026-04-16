console.log('im here!!');
(() => {
  // Build ws url from current location (works for localhost and LAN)
  const WS_URL = (location.protocol === 'https:' ? 'wss://' : 'ws://') + location.host + '/ws';

  let socket = null;
  let retryMs = 250;

  function log(...args) {
    // Keep logs on; you can remove later.
    console.log('[overlay]', ...args);
  }

  function connect() {
    log('connecting', WS_URL);
    socket = new WebSocket(WS_URL);

    socket.onopen = () => {
      retryMs = 250;
      log('ws open');

      // Handshake expected by the server
      socket.send(JSON.stringify({ type: 'hello', role: 'overlay', version: 1 }));
    };

    socket.onmessage = (ev) => {
      let msg;
      try {
        msg = JSON.parse(ev.data);
      } catch {
        return;
      }

      if (msg.type === 'state' && msg.payload) {
        applyState(msg.payload);
      } else if (msg.type === 'error') {
        log('server error:', msg);
      }
    };

    socket.onclose = () => {
      log('ws closed, reconnecting...');
      scheduleReconnect();
    };

    socket.onerror = (e) => {
      log('ws error', e);
      try {
        socket.close();
      } catch {}
    };
  }

  function scheduleReconnect() {
    setTimeout(() => {
      retryMs = Math.min(retryMs * 2, 5000);
      connect();
    }, retryMs);
  }

  function applyState(payload) {
    if (!payload.items) return;

    const items = payload.items;

    applyItem('bible', items.bible);
    applyItem('ref', items.ref);
    applyItem('content', items.content);
  }

  function applyItem(id, data) {
    const el = document.getElementById(id);
    if (!el) return;

    const text = data && typeof data.text === 'string' ? data.text : '';
    const visible = data && typeof data.visible === 'boolean' ? data.visible : false;

    el.textContent = text;
    el.style.display = visible ? 'block' : 'none';
  }

  // Kick off
  connect();
})();
