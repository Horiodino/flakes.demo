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

        installPhase = ''
        '';

        shellHook = ''
        echo $src
        install -m755 -D $src $out/bin/kubebuilder
        echo "Kubebuilder is available: $out/bin/kubebuilder"
        $out/bin/kubebuilder version
      '';
      };
  };
}
