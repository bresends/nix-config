{ ... }:

{
  programs.ssh = {
    enable = true;
    settings = {
      "oracle-inys-micro-sp-alpha" = {
        HostName = "oracle-inys-micro-sp-alpha";
        User = "bruno";
      };
      "oracle-inys-micro-sp-bravo" = {
        HostName = "oracle-inys-micro-sp-bravo";
        User = "bruno";
      };
      "oracle-bruno-micro-sp-alpha" = {
        HostName = "oracle-bruno-micro-sp-alpha";
        User = "bruno";
      };
      "oracle-bruno-ampere-sp-alpha" = {
        HostName = "oracle-bruno-ampere-sp-alpha";
        User = "bruno";
      };
    };
  };
}
