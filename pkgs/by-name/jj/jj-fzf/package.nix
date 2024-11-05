{
  lib,
  bashInteractive,
  coreutils,
  fetchFromGitHub,
  findutils,
  fzf,
  gawk,
  gitFull,
  gnugrep,
  gnused,
  jujutsu,
  resholve,
  stdenv,
  which,
}:

resholve.mkDerivation rec {
  pname = "jj-fzf";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "tim-janik";
    repo = "jj-fzf";
    rev = "v${version}";
    hash = "sha256-a8h5H4uDsMHJvP/TuvkuCaw/uTR/Oe1lARPpqSzjqoQ=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -D jj-fzf $out/bin/jj-fzf
    runHook postInstall
  '';

  solutions.default = {
    scripts = [ "bin/jj-fzf" ];
    interpreter = "${lib.getExe bashInteractive}";
    inputs = [
      coreutils
      findutils
      fzf
      gawk
      gitFull
      gnugrep
      gnused
      jujutsu
      which
    ];
    keep = {
      "$COLOR" = true;
      "$EDITOR" = true;
      "$FZFPOPUP" = true;
      "$JJFZFONELINE" = true;
      "$JJFZFPAGER" = true;
      "$JJFZFSHOW" = true;
      "$ONESHOT" = true;
      "$R1" = true;
      "$REVSETNAME" = true;
      "$SELF" = true;
      "$SP" = true;
      source = [
        "$TEMPD/rebasing.env"
        "$TEMPD/reparenting.env"
      ];
    };
    execer = [
      "cannot:${gitFull}/bin/gitk"
      "cannot:${lib.getExe fzf}"
      "cannot:${lib.getExe gitFull}"
      "cannot:${lib.getExe jujutsu}"
    ];
  };

  meta = with lib; {
    description = "Text UI for Jujutsu based on fzf";
    homepage = "https://github.com/tim-janik/jj-fzf";
    license = licenses.mpl20;
    maintainers = with maintainers; [ bbigras ];
    platforms = platforms.all;
  };
}
