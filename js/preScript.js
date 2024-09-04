const override = ['log', 'error', 'warn', 'info', 'debug'];
console = new Proxy(console, {
  get: function (target, prop) {
    if (!override.includes(prop)) {
      return Reflect.get(...arguments)
    }
    return function (...args) {
      const [_,lineNum] = new Error().stack.split("\n")[2].match(/:(\d+):(\d+)$/);
      const data = `line:${lineNum},prop:${prop}|`;
      target[prop].call(target, data, ...args);
    };
  },
});
