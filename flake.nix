{
  description = "kbuilder ";  

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = {self, nixpkgs}: {
    defaultPackage.x86_64-linux =
      with import nixpkgs { system = "x86_64-linux"; };

      stdenv.mkDerivation rec {
        name = "kubebuilder";
        version = "3.14.2";

        src = fetchurl {
          url = "https://github.com/kubernetes-sigs/kubebuilder/releases/download/v3.14.2/kubebuilder_linux_amd64";
          sha256 = "sha256-RCTN6C2PUjyiAN2Uy+HTUUQRsHOQRuQevFOGLqGZyQQ=";
        };

        sourceRoot = ".";
        buildPhase = pkgs.tarballs.unpackArchive $src;


        installPhase = ''
        install -m775 -D $src $out/bin/kubebuilder
        '';

        shellHook = ''
        echo "Kubebuilder is available: $out/bin/kubebuilder"
        $out/bin/kubebuilder version
      '';
      };
  };
}
