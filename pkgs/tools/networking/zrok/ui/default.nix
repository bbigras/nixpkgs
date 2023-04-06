{ buildPackages, nodejs, stdenv, src, version, buildNpmPackage }:

let
  nodeComposition = import ./node-composition.nix {
    inherit (buildPackages) nodejs;
    inherit (stdenv.hostPlatform) system;
    pkgs = buildPackages;
  };
in
nodeComposition.package.override {
  pname = "zrok";
  inherit version;
  src = src;

  dontNpmInstall = true;

  postInstall = ''
    npm run build
    cd $out
    mv lib/node_modules/zrok-ui/build/* .
    rm -rf lib
  '';
}
