{
  config,
  lib,
  ...
}:

let
  monokaiPro = (import ./colors.nix).monokaiPro;
  mainColor = config.bruno.starship.mainColor;

  langConfig = symbol: {
    inherit symbol;
    style = "bg:green";
    format = "[[ $symbol( $version) ](fg:crust bg:green)]($style)";
  };
in
{
  options.bruno.starship.mainColor = lib.mkOption {
    type = lib.types.enum [
      "peach"
      "sapphire"
    ];
    default = "peach";
    description = "Main Starship prompt segment color.";
  };

  config.programs.starship = {
    enable = true;
    settings = {
      format =
        "[](${mainColor})"
        + "$os"
        + "$username"
        + "$directory"
        + "[](bg:yellow fg:${mainColor})"
        + "$git_branch"
        + "$git_status"
        + "[](fg:yellow bg:green)"
        + "$c"
        + "$rust"
        + "$golang"
        + "$nodejs"
        + "$php"
        + "$java"
        + "$kotlin"
        + "$haskell"
        + "$python"
        + "[](fg:green bg:sapphire)"
        + "$docker_context"
        + "[](fg:sapphire bg:surface2)"
        + "$time"
        + "[ ](fg:surface2)"
        + "$character";
      palette = "monokai";

      os = {
        disabled = false;
        style = "bg:${mainColor} fg:crust";
        format = "[$symbol]($style)";
        symbols = {
          Windows = "󰍲";
          Ubuntu = "󰕈";
          SUSE = "";
          Raspbian = "󰐿";
          Mint = "󰣭";
          Macos = "󰀵";
          Manjaro = "";
          Linux = "❄";
          Gentoo = "󰣨";
          Fedora = "󰣛";
          Alpine = "";
          Amazon = "";
          Android = "";
          Arch = "󰣇";
          Artix = "󰣇";
          CentOS = "";
          Debian = "󰣚";
          Redhat = "󱄛";
          RedHatEnterprise = "󱄛";
        };
      };

      username = {
        show_always = false;
        style_user = "bg:${mainColor} fg:crust";
        style_root = "bg:${mainColor} fg:crust";
        format = "[ $user]($style)";
      };

      directory = {
        style = "bg:${mainColor} fg:crust";
        format = "[$path ]($style)";
        truncation_length = 3;
        truncation_symbol = "/";
        substitutions = {
          "Documents" = "󰈙 ";
          "Downloads" = " ";
          "Music" = "󰝚 ";
          "Pictures" = " ";
          "Developer" = "󰲋 ";
        };
      };

      git_branch = {
        symbol = "";
        style = "bg:yellow";
        format = "[[ $symbol $branch ](fg:crust bg:yellow)]($style)";

      };

      git_status = {
        style = "bg:yellow";
        format = "[[($all_status$ahead_behind )](fg:base bg:yellow)]($style)";
        conflicted = "=\${count}";
        ahead = "⇡\${count}";
        behind = "⇣\${count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
        up_to_date = "";
        untracked = "?\${count}";
        stashed = "\${count}";
        modified = "!\${count}";
        staged = "+\${count}";
        renamed = "»\${count}";
        deleted = "✘\${count}";
      };

      nodejs = langConfig "";
      c = langConfig " ";
      rust = langConfig "";
      golang = langConfig "";
      php = langConfig "";
      java = langConfig " ";
      kotlin = langConfig "";
      haskell = langConfig "";

      python = {
        symbol = "";
        style = "bg:green";
        format = "[[ $symbol( $version)(\(#$virtualenv\)) ](fg:crust bg:green)]($style)";
      };

      docker_context = {
        symbol = "";
        style = "bg:sapphire";
        format = "[[ $symbol( $context) ](fg:crust bg:sapphire)]($style)";
      };

      time = {
        disabled = false;
        time_format = "%R";
        style = "bg:surface2";
        format = "[[  $time ](fg:white bg:surface2)]($style)";
      };

      line_break.disabled = true;

      character = {
        disabled = false;
        success_symbol = "[❯](bold fg:green)";
        error_symbol = "[❯](bold fg:red)";
        vimcmd_symbol = "[❮](bold fg:green)";
        vimcmd_replace_one_symbol = "[❮](bold fg:lavender)";
        vimcmd_replace_symbol = "[❮](bold fg:lavender)";
        vimcmd_visual_symbol = "[❮](bold fg:yellow)";
      };

      cmd_duration = {
        show_milliseconds = true;
        format = " in $duration ";
        style = "bg:lavender";
        disabled = false;
        show_notifications = true;
        min_time_to_notify = 45000;
      };

      palettes = {
        monokai = {
          red = monokaiPro.UltraRed;
          peach = monokaiPro.AtomicTangerine;
          yellow = monokaiPro.Sunglow;
          green = monokaiPro.YellowGreen;
          sapphire = monokaiPro.TurquoiseBlue;
          lavender = monokaiPro.MediumPurple;
          surface2 = monokaiPro.Onyx;
          base = monokaiPro.Blackcurrant;
          crust = monokaiPro.EerieBlack;
          white = monokaiPro.WhiteSmoke;
        };
      };
    };
  };
}
