{ ... }:

{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "oracle-inys-micro-sp-alpha" = {
        hostname = "oracle-inys-micro-sp-alpha";
        user = "bruno";
      };
      "oracle-inys-micro-sp-bravo" = {
        hostname = "oracle-inys-micro-sp-bravo";
        user = "bruno";
      };
      "oracle-bruno-micro-sp-alpha" = {
        hostname = "oracle-bruno-micro-sp-alpha";
        user = "bruno";
      };
      "oracle-bruno-ampere-sp-alpha" = {
        hostname = "oracle-bruno-ampere-sp-alpha";
        user = "bruno";
      };
    };
  };
}
