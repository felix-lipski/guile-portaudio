{
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs;
    flake-utils.url = github:numtide/flake-utils;
  };

  outputs = { nixpkgs, self, flake-utils, ... }@inputs:
    flake-utils.lib.eachDefaultSystem
      (system:
      let 
        pkgs = import nixpkgs { config = { allowUnfree = false; }; inherit system; };
        buildInputs = with pkgs; [ guile_3_0 gnumake gcc9 portaudio alsaLib libjack2 argtable ]; 
      in {
        devShell = pkgs.mkShell { 
          inherit buildInputs;
          shellHook = ''
            export GUILE_LOAD_PATH=${pkgs.guile-json}/share/guile/site
            export LD_LIBRARY_PATH=${pkgs.portaudio}/lib:$PWD/lib

            echo ${pkgs.portaudio}
          '';
        };
        defaultPackage = pkgs.pkgs.stdenv.mkDerivation rec {
            inherit buildInputs;
            pname        = "flake-package";
            version      = "0.0.0";
            dontUnpack   = true;
            buildPhase   = "";
            installPhase = "mkdir -p $out/bin";
          };
        }
      );
}
