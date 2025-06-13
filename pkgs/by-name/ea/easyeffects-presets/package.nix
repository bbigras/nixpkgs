{
  pkgs,
  fetchFromGitHub,
  stdenv,
}:

stdenv.mkDerivation {
  version = "0.0.0";
  pname = "easyeffects-presets";

  src = fetchFromGitHub {
    owner = "JackHack96";
    repo = "EasyEffects-Presets";
    # tag = "v${version}";
    rev = "069195c4e73d5ce94a87acb45903d18e05bffdcc";
    sha256 = "sha256-nXVtX0ju+Ckauo0o30Y+sfNZ/wrx3HXNCK05z7dLaFc=";
  };

  postInstall = ''
    install -dm755 "$out/share/easyeffects/output/"
    install -m644 *.json "$out/share/easyeffects/output"
  '';

  meta = with pkgs.lib; {
    description = "Collection of PulseEffects presets";
    homepage = "https://github.com/JackHack96/EasyEffects-Presets";
    platforms = platforms.linux;
    license = licenses.mit;
  };
}
