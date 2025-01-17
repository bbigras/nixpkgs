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
  util-linux,
  which,
}:

resholve.mkDerivation rec {
  pname = "jj-fzf";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "tim-janik";
    repo = "jj-fzf";
    rev = "v${version}";
    hash = "sha256-naYedpY4bioJ1onn/8hQjkx8sKCgPXQP3nRbneVulcU=";
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
      bashInteractive
      coreutils
      findutils
      fzf
      gawk
      gitFull
      gnugrep
      gnused
      jujutsu
      util-linux # for the 'column' cmd
      which
    ];
    keep = {
      "$COLOR" = true;
      "$EDITOR" = true;
      "$FZFPOPUP" = true;
      "$JJFZFONELINE" = true;
      "$JJFZFPAGER" = true;
      "$JJFZFSHOW" = true;
      "$JJ_EDITOR" = true;
      "$ONESHOT" = true;
      "$R1" = true;
      "$REVSETNAME" = true;
      "$SELF" = true;
      "$SHOW_KEYS" = true;
      "$SIMPLIFY" = true;
      "$SP" = true;
      source = [
        "$TEMPD/rebase.env"
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
