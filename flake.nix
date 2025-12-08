{
  inputs = {
    nixpkgs.url = "github:cachix/devenv-nixpkgs/rolling";
    devenv.url = "github:cachix/devenv";
  };

  outputs = inputs@{ flake-parts, nixpkgs, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.devenv.flakeModule
      ];
      systems = nixpkgs.lib.systems.flakeExposed;

      perSystem = { config, self', inputs', pkgs, system, ... }: {
        devenv.shells.default = {
          git-hooks = {
            enable = true;
            hooks = {
              nixpkgs-fmt.enable = true;
              dune-fmt.enable = true;
            };
          };
          languages.ocaml = {
            enable = true;
            packages = pkgs.ocaml-ng.ocamlPackages_5_4;
          };
        };
      };
    };
}
