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
    };
}

