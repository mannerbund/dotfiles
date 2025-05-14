;;; early-init.el --- Early Initialization -*- lexical-binding: t; -*-
(setq inhibit-x-resources t)
(setq inhibit-startup-screen t)
(setq inhibit-startup-message t)
(setq initial-scratch-message nil)

(setq package-enable-at-startup nil)

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
(setq auto-mode-case-fold nil)
(setq bidi-inhibit-bpa t)
(setq-default bidi-display-reordering 'left-to-right
              bidi-paragraph-direction 'left-to-right)
(setq fast-but-imprecise-scrolling t)
(setq jit-lock-defer-time 0)

(setq-default user-full-name "Apostolic")
(setq backup-directory-alist `(("." . "~/.cache/backup")))
(setq backup-by-copying t)          ; Don't clobber symlinks
(setq create-lockfiles nil)         ; Don't have temp files
(setq delete-old-versions t)        ; Cleanup automatically
(setq delete-by-moving-to-trash t)  ; Dont delete, send to trash instead
(recentf-mode) ;; Enable recording recently-visited files
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)


(setq transient-mark-mode 1) ;; Highlight selected region
(menu-bar-mode -1) ;; Don't display menu bar
(tool-bar-mode -1) ;; Don't display tool bar
(scroll-bar-mode -1) ;; Don't display scroll bar
(blink-cursor-mode -1) ;; Don't blink the cursor
(column-number-mode) ;; Display column number in the mode line
(setq tooltip-mode -1) ;; Don't display tooltips as popups, use the echo area instead
(setq fringe-mode '(0 . 0)) ;; Don't display fringe
(setq confirm-kill-emacs 'y-or-n-p)
(setq ring-bell-function 'ignore)
(setq visible-cursor nil)
(setq cursor-in-non-selected-windows nil) ; dont render cursors other windows
(setq scroll-conservatively 101) ; Never recenter the window NEW
(setq scroll-preserve-screen-position t) ; Scrolling back and forth

(setq mouse-wheel-progressive-speed nil) ; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ; scroll window under mouse
(electric-pair-mode 1)
(show-paren-mode 1)
(setq show-paren-context-when-offscreen t)

(use-package gcmh
  :ensure t
  :hook
  (after-init-hook . gcmh-mode)
  :init
  (setq gcmh-idle-delay 5)
  (setq gcmh-high-cons-threshold (* 16 1024 1024)) ; 16MB
  (setq gcmh-verbose init-file-debug))

(use-package evil
  :ensure t
  :preface
  (setq evil-undo-system 'undo-redo)
  (setq evil-want-C-i-jump nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-Y-yank-to-eol t)
  (setq evil-want-minibuffer t)
  (setq evil-respect-visual-line-mode t)
  (setq evil-want-keybinding nil)
  :config
  (setq evil-visual-update-x-selection-p nil)
  (evil-mode 1))

(use-package evil-surround
  :ensure t
  :init
  (setq evil-want-keybinding nil)
  :config
  (global-evil-surround-mode 1))

(use-package evil-collection
  :ensure t
  :after evil
  :custom
  (evil-collection-calendar-want-org-bindings t)
  (evil-collection-setup-minibuffer t)
  :config
  (evil-collection-init))

(use-package calc
  :preface
  (evil-collection-define-key 'normal 'calc-mode-map
    (kbd "C-r") 'calc-redo))

;; Add orderless support
(use-package consult
  :ensure t
  ;; Replace bindings. Lazily loaded by `use-package'.
  :bind (;; C-c bindings in `mode-specific-map'
         ("C-c M-x" . consult-mode-command)
         ("C-c h" . consult-history)
         ("C-c m" . consult-man)
         ;; M-g bindings in `goto-map'
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flymake)
         ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
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

  ;; Enable automatic preview at point in the *Completions* buffer. This is
  ;; relevant when you use the default completion UI.
  :hook (completion-list-mode . consult-preview-at-point-mode)

  ;; The :init configuration is always executed (Not lazy)
  :init

  ;; Tweak the register preview for `consult-register-load',
  ;; `consult-register-store' and the built-in commands.  This improves the
  ;; register formatting, adds thin separator lines, register sorting and hides
  ;; the window mode line.
  (advice-add #'register-preview :override #'consult-register-window)
  (setq register-preview-delay 0.5)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  ;; Configure other variables and modes in the :config section,
  ;; after lazily loading the package.
  :config

  ;; Optionally configure preview. The default value
  ;; is 'any, such that any key triggers the preview.
  ;; (setq consult-preview-key 'any)
  ;; (setq consult-preview-key "M-.")
  ;; (setq consult-preview-key '("S-<down>" "S-<up>"))
  ;; For some commands and buffer sources it is useful to configure the
  ;; :preview-key on a per-command basis using the `consult-customize' macro.
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep consult-man
   consult-bookmark consult-recent-file consult-xref
   consult--source-bookmark consult--source-file-register
   consult--source-recent-file consult--source-project-recent-file
   ;; :preview-key "M-."
   :preview-key '(:debounce 0.4 any))

  ;; Optionally configure the narrowing key.
  ;; Both < and C-+ work reasonably well.
  (setq consult-narrow-key "<") ;; "C-+"

  ;; Optionally make narrowing help available in the minibuffer.
  ;; You may want to use `embark-prefix-help-command' or which-key instead.
  ;; (keymap-set consult-narrow-map (concat consult-narrow-key " ?") #'consult-narrow-help)
)

(use-package vertico
  :ensure t
  :custom
  (vertico-scroll-margin 0) ;; Different scroll margin
  (vertico-count 7) ;; Show more candidates
  (vertico-resize nil) ;; Grow and shrink the Vertico minibuffer
  (vertico-cycle t) ;; Enable cycling for vertico-next/previous
  (evil-make-intercept-map vertico-map 'insert)
  :init
  (vertico-mode))

(use-package savehist
  :init
  (savehist-mode))

(use-package marginalia
  :ensure t
  :bind (:map minibuffer-local-map
              ("M-A" . marginalia-cycle))
  :init
  (marginalia-mode))

(use-package orderless
  :ensure t
  :custom
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (orderless-style-dispatchers '(+orderless-consult-dispatch orderless-affix-dispatch))
  ;; (orderless-component-separator #'orderless-escapable-split-on-space)
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package which-key
  :custom
  (which-key-idle-delay 0.3)
  (which-key-sort-order 'which-key-key-order-alpha)
  (which-key-separator " → ")
  (which-key-unicode-correction 3)
  (which-key-prefix-prefix "+")
  :config
  (which-key-mode)
  (which-key-setup-minibuffer))

(use-package gruvbox-theme
  :ensure t
  :config
  (load-theme 'gruvbox-dark-hard t))

(add-to-list 'default-frame-alist '(font . "Iosevka Comfy-16"))

(use-package shackle
  :ensure t
  :custom (shackle-default-rule '(:same t :inhibit-window-quit t))
  :config
  (setq shackle-rules
        '((inferior-python-mode :select t :align 'right :size 0.42)
          ("\\*Messages\\*" :regexp t :select nil :align 'below :size 0.33)
          ("\\*eldoc\\*" :regexp t :select nil :align 'right)
          ("\\*envrc\\*" :regexp t :ignore t)
          (magit-diff-mode :select nil)
          (" *transient*" :popup t :align 'below)))
  (shackle-mode 1))

(use-package popper
  :ensure t
  :hook
  (after-init-hook . popper-mode)
  (popper-mode-hook . popper-echo-mode)
  :bind
  (("C-`" . popper-toggle)
   ("C-M-`" . popper-cycle)
   (:map window-prefix-map
        ("p" . popper-toggle-type)))
  :init
  (setq popper-reference-buffers
        '("Output\\*$"
          "\\*Messages\\*"
          "\\*Warnings\\*"
          "\\*devdocs\\*"
          elisp-refs-mode
          ghelp-page-mode
          (lambda (buf)
            (with-current-buffer buf
              (derived-mode-p '(compilation-mode
                                comint-mode
                                help-mode))))))
  :config
  (setq popper-mode-line nil
        popper-display-control nil))

(use-package org
  :ensure t
  :hook ((org-mode . visual-line-mode)
         (org-mode . auto-fill-mode)
         (org-mode . flyspell-mode)
         (org-babel-after-execute . org-redisplay-inline-images))
  :bind ("C-c a a" . org-agenda)
  :config
  (setq org-link-frame-setup
        '((vm . vm-visit-folder-other-frame)
          (vm-imap . vm-visit-imap-folder-other-frame)
          (gnus . org-gnus-no-new-news)
          (file . find-file)
          (wl . wl-other-frame)))
  ;; Babel
  (setq org-confirm-babel-evaluate nil)
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((C . t)
     (emacs-lisp . t)
     (latex . t)
     (org . t)
     (python . t)
     (shell . t)))
  (setq org-babel-python-command "python3")
  ;; Org
  (add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
  (setq org-directory "~/Documents/Vault")
  (setq org-agenda-files '("~/Documents/Vault/agenda/work/work.org"
                           "~/Documents/Vault/agenda/todo/read.org"
                           "~/Documents/Vault/WIKI/notes/"
                           "~/Documents/Vault/agenda/todo/todo.org"))
  (setq org-log-done 'time)
  ;; Appearance
  (setq org-pretty-entities t)
  (setq org-startup-indented t)
  (setq org-startup-folded 'content)
  (setq org-startup-with-inline-images t)
  (setq org-hide-emphasis-markers t)
  (setq org-ellipsis " ┅ ")
  (setq org-fontify-quote-and-verse-blocks t)
  (setq org-src-fontify-natively t)
  (setq org-fontify-whole-heading-line t)
  (setq org-fontify-todo-headline t)
  (setq org-fontify-done-headline t)
  (setq org-todo-keywords
        '((sequence "TODO(t)" "PLANNING(p)" "IN-PROGRESS(n)"
          		    "|" "DONE(d)" "HOLD(h)" "OPTIONAL(o)" "IRRELEVANT(i)")))
  (setq org-todo-keyword-faces
        '(("TODO" . (:foreground "Orchid" :weight bold))
          ("PLANNING" . (:foreground "SlateGray" :weight bold))
          ("IN-PROGRESS" . (:foreground "LimeGreen" :weight bold))
          ("DONE" . (:foreground "DarkBlue" :weight bold))
          ("HOLD" . (:foreground "GoldenRod"))
          ("OPTIONAL" . (:foreground "Snow" :weight bold))
          ("IRRELEVANT" . (:foreground "FireBrick" :weight bold))))
  ;; Vertico
  (advice-add #'org-make-tags-matcher :around #'vertico-enforce-basic-completion)
  (advice-add #'org-agenda-filter :around #'vertico-enforce-basic-completion)
  ;; LaTeX
  (setq org-startup-with-latex-preview t)
  (setq org-latex-compiler "pdflatex")
  (setq org-preview-latex-default-process 'dvisvgm)
  (setq org-highlight-latex-and-related '(native))
  (add-hook 'org-mode-hook 'org-preview-latex-fragment))

(use-package org-roam
  :ensure t
  :init
  (setq org-roam-database-connector 'sqlite-builtin)
  :custom
  (org-roam-directory (file-truename "~/Documents/Vault/WIKI/notes"))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ("C-c n a" . org-roam-alias-add)
         ("C-c n d" . org-id-get-create))
  :config
  ;; Vertico
  (setq org-roam-node-display-template (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
  (org-roam-db-autosync-mode))

(use-package org-modern
  :ensure t
  :hook
  (org-mode-hook . org-modern-mode)
  :init
  (setq org-modern-hide-stars t)
  (setq org-modern-table nil))

(use-package anki-editor
  :ensure t
  :defer t
  :bind (:map anki-editor-mode-map
         ("C-c a m" . anki-editor-insert-note)
         ("C-c a i" . anki-editor-insert-note)
         ("C-c a p" . anki-editor-push-note-at-point)
         ("C-c a d" . anki-editor-delete-note-at-point)))

(use-package auctex
  :ensure t
  :hook ((LaTeX-mode . LaTeX-preview-setup)
         (LaTeX-mode . LaTeX-math-mode)
         (LaTeX-mode . flyspell-mode)
         (LaTeX-mode . turn-on-reftex))
  :mode ("\\.tex\\'" . LaTeX-mode)
  :config
  (setq TeX-auto-save t
        TeX-parse-self t
        TeX-save-query nil
        TeX-PDF-mode t
        TeX-electric-escape t
        TeX-source-correlate-method 'synctex
        TeX-source-correlate-start-server t)

  (setq TeX-view-program-selection '((output-pdf "Zathura"))
        TeX-view-program-list '(("Zathura" "zathura %o"))))

(use-package magit
  :ensure t)

(use-package envrc
  :ensure t
  :defer t
  :hook (after-init . envrc-global-mode))

;; Add orderless support
(use-package corfu
  :ensure t
  :custom
  (corfu-auto t)
  (corfu-auto-prefix 4)
  (corfu-auto-delay 0.07)
  (corfu-count 8)
  (corfu-cycle t)
  (corfu-quit-no-match 'separator)
  (corfu-preselect 'prompt)
  (keymap-unset corfu-map "RET")
  :init
  (global-corfu-mode)
  (corfu-history-mode)
  (corfu-popupinfo-mode))

;; Enable indentation+completion using the TAB key.
;; `completion-at-point' is often bound to M-TAB.
(setq tab-always-indent 'complete)
;; Disable Ispell completion function.
(setq text-mode-ispell-word-completion nil)
;; Hide commands in M-x which do not apply to the current mode.
(setq read-extended-command-predicate #'command-completion-default-include-p)

(use-package dabbrev
  :bind (("M-/" . dabbrev-completion)
         ("C-M-/" . dabbrev-expand))
  :config
  (add-to-list 'dabbrev-ignored-buffer-regexps "\\` ")
  (add-to-list 'dabbrev-ignored-buffer-modes 'authinfo-mode)
  (add-to-list 'dabbrev-ignored-buffer-modes 'doc-view-mode)
  (add-to-list 'dabbrev-ignored-buffer-modes 'pdf-view-mode)
  (add-to-list 'dabbrev-ignored-buffer-modes 'tags-table-mode))

(use-package kind-icon
  :ensure t
  :after corfu
  :custom
  (kind-icon-default-style `(:padding -0.5 :scale 1.0 :height 0.85))
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

(use-package hl-line
  :hook
  (hl-line-mode-hook . hl-line-number-mode)
  (global-hl-line-mode-hook . global-hl-line-number-mode)
  :init
  (setq hl-line-sticky-flag nil)
  (setq global-hl-line-sticky-flag nil))

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
  (setq eldoc-idle-delay 0.5)
  (setq eldoc-echo-area-use-multiline-p nil))

(use-package eglot
  :defer t
  :init
  (setq eglot-autoshutdown t)
  (setq eglot-sync-connect nil)
  :bind (:map eglot-mode-map
              ("C-c l a" . eglot-code-actions)
              ("C-c l f" . eglot-format-buffer)
              ("C-c l d" . eldoc))
  :hook
  (python-mode . eglot-ensure)
  (nix-mode . eglot-ensure)
  :config
  (add-to-list 'eglot-server-programs '(nix-mode . ("nil")))
  (setq-default eglot-workspace-configuration
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
  :bind
  ((:map flymake-mode-map
         ("C-. !" . flymake-show-buffer-diagnostics)
         ("M-] E" . flymake-goto-next-error)
         ("M-[ E" . flymake-goto-prev-error))
   (:map flymake-diagnostics-buffer-mode-map
         ("n" . flymake-diagnostics-next-error)
         ("p" . flymake-diagnostics-prev-error)
         ("j" . flymake-diagnostics-next-error)
         ("k" . flymake-diagnostics-prev-error)
         ("TAB" . flymake-show-diagnostic))
   (:repeat-map flymake-mode-repeat-map
               ("e" . flymake-goto-next-error)
               ("E" . flymake-goto-prev-error)
               ("[" . flymake-goto-prev-error)
               ("]" . flymake-goto-next-error)))
  :config
  (defun flymake-setup-next-error-function ()
    (setq next-error-function 'flymake-next-error-compat))

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
  (setq flymake-proc-ignored-file-name-regexps '("\\.l?hs\\'"))
  (remove-hook 'flymake-diagnostic-functions 'flymake-proc-legacy-flymake))

(use-package python
  :custom
  (python-indent-guess-indent-offset-verbose nil))

(use-package nix-mode
  :ensure t
  :mode "\\.nix\\'")
