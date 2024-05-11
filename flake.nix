{
  description = "kubebuilder";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = { self, nixpkgs }:
    let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
    in
    {
      defaultPackage.x86_64-linux = pkgs.stdenv.mkDerivation rec {
        name = "kubebuilder";
        version = "3.14.2";

        src = pkgs.fetchurl {
          url = "https://github.com/kubernetes-sigs/kubebuilder/releases/download/v3.14.2/kubebuilder_linux_amd64";
          sha256 = "sha256-RCTN6C2PUjyiAN2Uy+HTUUQRsHOQRuQevFOGLqGZyQQ=";
        };

        dontUnpack = true;

        installPhase = ''
          install -m775 -D $src $out/bin/kubebuilder
        '';

        shellHook = ''
          echo $src
          echo "Kubebuilder is available: $out/bin/kubebuilder"
          $out/bin/kubebuilder version
        '';
      };
    };
}

