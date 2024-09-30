# JS Playground
A Neovim plugin that provides an interactive JavaScript/TypeScript playground buffer. Perfect for quickly testing snippets of JS/TS code directly inside Neovim.

![image](https://github.com/user-attachments/assets/e9cb3558-e23a-4979-b22e-f4f0466950b2)

## 📦 Installation
Install the plugin using your favorite package manager. Here's an example for lazy.nvim:

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "barspielberg/jsplayground.nvim",
  cmd = "JSPlayground",
  opts = {},
}
```

## ⚙️ Configuration
You can customize the plugin behavior by passing your own options. Below are the default settings:

```lua
{
  file_name = "playground.js",  -- The default file name for the playground
  cmd = { "node" },             -- The command used to execute the code
  console = {
    screenRatio = 0.25,         -- Ratio of the buffer for console output
  },
  marks = {
    inline_prefix = "// ",      -- Prefix for inline marks
  },
}
```
### Optional Configurations

##### Disable Console
If you prefer not to display a console output:

```lua
{
  opts = {
    console = false,
  },
}
```

##### Disable Marks
To remove inline marks:

```lua
{
  opts = {
    marks = false,
  },
}
```

##### TypeScript Support
For TypeScript support, simply adjust the file name and command:

```lua
{
  opts = {
    file_name = "playground.ts", 
    cmd = { "npx", "ts-node" },  -- Uses ts-node for TypeScript execution
  },
}
```

## 🚀 Usage
To create a new JavaScript/TypeScript playground, run:
```
:JSPlayground
```
This command opens a buffer where you can write your code. Once you save the buffer, the code will automatically execute, and the results will be displayed.

To detach the execution listener from the buffer, run the command `:JSPlayground` again.

---
##### 📝 TODO List 
- [ ] bun support
- [ ] deno support
- [ ] console colors support 
