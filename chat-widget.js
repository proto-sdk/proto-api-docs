(function() {
  let spec = null;
  let chatBox = null;
  let messages = null;
  let input = null;

  async function init() {
    try {
      const res = await fetch('spec.json');
      spec = await res.json();
      console.log('Spec loaded:', spec.info.version);
      createUI();
    } catch (e) {
      console.error('Failed to load spec:', e);
    }
  }

  function createUI() {
    const btn = document.createElement('button');
    btn.innerHTML = '💬';
    btn.style.cssText = 'position:fixed;bottom:20px;right:20px;width:60px;height:60px;border-radius:50%;background:#FF6B35;color:#fff;border:none;font-size:24px;cursor:pointer;box-shadow:0 4px 12px rgba(0,0,0,0.3);z-index:10000;transition:transform 0.2s;';
    btn.onmouseover = () => btn.style.transform = 'scale(1.1)';
    btn.onmouseout = () => btn.style.transform = 'scale(1)';
    document.body.appendChild(btn);

    chatBox = document.createElement('div');
    chatBox.style.cssText = 'position:fixed;bottom:90px;right:20px;width:400px;max-width:calc(100vw - 40px);height:500px;max-height:calc(100vh - 120px);background:#1a1a1a;border:2px solid #FF6B35;border-radius:12px;display:none;flex-direction:column;z-index:10000;box-shadow:0 8px 24px rgba(0,0,0,0.4);';
    chatBox.innerHTML = `
      <div style="padding:16px;background:#FF6B35;color:#000;font-weight:bold;border-radius:10px 10px 0 0;display:flex;justify-content:space-between;align-items:center;">
        <span>Proto API Assistant</span>
        <button id="chat-close" style="background:none;border:none;color:#000;font-size:20px;cursor:pointer;padding:0;width:24px;height:24px;">×</button>
      </div>
      <div id="chat-messages" style="flex:1;overflow-y:auto;padding:16px;color:#fff;font-family:monospace;font-size:13px;line-height:1.5;"></div>
      <div style="padding:12px;border-top:1px solid #333;display:flex;gap:8px;">
        <input id="chat-input" type="text" placeholder="Ask about the API..." style="flex:1;padding:10px;background:#2a2a2a;border:1px solid #444;color:#fff;border-radius:6px;font-size:14px;" />
        <button id="chat-send" style="padding:10px 20px;background:#FF6B35;color:#000;border:none;border-radius:6px;cursor:pointer;font-weight:bold;font-size:14px;">Send</button>
      </div>
    `;
    document.body.appendChild(chatBox);

    messages = document.getElementById('chat-messages');
    input = document.getElementById('chat-input');
    const send = document.getElementById('chat-send');
    const close = document.getElementById('chat-close');

    btn.onclick = () => {
      chatBox.style.display = chatBox.style.display === 'none' ? 'flex' : 'none';
      if (chatBox.style.display === 'flex') input.focus();
    };

    close.onclick = () => chatBox.style.display = 'none';
    send.onclick = sendQuery;
    input.onkeypress = (e) => { if (e.key === 'Enter') sendQuery(); };

    addMessage('Hi! Ask me about the Proto API.\n\nTry:\n• "find pools"\n• "get operation GET /api/v1/pools"\n• "schema Pool"\n• "curl PUT /api/v1/mining/target"', false);
  }

  function addMessage(text, isUser) {
    const msg = document.createElement('div');
    msg.style.cssText = `margin-bottom:12px;padding:10px 14px;background:${isUser ? '#FF6B35' : '#2a2a2a'};color:${isUser ? '#000' : '#fff'};border-radius:8px;white-space:pre-wrap;word-break:break-word;line-height:1.4;`;
    msg.textContent = text;
    messages.appendChild(msg);
    messages.scrollTop = messages.scrollHeight;
  }

  function sendQuery() {
    const query = input.value.trim();
    if (!query) return;
    
    console.log('Query:', query);
    addMessage(query, true);
    input.value = '';
    
    try {
      const response = handleQuery(query);
      addMessage(response, false);
    } catch (e) {
      addMessage('Error: ' + e.message, false);
      console.error('Query error:', e);
    }
  }

  function handleQuery(query) {
    const q = query.toLowerCase();

    if (q.includes('find') || q.includes('search') || q.includes('list')) {
      const term = q.replace(/find|search|list/gi, '').trim() || 'all';
      const results = [];
      for (const path of Object.keys(spec.paths || {})) {
        for (const method of Object.keys(spec.paths[path] || {})) {
          const op = spec.paths[path][method];
          if (term === 'all' || 
              path.toLowerCase().includes(term) ||
              method.toLowerCase().includes(term) ||
              (op.operationId || '').toLowerCase().includes(term) ||
              (op.tags || []).some(t => t.toLowerCase().includes(term))) {
            results.push(`${method.toUpperCase()} ${path}${op.operationId ? ' (' + op.operationId + ')' : ''}`);
          }
        }
      }
      return `Found ${results.length} endpoints:\n\n${results.slice(0, 15).join('\n')}${results.length > 15 ? '\n\n... and ' + (results.length - 15) + ' more' : ''}`;
    }

    if (q.includes('operation') || q.includes('endpoint')) {
      const pathMatch = q.match(/\/api\/v\d+\/[^\s]+/);
      const methodMatch = q.match(/\b(get|post|put|delete|patch)\b/i);
      if (pathMatch && methodMatch) {
        const op = spec.paths?.[pathMatch[0]]?.[methodMatch[0].toLowerCase()];
        return op ? JSON.stringify(op, null, 2) : 'Operation not found';
      }
      return 'Please specify method and path, e.g., "get operation GET /api/v1/pools"';
    }

    if (q.includes('schema')) {
      const nameMatch = q.match(/schema\s+(\w+)/i) || q.match(/(\w+)\s+schema/i);
      if (nameMatch) {
        const s = spec.components?.schemas?.[nameMatch[1]];
        return s ? JSON.stringify(s, null, 2) : `Schema "${nameMatch[1]}" not found`;
      }
      return 'Please specify schema name, e.g., "schema Pool"';
    }

    if (q.includes('curl')) {
      const pathMatch = q.match(/\/api\/v\d+\/[^\s]+/);
      const methodMatch = q.match(/\b(get|post|put|delete|patch)\b/i);
      if (pathMatch && methodMatch) {
        const op = spec.paths?.[pathMatch[0]]?.[methodMatch[0].toLowerCase()];
        if (!op) return 'Operation not found';
        const url = `http://miner.local${pathMatch[0]}`;
        const headers = ['-H "Content-Type: application/json"'];
        const auth = op.security ? ['-H "Authorization: Bearer <TOKEN>"'] : [];
        let data = '';
        const rb = op.requestBody?.content?.['application/json'];
        if (rb?.example) data = `-d '${JSON.stringify(rb.example)}'`;
        return `curl -X ${methodMatch[0].toUpperCase()} ${headers.concat(auth).join(' ')} ${data} "${url}"`.replace(/\s+/g, ' ').trim();
      }
      return 'Please specify method and path, e.g., "curl PUT /api/v1/mining/target"';
    }

    return 'I can help with:\n• "find [term]" - search endpoints\n• "get operation [METHOD] [path]" - show operation details\n• "schema [Name]" - show schema definition\n• "curl [METHOD] [path]" - generate cURL command';
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
})();
