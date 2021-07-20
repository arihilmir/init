;;; package --- Summary
;;; My init.el file
;;; ver. 0.3

;;; Commentary:
;;; attempt to emacs: 7

;;; Code:

;;setup package management
(require 'package)
(setq package-archives
      `(,@package-archives
        ("melpa" . "https://melpa.org/packages/")
;;        ("marmalade" . "https://marmalade-repo.org/packages/")
        ("org" . "https://orgmode.org/elpa/")
;;        ("user42" . "https://download.tuxfamily.org/user42/elpa/packages/")
        ("emacswiki" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/emacswiki/")
;;        ("sunrise" . "http://joseito.republika.pl/sunrise-commander/")
        ))
(package-initialize)

;; installing and configuring use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

(put 'use-package 'lisp-indent-function 1)

(use-package use-package-core
  :custom
  (use-package-verbose t)
  (use-package-minimum-reported-time 0.005)
  (use-package-enable-imenu-support t))


(use-package quelpa
  :ensure t
  :defer t
  :custom
  (quelpa-update-melpa-p nil "Don't update the MELPA git repo."))

(use-package quelpa-use-package
  :init
  (setq quelpa-use-package-inhibit-loading-quelpa t)
  :ensure t)

;; global hotkeys
(global-set-key (quote [M-down]) (quote scroll-up-line))
(global-set-key (quote [M-up]) (quote scroll-down-line))

(use-package emacs
  :custom
  (indent-tabs-mode nil "Spaces!")
  (x-gtk-use-system-tooltips nil)
   (default-frame-alist '((menu-bar-lines 0)
                         (tool-bar-lines -1))))

;; some highlighting
(use-package paren
  :config
  (show-paren-mode t))

(use-package hl-line
  :hook
  (prog-mode . hl-line-mode))

(use-package highlight-numbers
  :ensure t
  :hook
  (prog-mode . highlight-numbers-mode))

(use-package highlight-escape-sequences
  :ensure t
  :config (hes-mode))

(use-package hl-todo
  :ensure t
  :custom-face
  (hl-todo ((t (:inherit hl-todo :italic t))))
  :hook ((prog-mode . hl-todo-mode)
         (yaml-mode . hl-todo-mode)))

(use-package page-break-lines
  :ensure t
  :hook
  (help-mode . page-break-lines-mode)
  (prog-mode . page-break-lines-mode)
  (special-mode . page-break-lines-mode)
  (compilation-mode . page-break-lines-mode))

(use-package rainbow-delimiters
  :ensure t
  :hook
  (prog-mode . rainbow-delimiters-mode))

;; (use-package rainbow-identifiers
;;   :ensure t
;;   :custom
;;   (rainbow-identifiers-cie-l*a*b*-lightness 80)
;;   (rainbow-identifiers-cie-l*a*b*-saturation 50)
;;   (rainbow-identifiers-choose-face-function
;;    #'rainbow-identifiers-cie-l*a*b*-choose-face)
;;   :hook
;;   (emacs-lisp-mode . rainbow-identifiers-mode) actually, turn it off
;;   (prog-mode . rainbow-identifiers-mode))

(use-package rainbow-mode
  :ensure t
  :hook '(prog-mode help-mode))

;; autocomplete
(use-package company
  :ensure t
  :bind
  (:map company-active-map
        ("C-n" . company-select-next-or-abort)
        ("C-p" . company-select-previous-or-abort)
        ("C-c c" . company-complete))
  :hook
  (after-init . global-company-mode))

(use-package company-quickhelp
  :ensure t
  :defer t
  :custom
  (company-quickhelp-delay 1.5)
  (company-quickhelp-mode 1))

(use-package company-shell
  :ensure t
  :after company
  :defer t)

;; counsel-M-x can use this one
(use-package amx :ensure t :defer t)

(use-package ivy
  :ensure t
  :custom
  ;; (ivy-re-builders-alist '((t . ivy--regex-fuzzy)))
  (ivy-count-format "%d/%d " "Show anzu-like counter")
  (ivy-use-selectable-prompt t "Make the prompt line selectable")
  :custom-face
  (ivy-current-match ((t (:inherit 'hl-line))))
  :bind
  (:map mode-specific-map
        ("C-r" . ivy-resume))
  :config
  (ivy-mode t))

(use-package ivy-xref
  :ensure t
  :defer t
  :custom
  (xref-show-xrefs-function #'ivy-xref-show-xrefs "Use Ivy to show xrefs"))

(use-package counsel
  :ensure t
  :bind
  (([remap menu-bar-open] . counsel-tmm)
   ([remap insert-char] . counsel-unicode-char)
   ([remap isearch-forward] . counsel-grep-or-swiper)
   :map mode-specific-map
   :prefix-map counsel-prefix-map
   :prefix "c"
   ("a" . counsel-apropos)
   ("b" . counsel-bookmark)
   ("B" . counsel-bookmarked-directory)
   ("c w" . counsel-colors-web)
   ("c e" . counsel-colors-emacs)
   ("d" . counsel-dired-jump)
   ("f" . counsel-file-jump)
   ("F" . counsel-faces)
   ("g" . counsel-org-goto)
   ("h" . counsel-command-history)
   ("H" . counsel-minibuffer-history)
   ("i" . counsel-imenu)
   ("j" . counsel-find-symbol)
   ("l" . counsel-locate)
   ("L" . counsel-find-library)
   ("m" . counsel-mark-ring)
   ("o" . counsel-outline)
   ("O" . counsel-find-file-extern)
   ("p" . counsel-package)
   ("r" . counsel-recentf)
   ("s g" . counsel-grep)
   ("s r" . counsel-rg)
   ("s s" . counsel-ag)
   ("t" . counsel-org-tag)
   ("v" . counsel-set-variable)
   ("w" . counsel-wmctrl)
   :map help-map
   ("F" . counsel-describe-face))
  :custom
  (counsel-grep-base-command
   "rg -i -M 120 --no-heading --line-number --color never %s %s")
  (counsel-search-engines-alist
   '((google
      "http://suggestqueries.google.com/complete/search"
      "https://www.google.com/search?q="
      counsel--search-request-data-google)
     (ddg
      "https://duckduckgo.com/ac/"
      "https://duckduckgo.com/html/?q="
      counsel--search-request-data-ddg)))
  :init
  (counsel-mode))

(use-package swiper :ensure t)

(use-package counsel-web
  :defer t
  :quelpa
  (counsel-web :repo "mnewt/counsel-web" :fetcher github))

(use-package counsel-world-clock
  :ensure t
  :after counsel
  :bind
  (:map counsel-prefix-map
        ("C" .  counsel-world-clock)))

(use-package ivy-rich
  :ensure t
  :config
  (ivy-rich-mode 1))

(use-package helm-make
  :defer t
  :ensure t
  :custom (helm-make-completion-method 'ivy))

(use-package avy
  :ensure t
  :bind
  (("C-:" .   avy-goto-char-timer)
   ("C-." .   avy-goto-word-1)
   :map goto-map
   ("M-g" . avy-goto-line)
   :map search-map
   ("M-s" . avy-goto-word-1)))

(use-package avy-zap
  :ensure t
  :bind
  ([remap zap-to-char] . avy-zap-to-char))

(use-package ace-jump-buffer
  :ensure t
  :bind
  (:map goto-map
        ("b" . ace-jump-buffer)))

(use-package ace-window
  :ensure t
  :custom
  (aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l) "Use home row for selecting.")
  (aw-scope 'global "Manage windows")
  :bind
  ("M-o" . ace-window))

(use-package link-hint
  :ensure t
  :bind
  (("<XF86Search>" . link-hint-open-link)
   ("S-<XF86Search>" . link-hint-copy-link)
   :map mode-specific-map
   :prefix-map link-hint-keymap
   :prefix "l"
   ("o" . link-hint-open-link)
   ("c" . link-hint-copy-link)))

(use-package ace-link
  :ensure t
  :after link-hint ; to use prefix keymap
  :bind
  (:map link-hint-keymap
        ("l" . counsel-ace-link))
  :config
  (ace-link-setup-default))

(use-package flycheck
  :ensure t
  :hook
  (prog-mode . flycheck-mode))

(use-package avy-flycheck
  :ensure t
  :defer t
  :config
  (avy-flycheck-setup))

;; -- end autocomplete


;; elisp
(use-package lisp
  :hook
  (after-save . check-parens))

(use-package elisp-mode
  :bind
  (:map emacs-lisp-mode-map
        ("C-c C-d C-d" . describe-function)
        ("C-c C-d d" . describe-function)
        ("C-c C-k" . eval-buffer)))

(use-package highlight-defined
  :ensure t
  :custom
  (highlight-defined-face-use-itself t)
  :hook
  (help-mode . highlight-defined-mode)
  (emacs-lisp-mode . highlight-defined-mode))

(use-package highlight-quoted
  :ensure t
  :hook
  (emacs-lisp-mode . highlight-quoted-mode))

(use-package highlight-sexp
  :quelpa
  (highlight-sexp :repo "daimrod/highlight-sexp" :fetcher github :version original)
  :hook
  (clojure-mode . highlight-sexp-mode)
  (emacs-lisp-mode . highlight-sexp-mode)
  (lisp-mode . highlight-sexp-mode))

(use-package eros
  :ensure t
  :hook
  (emacs-lisp-mode . eros-mode))

(use-package suggest
  :ensure t
  :defer t)

(use-package ipretty
  :defer t
  :ensure t
  :config
  (ipretty-mode 1))

(use-package nameless
  :ensure t
  :hook
  (emacs-lisp-mode .  nameless-mode)
  :custom
  (nameless-global-aliases '())
  (nameless-private-prefix t))


;;; Programming
;; LSP mode
(use-package lsp-mode
  :ensure t
  :hook (
         ((c-mode c++-mode) . lsp-deferred)
	 (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp
  :config
  (define-key lsp-mode-map (kbd "C-;") lsp-command-map)
  :custom
  (lsp-enable-xref t))

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode)

(use-package lsp-ivy
  :ensure t
  :commands lsp-ivy-workspace-symbol)

;; c++ config

(use-package cc-mode
  :config
  (c-set-offset 'substatement-open 0))

;; modern c++ code highlighting
(use-package modern-cpp-font-lock
  :ensure t
  :config
  (modern-c++-font-lock-global-mode t))

(use-package ivy-rtags
  :ensure t)

;; setup navigation for c/c++
(use-package rtags
  :ensure t
  :config
  (progn
    (defun rtags-load-compile-commands ()
      "Load the closest compile_commands.json."
      (let* ((file-path (buffer-file-name))
	     (path-list (split-string file-path "/")))
	(while (> (length path-list) 2)
	  (setq path-list (nbutlast path-list 1))
	  (let ((cmds-path
		 (format "%s/compile_commands.json"
			 (mapconcat 'identity path-list "/"))))
	    (when (file-exists-p cmds-path)
	      (shell-command
	       (format "%s -J %s"
		       (rtags-executable-find rtags-rc-binary-name)
		       cmds-path)))))))
    (rtags-start-process-unless-running)
    (add-hook 'c-mode-hook 'rtags-load-compile-commands)
    (add-hook 'c++-mode-hook 'rtags-load-compile-commands)
    (setq rtags-autostart-diagnostics t)
    (rtags-diagnostics)
    (setq rtags-display-result-backend 'ivy)
    ;; Uncomment following lines to enable rtags autocomplete
    ;;(setq rtags-completions-enabled t)
    ;;(use-package company-rtags :ensure t)
    ;;(push 'company-rtags company-backends)
    ;;(use-package flycheck-rtags :ensure t)
    (rtags-enable-standard-keybindings)))

;; ;; setup navigation for rtags mode
;; (progn
;; (defun rtags-forward-line-show-in-other-window ()
;; "Call 'forward-line' and 'rtags-show-in-other-window'."
;; (interactive)
;; (forward-line)
;; (rtags-show-in-other-window))
;; (defun rtags-backward-line-show-in-other-window ()
;; "Call 'forward-line -1' and 'rtags-show-in-other-window'."
;; (interactive)
;; (forward-line -1)
;; (rtags-show-in-other-window))
;; (define-key rtags-mode-map (kbd "n") 'rtags-forward-line-show-in-other-window)
;; (define-key rtags-mode-map (kbd "p") 'rtags-backward-line-show-in-other-window))

;; snippets

(use-package autoinsert
  :hook
  (find-file . auto-insert))

(use-package yasnippet
  :hook
  (prog-mode . yas-minor-mode)
  :diminish yas-minor-mode
  :config
  (use-package yasnippet-snippets
    :defer t)
  (add-to-list 'yas-snippet-dirs "~/.emacs.d/yasnippet-snippets")
  (yas-reload-all))


(use-package ivy-yasnippet
  :bind ("C-x y" . ivy-yasnippet))


;; evil mode. disabled for now.
;; (use-package evil
;;  :ensure t)

(use-package gitconfig-mode
  :ensure t
  :defer t)

(use-package gitignore-mode
  :ensure t
  :defer t)

(use-package magit
  :ensure t
  :custom
  (magit-clone-default-directory (expand-file-name "~/Developer"))
  (magit-completing-read-function 'ivy-completing-read "Force Ivy usage.")
  :bind
  (:map mode-specific-map
        :prefix-map magit-prefix-map
        :prefix "m"
        (("a" . magit-stage-file) ; the closest analog to git add
         ("b" . magit-blame)
         ("B" . magit-branch)
         ("c" . magit-checkout)
         ("C" . magit-commit)
         ("d" . magit-diff)
         ("D" . magit-discard)
         ("f" . magit-fetch)
         ("g" . vc-git-grep)
         ("G" . magit-gitignore)
         ("i" . magit-init)
         ("l" . magit-log)
         ("m" . magit)
         ("M" . magit-merge)
         ("n" . magit-notes-edit)
         ("p" . magit-pull-branch)
         ("P" . magit-push-current)
         ("r" . magit-reset)
         ("R" . magit-rebase)
         ("s" . magit-status)
         ("S" . magit-stash)
         ("t" . magit-tag)
         ("T" . magit-tag-delete)
         ("u" . magit-unstage)
         ("U" . magit-update-index))))

(use-package forge
  :defer t
  :after magit
  :ensure t)

;; projects
(use-package projectile
  :defer 0.2
  :ensure t
  :bind
  (:map mode-specific-map ("p" . projectile-command-map))
  :custom
  (projectile-project-root-files-functions
   '(projectile-root-local
     projectile-root-top-down
     projectile-root-bottom-up
     projectile-root-top-down-recurring))
  (projectile-completion-system 'ivy))

(setq projectile-enable-caching t)
(setq projectile-indexing-method 'native)

(use-package counsel-projectile
  :ensure t
  :after counsel projectile
  :config
  (counsel-projectile-mode))

(use-package display-line-numbers
  :bind ("<f6> l" . display-line-numbers-mode))

;; Modernise package menu

;; (use-package paradox
;;   :ensure t
;;   :defer 1
;;   :config
;;   (paradox-enable))


;; Let's optimise a little bit

(use-package gcmh
  :ensure t
  :init
  (gcmh-mode 1))

;; disable suspend on C-z
(use-package frame
  :bind
  ("C-z" . nil)
  :custom
  (initial-frame-alist '((vertical-scroll-bars))))

;; C-c C-g always quits minibuffer
(use-package delsel
  :bind
  (:map mode-specific-map
        ("C-g" . minibuffer-keyboard-quit)))

(setq-default indent-tabs-mode nil)

(use-package files
  :hook
  (before-save . delete-trailing-whitespace)
  :custom
  (require-final-newline t)
  ;; backup settings
  (backup-by-copying t)
  (backup-directory-alist
   `((".*" . ,(locate-user-emacs-file "backups"))))
  (delete-old-versions t)
  (kept-new-versions 6)
  (kept-old-versions 2)
  (version-control t))

(use-package autorevert
  :defer 0.1)

;; dired

;; make dired faster
(use-package async
  :ensure t
  :defer t
  :custom
  (dired-async-mode 1))

;; localization
(use-package mule
  :defer 0.1
  :config
  (prefer-coding-system 'utf-8)
  (set-language-environment "UTF-8")
  (set-terminal-coding-system 'utf-8))

;; fancy gui

;; (use-package lor-theme
;;   :config
;;   (load-theme 'lor t)
;;   :quelpa
;;   (lor-theme :repo "a13/lor-theme" :fetcher github :version original))

(use-package gruvbox-theme
  :ensure t
  :config
  (load-theme 'gruvbox-dark-medium t))

(use-package emojify
  :ensure t
    :hook (elfeed-search-mode-hook . emojify-mode)
    :bind ("<f6> e". emojify-mode))

(use-package olivetti
  :ensure t
  :custom
  (olivetti-body-width 125))

(use-package font-lock+
  :defer t
  :quelpa
  (font-lock+ :repo "emacsmirror/font-lock-plus" :fetcher github))

(use-package all-the-icons-dired
  :ensure t
  :hook
  (dired-mode . all-the-icons-dired-mode))

(use-package all-the-icons-ivy
  :defer t
  :ensure t
  :after ivy
  :custom
  (all-the-icons-ivy-buffer-commands '() "Don't use for buffers.")
  :config
  (all-the-icons-ivy-setup))

(use-package mood-line
  :ensure t
  :custom-face
  (mode-line ((t (:inherit defauplt (:box (:line-width -1 :style released-button))))))
  :hook
  (after-init . mood-line-mode))

(use-package winner
  :config
  (winner-mode 1))

(use-package mwheel
  :custom
  (mouse-wheel-scroll-amount '(1
                               ((shift) . 5)
                               ((control))))
  (mouse-wheel-progressive-speed nil))

(use-package pixel-scroll
  :config
  (pixel-scroll-mode))

(use-package tooltip
  :defer t
  :custom
  (tooltip-mode -1))

;;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("7661b762556018a44a29477b84757994d8386d6edee909409fabe0631952dad9" default)))
 '(package-selected-packages
   (quote
    (ivy-rtags tab-bar spaceline gruvbox-theme doremi ace-link link-hint ace-jump-buffer modern-cpp-font-lock powerline yasnippet magit gitignore-mode gitconfig-mode emojify which-key mood-line all-the-icons-ivy all-the-icons-dired all-the-icons font-lock+ olivetti async gcmh counsel-projectile projectile dap-mode lsp-ivy lsp-ui lsp-mode nameless ipretty suggest eros highlight-sexp highlight-quoted highlight-defined avy-flycheck flycheck avy-zap avy helm-make ivy-rich counsel-world-clock counsel-web request counsel ivy-xref ivy amx company-shell company-quickhelp company rainbow-mode rainbow-identifiers rainbow-delimiters page-break-lines hl-todo highlight-escape-sequences highlight-numbers quelpa-use-package quelpa use-package rtags)))
 '(projectile-project-root-functions
   (quote
    (projectile-root-local projectile-root-top-down projectile-root-bottom-up projectile-root-top-down-recurring)) nil nil "Customized with use-package projectile")
 '(tool-bar-mode nil nil nil "Customized with use-package emacs")
 '(tooltip-mode -1 nil nil "Customized with use-package tooltip"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(hl-todo ((t (:inherit hl-todo :italic t))))
 '(ivy-current-match ((t (:inherit (quote hl-line)))))
 '(mode-line ((t (:inherit defauplt (:box (:line-width -1 :style released-button)))))))
