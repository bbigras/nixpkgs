{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "diffsitter";
  version = "0.6.6";

  src = fetchFromGitHub {
    owner = "afnanenayet";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-I4DruNglY8iok+UN/nvlKoqQJgL+F9O+9S0+64lk7OE=";
    fetchSubmodules = true;
  };

  cargoSha256 = "sha256-xGUYHLifPm0K4NDnjpvGJEF2aLOmXlNrXgqo4UPEB+A=";

  meta = with lib; {
    homepage = "https://github.com/afnanenayet/diffsitter";
    description = "A tree-sitter based AST difftool to get meaningful semantic diffs";
    license = licenses.mit;
    maintainers = with maintainers; [ bbigras ];
  };
}
