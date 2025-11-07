;;; early-init.el --- Early Initialization -*- lexical-binding: t; -*-

(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024))

(setq initial-major-mode 'fundamental-mode)

(setq inhibit-x-resources t)
(setq inhibit-startup-screen t)
(setq inhibit-startup-message t)
(setq inhibit-startup-buffer-menu t)
(setq initial-scratch-message nil)

(menu-bar-mode -1) ;; Don't display menu bar
(tool-bar-mode -1) ;; Don't display tool bar
(scroll-bar-mode -1) ;; Don't display scroll bar

(setq package-enable-at-startup nil) ;; Disable `package.el'

(custom-set-faces
 ;; Default font for all text
 '(default ((t (:family "Aporetic Sans Mono" :height 160))))
 '(fixed-pitch ((t (:family "Aporetic Serif Mono" :height 160))))

 ;; Current line number
 '(line-number-current-line ((t (:foreground "yellow" :inherit line-number))))
 '(mode-line ((t (:family "Aporetic Sans Mono" :weight Bold))))

 ;; Comments italic
 '(font-lock-function-name-face ((t (:family "Aporetic Sans Mono":slant italic))))
 '(font-lock-variable-name-face ((t (:family "Aporetic Sans Mono":weight bold)))))

;; Wayland Clipboard
(setq select-active-regions nil)
(setq select-enable-clipboard 't)
(setq select-enable-primary nil)
(setq interprogram-cut-function #'gui-select-text)

;;; init.el --- Initialization -*- lexical-binding: t; -*-
(setopt confirm-kill-emacs 'y-or-n-p)

;; Backups
(setopt backup-directory-alist `(("." . "~/.cache/backup")))
(setopt backup-by-copying t)
(setopt create-lockfiles nil)
(setopt delete-old-versions t)
(setopt delete-by-moving-to-trash t)
(recentf-mode 1)

;; Bidirectional Display
(setopt bidi-display-reordering nil)

;; Tabs & Spaces
(setopt indent-tabs-mode nil)
(setopt tab-width 4)
(setopt tab-always-indent 'complete)

;; Parenthesis
(electric-pair-mode 1)
(show-paren-mode 1)

;; Scrolling & Cursor
(setopt cursor-in-non-selected-windows nil)
(setopt scroll-conservatively 101)
(setopt scroll-preserve-screen-position t)
(setopt mouse-wheel-progressive-speed nil)
(setopt mouse-wheel-follow-mouse t)
(setopt blink-cursor-mode nil) ;; Don't blink the cursor
(setopt visible-cursor nil)
(setopt minibuffer-prompt-properties
        ;; Do not allow the cursor in the minibuffer prompt
        '(read-only t cursor-intangible t face minibuffer-prompt))

;; Mode Line
(setopt mode-line-format (delq 'mode-line-modes mode-line-format))
(column-number-mode 1) ;; Display column number in the mode line

;; Visual
(tooltip-mode -1)
(setopt ring-bell-function 'ignore)

;; Disable Ispell completion function.
(setopt text-mode-ispell-word-completion nil)

;; Hide commands in M-x which do not work in the current mode.
(setopt read-extended-command-predicate #'command-completion-default-include-p)
(setopt reb-re-syntax 'string)

;; Native-Comp
(setopt native-comp-speed 3)
(setopt native-comp-compiler-options '("-march=skylake" "-O2" "-g0" "-fno-finite-math-only" "-fno-semantic-interposition" "-flto=auto" "-fuse-linker-plugin"))
(setopt native-comp-driver-options '("-march=skylake" "-O2" "-g0" "-fno-finite-math-only" "-fno-semantic-interposition" "-flto=auto" "-fuse-linker-plugin"))

;; Windows Management
(global-set-key (kbd "M-o") 'other-window)

;; Garbage Collection
(use-package gcmh
  :ensure t
  :hook
  (after-init-hook . gcmh-mode)
  :init
  (setopt gcmh-idle-delay 5)
  (setopt gcmh-high-cons-threshold (* 16 1024 1024)) ; 16MB
  (setopt gcmh-verbose init-file-debug))

;; Theme
(use-package gruvbox-theme
  :ensure t
  :config
  (load-theme 'gruvbox t))


;; Org-mode
(use-package org
  :ensure t
  :hook ((org-mode . visual-line-mode)
         (org-mode . flyspell-mode)
         (org-mode . turn-on-org-cdlatex))
  :bind (([f12] . org-agenda)
         ([f11] . org-clock-goto)
         ([C-f11] . org-clock-in)
         ("C-c c" . org-capture))
  :custom
  ;; Babel
  (org-confirm-babel-evaluate nil)
  (org-babel-python-command "python3")

  ;; Org
  (org-directory "~/Documents/Vault")
  (org-log-done 'time)
  (org-log-into-drawer t)

  ;; Agenda
  (org-modules '(org-habit))
  (org-habit-graph-column 60)
  (org-agenda-files '("~/Documents/Vault/agenda"
                      "~/Documents/Vault/journal"))
  (org-default-notes-file "~/Documents/Vault/agenda/refile.org")

  (org-todo-keywords
   '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
     (sequence "WAITING(w)" "HOLD(h)" "|" "CANCELED(c)")))

  (org-todo-state-tags-triggers
   '(("CANCELED" ("CANCELED" . t))
     ("WAITING" ("WAITING" . t))
     ("HOLD" ("WAITING") ("HOLD" . t))
     (done ("WAITING") ("HOLD"))
     ("TODO" ("WAITING") ("CANCELED") ("HOLD"))
     ("NEXT" ("WAITING") ("CANCELED") ("HOLD"))
     ("DONE" ("WAITING") ("CANCELED") ("HOLD"))))

  (org-todo-keyword-faces
   '(("TODO" . (:background "DodgerBlue" :weight bold :foreground "black"))
     ("NEXT" . (:background "BlueViolet" :weight bold :foreground "black"))
     ("DONE" . (:background "LimeGreen" :weight bold :foreground "black"))
     ("WAITING" . (:background "DarkOrange" :weight bold :foreground "black"))
     ("HOLD" . (:background "SlateGray" :weight bold :foreground "black"))
     ("CANCELED" . (:background "DarkRed" :weight bold :foreground "black"))))

  (org-agenda-custom-commands
   '(("u" "Super View"
      ((agenda "" ((org-super-agenda-groups
                    '((:name "Today"
                             :time-grid t
                             :date today
                             :scheduled today
                             :order 1)
                      (:discard (:habit t))))))
       (alltodo "" ((org-agenda-overriding-header "")
                    (org-super-agenda-groups
                     '((:discard (:habit t))
                       (:name "Important"
                              :priority "A"
                              :order 0)
                       (:name "Next to do"
                              :todo "NEXT"
                              :order 0)
                       (:name "Refile"
                              :tag "REFILE"
                              :order 2)
                       (:name "Low Priority"
                              :priority "C"
                              :order 100)
                       (:auto-category t)))))))))

  (org-enforce-todo-dependencies t)
  (org-agenda-start-on-weekday nil)
  (org-agenda-span 'day)
  (org-deadline-warning-days 7)
  (org-agenda-skip-deadline-if-done t)
  (org-agenda-skip-scheduled-if-done t)
  (org-agenda-dim-blocked-tasks t)
  (org-agenda-compact-blocks t)
  (org-agenda-include-diary t)
  (org-agenda-log-mode 'clockcheck)
  (org-agenda-log-mode-items '(clock closed))

  ;; Refile
  (org-refile-target-verify-function 'bh/verify-refile-target)
  (org-refile-targets '((nil :maxlevel . 9)
                        (org-agenda-files :maxlevel . 9)))
  (org-refile-use-outline-path 'file)
  (org-outline-path-complete-in-steps nil)
  (org-refile-allow-creating-parent-nodes 'confirm)

  ;; Archive
  (org-archive-mark-done nil)
  (org-archive-location "~/Documents/Vault/agenda/archive/%s_archive::* Archived Tasks")
  
  ;; Appearance
  (org-startup-indented t)
  (org-startup-folded 'content)
  (org-startup-with-inline-images t)
  (org-hide-emphasis-markers t)
  (org-pretty-entities t)
  (org-ellipsis " ┅ ")
  (org-src-fontify-natively t)
  (org-fontify-quote-and-verse-blocks t)
  (org-fontify-whole-heading-line t)
  (org-fontify-todo-headline t)
  (org-fontify-done-headline t)

  ;; LaTeX
  (org-use-sub-superscripts '{})
  (org-startup-with-latex-preview t)
  (org-latex-compiler "pdflatex")
  (org-preview-latex-default-process 'dvisvgm)
  (org-highlight-latex-and-related '(latex script entities))
  :config
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((C . t)
     (emacs-lisp . t)
     (shell . t)
     (org . t)
     (python . t)))

  (setq org-capture-templates
        '(("t" "Todo" entry (file "~/Documents/Vault/agenda/refile.org")
           "* TODO %?\n%u\n")
          ("j" "Journal" plain (function org-journal-find-location)
           "** %(format-time-string org-journal-time-format)%^{Title}\n%i%?"
           :jump-to-captured t :immediate-finish t)
          ("n" "Note" entry (file "~/Documents/Vault/agenda/refile.org")
           "* %? :note:\n%u\n")))

  ;; Vertico
  (advice-add #'org-make-tags-matcher :around #'vertico-enforce-basic-completion)
  (advice-add #'org-agenda-filter :around #'vertico-enforce-basic-completion)

  ;; Custom
  (defun org-journal-find-location ()
    (org-journal-new-entry t)
    (unless (eq org-journal-file-type 'daily)
      (org-narrow-to-subtree))
    (goto-char (point-max)))

  (defun bh/verify-refile-target ()
    "Exclude todo keywords with a done state from refile targets"
    (not (member (nth 2 (org-heading-components)) org-done-keywords))))

(use-package org-journal
  :ensure t
  :bind ("C-c o j" . org-journal-new-entry)
  :custom
  (org-journal-dir "~/Documents/Vault/journal")
  (org-journal-file-format "%Y-%m.org")
  (org-journal-date-format "%A, %d %B %Y")
  (org-journal-time-format "%H:%M")
  (org-journal-file-type 'monthly)
  (org-journal-enable-cache t)
  (org-journal-enable-agenda-integration t))

(use-package org-roam
  :ensure t
  :after org
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ("C-c n a" . org-roam-alias-add)
         ("C-c n d" . org-id-get-create))
  :custom
  (org-roam-directory (file-truename "~/Documents/Vault/WIKI/notes"))
  (org-roam-database-connector 'sqlite-builtin)
  (org-roam-node-display-template (concat "${title:*} " (propertize "${tags:25}" 'face 'org-tag)))
  :config
  (org-roam-db-autosync-mode))

(use-package org-super-agenda
  :ensure t
  :init
  (org-super-agenda-mode))

(use-package org-appear
  :ensure t
  :after org
  :hook (org-mode . org-appear-mode))

;; Completion
(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-pcm-leading-wildcard t)
  ;; Vertico
  (completion-category-defaults nil))

(use-package marginalia
  :ensure t
  :bind (:map minibuffer-local-map
              ("M-A" . marginalia-cycle))
  :init
  (marginalia-mode))

(use-package savehist
  :init
  (savehist-mode)
  :custom
  (savehist-additional-variables '(minibuffer-history)))

(use-package vertico
  :ensure t
  :init
  (vertico-mode)
  :custom
  (vertico-preselect 'prompt)
  (vertico-multiform-categories
   '((file (vertico-sort-function . vertico-sort-directories-first))
     (imenu buffer)))
  (vertico-scroll-margin 0) ;; Different scroll margin
  (vertico-count 12) ;; Show more candidates
  (vertico-resize nil) ;; Grow and shrink the Vertico minibuffer
  :config
  (vertico-multiform-mode))

(use-package corfu
  :ensure t
  :init
  (global-corfu-mode)
  (corfu-history-mode)
  (corfu-popupinfo-mode)
  :custom
  (corfu-max-width 24)
  (corfu-auto t)
  (corfu-auto-prefix 3)
  (corfu-auto-delay 0.07)
  (corfu-count 8)
  (corfu-cycle nil)
  (corfu-quit-no-match 'separator)
  (corfu-preselect 'prompt))

(use-package dabbrev
  :config
  (add-to-list 'dabbrev-ignored-buffer-regexps "\\` ")
  (add-to-list 'dabbrev-ignored-buffer-modes 'authinfo-mode)
  (add-to-list 'dabbrev-ignored-buffer-modes 'doc-view-mode)
  (add-to-list 'dabbrev-ignored-buffer-modes 'pdf-view-mode)
  (add-to-list 'dabbrev-ignored-buffer-modes 'tags-table-mode))

(use-package deadgrep
  :ensure t
  :bind (:map search-map
              ("r" . deadgrep)))

;; Major Modes
(use-package magit
  :ensure t)

(use-package git-commit
  :after magit
  :hook (git-commit-setup . flyspell-mode))

(use-package markdown-mode
  :ensure t
  :mode ("README\\.md\\'" . gfm-mode)
  :bind (:map markdown-mode-map
              ("C-c C-e" . markdown-do))
  :custom
  (markdown-command "multimarkdown"))

(use-package calc
  :custom
  (calc-group-char ",")
  :config
  (setopt calc-group-digits t))

(use-package mhtml-mode
  :hook (mhtml-mode . flyspell-mode)
  :config
  (define-key mhtml-mode-map (kbd "M-o") nil)
  (define-key mhtml-mode-map (kbd "M-p") facemenu-keymap))

;; Miscellaneous
(use-package tramp
  :custom
  (tramp-default-method "ssh")
  (remote-file-name-inhibit-cache nil)
  (tramp-verbose 1))

(use-package which-key
  :custom
  (which-key-idle-delay 0.3)
  (which-key-sort-order 'which-key-key-order-alpha)
  (which-key-separator " → ")
  (which-key-unicode-correction 3)
  (which-key-prefix-prefix "+")
  :config
  (which-key-setup-minibuffer)
  (which-key-mode 1))

(use-package eyebrowse
  :ensure t
  :custom
  (eyebrowse-keymap-prefix (kbd "C-c w"))
  (eyebrowse-new-workspace t)
  :config
  (eyebrowse-mode t))

(defun apostolic/latex-prettify-symbols ()
  (setopt prettify-symbols-alist
          '(("\\alpha"     . #x03B1)
            ("\\beta"      . #x03B2)
            ("\\gamma"     . #x03B3)
            ("\\delta"     . #x03B4)
            ("\\epsilon"   . #x03B5)
            ("\\zeta"      . #x03B6)
            ("\\eta"       . #x03B7)
            ("\\theta"     . #x03B8)
            ("\\lambda"    . #x03BB)
            ("\\mu"        . #x03BC)
            ("\\pi"        . #x03C0)
            ("\\phi"       . #x03C6)
            ("\\psi"       . #x03C8)
            ("\\Omega"     . #x03A9)
            ("\\infty"     . #x221E)
            ("\\rightarrow". #x2192)
            ("\\leftarrow" . #x2190)
            ("\\leq"       . #x2264)
            ("\\geq"       . #x2265)
            ("\\neq"       . #x2260)
            ("\\times"     . #x00D7)
            ("\\cdot"      . #x22C5)
            ("\\sum"       . #x2211)
            ("\\int"       . #x222B)
            ("\\to"        . #x2192)))
  (prettify-symbols-mode 1))

(use-package auctex
  :ensure t
  :mode ("\\.tex\\'" . LaTeX-mode)
  :hook ((LaTeX-mode . LaTeX-preview-setup)
         (LaTeX-mode . apostolic/latex-prettify-symbols)
         (LaTeX-mode . flyspell-mode)
         (LaTeX-mode . TeX-source-correlate-mode))
  :custom
  (TeX-view-program-selection '((output-pdf "Zathura")))
  (TeX-auto-save t)
  (TeX-parse-self t)
  (TeX-save-query nil)
  (TeX-PDF-mode t)
  (TeX-source-correlate-method 'synctex)
  (TeX-source-correlate-start-server t)
  (LaTeX-electric-left-right-brace t)
  (LaTeX-indent-level 2)
  (LaTeX-item-indent 0)
  (TeX-brace-indent-level 2))

(use-package cdlatex
  :ensure t
  :after (auctex)
  :hook ((LaTeX-mode . cdlatex-mode)
         (LaTeX-mode . cdlatex-electricindex-mode)))

(use-package wrap-region
  :ensure t
  :config
  (wrap-region-add-wrapper "$" "$" nil 'org-mode)
  (wrap-region-add-wrapper "*" "*" nil 'org-mode) 
  (wrap-region-add-wrapper "/" "/" nil 'org-mode) 
  (wrap-region-add-wrapper "_" "_" nil 'org-mode) 
  (wrap-region-add-wrapper "=" "=" nil 'org-mode) 
  (wrap-region-add-wrapper "~" "~" nil 'org-mode) 
  (wrap-region-add-wrapper "+" "+" nil 'org-mode)
  (wrap-region-global-mode t))

(use-package envrc
  :ensure t
  :hook (after-init . envrc-global-mode))

(use-package hl-line
  :hook
  (prog-mode . hl-line-mode)
  (text-mode . hl-line-mode)
  (org-mode . (lambda () (hl-line-mode -1)))
  :custom
  (hl-line-sticky-flag nil)
  (global-hl-line-sticky-flag nil))

(use-package eldoc
  :custom
  (eldoc-idle-delay 0.5)
  (eldoc-echo-area-use-multiline-p nil))

(use-package flymake
  :defer t
  :bind
  (:map flymake-mode-map
        ("C-. !" . flymake-show-buffer-diagnostics)))

(use-package eglot
  :defer t
  :hook ((python-mode . eglot-ensure)
         (c-mode . eglot-ensure)
         (c++-mode . eglot-ensure)
         (nix-ts-mode . eglot-ensure))
  :bind
  (:map eglot-mode-map
        :prefix-map eglot-prefix-map
        :prefix "C-. e"
        ("a" . eglot-code-actions)
        ("f" . eglot-format)
        ("r" . eglot-rename)
        ("q" . eglot-reconnect)
        ("Q" . eglot-shutdown))
  :custom
  (eglot-autoshutdown t)
  (eglot-autoreconnect t)
  (eglot-code-action-indications nil)
  (eglot-sync-connect nil)
  :config
  (add-to-list 'eglot-server-programs
               '(nix-ts-mode . ("nil"
                                :initializationOptions
                                (:formatting (:command ["alejandra"])))))
  (add-to-list 'eglot-server-programs
               '(python-mode . ("pylsp"))))

(use-package eglot-booster
  :after eglot
  :config (eglot-booster-mode))

;; Python
(use-package python
  :custom
  (python-indent-guess-indent-offset-verbose nil)
  (add-to-list 'display-buffer-alist
               '("\\*Python\\*"
                 (display-buffer-in-side-window)
                 (side . right)
                 (window-width . 0.42)
                 (no-select . t))))

;; Nix
(use-package nix-ts-mode
  :ensure t
  :mode "\\.nix\\'")

;; Proof-general
(use-package proof-general
  :ensure t
  :custom
  (proof-splash-enable nil)
  (proof-shell-kill-function-also-kills-associated-buffers t)
  (proof-multiple-frames-enable nil))

;; Anki
(use-package anki-editor
  :ensure t)
