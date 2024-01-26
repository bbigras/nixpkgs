{ lib
, callPackage
, fetchFromGitHub
, rustPlatform
, cmake
, pkg-config
, protobuf
, elfutils
}:

rustPlatform.buildRustPackage rec {
  pname = "router";
  version = "1.45.1";

  src = fetchFromGitHub {
    owner = "apollographql";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-GmSQyFVaCfx2keaFgqtI0iFUvYoH3KQzyQCRzE0D920=";
  };

  cargoHash = "sha256-KKFbW3pzP43EHtKqEU18WOEuhqjP3EmN5NuhZvtRoig=";

  nativeBuildInputs = [
    cmake
    pkg-config
    protobuf
  ];

  buildInputs = [
    elfutils
  ];

  # The v8 package will try to download a `librusty_v8.a` release at build time to our read-only filesystem
  # To avoid this we pre-download the file and export it via RUSTY_V8_ARCHIVE
  RUSTY_V8_ARCHIVE = callPackage ./librusty_v8.nix { };

  cargoTestFlags = [
    "-- --skip=query_planner::tests::missing_typename_and_fragments_in_requires"
  ];

  meta = with lib; {
    description = "A configurable, high-performance routing runtime for Apollo Federation";
    homepage = "https://www.apollographql.com/docs/router/";
    license = licenses.elastic20;
    maintainers = [ maintainers.bbigras ];
  };
}
