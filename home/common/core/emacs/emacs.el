;;; early-init.el --- Early Initialization -*- lexical-binding: t; -*-
(setq inhibit-x-resources t)
(setq inhibit-startup-screen t)
(setq inhibit-startup-message t)
(setq initial-scratch-message nil)

(setq package-enable-at-startup nil) ;; Disable `package.el'

(menu-bar-mode -1) ;; Don't display menu bar
(tool-bar-mode -1) ;; Don't display tool bar
(scroll-bar-mode -1) ;; Don't display scroll bar
(blink-cursor-mode -1) ;; Don't blink the cursor

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
  (setopt backup-directory-alist `(("." . "~/.cache/backup")))
  (setopt backup-by-copying t)
  (setopt create-lockfiles nil)
  (setopt delete-old-versions t)
  (setopt delete-by-moving-to-trash t)
  (setopt auto-mode-case-fold nil)
  (setopt bidi-inhibit-bpa t)
  (setopt bidi-display-reordering 'left-to-right
          bidi-paragraph-direction 'left-to-right)
  (setopt fast-but-imprecise-scrolling t)
  (setopt indent-tabs-mode nil)
  (setopt tab-width 4)
  (setopt confirm-kill-emacs 'y-or-n-p)
  (setopt ring-bell-function 'ignore)
  (setopt visible-cursor nil)
  (setopt cursor-in-non-selected-windows nil)
  (setopt scroll-conservatively 101)
  (setopt scroll-preserve-screen-position t)
  (setopt mouse-wheel-progressive-speed nil)
  (setopt mouse-wheel-follow-mouse t)
  (tooltip-mode -1) ;; Don't display tooltips as popups, use the echo area instead
  (electric-pair-mode 1)
  (show-paren-mode 1)
  (column-number-mode 1) ;; Display column number in the mode line
  (setopt show-paren-context-when-offscreen t)
  ;; Enable indentation+completion using the TAB key.
  ;; `completion-at-point' is often bound to M-TAB.
  (setopt tab-always-indent 'complete)
  ;; Disable Ispell completion function.
  (setopt text-mode-ispell-word-completion nil)
  ;; Hide commands in M-x which do not work in the current mode.
  (setopt read-extended-command-predicate #'command-completion-default-include-p)
  ;; Do not allow the cursor in the minibuffer prompt
  (setopt minibuffer-prompt-properties
          '(read-only t cursor-intangible t face minibuffer-prompt)))

(use-package gcmh
  :ensure t
  :hook
  (after-init-hook . gcmh-mode)
  :init
  (setopt gcmh-idle-delay 5)
  (setopt gcmh-high-cons-threshold (* 16 1024 1024)) ; 16MB
  (setopt gcmh-verbose init-file-debug))

;; Evil
(use-package evil
  :ensure t
  :init
  (setopt evil-want-keybinding nil)
  (setopt evil-undo-system 'undo-redo)
  (setopt evil-want-C-i-jump nil)
  (setopt evil-want-C-u-scroll t)
  (setopt evil-want-Y-yank-to-eol t)
  :config
  (setopt evil-visual-update-x-selection-p nil)
  (setopt evil-respect-visual-line-mode t)
  (setopt evil-want-minibuffer t)
  (evil-mode))

(use-package evil-collection
  :ensure t
  :after evil
  :config
  (setopt evil-collection-calendar-want-org-bindings t)
  (setopt evil-collection-setup-minibuffer t)
  (evil-collection-init))

(use-package evil-org
  :ensure t
  :after (evil org)
  :hook (org-mode . evil-org-mode)
  :config
  (require 'evil-org-agenda)
  (evil-org-set-key-theme '(textobjects insert navigation additional shift todo heading))
  (evil-org-agenda-set-keys))

(use-package evil-surround
  :ensure t
  :after evil
  :config
  (global-evil-surround-mode 1))

;; Theme
(use-package gruvbox-theme
  :ensure t
  :config
  (load-theme 'gruvbox-dark-hard t))

(set-face-attribute 'default nil :family "Iosevka" :height 160)
(set-face-attribute 'variable-pitch nil :family "Aporetic Serif Mono" :height 160)

;; Major Modes
(use-package calc
  :preface
  (evil-collection-define-key 'normal 'calc-mode-map
    (kbd "C-r") 'calc-redo))

(use-package nix-mode
  :ensure t
  :mode "\\.nix\\'")

;; Org-mode
(use-package org
  :hook ((org-mode . visual-line-mode)
         (org-mode . flyspell-mode)
         (org-mode . turn-on-org-cdlatex)
         (org-mode . org-latex-preview))
  :bind (([f12] . org-agenda)
         ([f11] . org-clock-goto)
         ([C-f11] . org-clock-in)
         ("C-c c" . org-capture))
  :config
  (setopt org-link-frame-setup
          '((vm . vm-visit-folder-other-frame)
            (vm-imap . vm-visit-imap-folder-other-frame)
            (gnus . org-gnus-no-new-news)
            (file . find-file)
            (wl . wl-other-frame)))
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
  (setopt org-agenda-files '("~/Documents/Vault/agenda"))
  (setopt org-default-notes-file "~/Documents/Vault/agenda/refile.org")
  (setopt org-capture-templates
          '(("t" "todo" entry (file "~/Documents/Vault/agenda/refile.org")
             "* TODO %?\n%u\n" :clock-in t :clock-resume t)
            ("d" "diary" entry (file+olp+datetree "~/Documents/Vault/agenda/diary.org")
             "* %?\n%u\n" :clock-in t :clock-resume t)
            ("n" "note" entry (file "~/Documents/Vault/agenda/refile.org")
             "* %? :note:\n%u\n" :clock-in t :clock-resume t)))
  (setopt org-todo-keywords
          '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
            (sequence "WAITING(w)" "HOLD(i)" "|" "CANCELLED(c)")))
  (setopt org-todo-state-tags-triggers
          '(("CANCELLED" ("CANCELLED" . t))
            ("WAITING" ("WAITING" . t))
            ("HOLD" ("WAITING") ("HOLD" . t))
            (done ("WAITING") ("HOLD"))
            ("TODO" ("WAITING") ("CANCELLED") ("HOLD"))
            ("NEXT" ("WAITING") ("CANCELLED") ("HOLD"))
            ("DONE" ("WAITING") ("CANCELLED") ("HOLD"))))
  (setopt org-agenda-include-diary t)
  (setopt org-agenda-diary-file "~/Documents/Vault/agenda/diary.org")
  (setopt org-enforce-todo-dependencies t)
  (setopt org-agenda-dim-blocked-tasks t)
  (setopt org-agenda-compact-blocks t)
  (setopt org-agenda-start-on-weekday nil)
  (setopt org-agenda-span 'day)
  (setopt org-deadline-warning-days 7)
  (setopt org-agenda-skip-deadline-if-done t)
  (setopt org-agenda-skip-scheduled-if-done t)
  (evil-set-initial-state 'org-agenda-mode 'motion)
  ;;;; Refile settings
  ; Exclude DONE state tasks from refile targets
  (defun bh/verify-refile-target ()
    "Exclude todo keywords with a done state from refile targets"
    (not (member (nth 2 (org-heading-components)) org-done-keywords)))
  (setq org-refile-target-verify-function 'bh/verify-refile-target)
  (setq org-refile-targets (quote ((nil :maxlevel . 9)
                                   (org-agenda-files :maxlevel . 9))))
  (setq org-refile-use-outline-path t)
  (setq org-outline-path-complete-in-steps nil)
  (setq org-refile-allow-creating-parent-nodes (quote confirm))
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
  (setopt org-use-sub-superscripts '{})
  (setopt org-startup-with-latex-preview t)
  (setopt org-latex-compiler "pdflatex")
  (setopt org-preview-latex-default-process 'dvisvgm)
  (setopt org-highlight-latex-and-related '(latex script entities)))

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

(use-package org-modern
  :ensure t
  :hook
  (org-mode-hook . org-modern-mode)
  :init
  (setopt org-modern-hide-stars t)
  (setopt org-modern-table nil)
  :config
  (setopt org-modern-todo-faces
          '(("TODO" :background "DodgerBlue" :weight bold :foreground "black")
            ("NEXT" :background "BlueViolet" :weight bold :foreground "black")
            ("DONE" :background "LimeGreen" :weight bold :foreground "black")
            ("WAITING" :background "DarkOrange" :weight bold :foreground "black")
            ("HOLD" :background "SlateGray" :weight bold :foreground "black")
            ("CANCELLED" :background "DarkRed" :weight bold :foreground "black"))))

(use-package org-appear
  :ensure t
  :hook
  (org-mode-hook . org-appear-mode))

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

(use-package consult
  :ensure t
  :bind (;; C-c bindings in `mode-specific-map'
         ("C-c M-x" . consult-mode-command)
         ("C-c h" . consult-history)
         ("C-c m" . consult-man)
         ;; C-x bindings in `ctl-x-map'
         ("C-x b" . consult-buffer)            
         ;; M-g bindings in `goto-map'
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flymake)
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings in `search-map'
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history)                 ;; orig. next-matching-history-element
         ("M-r" . consult-history))                ;; orig. previous-matching-history-element

  :hook (completion-list-mode . consult-preview-at-point-mode)
  :init
  (advice-add #'register-preview :override #'consult-register-window)
  (setopt register-preview-delay 0.5)
  ;; Use Consult to select xref locations with preview
  (setopt xref-show-xrefs-function #'consult-xref
          xref-show-definitions-function #'consult-xref)
  ;; Enable recording recently-visited files
  (recentf-mode)
  :config
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep consult-man
   consult-bookmark consult-recent-file consult-xref
   consult--source-bookmark consult--source-file-register
   consult--source-recent-file consult--source-project-recent-file
   ;; :preview-key "M-."
   :preview-key '(:debounce 0.4 any))
  (setopt consult-narrow-key "<"))

(use-package savehist
  :init
  (savehist-mode))

(use-package vertico
  :ensure t
  :init
  (vertico-mode)
  :config
  (setopt vertico-scroll-margin 0) ;; Different scroll margin
  (setopt vertico-count 12) ;; Show more candidates
  (setopt vertico-resize nil) ;; Grow and shrink the Vertico minibuffer
  (evil-make-intercept-map vertico-map 'insert))

(use-package corfu
  :ensure t
  :init
  (global-corfu-mode)
  (corfu-history-mode)
  (corfu-popupinfo-mode)
  :config
  (setopt corfu-auto t)
  (setopt corfu-auto-prefix 4)
  (setopt corfu-auto-delay 0.07)
  (setopt corfu-count 8)
  (setopt corfu-cycle t)
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

;; Miscellaneous 
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
  (eyebrowse-setup-evil-keys)
  (eyebrowse-mode t))

(use-package anki-editor
  :ensure t
  :defer t
  :bind (:map anki-editor-mode-map
              ("C-c a i" . anki-editor-insert-note)
              ("C-c a p" . anki-editor-push-note-at-point)
              ("C-c a d" . anki-editor-delete-note-at-point)))

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
         (LaTeX-mode . flyspell-mode))
  :config
  (setopt TeX-auto-save t
          TeX-parse-self t
          TeX-save-query nil
          TeX-PDF-mode t
          TeX-source-correlate-method 'synctex
          TeX-source-correlate-start-server t)

  (setopt TeX-view-program-selection '((output-pdf "Zathura"))
          TeX-view-program-list '(("Zathura" "zathura %o"))))

(use-package cdlatex
  :ensure t
  :after latex
  :hook ((LaTeX-mode . cdlatex-mode)
         (LaTeX-mode . cdlatex-electricindex-mode)))

(use-package magit
  :ensure t)

(use-package git-commit
  :after magit
  :hook (git-commit-setup . flyspell-mode))

(use-package envrc
  :ensure t
  :hook (after-init . envrc-global-mode))

(use-package kind-icon
  :ensure t
  :after corfu
  :config
  (setopt kind-icon-default-style `(:padding -0.5 :scale 1.0 :height 0.85))
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

(use-package hl-line
  :init
  (setopt hl-line-sticky-flag nil)
  (setopt global-hl-line-sticky-flag nil)
  :hook
  (prog-mode . hl-line-mode)
  (text-mode . hl-line-mode))

(use-package indent-bars
  :ensure t
  :custom
  (indent-bars-no-descend-lists t) ; no extra bars in continued func arg lists
  (indent-bars-treesit-support t)
  (indent-bars-treesit-ignore-blank-lines-types '("module"))
  ;; Add other languages as needed
  (indent-bars-treesit-scope '((python function_definition class_definition for_statement
	                                   if_statement with_statement while_statement)))
  ;; Note: wrap may not be needed if no-descend-list is enough
  ;;(indent-bars-treesit-wrap '((python argument_list parameters ; for python, as an example
  ;;				      list list_comprehension
  ;;				      dictionary dictionary_comprehension
  ;;				      parenthesized_expression subscript)))
  :hook ((python-base-mode yaml-mode) . indent-bars-mode))

(use-package eldoc
  :config
  (setopt eldoc-idle-delay 0.5)
  (setopt eldoc-echo-area-use-multiline-p nil))

(use-package eglot
  :defer t
  :init
  (setopt eglot-autoshutdown t)
  (setopt eglot-sync-connect nil)
  :bind (:map eglot-mode-map
              ("C-c l a" . eglot-code-actions)
              ("C-c l f" . eglot-format-buffer)
              ("C-c l d" . eldoc))
  :hook
  (python-mode . eglot-ensure)
  (nix-mode . eglot-ensure)
  :config
  (add-to-list 'eglot-server-programs '(nix-mode . ("nil")))
  (setopt eglot-workspace-configuration
          '((:pylsp
             (:plugins
              (:ruff
               (:enabled t :json-false
                         :formatEnabled t
                         :lineLength 88)))))))

(use-package eglot-booster
  :after eglot
  :config (eglot-booster-mode))

(use-package flymake
  :hook
  (flymake-mode-hook . flymake-setup-next-error-function)
  :config
  (defun flymake-setup-next-error-function ()
    (setopt next-error-function 'flymake-next-error-compat))

  (defun flymake-next-error-compat (&optional n _)
    (flymake-goto-next-error n))

  (defun flymake-diagnostics-next-error ()
    (interactive)
    (forward-line)
    (when (eobp) (forward-line -1))
    (flymake-show-diagnostic (point)))

  (defun flymake-diagnostics-prev-error ()
    (interactive)
    (forward-line -1)
    (flymake-show-diagnostic (point))))

(use-package flymake-proc
  :config
  (setopt flymake-proc-ignored-file-name-regexps '("\\.l?hs\\'"))
  (remove-hook 'flymake-diagnostic-functions 'flymake-proc-legacy-flymake))

(use-package python
  :config
  (setopt python-indent-guess-indent-offset-verbose nil)
  (setopt comint-move-point-for-output 'all)
  (evil-set-initial-state 'inferior-python-mode 'normal)
  (add-to-list 'display-buffer-alist
               '("\\*Python\\*"
                 (display-buffer-in-side-window)
                 (side . right)
                 (window-width . 0.42)
                 (no-select . t))))
