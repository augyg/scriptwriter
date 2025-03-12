{ nixpkgs ? import <nixpkgs> {}, compiler ? "default", doBenchmark ? false }:

let
  inherit (nixpkgs) pkgs;
  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};
  variant = if doBenchmark then pkgs.haskell.lib.doBenchmark else pkgs.lib.id;
  pkg = import ./default.nix;
  drv = variant (haskellPackages.callPackage pkg {}); 
in
pkgs.mkShell {
  buildInputs = [ pkgs.cabal-install ];
  inputsFrom = [ (if pkgs.lib.inNixShell then drv.env else drv) ];
} 


# { nixpkgs ? import <nixpkgs> {}, compiler ? "default", doBenchmark ? false }:

# let

#   inherit (nixpkgs) pkgs;
#   llm-with-contextSrc = pkgs.fetchFromGitHub {
#     owner = "augyg";
#     repo =  "llm-with-context";
#     rev = "4bc0739d14fcb2474b93ecedaabc727a40f5d5db";
#     sha256 = "sha256-6tMKYmfopAl+/0ja/1PNa9aw28BdvzDp5pdc1D1JOpc=";
#   };

#   scrappy-coreSrc = pkgs.fetchFromGitHub {
#     owner = "Ace-Interview-Prep";
#     repo =  "scrappy-core";
#     rev = "913670f2f83cabb2b56302e17604ec488e89da7b";
#     sha256 = "0xvxc29x2izm1jpq5zpncyirhadwcx2wf3b61ns9mhvcpkjbw3m8";
#   };
 
#   istrSrc = pkgs.fetchFromGitHub {
#     owner = "augyg";
#     repo =  "IStr";
#     rev = "711fba57a38752cd22697b715607f6061e398768";
#     sha256 = "sha256-M4f3tNHDRgR+wjvS0L8MKm9VKhGEkSxXMkrn24YKa+s=";
#   };

#   llm-with-context = pkgs.haskellPackages.callPackage llm-with-contextSrc {};
#   istr = pkgs.haskellPackages.callPackage istrSrc {};
#   scrappy-core = pkgs.haskellPackages.callCabal2nix "scrappy-core" scrappy-coreSrc {};
  
#   f = { mkDerivation, base, lib, text, http-client, http-client-tls, aeson, bytestring
#       , parsec, data-default, transformers, directory, optparse-applicative
#       }:
#       mkDerivation {
#         pname = "scriptwriter";
#         version = "0.1.0.0";
#         src = ./.;
#         isLibrary = false;
#         isExecutable = true;
#         executableHaskellDepends =
#           [ base text istr llm-with-context http-client http-client-tls
#             scrappy-core aeson bytestring parsec data-default transformers directory
#             optparse-applicative
#           ];
#         license = lib.licenses.mit;
#         mainProgram = "scriptwriter";
#       };

#   haskellPackages = if compiler == "default"
#                        then pkgs.haskellPackages
#                        else pkgs.haskell.packages.${compiler};

#   variant = if doBenchmark then pkgs.haskell.lib.doBenchmark else pkgs.lib.id;

#   drv = variant (haskellPackages.callPackage f {});

# in

#   if pkgs.lib.inNixShell then drv.env else drv
