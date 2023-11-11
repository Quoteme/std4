{
  nixConfig.trusted-substituters = "https://lean4.cachix.org/";
  nixConfig.trusted-public-keys = "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= lean4.cachix.org-1:mawtxSxcaiWE24xCXXgh3qnvlTkyU7evRRnGeAhD4Wk=";
  nixConfig.max-jobs = "auto"; # Allow building multiple derivations in parallel
  # nixConfig.keep-outputs = true; # Do not garbage-collect build time-only dependencies (e.g. clang)

  description = "Standard Library for Lean 4";

  inputs.lean.url = "github:leanprover/lean4";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, lean, flake-utils, ... }@inputs: flake-utils.lib.eachDefaultSystem (system:
    let
      leanPkgs = lean.packages.${system};
      std4 = leanPkgs.buildLeanPackage {
        name = "Std"; # must match the name of the top-level .lean file
        src = ./.;
        precompilePackage = true;
      };
    in
    {
      packages = std4 // {
        inherit (leanPkgs) lean;
      };

      defaultPackage = std4.modRoot;
    });
}
