return {
  "mfussenegger/nvim-jdtls",
  opts = function(_, opts)
    -- Configure the JDK runtime so the debug adapter can resolve the java executable
    opts.settings = vim.tbl_deep_extend("force", opts.settings or {}, {
      java = {
        configuration = {
          runtimes = {
            {
              name = "JavaSE-25",
              path = "/usr/lib/jvm/java-25-openjdk",
              default = true,
            },
          },
        },
      },
    })

    -- Drop java-test JARs from bundles — they are not valid OSGi bundles and
    -- cause jdtls to reject the entire bundle list. Only keep the debug adapter.
    opts.init_options = vim.tbl_deep_extend("force", opts.init_options or {}, {
      bundles = {
        vim.fn.expand "$MASON/share/java-debug-adapter/com.microsoft.java.debug.plugin.jar",
      },
    })

    return opts
  end,
}
