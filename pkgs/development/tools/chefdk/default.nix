{ lib, bundlerEnv, ruby_2_6, perl, autoconf }:

bundlerEnv {
  # Last updated via:
  # nix-shell -p bundix -p gcc -p libxml2 -p zlib --run "bundix -ml"
  name = "chefdk-3.10.1";

  ruby = ruby_2_6;
  gemdir = ./.;

  buildInputs = [ perl autoconf ];

  meta = with lib; {
    description = "A streamlined development and deployment workflow for Chef platform";
    homepage    = https://downloads.chef.io/chef-dk/;
    license     = licenses.asl20;
    maintainers = with maintainers; [ offline ];
    platforms   = platforms.unix;
  };
}
