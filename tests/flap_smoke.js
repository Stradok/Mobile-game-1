// node tests/flap_smoke.js : runs public/index.html's script against stub DOM, asserts flap/fall/die logic.
const fs = require('fs'), vm = require('vm');
const src = fs.readFileSync(__dirname + '/../public/index.html', 'utf8').match(/<script>([\s\S]*)<\/script>/)[1];
const ctx = new Proxy({}, { get: (_, k) => k === 'createLinearGradient' ? () => ({ addColorStop() {} }) : () => {}, set: () => true });
const listeners = {}; let frame;
const sandbox = {
  document: { getElementById: () => ({ getContext: () => ctx, width: 0, height: 0 }) },
  addEventListener: (n, f) => listeners[n] = f, innerWidth: 360, innerHeight: 640, devicePixelRatio: 1,
  localStorage: { getItem: () => null, setItem() {} }, navigator: {}, performance: { now: () => 0 },
  requestAnimationFrame: f => { frame = f; }, Math,
};
sandbox.window = sandbox; vm.createContext(sandbox);
vm.runInContext(src + '\n;globalThis.S=()=>({state,y,score});globalThis.F=flap;', sandbox);
const step = n => { for (let i = 0; i < n; i++) { const f = frame; frame = null; f((sandbox._t = (sandbox._t || 0) + 16.7)); } };
step(5);
console.assert(sandbox.S().state === 'ready', 'starts ready');
sandbox.F(); step(3);
console.assert(sandbox.S().state === 'play', 'tap starts play');
step(120); // no more taps: falls to ground
console.assert(sandbox.S().state === 'dead', 'falling bird dies, got ' + sandbox.S().state);
console.log('OK', JSON.stringify(sandbox.S()));
