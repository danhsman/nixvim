{ pkgs, ... }: {

  extraPackages = [
    #pkgs.cpplint
    pkgs.rustfmt
    pkgs.slint-lsp
    pkgs.rust-analyzer
    pkgs.pylint
    pkgs.pyright
    pkgs.statix
    pkgs.kdePackages.qtdeclarative
    pkgs.tree-sitter
    pkgs.fd
    pkgs.black
    pkgs.isort
    pkgs.nixpkgs-fmt
  ];

  vimAlias = true;
  viAlias = true;

  globals.mapleader = " ";

  colorschemes.oxocarbon = {
    enable = true;
  };

  highlight = {
    Keyword = { fg = "#ff7eb6"; };
    Conditional = { fg = "#ff7eb6"; };
    Function = { fg = "#ff7eb6"; };
    Statement = { fg = "#ff7eb6"; };

    CursorLineNr = { fg = "#ff7eb6"; bold = true; };
    FloatBorder = { fg = "#ff7eb6"; bg = "NONE"; };

    PmenuSel = { bg = "#ff7eb6"; fg = "#161616"; };
    Pmenu = { bg = "NONE"; };
    NormalFloat = { bg = "NONE"; };
  };

  opts = {
    wrap = false;
    clipboard = "unnamedplus";
    termguicolors = true;
    completeopt = "menuone,noselect";
    updatetime = 300;

    shiftwidth = 2;
    tabstop = 2;
    softtabstop = 2;
    expandtab = true;
    shiftround = true;
    smartindent = true;

    number = true;
    relativenumber = true;
    cursorline = true;
    signcolumn = "yes";

    ignorecase = true;
    smartcase = true;
    incsearch = true;
    hlsearch = true;

    swapfile = false;
    backup = false;
    writebackup = false;
    undofile = true;
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>w";
      action = ":w<CR>";
      options.silent = false;
    }
    {
      mode = "n";
      key = "<leader>q";
      action = ":q<CR>";
      options.silent = false;
    }
    {
      mode = "n";
      key = "<leader>ff";
      action = "<cmd>Telescope find_files<CR>";
      options.silent = false;
    }
    {
      mode = "n";
      key = "<leader>fg";
      action = "<cmd>Telescope live_grep<CR>";
      options.silent = false;
    }
    {
      mode = "n";
      key = "<leader>fb";
      action = "<cmd>Telescope buffers<CR>";
      options.silent = false;
    }
    {
      mode = "n";
      key = "<leader>fh";
      action = "<cmd>Telescope help_tags<CR>";
      options.silent = false;
    }
    {
      mode = "n";
      key = "<leader>lp";
      action = "<cmd>lua require('gitsigns').preview_hunk()<CR>";
      options.silent = false;
    }
    {
      mode = "n";
      key = "<leader>lg";
      action = "<cmd>LazyGit<CR>";
      options.silent = false;
    }
  ];

  autoCmd = [
    {
      event = [ "BufWritePost" "BufEnter" "InsertLeave" ];
      callback = {
        __raw = ''
          function()
            require('lint').try_lint()
          end
        '';
      };
    }
  ];

  plugins = {
    treesitter = {
      enable = true;
      settings = {
        highlight.enable = true;
        indent.enable = true;

        ensure_installed = [
          "bash"
          "c"
          "cpp"
          "css"
          "html"
          "javascript"
          "json"
          "lua"
          "markdown"
          "nix"
          "python"
          "rust"
          "toml"
          "yaml"
        ];
      };
    };

    nvim-autopairs = {
      enable = true;
      settings = {
        check_ts = true;
      };
    };

    direnv.enable = true;
    luasnip.enable = true;

    cmp = {
      enable = true;
      autoEnableSources = true;

      settings = {
        snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";
        sources = [
          { name = "nvim_lsp"; }
          { name = "luasnip"; }
          { name = "path"; }
          { name = "buffer"; }
        ];
        mapping = {
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-d>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<C-e>" = "cmp.mapping.close()";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<Tab>" = "cmp.mapping.select_next_item()";
          "<S-Tab>" = "cmp.mapping.select_prev_item()";
        };
        window = {
          completion.border = "rounded";
          documentation.border = "rounded";
        };
      };
    };

    conform-nvim = {
      enable = true;
      settings = {
        format_on_save = {
          lsp_fallback = true;
          timeout_ms = 500;
        };
        formatters_by_ft = {
          nix = [ "nixpkgs_fmt" ];
          python = [ "isort" "black" ];
          rust = [ "rustfmt" ];
          c = [ "clang_format" ];
          "_" = [ "trim_whitespace" ];
        };
      };
    };

    lint = {
      enable = true;
      lintersByFt = {
        nix = [ "statix" ];
        #c = [ "cpplint" ];
        python = [ "pylint" ];
      };
    };

    gitsigns = {
      enable = true;
      settings = {
        attach_to_untracked = true;
        current_line_blame = true;
        current_line_blame_opts = {
          delay = 0;
          virt_text_pos = "eol";
        };
      };
    };

    lazygit = {
      enable = true;
      settings = {
        floating_window_winblend = 0;
        floating_window_scaling_factor = 0.9;
      };
    };

    lualine = {
      enable = true;
      settings = {
        options = {
          theme = "auto";
          icons_enabled = true;
          section_separators = { left = ""; right = ""; };
          component_separators = { left = ""; right = ""; };
        };
      };
    };

    lsp = {
      enable = true;

      onAttach = ''
        client.server_capabilities.semanticTokensProvider = nil
      '';

      servers = {
        lua_ls.enable = true;
        pyright.enable = true;
        nixd.enable = true;
        clangd.enable = true;
        qmlls = {
          enable = true;
          cmd = [ "qmlls" "-E" ];
        };
        #rust_analyzer = {
        # enable = true;
        # installCargo = false;
        # installRustc = false;
        # settings = {
        #   check = {
        #     command = "clippy";
        #   };
        # cargo = {
        #   autoreload = true;
        # };
        #};
        #};
        slint_lsp = {
          enable = true;
        };
      };
    };

    rustaceanvim = {
      enable = true;
      settings = {
        server = {
          default_settings = {
            "rust-analyzer" = {
              check = {
                command = "clippy";
              };
            };
          };
        };
      };
    };
    web-devicons = {
      enable = true;
    };

    telescope = {
      enable = true;
      extensions."fzf-native" = {
        enable = true;
        settings = {
          fuzzy = true;
          override_file_sorter = true;
          override_generic_sorter = true;
          case_mode = "smart_case";
        };
      };
    };
  };
}
