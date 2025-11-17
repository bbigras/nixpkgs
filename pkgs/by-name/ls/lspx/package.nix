{
  lib,
  stdenvNoCC,
  deno,
  fetchFromGitHub,
  fetchDenoDeps,
}:

let
  my-deps = fetchDenoDeps {
    name = "lspx";
    denoLock = ./deno.lock;
    hash = "sha256-rUZuwrb2G5LyUh+/k/0VDGX5+hDklQEque5Sg5/8cfY=";
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "lspx";
  # version = "0.3.1";
  version = "0-unstable-2025-11-08";

  src = fetchFromGitHub {
    owner = "thefrontside";
    repo = "lspx";
    # tag = "v${version}";
    rev = "1b9649fa5567ef482dc54519943737922ef291dd";
    hash = "sha256-RuwtILZ66ztUpxu8UBpwfqMdzmQ26PuSblMJEHKfkqI=";
  };

  nativeBuildInputs = [ deno ];

  buildPhase = ''
    # copy the deps to the required location
    cp -r --no-preserve=mode ${my-deps.denoDeps}/* ./
    cp -r --no-preserve=mode ${my-deps.denoDeps}/.deno ./

    # Now you can run the project using deps
    # you need to activate [deno's vendor feature](https://docs.deno.com/runtime/fundamentals/modules/#vendoring-remote-modules)
    # you need to use the `$DENO_DIR` env var, to point deno to the correct local cache
    DENO_DIR=./.deno deno compile --cached-only --frozen --vendor ./main.ts
  '';

  # installPhase = ''
  #   cp -r ./path/to/build/result $out
  # '';

  meta = {
    description = "language server multiplexer, supervisor, and interactive shell";
    homepage = "https://github.com/thefrontside/lspx";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bbigras ];
    mainProgram = "lspx";
    inherit (deno.meta) platforms;
  };
})
