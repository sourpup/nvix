{ inputs, self, ... }: {
  perSystem = { pkgs, ... }:
    let
      inherit (inputs) nixvim;
      extraSpecialArgs = {
        inherit inputs self; # This will ensure all inputs are available in the module
      };

      nvix = type: {
        inherit pkgs extraSpecialArgs;
        module = import ./config/${type}.nix;
      };
      check = attr: description:
        let
          output = nixvim.lib.${pkgs.stdenv.hostPlatform.system}.check.mkTestDerivationFromNixvimModule attr;
        in
        output // { meta = output.meta // { inherit description; }; };
      package = attr: description:
        let
          output = nixvim.legacyPackages.${pkgs.stdenv.hostPlatform.system}.makeNixvimWithModule attr;
        in
        output // { meta = output.meta // { inherit description; }; };
    in
    {
      # Run `nix flake check .` to verify that your config is not broken
      checks = rec {
        default = check (nvix "core") "Checks if core builds fine.";
        core = default;
        bare = check (nvix "bare") "Checks if bare builds fine";
      };
      # Lets you run `nix run .` to start nixvim
      packages = rec {
        default = package (nvix "core") "Balanced for regular usage";
        core = default;
        bare = package (nvix "bare") "Minimal utility set (Good for servers to quick spin)";
      };
      formatter = pkgs.nixpkgs-fmt;
    };
}
