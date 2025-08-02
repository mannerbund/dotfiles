{config, pkgs, ...}:
{

  home.persistence."/persist/${config.home.homeDirectory}" = {
    directories = [
      ".local/share/PrismLauncher"
    ];
  };

  home.packages = with pkgs; [
    glfw
    (prismlauncher.override {
      # Add binary required by some mod
      additionalPrograms = [ ffmpeg ];

      # Change Java runtimes available to Prism Launcher
      jdks = [
        graalvm-ce
        zulu8
        zulu17
        zulu
      ];
    })
  ];
}
