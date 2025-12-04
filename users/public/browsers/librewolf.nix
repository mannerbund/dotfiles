{ username, ... }:
{
  home-manager.users.${username} =
    {
      config,
      ...
    }:
    {
      home.persistence."/persist/${config.home.homeDirectory}" = {
        directories = [ ".librewolf" ];
      };

      home.sessionVariables = {
        BROWSER = "librewolf";
      };

      programs.librewolf = {
        enable = true;
        settings = {
          "cookiebanners.service.mode.privateBrowsing" = 2;
          "cookiebanners.service.mode" = 2;
          "webgl.disabled" = false;
          "privacy.resistFingerprinting" = false;
          "privacy.fingerprintingProtection" = true;
          "privacy.fingerprintingProtection.overrides" = "+AllTargets,-CSSPrefersColorScheme,-JSDateTimeUTC";
          "privacy.clearOnShutdown.history" = false;
          "privacy.clearOnShutdown.cookies" = false;
          "privacy.clearOnShutdown.downloads" = false;
          "layout.css.devPixelsPerPx" = "1.05";
        };
        profiles."${config.home.username}" = {
          bookmarks.force = true;
          bookmarks.settings = [
            {
              name = "stuff";
              toolbar = true;
              bookmarks = [
                {
                  name = "github";
                  url = "https://github.com";
                }
                {
                  name = "wikipedia";
                  tags = [ "wiki" ];
                  keyword = "wiki";
                  url = "https://en.wikipedia.org/wiki/Special:Search?search=%s&go=Go";
                }
                {
                  name = "python docs";
                  url = "file://${config.home.homeDirectory}/Documents/python-3.13-docs/index.html";
                }
                {
                  name = "rutracker";
                  url = "https://rutracker.org";
                }
              ];
            }
            {
              name = "nix sites";
              toolbar = true;
              bookmarks = [
                {
                  name = "home-manager";
                  url = "https://home-manager-options.extranix.com/?query=&release=master";
                }
                {
                  name = "nixos-search";
                  url = "https://search.nixos.org";
                }
                {
                  name = "wiki";
                  tags = [
                    "wiki"
                    "nix"
                  ];
                  url = "https://wiki.nixos.org/";
                }
              ];
            }
            {
              name = "chatbots";
              toolbar = true;
              bookmarks = [
                {
                  name = "chatgpt";
                  url = "https://chatgpt.com";
                }
                {
                  name = "qwen";
                  url = "https://chat.qwen.ai";
                }
                {
                  name = "perplexity";
                  url = "https://www.perplexity.ai";
                }
              ];
            }
            {
              name = "books";
              toolbar = true;
              bookmarks = [
                {
                  name = "open-slum";
                  url = "https://open-slum.org";
                }
                {
                  name = "flibusta";
                  url = "https://flibusta.is";
                }
                {
                  name = "audiobookbay";
                  url = "https://audiobookbay.lu";
                }
              ];
            }
          ];
        };
        policies = {
          Homepage = {
            StartPage = "previous-session";
            Locked = true;
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
          EnableTrackingProtection = {
            Value = true;
            Locked = true;
            Cryptomining = true;
            Fingerprinting = true;
          };
          FirefoxSuggest = {
            SponsoredSuggestions = false;
            Locked = true;
          };
          AutofillAddressEnabled = true;
          AutofillCreditCardEnabled = false;
          PasswordManagerEnabled = false;
          DisableAppUpdate = true;
          DisableFirefoxAcounts = true;
          DisableFirefoxStudies = true;
          DisableFeedbackCommands = true;
          DisablePocket = true;
          DisableTelemetry = true;
          DontCheckDefaultBrowser = true;
          OfferToSaveLogins = false;
          ExtensionSettings = {
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
          };
        };
      };

    };
}
