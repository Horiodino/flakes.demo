{
  description = "kubebuilder";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" "aarch64-linux" ];
      forEachSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        inherit system;
        pkgs = import nixpkgs { inherit system; };
      });

      getBinaryUrl = { system, version }: 
        let
          urls = {
            "x86_64-linux" = "https://github.com/kubernetes-sigs/kubebuilder/releases/download/${version}/kubebuilder_linux_amd64";
            "aarch64-darwin" = "https://github.com/kubernetes-sigs/kubebuilder/releases/download/${version}/kubebuilder_darwin_amd64";
            "x86_64-darwin" = "https://github.com/kubernetes-sigs/kubebuilder/releases/download/${version}/kubebuilder_darwin_amd64";
            "aarch64-linux" = "https://github.com/kubernetes-sigs/kubebuilder/releases/download/${version}/kubebuilder_linux_arm64";
          };
        in urls.${system};
        
    in
    {
      packages = forEachSystem ({ pkgs, ... }: {
        default = pkgs.stdenv.mkDerivation rec {
          name = "kubebuilder";
          version = "3.14.2";

          src = pkgs.fetchurl {
            url = getBinaryUrl { system = pkgs.system; version = version; };
            sha256 = "sha256-RCTN6C2PUjyiAN2Uy+HTUUQRsHOQRuQevFOGLqGZyQQ=";
          };

          dontUnpack = true;
          phases = [ "installPhase" ];
          dontBuild = true;

          installPhase = ''
            mkdir -p $out/bin
            cp $src $out/bin/kubebuilder
            chmod +x $out/bin/kubebuilder
          '';

          shellHook = ''
            echo $src
            echo "Kubebuilder is available: $out/bin/kubebuilder"
            $out/bin/kubebuilder version
          '';
        };
      });
    };
}
