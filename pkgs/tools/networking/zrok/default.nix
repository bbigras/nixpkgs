{ lib
, callPackage
, stdenv
, buildGoModule
, buildGo118Module
, fetchFromGitHub
, openssh
, makeWrapper
, ps
}:

let
  version = "0.3.5";

  src = fetchFromGitHub {
    repo = "zrok";
    owner = "openziti";
    rev = "v${version}";
    sha256 = "sha256-6+g5ox366HeW7kerwX7R7ykQ+r5sGX2xlSAL/jpLCjY=";
    fetchSubmodules = true;
  };

  ui = callPackage ./ui {
    inherit src version;
  };
in
buildGoModule rec {
  pname = "zrok";
  inherit src version;

  vendorSha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";

  subPackages = [
    "cmd/zrok"
  ];

  prePatch = ''
    cp -r ${ui}/* ui/build
  '';

  meta = with lib; {
  };
}
