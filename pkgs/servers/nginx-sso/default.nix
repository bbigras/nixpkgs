{ buildGoPackage, fetchFromGitHub, stdenv }:

buildGoPackage rec {
  pname = "nginx-sso";
  # version = "0.22.0";
  version = "69c7f91be221168c4d892fa014a68f3a1e37dcde";
  rev = "69c7f91be221168c4d892fa014a68f3a1e37dcde";

  goPackagePath = "github.com/Luzifer/nginx-sso";

  src = fetchFromGitHub {
    inherit rev;
    owner = "Luzifer";
    repo = "nginx-sso";
    sha256 = "0shqawz5bgg40v8f00md150g7gkr26nwnmdp5bixpr8yb5myd24y";
  };

  postInstall = ''
    mkdir -p $bin/share
    cp -R $src/frontend $bin/share
  '';

  meta = with stdenv.lib; {
    description = "SSO authentication provider for the auth_request nginx module";
    homepage = https://github.com/Luzifer/nginx-sso;
    license = licenses.asl20;
    maintainers = with maintainers; [ delroth ];
    platforms = platforms.unix;
  };
}
