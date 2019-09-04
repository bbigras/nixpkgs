{ stdenv, fetchFromGitHub, rustPlatform, openssl, pkgconfig, libiconv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "starship";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "starship";
    repo = "starship";
    rev = "68754208c1fae976c71747fe87d8ab558922cd3f";
    sha256 = "1v8gr2zxkv24h03lq1jzrlzbkqffbhn114zzy32zqbz7xl367nnd";
  };

  buildInputs = [ openssl ] ++ stdenv.lib.optionals stdenv.isDarwin [ libiconv darwin.apple_sdk.frameworks.Security ];
  nativeBuildInputs = [ pkgconfig ];

  cargoSha256 = "192lq0wf8c2p3s4n6c0xr02hwyswypxypimbghi4m8f3fgj2l3ig";
  checkPhase = "cargo test -- --skip directory::home_directory --skip directory::directory_in_root";

  meta = with stdenv.lib; {
    description = "A minimal, blazing fast, and extremely customizable prompt for any shell";
    homepage = "https://starship.rs";
    license = licenses.isc;
    maintainers = with maintainers; [ bbigras ];
    platforms = platforms.all;
  };
}
