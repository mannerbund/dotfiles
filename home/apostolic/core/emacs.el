;;; early-init.el --- Early Initialization -*- lexical-binding: t; -*-

(setq-default
 inhibit-x-resources t
 inhibit-startup-screen t
 inhibit-startup-message t
 initial-scratch-message nil
 
 tab-width 4 ; Always tab 4 spaces.
 indent-tabs-mode nil ; Default to indenting with spaces

 user-full-name "Apostolic"
 ring-bell-function 'ignore
 visible-cursor nil ; Reduce cursor annoyance
 cursor-in-non-selected-windows nil ; dont render cursors other windows
 confirm-kill-emacs 'y-or-n-p ;; Ask before exiting Emacs

 scroll-conservatively 101 ; Never recenter the window NEW
 scroll-margin 8
 scroll-preserve-screen-position 1 ; Scrolling back and forth

 mouse-wheel-progressive-speed nil ; don't accelerate scrolling
 mouse-wheel-follow-mouse 't ; scroll window under mouse

 backup-directory-alist `(("." . "~/.cache/backup"))
 backup-by-copying t          ; Don't clobber symlinks
 create-lockfiles nil         ; Don't have temp files
 delete-old-versions t        ; Cleanup automatically
 kept-new-versions 6          ; Update every few times
 kept-old-versions 2          ; And cleanup even more
 version-control t            ; Version them backups
 delete-by-moving-to-trash t  ; Dont delete, send to trash instead

 gc-cons-threshold most-positive-fixnum
 byte-compile-warnings '(not obsolete)
 warning-suppress-log-types '((comp) (bytecomp))
 large-file-warning-threshold 100000000)

;;; init.el --- Initialization -*- lexical-binding: t; -*-

(use-package emacs
  :custom
  ;; ===============================
  ;; ||          VERTICO          ||
  ;; ===============================
  ;; Hide commands in M-x which do not work in the current mode.  Vertico
  ;; commands are hidden in normal buffers. This setting is useful beyond
  ;; Vertico.
  (read-extended-command-predicate #'command-completion-default-include-p)
  ;; Do not allow the cursor in the minibuffer prompt
  (minibuffer-prompt-properties
   '(read-only t cursor-intangible t face minibuffer-prompt))

  ;; ===============================
  ;; ||           CORFU           ||
  ;; ===============================
  ;; TAB cycle if there are only few candidates
  ;; (completion-cycle-threshold 3)
  
  ;; Enable indentation+completion using the TAB key.
  ;; `completion-at-point' is often bound to M-TAB.
  (tab-always-indent 'complete)
  
  ;; Emacs 30 and newer: Disable Ispell completion function.
  ;; Try `cape-dict' as an alternative.
  (text-mode-ispell-word-completion nil)
  
  ;; Hide commands in M-x which do not apply to the current mode.  Corfu
  ;; commands are hidden, since they are not used via M-x. This setting is
  ;; useful beyond Corfu.
  (read-extended-command-predicate #'command-completion-default-include-p)

  :init
  (setq minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)
  :config
  (transient-mark-mode 1) ;; Highlight selected region
  (menu-bar-mode -1) ;; Don't display menu bar
  (tool-bar-mode -1) ;; Don't display tool bar
  (scroll-bar-mode -1) ;; Don't display scroll bar
  (blink-cursor-mode -1) ;; Don't blink the cursor
  (tooltip-mode -1) ;; Don't display tooltips as popups, use the echo area instead
  (column-number-mode) ;; Display column number in the mode line
  (recentf-mode) ;; Enable recording recently-visited files
  (fringe-mode '(0 . 0))
  (global-set-key (kbd "C-x C-b") 'buffer-menu-other-window) ;; Auto switch to buff-menu on open
  (global-set-key (kbd "C-c s") #'replace-regexp))

(use-package hl-line
  :hook
  (hl-line-mode-hook . hl-line-number-mode)
  (global-hl-line-mode-hook . global-hl-line-number-mode)
  :init
  (setq hl-line-sticky-flag nil)
  (setq global-hl-line-sticky-flag nil))

(use-package hl-line
  :hook
  (prog-mode . hl-line-mode)
  (text-mode . hl-line-mode))


(use-package vertico
  :ensure t
  :custom
  (vertico-scroll-margin 0) ;; Different scroll margin
  (vertico-count 7) ;; Show more candidates
  (vertico-resize nil) ;; Grow and shrink the Vertico minibuffer
  (vertico-cycle t) ;; Enable cycling for `vertico-next/previous'
  :init
  (vertico-mode))

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :init
  (savehist-mode))

;; Enable rich annotations using the Marginalia package
(use-package marginalia
  :ensure t
  ;; Bind `marginalia-cycle' locally in the minibuffer.  To make the binding
  ;; available in the *Completions* buffer, add it to the
  ;; `completion-list-mode-map'.
  :bind (:map minibuffer-local-map
              ("M-A" . marginalia-cycle))
  ;; The :init section is always executed.
  :init
  ;; Marginalia must be activated in the :init section of use-package such that
  ;; the mode gets enabled right away. Note that this forces loading the
  ;; package.
  (marginalia-mode))

(use-package corfu
  :ensure t
  ;; Optional customizations
  :custom
  (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
  (corfu-auto t)                 ;; Enable auto completion
  (corfu-separator ?\s)          ;; Orderless field separator
  (corfu-quit-at-boundary nil)   ;; Never quit at completion boundary
  (corfu-quit-no-match nil)      ;; Never quit, even if there is no match
  (corfu-preview-current nil)    ;; Disable current candidate preview
  (corfu-scroll-margin 5)        ;; Use scroll margin
  ;; (corfu-preselect 'prompt)      ;; Preselect the prompt
  ;; (corfu-on-exact-match nil)     ;; Configure handling of exact matches

  ;; Recommended: Enable Corfu globally.  This is recommended since Dabbrev can
  ;; be used globally (M-/).  See also the customization variable
  ;; `global-corfu-modes' to exclude certain modes.
  :init
  (global-corfu-mode))
;; Use Dabbrev with Corfu!
(use-package dabbrev
  ;; Swap M-/ and C-M-/
  :bind (("M-/" . dabbrev-completion)
         ("C-M-/" . dabbrev-expand))
  :config
  (add-to-list 'dabbrev-ignored-buffer-regexps "\\` ")
  ;; Since 29.1, use `dabbrev-ignored-buffer-regexps' on older.
  (add-to-list 'dabbrev-ignored-buffer-modes 'doc-view-mode)
  (add-to-list 'dabbrev-ignored-buffer-modes 'pdf-view-mode)
  (add-to-list 'dabbrev-ignored-buffer-modes 'tags-table-mode))

;; Example configuration for Consult
(use-package consult
  :ensure t
  ;; Replace bindings. Lazily loaded by `use-package'.
  :bind (;; C-c bindings in `mode-specific-map'
         ("C-c M-x" . consult-mode-command)
         ("C-c h" . consult-history)
         ("C-c k" . consult-kmacro)
         ("C-c m" . consult-man)
         ("C-c i" . consult-info)
         ([remap Info-search] . consult-info)
         ;; C-x bindings in `ctl-x-map'
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
         ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ("C-x t b" . consult-buffer-other-tab)    ;; orig. switch-to-buffer-other-tab
         ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
         ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ;; M-g bindings in `goto-map'
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flycheck)               ;; Alternative: consult-flycheck
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings in `search-map'
         ("M-s d" . consult-find)                  ;; Alternative: consult-fd
         ("M-s c" . consult-locate)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
         ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
         ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
         ("M-s L" . consult-line-multi)            ;; needed by consult-line to detect isearch
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
   consult-ripgrep consult-man
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
  (keymap-set consult-narrow-map (concat consult-narrow-key " ?") #'consult-narrow-help)
  )

(use-package orderless
  :ensure t
  :custom
  ;; Configure a custom style dispatcher (see the Consult wiki)
  (orderless-style-dispatchers '(+orderless-consult-dispatch orderless-affix-dispatch))
  (orderless-component-separator #'orderless-escapable-split-on-space)
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion))))
  :config

  (defun +orderless--consult-suffix ()
    "Regexp which matches the end of string with Consult tofu support."
    (if (boundp 'consult--tofu-regexp)
        (concat consult--tofu-regexp "*\\'")
      "\\'"))

  ;; Recognizes the following patterns:
  ;; * .ext (file extension)
  ;; * regexp$ (regexp matching at end)
  (defun +orderless-consult-dispatch (word _index _total)
    (cond
     ;; Ensure that $ works with Consult commands, which add disambiguation suffixes
     ((string-suffix-p "$" word)
      `(orderless-regexp . ,(concat (substring word 0 -1) (+orderless--consult-suffix))))
     ;; File extensions
     ((and (or minibuffer-completing-file-name
               (derived-mode-p 'eshell-mode))
           (string-match-p "\\`\\.." word))
      `(orderless-regexp . ,(concat "\\." (substring word 1) (+orderless--consult-suffix))))))
  )

(use-package which-key
  :custom
  (setq which-key-setup-side-window-right)
  (setq which-key-idle-delay 0.3)
  (setq which-key-sort-order 'which-key-key-order-alpha)
  (setq which-key-separator " → " )
  (setq which-key-unicode-correction 3)
  (setq which-key-prefix-prefix "+" )
  :config
  (which-key-mode)
  (which-key-setup-minibuffer))

(use-package evil
  :ensure t
  :preface
  (setq evil-undo-system 'undo-redo)
  (setq evil-want-C-i-jump nil)  ; we do this ourselves
  (setq evil-want-C-u-scroll t)  ; moved the universal arg to <leader> u
  (setq evil-want-Y-yank-to-eol t)
  (setq evil-want-abbrev-expand-on-insert-exit nil)
  (setq evil-respect-visual-line-mode t)
  :config
  (evil-select-search-module 'evil-search-module 'evil-search)
  ;; PERF: Stop copying the selection to the clipboard each time the cursor
  ;; moves in visual mode.
  (setq evil-visual-update-x-selection-p nil)
  (setq evil-buffer-regexps
        '(("\\*Python\\*" . normal)))

  (define-key evil-normal-state-map (kbd "C-.") nil)  ; Unbind C-.
  (define-key evil-normal-state-map (kbd "M-.") nil)  ; Unbind M-.
  (evil-define-key 'normal evil-normal-state-map (kbd ".") nil) ; Unbind .
  (evil-mode 1))

(use-package evil-surround
  :ensure t
  :config
  (global-evil-surround-mode 1))

(electric-pair-mode 1)
(show-paren-mode 1)
(setq show-paren-context-when-offscreen t)

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :config
  (setq doom-modeline-height 32)
  (setq doom-modeline-buffer-file-name-style 'relative-to-project)
  (setq doom-modeline-major-mode-icon t)
  (setq doom-modeline-buffer-state-icon t)
  (setq doom-modeline-major-mode-color-icon t))

(add-to-list 'default-frame-alist '(font . "Iosevka Comfy-16"))
(use-package ef-themes
  :ensure t
  :config
  (ef-themes-select 'ef-tritanopia-dark)
  (ef-themes-with-colors
    (set-face-attribute 'vertical-border nil
  		                :foreground fg-main
  		                :background bg-main)
    (set-face-attribute 'fringe nil
  		                :foreground bg-alt
  		                :background bg-alt)))

;; Note: Add evil keybinds
(use-package dirvish
  :ensure t
  :init
  (dirvish-override-dired-mode)
  :custom
  (dirvish-quick-access-entries ; It's a custom option, `setq' won't work
   '(("h" "~/"                          "Home")
     ("d" "~/Downloads/"                "Downloads")
     ("t" "~/.local/share/Trash/" "TrashCan")))
  :config
  ;; (dirvish-peek-mode)             ; Preview files in minibuffer
  ;; (dirvish-side-follow-mode)      ; similar to `treemacs-follow-mode'
  (setq dirvish-mode-line-format
        '(:left (sort symlink) :right (omit yank index)))
  (setq dirvish-attributes
        '(nerd-icons file-time file-size collapse subtree-state vc-state git-msg)
        dirvish-side-attributes
        '(vc-state file-size nerd-icons collapse))
  (setq delete-by-moving-to-trash t)
  (setq dired-listing-switches
        "-l --almost-all --human-readable --group-directories-first --no-group")
  :bind ; Bind `dirvish-fd|dirvish-side|dirvish-dwim' as you see fit
  (("C-c f" . dirvish)
   :map dirvish-mode-map          ; Dirvish inherits `dired-mode-map'
   ("?"   . dirvish-dispatch)     ; contains most of sub-menus in dirvish extensions
   ("a"   . dirvish-quick-access)
   ("f"   . dirvish-file-info-menu)
   ("y"   . dirvish-yank-menu)
   ("N"   . dirvish-narrow)
   ("^"   . dirvish-history-last)
   ("h"   . dirvish-history-jump) ; remapped `describe-mode'
   ("s"   . dirvish-quicksort)    ; remapped `dired-sort-toggle-or-edit'
   ("v"   . dirvish-vc-menu)      ; remapped `dired-view-file'
   ("TAB" . dirvish-subtree-toggle)
   ("M-f" . dirvish-history-go-forward)
   ("M-b" . dirvish-history-go-backward)
   ("M-l" . dirvish-ls-switches-menu)
   ("M-m" . dirvish-mark-menu)
   ("M-t" . dirvish-layout-toggle)
   ("M-s" . dirvish-setup-menu)
   ("M-e" . dirvish-emerge-menu)
   ("M-j" . dirvish-fd-jump)))

(use-package shackle
  :ensure t
  :custom (shackle-default-rule '(:same t :inhibit-window-quit t))
  :config
  (setq shackle-rules
        '((inferior-python-mode :select t :align right :size 0.42)
          ("\\*Messages\\*" :regexp t :select nil :align below :size 0.33)
          ("\\*eldoc\\*" :regexp t :select nil :align right)
          ("\\*envrc\\*" :regexp t :ignore t)
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
  :hook (org-mode . visual-line-mode)
  :bind ("C-c a" . org-agenda)
  :config
  (evil-define-key 'normal org-mode-map
    (kbd "H") 'org-shiftleft
    (kbd "L") 'org-shiftright
    (kbd "M-H") 'org-metaleft
    (kbd "M-J") 'org-metadown
    (kbd "M-K") 'org-metaup
    (kbd "M-L") 'org-metaright
    (kbd "C-h") 'org-shiftmetaleft
    (kbd "C-j") 'org-shiftmetadown
    (kbd "C-k") 'org-shiftmetaup
    (kbd "C-l") 'org-shiftmetaright
    (kbd "RET") 'org-open-at-point)
  ;; Frames
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
  (setq org-startup-folded 'content)
  (setq org-startup-indented t)
  (setq org-hide-emphasis-markers t)
  (setq org-directory "~/Documents/Vault")
  (setq org-agenda-files '("~/Documents/Vault/agenda/work/work.org"
                           "~/Documents/Vault/agenda/todo/read.org"
                           "~/Documents/Vault/WIKI/notes/"
                           "~/Documents/Vault/agenda/todo/todo.org"))
  (setq org-log-done 'time)
  ;; TODO & colors
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
  (setq org-startup-with-latex-preview t) ; Automatically preview LaTeX on startup
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
  ;; If you're using a vertical completion framework, you might want a more informative completion interface
  (setq org-roam-node-display-template (concat "${title:*} " (propertize "${tags:25}" 'face 'org-tag)))
  (org-roam-db-autosync-mode))

(use-package magit
  :ensure t)

(use-package envrc
  :ensure t
  :hook (after-init . envrc-global-mode))

(use-package eldoc
  :config
  (setq eldoc-idle-delay 0.5)
  (setq eldoc-echo-area-use-multiline-p nil))

(use-package eglot
  :ensure t
  :defer t
  :bind (:map eglot-mode-map
              ("C-c l a" . eglot-code-actions)
              ("C-c l f" . eglot-format-buffer)
              ("C-c l d" . eldoc))
  :hook (python-mode . eglot-ensure)
  :config
  (setq-default eglot-workspace-configuration
                '((:pylsp
                   (:plugins
                    (:ruff
                     (:enabled t :json-false
                      :formatEnabled t
                      :lineLength 88)))))))

(use-package flycheck
  :ensure t
  :custom
  (setq flycheck-check-syntax-automatically '(save mode-enable))
  :hook
  (after-init . global-flycheck-mode))

(use-package flycheck-eglot
  :ensure t
  :after (flycheck eglot)
  :config
  (global-flycheck-eglot-mode 1))

(use-package python
  :custom (python-indent-guess-indent-offset-verbose nil))

(use-package nix-mode
  :ensure t
  :mode "\\.nix\\'")
