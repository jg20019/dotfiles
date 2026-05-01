
;; General 
(setq inhibit-startup-message t ;; Don't show splash screen
      visible-bell t)           ;; Flash when the bell rings

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(global-display-line-numbers-mode 1)

(global-text-scale-adjust 20)

(setq make-backup-files nil) ; stop creating ~ files

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(recentf-mode 1)

;; Move customization variables to a separate file and load it
(setq custom-file (locate-user-emacs-file "custom-vars.el"))
(load custom-file 'noerror 'nomessage)

;; Revert buffers when the underlying file has changed
(global-auto-revert-mode 1)

;; Remember and restore the last cursor location of opened files
(save-place-mode 1)

;; Save what you enter into minibuffer prompts
(setq history-length 25)
(savehist-mode 1)


;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
 (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
   (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package swiper
  :ensure t)

(use-package counsel
  :ensure t)

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)	
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))


;; Theme
(load-theme 'modus-vivendi t)

;; Make background transparent
(set-frame-parameter nil 'alpha-background 70)

(add-to-list 'default-frame-alist '(alpha-background . 70))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

;; Keybindings

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package general
  :config
  (general-evil-setup t)

  (general-create-definer rune/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC"))

(use-package hydra)

(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("j" (lambda ()
	 (interactive)
	 (let ((current-prefix-arg 5))
	   (call-interactively #'global-text-scale-adjust)))  "in")
  ("k" (lambda ()
	 (interactive)
	 (let ((current-prefix-arg -5))
	   (call-interactively #'global-text-scale-adjust))) "out")
  ("f" nil "finished" :exit t))

(rune/leader-keys
  "ts" '(hydra-text-scale/body :which-key "scale text"))

;; UI

(use-package paredit
  :hook ((clojure-mode emacs-lisp-mode) . paredit-mode))

(add-to-list 'auto-mode-alist '("\\.bb\\'" . clojure-mode))

;; Org Mode
(defun dw/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (auto-fill-mode 0)
  (visual-line-mode 1)
  (keymap-set org-mode-map "C-c a" 'org-agenda-list)
  (setq evil-auto-indent nil))

(setq org-hide-emphasis-markers t)
(font-lock-add-keywords 'org-mode
                        '(("^ *\\([-]\\) "
                           (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

(use-package org
  :hook (org-mode . dw/org-mode-setup)
  :config
  (setq org-ellipsis " ▾"
        org-hide-emphasis-markers t))

(use-package org-bullets
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

;; This removes the bullets which I think looks nicer
(setq org-bullets-bullet-list '(" "))

(setq org-directory "~/org-files")
(setq org-agenda-files '("tickets.org" "todo.org" "curriculum.org"))
(setq org-tag-alist '(("howto"  . ?h)
		      ("urgent" . ?u)))

(use-package cider
  :ensure t)

(use-package company
  :hook ((cider-mode cider-repl-mode) . company-mode))

(use-package projectile
  :config (projectile-mode 1)
  :bind-keymap
  ("C-c p" . projectile-command-map))
