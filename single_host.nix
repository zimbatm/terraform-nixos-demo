{ ... }:
{
  imports = [ ./boot_image.nix ];

  networking.firewall.allowedTCPPorts = [ 80 ];

  services.nginx = {
    enable = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    statusPage = true;
    commonHttpConfig = ''
      resolver 127.0.0.1 valid=5s;
    '';

    virtualHosts."default" = {
      locations."/" = {
        proxyPass = "http://localhost:3000";
      };
    };
  };

  services.grafana = {
    enable = true;
    port = 3000;
    auth.anonymous.enable = true;
  };

  services.prometheus = {
    enable = true;
    globalConfig = {
      scrape_interval = "30s";
    };
    scrapeConfigs = [
      {
        job_name = "prometheus";
        static_configs = [
          { targets = [ "localhost:9130" ]; }
        ];
      }

      {
        job_name = "unifi";
        static_configs = [
          { targets = [ "localhost:9130" ]; }
        ];
      }

      {
        job_name = "node";
        static_configs = [
          { targets = [ "localhost:9100" ]; }
        ];
      }
    ];
  };

  services.prometheus.exporters.node.enable = true;
}
