{ stdenv, fetchFromGitHub, rustPlatform, pkgconfig, openssl
, withALSA ? true, alsaLib ? null
, withPulseAudio ? false, libpulseaudio ? null
, withPortAudio ? false, portaudio ? null
, withMpris ? false
, withKeyring ? false
, dbus ? null
}:

rustPlatform.buildRustPackage rec {
  pname = "spotifyd";
  version = "0.2.24";

  src = fetchFromGitHub {
    owner = "bbigras";
    repo = "spotifyd";
    rev = "739cdec697aedd3880bda2c2c8be21483395f6f7";
    sha256 = "12ihplks2dry8nwfp1g5wgfs0sa9k5k64iirbnp2i70lilh77gwf";
  };

  cargoSha256 = "0lh3y3ca7n3lzc6gh906d057pgxk1h1gx1f77179bck4z2kxz3pb";

  cargoBuildFlags = [
    "--no-default-features"
    "--features"
    "${stdenv.lib.optionalString withALSA "alsa_backend,"}${stdenv.lib.optionalString withPulseAudio "pulseaudio_backend,"}${stdenv.lib.optionalString withPortAudio "portaudio_backend,"}${stdenv.lib.optionalString withMpris "dbus_mpris,"}${stdenv.lib.optionalString withKeyring "dbus_keyring,"}"
  ];

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ openssl ]
    ++ stdenv.lib.optional withALSA alsaLib
    ++ stdenv.lib.optional withPulseAudio libpulseaudio
    ++ stdenv.lib.optional withPortAudio portaudio
    ++ stdenv.lib.optional (withMpris || withKeyring) dbus;

  doCheck = false;

  meta = with stdenv.lib; {
    description = "An open source Spotify client running as a UNIX daemon";
    homepage = "https://github.com/Spotifyd/spotifyd";
    license = with licenses; [ gpl3 ];
    maintainers = with maintainers; [ anderslundstedt filalex77 marsam ];
    platforms = platforms.unix;
  };
}
