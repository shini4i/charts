{
  description = "Development environment for the shini4i Helm charts repository";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

        # `helm unittest` (used by the Helm Unit Test workflow) ships as a plugin.
        # Wrapping helm makes it available without a global `helm plugin install`,
        # which would write outside the reproducible environment.
        helm = pkgs.wrapHelm pkgs.kubernetes-helm {
          plugins = [ pkgs.kubernetes-helmPlugins.helm-unittest ];
        };

        helmToolchain = [
          helm
          # Regenerates each chart's README.md from Chart.yaml + values.yaml.
          # Also invoked by the helm-docs pre-commit hook.
          pkgs.helm-docs
        ];

        # scripts/update-readme.py rebuilds the chart table in the root README.
        # It needs yaml and prettytable only (see scripts/requirements.txt).
        readmePython = pkgs.python3.withPackages (ps: with ps; [
          prettytable
          pyyaml
        ]);

        preCommitTools = with pkgs; [
          pre-commit
          git
        ];

        dataTools = with pkgs; [
          yq-go
          jq
        ];
      in
      {
        devShells.default = pkgs.mkShell {
          packages = helmToolchain ++ [ readmePython ] ++ preCommitTools ++ dataTools;
        };
      }
    );
}
