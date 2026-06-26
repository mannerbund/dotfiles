{ username, ... }:
{
  home-manager.users.${username} =
    {
      config,
      ...
    }:
    {
      home.persistence."/persist" = {
        directories = [ ".config/mozilla/firefox" ];
      };

      home.sessionVariables = {
        BROWSER = "firefox";
      };

      programs.firefox = {
        enable = true;
        configPath = "${config.xdg.configHome}/mozilla/firefox";
        policies = {
          PasswordManagerEnabled = false;
          DisableFirefoxAccounts = true;
          DisablePocket = true;
          EnableTrackingProtection = {
            Value = true;
            Locked = true;
            Cryptomining = true;
            Fingerprinting = true;
          };
          FirefoxHome = {
            Search = true;
            TopSites = false;
            SponsoredTopSites = false;
            Highlights = false;
            Pocket = false;
            SponsoredPocket = false;
            Snippets = false;
            Locked = true;
          };
          FirefoxSuggest = {
            SponsoredSuggestions = false;
            Locked = true;
          };
          # DNSOverHTTPS = {
          #   Enabled = true;
          #   ProviderURL = "https://1.1.1.1/dns-query";
          #   Locked = true;
          #   Fallback = false;
          # };
          Preferences = {
            "browser.urlbar.autoFill.adaptiveHistory.enabled" = true;
            "browser.tabs.closeWindowWithLastTab" = false;
            "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
          };
          ExtensionSettings = {
            "uBlock0@raymondhill.net" = {
              installation_mode = "force_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            };
            "jid1-BoFifL9Vbdl2zQ@jetpack" = {
              installation_mode = "force_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/decentraleyes/latest.xpi";
            };
            "addon@darkreader.org" = {
              installation_mode = "force_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
            };
            "ru@dictionaries.addons.mozilla.org" = {
              installation_mode = "force_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/russian-spellchecking-dic-3703/latest.xpi";
            };
            "@testpilot-containers" = {
              installation_mode = "force_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/multi-account-containers/latest.xpi";
            };
          };
        };
      };
    };
}
