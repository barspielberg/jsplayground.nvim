console = new Proxy(console, {
  get: function (target, prop) {
    return function (...args) {
      const lineNum = new Error().stack.split("\n")[2].split(":")[1];
      const data = `line:${lineNum},prop:${prop}|`;
      target[prop].call(target, data, ...args);
    };
  },
});
