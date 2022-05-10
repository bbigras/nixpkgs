{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.cloudflared;

  originRequest = {
    connectTimeout = mkOption {
      type = with types; nullOr str;
      default = null;
      example = "30s";
      description = ''
        Timeout for establishing a new TCP connection to your origin server. This excludes the time taken to establish TLS, which is controlled by <link xlink:href="https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/configuration/local-management/ingress/#tlstimeout">tlsTimeout</link>.
      '';
    };

    tlsTimeout = mkOption {
      type = with types; nullOr str;
      default = null;
      example = "10s";
      description = ''
        Timeout for completing a TLS handshake to your origin server, if you have chosen to connect Tunnel to an HTTPS server.
      '';
    };

    tcpKeepAlive = mkOption {
      type = with types; nullOr str;
      default = null;
      example = "30s";
      description = ''
        The timeout after which a TCP keepalive packet is sent on a connection between Tunnel and the origin server.
      '';
    };

    noHappyEyeballs = mkOption {
      type = with types; nullOr bool;
      default = null;
      example = false;
      description = ''
        Disable the “happy eyeballs” algorithm for IPv4/IPv6 fallback if your local network has misconfigured one of the protocols.
      '';
    };

    keepAliveConnections = mkOption {
      type = with types; nullOr int;
      default = null;
      example = 100;
      description = ''
        Maximum number of idle keepalive connections between Tunnel and your origin. This does not restrict the total number of concurrent connections.
      '';
    };

    keepAliveTimeout = mkOption {
      type = with types; nullOr str;
      default = null;
      example = "1m30s";
      description = ''
        Timeout after which an idle keepalive connection can be discarded.
      '';
    };

    httpHostHeader = mkOption {
      type = with types; nullOr str;
      default = null;
      example = "";
      description = ''
        Sets the HTTP <literal>Host</literal> header on requests sent to the local service.
      '';
    };

    originServerName = mkOption {
      type = with types; nullOr str;
      default = null;
      example = "";
      description = ''
        Hostname that <literal>cloudflared</literal> should expect from your origin server certificate.
      '';
    };

    caPool = mkOption {
      type = with types; nullOr (either str path);
      default = null;
      example = "";
      description = ''
        Path to the certificate authority (CA) for the certificate of your origin. This option should be used only if your certificate is not signed by Cloudflare.
      '';
    };

    noTLSVerify = mkOption {
      type = with types; nullOr bool;
      default = null;
      example = false;
      description = ''
        Disables TLS verification of the certificate presented by your origin. Will allow any certificate from the origin to be accepted.
      '';
    };

    disableChunkedEncoding = mkOption {
      type = with types; nullOr bool;
      default = null;
      example = false;
      description = ''
        Disables chunked transfer encoding. Useful if you are running a WSGI server.
      '';
    };

    proxyAddress = mkOption {
      type = with types; nullOr str;
      default = null;
      example = "127.0.0.1";
      description = ''
        <literal>cloudflared</literal> starts a proxy server to translate HTTP traffic into TCP when proxying, for example, SSH or RDP. This configures the listen address for that proxy.
      '';
    };

    proxyPort = mkOption {
      type = with types; nullOr int;
      default = null;
      example = 0;
      description = ''
        <literal>cloudflared</literal> starts a proxy server to translate HTTP traffic into TCP when proxying, for example, SSH or RDP. This configures the listen port for that proxy. If set to zero, an unused port will randomly be chosen.
      '';
    };

    proxyType = mkOption {
      type = with types; nullOr (enum [ "" "socks" ]);
      default = null;
      example = "";
      description = ''
        <literal>cloudflared</literal> starts a proxy server to translate HTTP traffic into TCP when proxying, for example, SSH or RDP. This configures what type of proxy will be started. Valid options are:

        <itemizedlist>
            <listitem><para><literal>""</literal> for the regular proxy</para></listitem>
            <listitem><para><literal>"socks"</literal> for a SOCKS5 proxy. Refer to the <link xlink:href="https://developers.cloudflare.com/cloudflare-one/tutorials/kubectl/">tutorial on connecting through Cloudflare Access using kubectl</link> for more information.</para></listitem>
        </itemizedlist>
      '';
    };
  };
in
{
  meta.maintainers = with maintainers; [ bbigras ];

  options.services.cloudflared = {
    enable = mkEnableOption "Cloudflared Argo Tunnel client daemon";

    package = mkOption {
      type = types.package;
      default = pkgs.cloudflared;
      defaultText = "pkgs.cloudflared";
      description = "The package to use for Cloudflared.";
    };

    tunnels = mkOption {
      description = ''
        Cloudflare tunnels.
      '';
      type = types.attrsOf (types.submodule ({ name, ... }: {
        options = {
          inherit originRequest;

          tunnel = mkOption {
            type = with types; nullOr str;
            default = null;
            description = ''
              Tunnel ID or name.
            '';
            example = "00000000-0000-0000-0000-000000000000";
          };

          credentialsFile = mkOption {
            type = with types; nullOr str;
            default = null;
            description = ''
              Credential file.
            '';
          };

          default = mkOption {
            type = with types; nullOr str;
            default = null;
            description = ''
              Catch-all if no ingress matches.
            '';
            example = "http_status:404";
          };

          ingress = mkOption {
            type = types.attrsOf (types.submodule ({ hostname, ... }: {
              options = {
                inherit originRequest;

                service = mkOption {
                  type = with types; nullOr str;
                  default = null;
                  description = ''
                    TODO
                  '';
                  example = "http://localhost:80, tcp://localhost:8000, unix:/home/production/echo.sock, hello_world or http_status:404";
                };

                path = mkOption {
                  type = with types; nullOr str;
                  default = null;
                  description = ''
                    TODO
                  '';
                  example = "/*.(jpg|png|css|js)";
                };

              };
            }));
            default = { };
            description = ''
              TODO
            '';
            example = {
              "*.domain.com" = "http://localhost:80";
              "*.anotherone.com" = "http://localhost:80";
            };
          };
        };
      }));

      default = { };
    };
  };

  config = {
    systemd.services =
      mapAttrs'
        (name: tunnel:
          let
            filterConfig = lib.attrsets.filterAttrsRecursive (_: v: ! builtins.elem v [ null [ ] { } ]);

            fullConfig = {
              tunnel = name;
              "credentials-file" = tunnel.credentialsFile;
              ingress = (map
                (key: {
                  hostname = key;
                } // getAttr key (filterConfig (filterConfig tunnel.ingress)))
                (attrNames tunnel.ingress)) ++ [{ service = tunnel.default; }];
            };
            mkConfigFile = pkgs.writeText "cloudflared.yml" (builtins.toJSON fullConfig);
          in
          nameValuePair "cloudflared-tunnel-${name}" ({
            after = [ "network.target" ];
            wantedBy = [ "multi-user.target" ];
            serviceConfig = {
              ExecStart = "${cfg.package}/bin/cloudflared tunnel --config=${mkConfigFile} --no-autoupdate run";
              Restart = "always";
            };
          })
        )
        config.services.cloudflared.tunnels;
  };
}
