{
  lib,
  python3Packages,
  fetchFromGitHub,
  p7zip,
  versionCheckHook,
}:
python3Packages.buildPythonApplication rec {
  pname = "gamma-launcher";
  version = "git-2025-12-09";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Mord3rca";
    repo = "gamma-launcher";
    rev = "c3b8234525d1b75ef54912eeb34230058b7670b7";
    hash = "sha256-41PksS5F8kGw/ou5T2fNvyumlt4bKdpgZdoPZqKIPvE=";
  };

  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    beautifulsoup4
    cloudscraper
    gitpython
    platformdirs
    py7zr
    python-unrar
    requests
    tenacity
    tqdm
  ];

  # nativeCheckInputs = [ versionCheckHook ];
  # doInstallCheck = true;

  postFixup = ''
    wrapProgram $out/bin/gamma-launcher \
    --prefix PATH : "${
      lib.makeBinPath [
        p7zip
      ]
    }"
  '';

  meta = {
    description = "Python cli to download S.T.A.L.K.E.R. GAMMA";
    changelog = "https://github.com/Mord3rca/gamma-launcher/releases/tag/v${version}";
    homepage = "https://github.com/Mord3rca/gamma-launcher";
    mainProgram = "gamma-launcher";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ DrymarchonShaun ];
    platforms = lib.platforms.linux;
  };
}
