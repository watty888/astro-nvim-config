return {
  "mfussenegger/nvim-dap",
  config = function()
    local dap = require "dap"

    -- Define the adapter
    dap.adapters["pwa-node"] = {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = {
        command = "js-debug-adapter",
        args = { "${port}" },
      },
    }

    -- Java: attach to WildFly JPDA
    -- modulePaths/classPaths/mainClass/projectName/javaExec are set to dummy
    -- values to short-circuit nvim-jdtls's enrich_dap_config, which otherwise
    -- tries to resolve them for every config (including attach) and breaks the
    -- session when it can't find a main class.
    dap.configurations.java = {
      {
        type = "java",
        request = "attach",
        name = "Attach to WildFly (8787)",
        hostName = "127.0.0.1",
        port = 8787,
        mainClass = "",
        projectName = "",
        modulePaths = {},
        classPaths = {},
        javaExec = "/usr/lib/jvm/java-25-openjdk/bin/java",
      },
    }

    -- Define the configuration for TypeScript/JavaScript
    for _, language in ipairs { "typescript", "javascript", "typescriptreact", "javascriptreact" } do
      dap.configurations[language] = {
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach to Next.js Server",
          port = 9230, -- Default Node.js debug port
          restart = true,
          sourceMaps = true,
          localRoor = vim.fn.getcwd(),
          remoteRoot = vim.fn.getcwd(),
          skipFiles = { "<node_internals>/**", "node_modules/**" },
          protocol = "inspector",
          console = "integratedTerminal",
        },
      }
    end
  end,
}
