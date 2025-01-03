return {
    {
        'neovim/nvim-lspconfig',
        -- IMPORTANT: someone smarter than me got this workign so dont touch
        -- this is used to enable typsciprt auto completes and highlights
        lazy = false,
        config = function()
            local lspconfig = require("lspconfig")
            lspconfig.angularls.setup({})
            lspconfig.eslint.setup({})
            lspconfig.jdtls.setup({})
            lspconfig.jedi_language_server.setup({})
            lspconfig.lua_ls.setup({})
            lspconfig.rust_analyzer.setup({})
            lspconfig.ts_ls.setup({})
            lspconfig.nixd.setup({})
            lspconfig.markdown_oxide.setup{}
        end,
        -- IMPORTANT --
    },
    { 'mason.nvim',                        enabled = false },
    { 'williamboman/mason-lspconfig.nvim', enabled = false },
}
