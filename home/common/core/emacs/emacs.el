;;; early-init.el --- Early Initialization -*- lexical-binding: t; -*-
(setq inhibit-x-resources t)
(setq inhibit-startup-screen t)
(setq inhibit-startup-message t)
(setq initial-scratch-message nil)

(setq package-enable-at-startup nil) ;; Disable `package.el'

(menu-bar-mode -1) ;; Don't display menu bar
(tool-bar-mode -1) ;; Don't display tool bar
(scroll-bar-mode -1) ;; Don't display scroll bar

;; Wayland Clipboard
(setopt select-active-regions nil)
(setopt select-enable-clipboard 't)
(setopt select-enable-primary nil)
(setopt interprogram-cut-function #'gui-select-text)

;; From https://github.com/terlar/emacs-config/blob/eb245566b1484112c3768ce44d353a1688f4ee66/init.org
(let ((normal-gc-cons-threshold gc-cons-threshold)
      (normal-gc-cons-percentage gc-cons-percentage)
      (normal-file-name-handler-alist file-name-handler-alist)
      (init-gc-cons-threshold most-positive-fixnum)
      (init-gc-cons-percentage 0.6))
  (setq gc-cons-threshold init-gc-cons-threshold
        gc-cons-percentage init-gc-cons-percentage
        file-name-handler-alist nil)
  (add-hook 'after-init-hook
            `(lambda ()
               (setq gc-cons-threshold ,normal-gc-cons-threshold
                     gc-cons-percentage ,normal-gc-cons-percentage
                     file-name-handler-alist ',normal-file-name-handler-alist))))

;;; init.el --- Initialization -*- lexical-binding: t; -*-
(use-package emacs
  :init
  (setopt confirm-kill-emacs 'y-or-n-p)
  ;; Backups
  (setopt backup-directory-alist `(("." . "~/.cache/backup")))
  (setopt backup-by-copying t)
  (setopt create-lockfiles nil)
  (setopt delete-old-versions t)
  (setopt delete-by-moving-to-trash t)
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
  (setopt reb-re-syntax 'string))

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

(set-face-attribute 'default nil :family "Aporetic Sans Mono" :height 160)
(set-face-attribute 'variable-pitch nil :family "Aporetic Serif Mono" :height 160)

;; Windows Management
(use-package windows
  :bind ("M-o" . other-window))

;; Org-mode
(use-package org
  :hook ((org-mode . visual-line-mode)
         (org-mode . flyspell-mode))
  :bind (([f12] . org-agenda)
         ([f11] . org-clock-goto)
         ([C-f11] . org-clock-in)
         ("C-c c" . org-capture))
  :config
  ;; Babel
  (setopt org-confirm-babel-evaluate nil)
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((C . t)
     (emacs-lisp . t)
     (latex . t)
     (org . t)
     (python . t)))
  (setopt org-babel-python-command "python3")
  ;; Org
  (setopt org-directory "~/Documents/Vault")
  (setopt org-log-done 'time)
  (setopt org-log-into-drawer t)
  ;; Agenda
  (setopt org-modules '(org-habit))
  (setopt org-habit-graph-column 60)
  (setopt org-agenda-files '("~/Documents/Vault/agenda"
                             "~/Documents/Vault/journal"))
  (setopt org-default-notes-file "~/Documents/Vault/agenda/refile.org")
  (defun org-journal-find-location ()
    (org-journal-new-entry t)
    (unless (eq org-journal-file-type 'daily)
      (org-narrow-to-subtree))
    (goto-char (point-max)))
  (setopt org-capture-templates
          '(("t" "Todo" entry (file "~/Documents/Vault/agenda/refile.org")
             "* TODO %?\n%u\n")
            ("j" "Journal" plain (function org-journal-find-location)
             "** %(format-time-string org-journal-time-format)%^{Title}\n%i%?"
             :jump-to-captured t :immediate-finish t)
            ("n" "Note" entry (file "~/Documents/Vault/agenda/refile.org")
             "* %? :note:\n%u\n")))
  (setopt org-todo-keywords
          '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
            (sequence "WAITING(w)" "HOLD(h)" "|" "CANCELED(c)")))
  (setopt org-todo-state-tags-triggers
          '(("CANCELED" ("CANCELED" . t))
            ("WAITING" ("WAITING" . t))
            ("HOLD" ("WAITING") ("HOLD" . t))
            (done ("WAITING") ("HOLD"))
            ("TODO" ("WAITING") ("CANCELED") ("HOLD"))
            ("NEXT" ("WAITING") ("CANCELED") ("HOLD"))
            ("DONE" ("WAITING") ("CANCELED") ("HOLD"))))
  (setopt org-todo-keyword-faces
          '(("TODO" . (:background "DodgerBlue" :weight bold :foreground "black"))
            ("NEXT" . (:background "BlueViolet" :weight bold :foreground "black"))
            ("DONE" . (:background "LimeGreen" :weight bold :foreground "black"))
            ("WAITING" . (:background "DarkOrange" :weight bold :foreground "black"))
            ("HOLD" . (:background "SlateGray" :weight bold :foreground "black"))
            ("CANCELED" . (:background "DarkRed" :weight bold :foreground "black"))))
  (setopt org-agenda-custom-commands
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
  (setopt org-enforce-todo-dependencies t)
  (setopt org-agenda-start-on-weekday nil)
  (setopt org-agenda-span 'day)
  (setopt org-deadline-warning-days 7)
  (setopt org-agenda-skip-deadline-if-done t)
  (setopt org-agenda-skip-scheduled-if-done t)
  (setopt org-agenda-dim-blocked-tasks t)
  (setopt org-agenda-compact-blocks t)
  (setopt org-agenda-include-diary t)
  (setopt org-agenda-log-mode 'clockcheck)
  (setopt org-agenda-log-mode-items '(clock closed))
  ;; Refile settings
  ;; Exclude DONE state tasks from refile targets
  (defun bh/verify-refile-target ()
    "Exclude todo keywords with a done state from refile targets"
    (not (member (nth 2 (org-heading-components)) org-done-keywords)))
  (setopt org-refile-target-verify-function 'bh/verify-refile-target)
  (setopt org-refile-targets (quote ((nil :maxlevel . 9)
                                     (org-agenda-files :maxlevel . 9))))
  (setopt org-refile-use-outline-path 'file)
  (setopt org-outline-path-complete-in-steps nil)
  (setopt org-refile-allow-creating-parent-nodes (quote confirm))
  ;; Archive settings
  (setopt org-archive-mark-done nil)
  (setopt org-archive-location "~/Documents/Vault/agenda/archive/%s_archive::* Archived Tasks")
  ;; Appearance
  (setopt org-startup-indented t)
  (setopt org-startup-folded 'content)
  (setopt org-startup-with-inline-images t)
  (setopt org-hide-emphasis-markers t)
  (setopt org-pretty-entities t)
  (setopt org-ellipsis " ┅ ")
  (setopt org-src-fontify-natively t)
  (setopt org-fontify-quote-and-verse-blocks t)
  (setopt org-fontify-whole-heading-line t)
  (setopt org-fontify-todo-headline t)
  (setopt org-fontify-done-headline t)
  ;; Vertico
  (advice-add #'org-make-tags-matcher :around #'vertico-enforce-basic-completion)
  (advice-add #'org-agenda-filter :around #'vertico-enforce-basic-completion)
  ;; LaTeX
  (add-hook 'org-mode-hook #'turn-on-org-cdlatex)
  (setopt org-use-sub-superscripts '{})
  (setopt org-startup-with-latex-preview t)
  (setopt org-latex-compiler "pdflatex")
  (setopt org-preview-latex-default-process 'dvisvgm)
  (setopt org-highlight-latex-and-related '(latex script entities)))

(use-package org-journal
  :ensure t
  :bind ("C-c o j" . org-journal-new-entry)
  :config
  (setopt org-journal-dir "~/Documents/Vault/journal"
          org-journal-file-format "%Y-%m.org"
          org-journal-date-format "%A, %d %B %Y"
          org-journal-time-format "%H:%M"
          org-journal-file-type 'monthly
          org-journal-enable-cache t
          org-journal-enable-agenda-integration t))

(use-package org-roam
  :ensure t
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ("C-c n a" . org-roam-alias-add)
         ("C-c n d" . org-id-get-create))
  :init
  (setq org-roam-db-gc-threshold most-positive-fixnum)
  :config
  (setopt org-roam-directory (file-truename "~/Documents/Vault/WIKI/notes"))
  (setopt org-roam-database-connector 'sqlite-builtin)
  (setopt org-roam-node-display-template (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
  (org-roam-db-autosync-mode))

(use-package org-super-agenda
  :ensure t
  :config
  (org-super-agenda-mode))

(use-package org-appear
  :ensure t
  :after org
  :hook (org-mode . org-appear-mode))

;; Completion
(use-package orderless
  :ensure t
  :config
  (setopt completion-styles '(orderless basic))
  (setopt completion-category-defaults nil)
  (setopt completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia
  :ensure t
  :bind (:map minibuffer-local-map
              ("M-A" . marginalia-cycle))
  :init
  (marginalia-mode))

(use-package savehist
  :init
  (savehist-mode))

(use-package vertico
  :ensure t
  :init
  (vertico-mode)
  :config
  (setopt vertico-multiform-categories
          '((file grid reverse)
            (imenu buffer)
            (deadgrep buffer)))
  (setopt vertico-multiform-commands
          '((buffer indexed)))
  (setopt vertico-scroll-margin 0) ;; Different scroll margin
  (setopt vertico-count 12) ;; Show more candidates
  (setopt vertico-resize nil)) ;; Grow and shrink the Vertico minibuffer

(use-package corfu
  :ensure t
  :init
  (global-corfu-mode)
  (corfu-history-mode)
  (corfu-popupinfo-mode)
  :config
  (setopt corfu-max-width 24)
  (setopt corfu-auto t)
  (setopt corfu-auto-prefix 5)
  (setopt corfu-auto-delay 0.07)
  (setopt corfu-count 8)
  (setopt corfu-cycle nil)
  (setopt corfu-quit-no-match 'separator)
  (setopt corfu-preselect 'prompt)
  (keymap-unset corfu-map "RET"))

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

;; Miscellaneous
(use-package tramp
  :config
  (setopt tramp-default-method "ssh")
  (setopt remote-file-name-inhibit-cache nil)
  (setopt tramp-verbose 1))

(use-package which-key
  :config
  (setopt which-key-idle-delay 0.3)
  (setopt which-key-sort-order 'which-key-key-order-alpha)
  (setopt which-key-separator " → ")
  (setopt which-key-unicode-correction 3)
  (setopt which-key-prefix-prefix "+")
  (which-key-setup-minibuffer)
  (which-key-mode))

(use-package eyebrowse
  :ensure t
  :init
  (setopt eyebrowse-keymap-prefix (kbd "C-c w"))
  :config
  (setopt eyebrowse-new-workspace t)
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
  :config
  (setq TeX-view-program-selection
        '((output-pdf "Zathura")))
  (setopt TeX-auto-save t
          TeX-parse-self t
          TeX-save-query nil
          TeX-PDF-mode t
          TeX-source-correlate-method 'synctex
          TeX-source-correlate-start-server t))

(use-package cdlatex
  :ensure t
  :after latex
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
  :init
  (setopt hl-line-sticky-flag nil)
  (setopt global-hl-line-sticky-flag nil)
  :hook
  (prog-mode . hl-line-mode)
  (text-mode . hl-line-mode)
  (org-mode . (lambda () (hl-line-mode -1))))

(use-package eldoc
  :config
  (setopt eldoc-idle-delay 0.5)
  (setopt eldoc-echo-area-use-multiline-p nil))

(use-package flymake
  :config
  :bind
  (:map flymake-mode-map
        ("C-. !" . flymake-show-buffer-diagnostics)))

(use-package eglot
  :defer t
  :hook ((python-mode . eglot-ensure)
         (c-mode . eglot-ensure)
         (c++-mode . eglot-ensure)
         (nix-ts-mode . eglot-ensure))
  :init
  (setopt eglot-autoshutdown t)
  (setopt eglot-autoreconnect t)
  (setopt eglot-code-action-indications nil)
  (setopt eglot-sync-connect nil)
  :bind
  (:map eglot-mode-map :prefix-map eglot-prefix-map :prefix "C-. e"
         ("a" . eglot-code-actions)
         ("f" . eglot-format)
         ("r" . eglot-rename)
         ("q" . eglot-reconnect)
         ("Q" . eglot-shutdown))
  :config
  (add-to-list 'eglot-server-programs
               '(nix-ts-mode . ("nil" :initializationOptions
                                (:formatting (:command ["alejandra"])))))

  (add-to-list 'eglot-server-programs
               '(python-mode . ("pylsp"))))
   
(use-package eglot-booster
  :after eglot
  :config (eglot-booster-mode))

;; Python
(use-package python
  :config
  (setopt python-indent-guess-indent-offset-verbose nil)
  (add-to-list 'display-buffer-alist
               '("\\*Python\\*"
                 (display-buffer-in-side-window)
                 (side . right)
                 (window-width . 0.42)
                 (no-select . t))))

;; Nix
(use-package nix-ts-mode
  :mode "\\.nix\\'")

;; Proof-general
(use-package proof-general
  :ensure t
  :config
  (load-library "proof-general")
  (setq proof-splash-enable nil)
  (setq proof-shell-kill-function-also-kills-associated-buffers t)
  (setq proof-multiple-frames-enable nil))


