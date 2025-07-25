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
  (setopt auth-sources '("~/.authinfo.gpg"))
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
          '(read-only t cursor-intangible t face minibuffer-prompt))
  (setopt reb-re-syntax 'string))

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
  (setopt evil-respect-visual-line-mode t)
  :config
  (evil-define-key '(normal visual) 'global (kbd "M-r") 'replace-regexp)
  (setopt evil-visual-update-x-selection-p nil)
  (evil-mode))

(use-package evil-collection
  :ensure t
  :after evil
  :init 
  (evil-collection-init)
  :config
  (setopt evil-collection-calendar-want-org-bindings t)
  (setopt evil-collection-setup-minibuffer t))

(use-package evil-org
  :ensure t
  :after org
  :hook (org-mode . evil-org-mode)
  :config
  (evil-org-set-key-theme '(textobjects insert navigation additional shift todo heading)))

(use-package evil-surround
  :ensure t
  :config
  (global-evil-surround-mode 1))

;; Theme
(use-package gruvbox-theme
  :ensure t
  :config
  (load-theme 'gruvbox t))

(set-face-attribute 'default nil :family "Iosevka" :height 160)
(set-face-attribute 'variable-pitch nil :family "Aporetic Serif Mono" :height 160)

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
  (setopt org-agenda-files '("~/Documents/Vault/agenda"))
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
                                    :discard (:habit t)
                                    :time-grid t
                                    :date today
                                    :scheduled today)))))
              (alltodo "" ((org-agenda-overriding-header "")
                           (org-super-agenda-groups
                            '((:discard (:habit t :category "Reading" :tag
                                                ("book" "article" "text")))
                              (:name "Important"
                                     :priority "A"
                                     :order 0)
                              (:name "Refile"
                                     :tag "REFILE"
                                     :order 1)
                              (:name "Low Priority"
                                     :priority "C"
                                     :order 2)
                              (:auto-category t)))))))
            ("h" "Habits"
             ((agenda "" ((org-agenda-overriding-header "Habits")
                          (org-super-agenda-groups
                           '((:name "Day"
                                    :time-grid t
                                    :and (:habit t :category ("Morning" "Daytime" "Evening")))
                             (:name "Off Schedule"
                                    :and (:habit t :not (:time-grid t :category ("Morning" "Daytime" "Evening" ))))
                             (:discard (:anything t))))))))
            ("r" "Reading"
             ((alltodo "" ((org-agenda-overriding-header "Books to Read")
                           (org-super-agenda-groups
                            '((:name "Currently Reading"
                                     :and (:tag ("book" "article" "text") :priority "A")
                                     :and (:category "Reading" :priority "A"))
                              (:name "To-read"
                                     :and (:tag ("book" "article" "text") :not (:priority "A"))
                                     :and (:category "Reading" :not (:priority "A")))
                              (:discard (:anything t))))))))))
  (setopt org-enforce-todo-dependencies t)
  (setopt org-agenda-start-on-weekday nil)
  (setopt org-agenda-span 'day)
  (setopt org-deadline-warning-days 7)
  (setopt org-agenda-skip-deadline-if-done t)
  (setopt org-agenda-skip-scheduled-if-done t)
  (setopt org-agenda-dim-blocked-tasks t)
  (setopt org-agenda-compact-blocks t)
  (evil-set-initial-state 'org-agenda-mode 'motion)
  ;;;; Refile settings
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
  ;;;; Archive settings
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
  :defer t
  :bind ("C-c o j" . org-journal-new-entry)
  :config
  (setopt org-journal-dir "~/Documents/Vault/journal"
          org-journal-file-format "%Y-%m.org"
          org-journal-date-format "%A, %d %B %Y"
          org-journal-time-format "%H:%M"
          org-journal-file-type 'monthly 
          org-journal-enable-cache t))

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
  (setopt vertico-multiform-categories
          '((file grid reverse)
            (imenu buffer)
            (consult-ripgrep buffer)))
  (setopt vertico-multiform-commands
          '((consult-imenu buffer indexed)))
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

(use-package cape
  :ensure t
  :bind ("C-c p" . cape-prefix-map) ;; Alternative key: M-<tab>, M-p, M-+
  :init
  ;; Merge the dabbrev, dict and keyword capfs, display candidates together.
  (setq-local completion-at-point-functions
              (list (cape-capf-super #'cape-dabbrev #'cape-dict #'cape-keyword)))
  ;; Cache
  (setq-local completion-at-point-functions
              (list (cape-capf-buster #'some-caching-capf)))
  ;; Use Company backends as Capfs.
  (setq-local completion-at-point-functions
              (mapcar #'cape-company-to-capf
                      (list #'company-files #'company-keywords #'company-dabbrev))))

;; Major Modes
(use-package calc
  :preface
  (evil-collection-define-key 'normal 'calc-mode-map
    (kbd "C-r") 'calc-redo))

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

(use-package eglot
  :defer t
  :init
  (setopt eglot-autoshutdown t)
  (setopt eglot-autoreconnect t)
  (setopt eglot-sync-connect nil)
  (setopt eglot-code-action-indications nil)
  :bind (:map eglot-mode-map
              ("C-c l a" . eglot-code-actions)
              ("C-c l f" . eglot-format-buffer)
              ("C-c l r" . eglot-rename)
              ("C-c l d" . eldoc))
  :config
  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs
                 `(nix-ts-mode . ("nil" :initializationOptions
                                  (:formatting (:command ["alejandra"])))))))

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

;; Python

(use-package elpy
  :ensure t
  :defer t
  :init
  (advice-add 'python-mode :before 'elpy-enable)
  :config
  (setopt elpy-rpc-backend "jedi")           
  (setopt elpy-checker "flake8")            
  (setopt elpy-rpc-virtualenv-path 'current))

(use-package python
  :config
  (setopt python-indent-guess-indent-offset-verbose nil)
  (evil-set-initial-state 'inferior-python-mode 'normal)
  (add-to-list 'display-buffer-alist
               '("\\*Python\\*"
                 (display-buffer-in-side-window)
                 (side . right)
                 (window-width . 0.42)
                 (no-select . t))))

;; Nix

(use-package nix-ts-mode
  :mode "\\.nix\\'"
  :hook
  (nix-ts-mode . eglot-ensure))
