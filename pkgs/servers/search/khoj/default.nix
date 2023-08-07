{ lib
, stdenv
, fetchFromGitHub
, python3
, qt6
}:

python3.pkgs.buildPythonApplication rec {
  pname = "khoj";
  version = "0.11.0";
  format = "pyproject";

  disabled = python3.pkgs.pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "khoj-ai";
    repo = "khoj";
    rev = "refs/tags/${version}";
    hash = "sha256-e8RFHS4eqTG0Rdo4Y9ITlVtDbhZprNXe+KM4x50zf7A=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "dateparser == 1.1.1" "dateparser" \
      --replace "defusedxml == 0.7.1" ""defusedxml"" \
      --replace "fastapi == 0.77.1" "fastapi" \
      --replace "jinja2 == 3.1.2" "jinja2" \
      --replace "openai >= 0.27.0" "openai" \
      --replace "pillow == 9.3.0" "pillow" \
      --replace "pydantic >= 1.10.10" "pydantic" \
      --replace "pyyaml == 6.0" "pyyaml" \
      --replace "rich >= 13.3.1" "rich" \
      --replace "schedule == 1.1.0" "schedule" \
      --replace "sentence-transformers == 2.2.2" "sentence-transformers" \
      --replace "torch >= 2.0.1" "torch" \
      --replace "pypdf >= 3.9.0" "pypdf" \
      --replace "pyside6 >= 6.5.1" "pyside6" \
      --replace "uvicorn == 0.17.6" "uvicorn" \
      --replace "aiohttp == 3.8.4" "aiohttp" \
      --replace "bs4 >= 0.0.1" "beautifulsoup4"
  '';

  nativeBuildInputs = with python3.pkgs; [
    hatch-vcs
    hatchling
  ] ++ (with qt6; [
    wrapQtAppsHook
  ]);

  buildInputs = lib.optionals stdenv.isLinux [
    qt6.qtwayland
  ] ++ lib.optionals stdenv.isDarwin [
    qt6.qtbase
  ];

  propagatedBuildInputs = with python3.pkgs; [
    dateparser
    defusedxml
    fastapi
    jinja2
    numpy
    openai
    pillow
    pydantic
gpt4all
pypdf
pyside6
    # pyqt6
    pyyaml
    rich
    schedule
    sentence-transformers
tiktoken
    torch
    uvicorn
tenacity
beautifulsoup4
aiohttp
langchain
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

doCheck = false;

  # preCheck = ''
  #   export HOME=$(mktemp -d)
  # '';

  # pythonImportsCheck = [
  #   "khoj"
  # ];

  # disabledTests = [
  #   # Tests require network access
  #   "test_search_with_valid_content_type"
  #   "test_update_with_valid_content_type"
  #   "test_regenerate_with_valid_content_type"
  #   "test_image_search"
  #   "test_notes_search"
  #   "test_notes_search_with_only_filters"
  #   "test_notes_search_with_include_filter"
  #   "test_notes_search_with_exclude_filter"
  #   "test_image_metadata"
  #   "test_image_search"
  #   "test_image_search_query_truncated"
  #   "test_image_search_by_filepath"
  #   "test_asymmetric_setup_with_missing_file_raises_error"
  #   "test_asymmetric_setup_with_empty_file_raises_error"
  #   "test_asymmetric_reload"
  #   "test_asymmetric_setup"
  #   "test_asymmetric_search"
  #   "test_entry_chunking_by_max_tokens"
  #   "test_incremental_update"
  # ];

  meta = with lib; {
    description = "Natural Language Search Assistant for your Org-Mode and Markdown notes, Beancount transactions and Photos";
    homepage = "https://github.com/debanjum/khoj";
    changelog = "https://github.com/debanjum/khoj/releases/tag/${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ dit7ya ];
    # src/tcmalloc.cc:333] Attempt to free invalid pointer
    broken = stdenv.isDarwin;
  };
}
