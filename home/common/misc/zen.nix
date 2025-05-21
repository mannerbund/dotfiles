{inputs, ...}: {
  imports = [
    inputs.zen-browser.homeModules.twilight
  ];

  xdg.mimeApps = let
    associations = builtins.listToAttrs (map (name: {
        inherit name;
        value = let
          zen-browser = inputs.zen-browser.packages."x86_64-linux".twilight;
        in
          zen-browser.meta.desktopFile;
      }) [
        "application/x-extension-shtml"
        "application/x-extension-xhtml"
        "application/x-extension-html"
        "application/x-extension-xht"
        "application/x-extension-htm"
        "x-scheme-handler/unknown"
        "x-scheme-handler/mailto"
        "x-scheme-handler/chrome"
        "x-scheme-handler/about"
        "x-scheme-handler/https"
        "x-scheme-handler/http"
        "application/xhtml+xml"
        "application/json"
        "text/html"
      ]);
  in {
    associations.added = associations;
    defaultApplications = associations;
  };

  home.sessionVariables = {
    BROWSER = "zen";
  };

  programs.zen-browser = {
    enable = true;
    policies = {
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
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
    };
  };
}
