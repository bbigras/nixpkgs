import ./make-test-python.nix ({ pkgs, ... }:

{
  name = "sssd-ad";

  meta.maintainers = [ pkgs.lib.maintainers.bbigras ];

  nodes =
    {
      # client =
        # { pkgs, ... }:
        # { fileSystems = pkgs.lib.mkVMOverride
            # { "/public" = {
                # fsType = "cifs";
                # device = "//server/public";
                # options = [ "guest" ];
              # };
            # };
        # };

      server =
        { ... }:
        { services.samba.enable = true;
          services.samba.package = pkgs.samba4Full;
          services.samba.configText = ''
# Global parameters
[global]
	binddns dir = /root/prov/bind-dns
	cache directory = /root/prov/cache
#	dns forwarder = 127.0.0.1
	dns forwarder = 10.0.2.3        
	lock directory = /root/prov
	netbios name = SERVER
	passwd program = /run/wrappers/bin/passwd %u
	private dir = /root/prov/private
	realm = SAMDOM.EXAMPLE.COM
	security = USER
	server role = active directory domain controller
	state directory = /root/prov/state
	workgroup = SAMDOM
	idmap_ldb:use rfc2307 = yes
	invalid users = root

[public]
	comment = Public samba share.
	guest ok = Yes
	path = /public

[sysvol]
	path = /root/prov/state/sysvol
	read only = No

[netlogon]
	path = /root/prov/state/sysvol/samdom.example.com/scripts
	read only = No
'';
          networking.firewall.allowedTCPPorts = [ 139 445 22 ];
          networking.firewall.allowedUDPPorts = [ 137 138 ];
          # networking.nameservers = [ "127.0.0.1" ];
          networking.search = [ "samdom.example.com" ];
          services.openssh.enable = true;
          # services.openssh.passwordAuthentication = true;

            users.users.bbigras = {
    createHome = true;
    isNormalUser = true;
    extraGroups = [
      "wheel"
    ];
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMjASjWJlY10Z1GlMtcB0VXZMr0toCrM1KFumMkRMyQF bruno@portable" ];
  };

          environment.systemPackages = with pkgs; [ pkgs.samba4Full sudo ];

          # services.kerberos_server.enable = true;
          # services.kerberos_server.realms."SAMDOM.EXAMPLE.COM" = {};
          
          krb5 = {
            enable = true;
            kerberos = pkgs.heimdalFull;
            # kerberos = pkgs.krb5Full;
            config = ''
[libdefaults]
	default_realm = SAMDOM.EXAMPLE.COM
	dns_lookup_realm = false
	dns_lookup_kdc = true
'';
          };


# search samdom.example.com
# nameserver 10.99.0.1
            
          # };
          
        };
    };

  # client# [    4.542997] mount[777]: sh: systemd-ask-password: command not found

      # server.wait_for_unit("samba.target")
      # server.succeed("mkdir -p /public; echo bar > /public/foo")

      # server.succeed("systemctl stop samba-smbd")
      # server.succeed("systemctl stop samba-nmbd")
  
  testScript =
    ''
      server.start()
      server.wait_for_unit("multi-user.target")
      server.succeed(
          "samba-tool domain provision --server-role=dc --use-rfc2307 --dns-backend=SAMBA_INTERNAL --realm=SAMDOM.EXAMPLE.COM --domain=SAMDOM --adminpass=Passw0rd --targetdir=/root/prov -s /etc/samba/smb.conf"
      )
    '';
})
