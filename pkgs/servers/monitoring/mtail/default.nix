{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "mtail";
  version = "3.0.0-rc34";
  goPackagePath = "github.com/google/mtail";

  src = fetchFromGitHub {
    owner = "google";
    repo = "mtail";
    rev = "7b4270cb6e8b6ed1f2febe48e370cb68d38681f9";
    sha256 = "0hrbv6dhiqwl1kyrjmwwplq5wig1yak0gql6w4cnac0060ba7r92";
  };

  modSha256 = "1111111111111111111111111111111111111111111111111111";
  subPackages = [ "cmd/mtail" ];

  preBuild = "go generate -x ./go/src/github.com/google/mtail/internal/vm/";

  buildFlagsArray = [
    "-ldflags=-X main.Version=${version}"
  ];

  meta = with lib; {
    license = licenses.asl20;
    homepage = "https://github.com/google/mtail";
    description = "Tool for extracting metrics from application logs";
  };
}
