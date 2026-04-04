{ config, lib, ... }:

{
  options = {
    myLocale = {
      defaultLocale = lib.mkOption {
        type = lib.types.str;
        default = "en_US.UTF-8";
        description = "Default system locale";
      };

      keyboardLayout = lib.mkOption {
        type = lib.types.str;
        default = "us";
        description = "Keyboard layout for X11";
      };

      keyboardVariant = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Keyboard variant for X11";
      };

      consoleKeyMap = lib.mkOption {
        type = lib.types.str;
        default = "us";
        description = "Console keymap";
      };
    };
  };

  config = {
    # Time zone
    time.timeZone = "America/Sao_Paulo";

    # Locale settings
    i18n.defaultLocale = config.myLocale.defaultLocale;

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "pt_BR.UTF-8";
      LC_IDENTIFICATION = "pt_BR.UTF-8";
      LC_MEASUREMENT = "pt_BR.UTF-8";
      LC_MONETARY = "pt_BR.UTF-8";
      LC_NAME = "pt_BR.UTF-8";
      LC_NUMERIC = "pt_BR.UTF-8";
      LC_PAPER = "pt_BR.UTF-8";
      LC_TELEPHONE = "pt_BR.UTF-8";
      LC_TIME = "pt_BR.UTF-8";
    };

    # Keyboard configuration
    services.xserver.xkb = {
      layout = config.myLocale.keyboardLayout;
      variant = config.myLocale.keyboardVariant;
    };

    console.keyMap = config.myLocale.consoleKeyMap;
  };
}
