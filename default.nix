{ mkDerivation, aeson, base, bytestring, containers, data-default
, directory, http-client, http-client-tls, lib
, optparse-applicative, parsec
, text, time, transformers, pkgs
, llm-with-context, IStr, scrappy-core
}:
let
  #inherit (nixpkgs) pkgs;
  # llm-with-contextSrc = pkgs.fetchFromGitHub {
  #   owner = "augyg";
  #   repo =  "llm-with-context";
  #   rev = "ce3bdbc9b09a792d67998a0b8324a1cefcd11ca4";
  #   sha256 = "sha256-LQaQPBtytZtNe6vtv1tBLnldNFUKxEDot30cQt5sQaU=";
  # };

  # scrappy-coreSrc = pkgs.fetchFromGitHub {
  #   owner = "Ace-Interview-Prep";
  #   repo =  "scrappy-core";
  #   rev = "913670f2f83cabb2b56302e17604ec488e89da7b";
  #   sha256 = "0xvxc29x2izm1jpq5zpncyirhadwcx2wf3b61ns9mhvcpkjbw3m8";
  # };
 
  # istrSrc = pkgs.fetchFromGitHub {
  #   owner = "augyg";
  #   repo =  "IStr";
  #   rev = "711fba57a38752cd22697b715607f6061e398768";
  #   sha256 = "sha256-M4f3tNHDRgR+wjvS0L8MKm9VKhGEkSxXMkrn24YKa+s=";
  # };

  # llm-with-context = pkgs.haskellPackages.callPackage llm-with-contextSrc {};
  # istr = pkgs.haskell.lib.doJailbreak (pkgs.haskellPackages.callPackage istrSrc {});
  # scrappy-core = pkgs.haskellPackages.callCabal2nix "scrappy-core" scrappy-coreSrc {};
  x = 1;
in
mkDerivation {
  pname = "scriptwriter";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    aeson base bytestring containers data-default directory http-client
    http-client-tls IStr llm-with-context optparse-applicative parsec
    scrappy-core text transformers time
  ];
  license = lib.licenses.mit;
  mainProgram = "scriptwriter";
}
