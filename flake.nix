{
  inputs.neovim-flake.url = "github:nyadiia/neovim-flake";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs =
    {
      self,
      nixpkgs,
      neovim-flake,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        configModule.config = {
          # Add any custom options (and feel free to upstream them!)
          # options = ...

          vim = {
            lsp = {
              enable = true;
              formatOnSave = true;
              lightbulb.enable = true;
              nvimCodeActionMenu.enable = true;
              trouble.enable = true;
            };
            languages = {
              enableFormat = true;
              enableTreesitter = true;
              enableExtraDiagnostics = true;
              enableLSP = true;
              rust.enable = true;
              html.enable = true;
              markdown.enable = true;
              nix = {
                enable = true;
                format.type = "nixfmt-rfc-style";
              };
            };
            theme.enable = true;
            theme.name = "gruvbox";
            autocomplete.enable = true;
            autopairs.enable = true;
            filetree.nvimTreeLua.enable = true;
            filetree.nvimTreeLua.resizeOnFileOpen = true;
            git.enable = true;
            git.gitsigns.enable = true;
            keys.enable = true;
            keys.whichKey.enable = true;
            statusline.lualine.enable = true;
            treesitter.enable = true;
          };
        };

        nadiavim = neovim-flake.lib.neovimConfiguration {
          modules = [ configModule ];
          inherit pkgs;
        };
      in
      {
        devShells.default = pkgs.mkShell { nativeBuildInputs = [ nadiavim ]; };
        packages.default = nadiavim;
        # i'm too stupid to figure out overlays >w<
        # overlays.default = final: prev: { neovim = neovim-flake.lib.buildPkg prev [ nadiavim ]; };
      }
    );
}
