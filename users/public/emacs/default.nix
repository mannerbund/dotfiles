{
  username,
  inputs,
  ...
}:
{
  nixpkgs = {
    overlays = [
      inputs.emacs-overlay.overlays.default
    ];
  };

  home-manager.users.${username} =
    {
      config,
      pkgs,
      ...
    }:
    {

      home = {
        persistence."/persist/${config.home.homeDirectory}" = {
          directories = [ ".emacs.d" ];
        };
        sessionVariables = {
          ALTERNATE_EDITOR = "";
          EDITOR = "emacsclient -nw"; # $EDITOR opens in terminal
          VISUAL = "emacsclient -c -a emacs"; # $VISUAL opens in GUI mode
        };
        packages = with pkgs; [
          (aspellWithDicts (
            dicts: with dicts; [
              en
              en-computers
              en-science
              ru
            ]
          ))
          graphviz
          emacs-lsp-booster
          nixd
          scrot
        ];
      };

      services.gpg-agent.extraConfig = ''
        allow-emacs-pinentry
        allow-loopback-pinentry
      '';

      home.file.".emacs.d/early-init.el".text = ''
        ;;; early-init.el --- Early Initialization -*- lexical-binding: t; -*-
        (setq gc-cons-threshold most-positive-fixnum)
        (setq gc-cons-percentage 1.0)
        (setq read-process-output-max (* 1024 1024))

        (setenv "LSP_USE_PLISTS" "true")
        (setq lsp-use-plists t)

        (setq package-quickstart t)

        (setq initial-major-mode 'fundamental-mode)

        ;; (setq inhibit-x-resources t)
        (setq inhibit-splash-screen t)
        (setq inhibit-startup-screen t)
        (setq inhibit-startup-message t)
        (setq inhibit-startup-buffer-menu t)
        (setq initial-scratch-message nil)
        (setq bidi-inhibit-bpa t)

        (menu-bar-mode -1) ;; Don't display menu bar
        (tool-bar-mode -1) ;; Don't display tool bar
        (scroll-bar-mode -1) ;; Don't display scroll bar

        (custom-set-faces
         ;; Default font for all text
         '(default ((t (:family "Aporetic Sans Mono" :height 120))))
         '(fixed-pitch ((t (:family "Aporetic Serif Mono" :height 120))))

         ;; Current line number
         '(line-number-current-line ((t (:foreground "yellow" :inherit line-number))))
         '(mode-line ((t (:family "Aporetic Sans Mono" :weight Bold))))

         ;; Comments italic
         '(font-lock-function-name-face ((t (:family "Aporetic Sans Mono":slant italic))))
         '(font-lock-variable-name-face ((t (:family "Aporetic Sans Mono":weight bold)))))

        ;; Wayland Clipboard
        ;; (setq select-active-regions nil)
        ;; (setq select-enable-clipboard 't)
        ;; (setq select-enable-primary nil)
        ;; (setq interprogram-cut-function #'gui-select-text)
        ;;; early-init.el ends here
      '';

      services.emacs = {
        enable = true;
        client.enable = true;
      };

      programs =
        let
          al = {
            e = "emacsclient -nw -c";
          };
        in
        {
          zsh.shellAliases = al;
          fish.shellAliases = al;
          info.enable = true;
          emacs = {
            enable = true;
            package = (
              pkgs.emacsWithPackagesFromUsePackage {
                package = pkgs.emacs-git;
                config = ./emacs.el;
                defaultInitFile = true;
                extraEmacsPackages = epkgs: [
                  (epkgs.treesit-grammars.with-grammars (grammars: [
                    grammars.tree-sitter-python
                    grammars.tree-sitter-javascript
                    grammars.tree-sitter-json
                    grammars.tree-sitter-nix
                  ]))
                  epkgs.eglot-booster
                ];
              }
            );
          };
        };
    };
}
