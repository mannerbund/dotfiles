{config, ...}: {
  home.persistence."/persist/${config.home.homeDirectory}" = {
    directories = [".librewolf"];
  };

  home.sessionVariables = {
    BROWSER = "librewolf";
  };

  programs.librewolf = {
    enable = true;
    languagePacks = ["en-US" "ru-RU"];
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
      "zoom.minPercent" = 110;
    };
    profiles."${config.home.username}" = {
      bookmarks.force = true;
      bookmarks.settings = [
        {
          name = "github";
          url = "https://github.com";
        }
        {
          name = "wikipedia";
          tags = ["wiki"];
          keyword = "wiki";
          url = "https://en.wikipedia.org/wiki/Special:Search?search=%s&go=Go";
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
              tags = ["wiki" "nix"];
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
              name = "deepseek";
              url = "https://deepseek.com";
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
              name = "libgen";
              url = "https://libgen.rs";
            }
            {
              name = "annas-archive";
              url = "https://annas-archive.org";
            }
            {
              name = "z-lib";
              url = "https://1lib.sk";
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
        {
          name = "trackers";
          toolbar = true;
          bookmarks = [
            {
              name = "rutracker";
              url = "https://rutracker.org";
            }
            {
              name = "thepiratebay";
              url = "https://thepiratebay.org";
            }
          ];
        }
      ];
    };
    policies = {
      Homepage = {
        StartPage = "previous-session";
      };
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      DNSOverHTTPS = {
        Enabled = true;
        Locked = true;
        Fallback = false;
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
        "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latestvimium-ff/latest.xpi";
        };
        "addon@darkreader.org" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
        };
      };
    };
  };
}
