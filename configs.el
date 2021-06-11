(eval-and-compile
  (setq gc-cons-threshold 402653184
      gc-cons-percentage 0.6))
(defvar temp--file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)
(setq backup-directory-alist `(("." . "~/.emacs.d/backups")) ; which directory to put backups file
      auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)) ;transform backups file name
      fill-column 80   ; toggle wrapping text at the 80th character
      scroll-conservatively 101         ;
      ispell-program-name "aspell")
(with-eval-after-load 'tramp
  (setq tramp-default-method "ssh"))
(with-eval-after-load 'display-line-numbers
  (setq display-line-numbers-type 'relative
        display-line-numbers-width-start t))
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)
(setq-default indent-tabs-mode nil)
(global-hl-line-mode 1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(blink-cursor-mode 0)
(winner-mode 1)
(put 'narrow-to-region 'disabled nil)
(add-to-list 'load-path "~/.emacs.d/local/")

(eval-and-compile
  (setq load-prefer-newer t
        package-user-dir "~/.emacs.d/elpa"
        package--init-file-ensured t
        package-enable-at-startup nil)

  (unless (file-directory-p package-user-dir)
    (make-directory package-user-dir t))

  (setq load-path (append load-path (directory-files package-user-dir t "^[^.]" t))))


(eval-when-compile
  (require 'package)
  ;; tells emacs not to load any packages before starting up
  ;; the following lines tell emacs where on the internet to look up
  ;; for new packages.
  (setq package-archives '(("melpa"     . "https://melpa.org/packages/")
                           ("elpa"      . "https://elpa.gnu.org/packages/")
                           ("repo-org"  . "https://orgmode.org/elpa/")))
  ;; (package-initialize)
  (unless package--initialized (package-initialize t))

  ;; Bootstrap `use-package'
  (unless (package-installed-p 'use-package) ; unless it is already installed
    (package-refresh-contents) ; updage packages archive
    (package-install 'use-package)) ; and install the most recent version of use-package

  (require 'use-package)
  (setq use-package-always-ensure t))

;; (setq default-frame-alist '((font . "Courier 10 Pitch-13")))
(setq default-frame-alist '((font . "Consolas-13")))
;; (setq doom-font (font-spec :family "Monaco" :size 13))
;; (setq doom-font (font-spec :family "Source Code Pro" :size 13))
;; (setq doom-font (font-spec :family "Courier New" :size 13))
;; (setq doom-font (font-spec :family "Courier 10 Pitch" :size 13))
;; (setq doom-font (font-spec :family "Fira Code" :size 13))
;; (setq doom-font (font-spec :family "Consolas" :size 13))

(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-one t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Enable custom neotree theme (all-the-icons must be installed!)
  (doom-themes-neotree-config)
  ;; or for treemacs users
  (setq doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
  (doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))
(use-package anti-zenburn-theme
  :ensure t)
;; (load-theme 'doom-solarized-light t)
;; (load-theme 'doom-opera-light t)
(load-theme 'doom-nord-light t)
;; (load-theme 'anti-zenburn t)

;; Hide all minor modes in modeline
;; (use-package minions
;;   :ensure t
;;   :config (minions-mode 1))
(use-package doom-modeline
  :ensure t
  :init
  (doom-modeline-mode 1)
  (setq doom-modeline-height 20)
  :config
  (setq doom-modeline-window-width-limit fill-column)
  (setq doom-modeline-major-mode-color-icon nil
        all-the-icons-color-icons nil))
(setq display-time-format "%H:%M:%S")
(display-time-mode 1)

(use-package exec-path-from-shell
  :ensure t
  :if (memq window-system '(mac ns))
  :config
  ;; (setq exec-path-from-shell-arguments '("-l"))
  (exec-path-from-shell-initialize)
  ;; (exec-path-from-shell-copy-envs
  ;;  '("GOPATH" "GO111MODULE" "GOPROXY"
  ;;    "NPMBIN" "LC_ALL" "LANG" "LC_TYPE"
  ;;    "SSH_AGENT_PID" "SSH_AUTH_SOCK" "SHELL"
  ;;   "JAVA_HOME"))
)
;; Auto revert file when pdf is updated:
(global-auto-revert-mode t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Full width comment box                                                 ;;
;; from http://irreal.org/blog/?p=374                                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun bjm-comment-box (b e)
"Draw a box comment around the region but arrange for the region to extend to at least the fill column. Place the point after the comment box."

(interactive "r")

(let ((e (copy-marker e t)))
  (goto-char b)
  (end-of-line)
  (insert-char ?  (- fill-column (current-column)))
  (comment-box b e 1)
  (goto-char e)
  (set-marker e nil)))

;; (defun my-prog-mode-hook ()
;;   ;; (auto-fill-mode)
;;   (show-paren-mode)
;;   (whitespace-mode)
;;   (electric-pair-mode)
;;   (flycheck-mode)
;;   (display-line-numbers-mode))

;; (add-hook 'prog-mode-hook 'my-prog-mode-hook)
;; (setq before-save-hook 'nil)

;; (add-hook 'before-save-hook 'delete-trailing-whitespace)

(defun number-region (start end)
  (interactive "r")
  (save-restriction
    (narrow-to-region start end)
    (goto-char (point-min))
    (let ((counter 0))
      (while (re-search-forward "^" nil t)
        (setq counter (+ 1 counter))
        (replace-match (format "%d" counter) nil nil)))))

(use-package which-key
  :config (which-key-mode 1))

(use-package general
  :after which-key
  :config
  (general-override-mode 1)

  (defun find-user-init-file ()
    "Edit the `user-init-file', in same window."
    (interactive)
    (find-file user-init-file))
  (defun load-user-init-file ()
    "Load the `user-init-file', in same window."
    (interactive)
    (load-file user-init-file))

  ;;Taken from http://emacsredux.com/blog/2013/05/04/rename-file-and-buffer/
  (defun rename-file-and-buffer ()
    "Rename the current buffer and file it is visiting."
    (interactive)
    (let ((filename (buffer-file-name)))
      (if (not (and filename (file-exists-p filename)))
          (message "Buffer is not visiting a file!")
        (let ((new-name (read-file-name "New name: " filename)))
          (cond
           ((vc-backend filename) (vc-rename-file filename new-name))
           (t
            (rename-file filename new-name t)
            (set-visited-file-name new-name t t)))))))


  (defun disable-all-themes ()
    "disable all active themes."
    (dolist (i custom-enabled-themes)
      (disable-theme i)))

  (defadvice load-theme (before disable-themes-first activate)
    (disable-all-themes))

  ;; Following lines to cycle through themes adapted from ivan's answer on
  ;; https://emacs.stackexchange.com/questions/24088/make-a-function-to-toggle-themes
  (setq my/themes (custom-available-themes))
  (setq my/themes-index 0)

  (defun my/cycle-theme ()
    "Cycles through my themes."
    (interactive)
    (setq my/themes-index (% (1+ my/themes-index) (length my/themes)))
    (my/load-indexed-theme))

  (defun my/load-indexed-theme ()
    (load-theme (nth my/themes-index my/themes)))

  (defun load-leuven-theme ()
    "Loads `leuven' theme"
    (interactive)
    (load-theme 'leuven))

  (defun load-dichromacy-theme ()
    "Loads `dichromacy' theme"
    (interactive)
    (load-theme 'dichromacy))

  (general-create-definer tyrant-def
    :states '(normal visual insert motion emacs)
    :prefix "SPC"
    :non-normal-prefix "C-SPC")

  (general-create-definer despot-def
    :states '(normal insert)
    :prefix "SPC"
    :non-normal-prefix "C-SPC")

  (general-define-key
    :keymaps 'key-translation-map
    "ESC" (kbd "C-g"))

  (general-def
    "C-x x" 'eval-defun)

  (tyrant-def
    ""     nil
    "c"   (general-simulate-key "C-c")
    "h"   (general-simulate-key "C-h")
    "u"   (general-simulate-key "C-u")
    "x"   (general-simulate-key "C-x")
    "X"   'org-capture

    ;; Package manager
    "lp"  'list-packages

    ;; Theme operations
    "t"   '(:ignore t :which-key "themes")
    "tn"  'my/cycle-theme
    "tt"  'load-theme
    "tl"  'load-leuven-theme
    "td"  'load-dichromacy-theme

    ;; Quit operations
    "q"   '(:ignore t :which-key "quit emacs")
    "qq"  'kill-emacs
    "qz"  'delete-frame

    ;; Buffer operations
    "b"   '(:ignore t :which-key "buffer")
    ;; "bb"  'mode-line-other-buffer
    "bk"  'kill-this-buffer
    "bn"  'next-buffer
    "bp"  'previous-buffer
    ;; "bk"  'kill-buffer-and-window
    "bR"  'rename-file-and-buffer
    "br"  'revert-buffer

    ;; Window operations
    "w"   '(:ignore t :which-key "window")
    "wm"  'maximize-window
    "w/"  'split-window-horizontally
    "wv"  'split-window-vertically
    "wm"  'maximize-window
    "wu"  'winner-undo
    "ww"  'other-window
    "wc"  'delete-window
    "wC"  'delete-other-windows

    ;; File operations
    "f"   '(:ignore t :which-key "files")
    "fc"  'write-file
    "fe"  '(:ignore t :which-key "emacs")
    "fed" 'find-user-init-file
    "feR" 'load-user-init-file
    "fj"  'dired-jump
    "fl"  'find-file-literally
    "fR"  'rename-file-and-buffer
    "fs"  'save-buffer

    ;; Applications
    "a"   '(:ignore t :which-key "Applications")
    "ad"  'dired
    ":"   'shell-command
    ";"   'eval-expression
    "ac"  'calendar
    "oa"  'org-agenda)

  (general-def 'normal doc-view-mode-map
    "j"   'doc-view-next-line-or-next-page
    "k"   'doc-view-previous-line-or-previous-page
    "gg"  'doc-view-first-page
    "G"   'doc-view-last-page
    "C-d" 'doc-view-scroll-up-or-next-page
    "C-f" 'doc-view-scroll-up-or-next-page
    "C-b" 'doc-view-scroll-down-or-previous-page)

  (general-def '(normal visual) outline-minor-mode-map
    "zn"  'outline-next-visible-heading
    "zp"  'outline-previous-visible-heading
    "zf"  'outline-forward-same-level
    "zB"  'outline-backward-same-level)

  (general-def 'normal package-menu-mode-map
    "i"   'package-menu-mark-install
    "U"   'package-menu-mark-upgrades
    "d"   'package-menu-mark-delete
    "u"   'package-menu-mark-unmark
    "x"   'package-menu-execute
    "q"   'quit-window)

  (general-def 'normal calendar-mode-map
    "h"   'calendar-backward-day
    "j"   'calendar-forward-week
    "k"   'calendar-backward-week
    "l"   'calendar-forward-day
    "0"   'calendar-beginning-of-week
    "^"   'calendar-beginning-of-week
    "$"   'calendar-end-of-week
    "["   'calendar-backward-year
    "]"   'calendar-forward-year
    "("   'calendar-beginning-of-month
    ")"   'calendar-end-of-month
    "SPC" 'scroll-other-window
    "S-SPC" 'scroll-other-window-down
    "<delete>" 'scroll-other-window-down
    "<"   'calendar-scroll-right
    ">"   'calendar-scroll-left
    "C-b" 'calendar-scroll-right-three-months
    "C-f" 'calendar-scroll-left-three-months
    "{"   'calendar-backward-month
    "}"   'calendar-forward-month
    "C-k" 'calendar-backward-month
    "C-j" 'calendar-forward-month
    "gk"  'calendar-backward-month
    "gj"  'calendar-forward-month
    "v"   'calendar-set-mark
    "."   'calendar-goto-today
    "q"   'calendar-exit))

(use-package suggest
:general (tyrant-def "as" 'suggest))

(use-package ranger
  :hook (after-init . ranger-override-dired-mode)
  :general (tyrant-def "fd" 'ranger))

(use-package evil
  :ensure t
  :init
  (setq evil-want-C-u-scroll t)
  (setq evil-undo-system 'undo-fu)
  :hook (after-init . evil-mode)
  :config
  (setcdr evil-insert-state-map nil)
  (define-key evil-insert-state-map [escape] 'evil-normal-state)
  (evil-set-initial-state 'shell-mode 'normal)
  (evil-set-initial-state 'doc-view-mode 'normal)
  (evil-set-initial-state 'package-menu-mode 'normal)
  (evil-set-initial-state 'biblio-selection-mode 'motion)
  ;; (evil-set-initial-state 'pdf-view-mode 'normal)
  (setq doc-view-continuous t)
  :general
  (tyrant-def
    "wh"  'evil-window-left
    "wl"  'evil-window-right
    "wj"  'evil-window-down
    "wk"  'evil-window-up
    "bN"  'evil-buffer-new)
  )
;; remove the annoying evil-ret from my motion state!!!!
(with-eval-after-load 'evil-maps
  (define-key evil-motion-state-map (kbd "SPC") nil)
  (define-key evil-motion-state-map (kbd "RET") nil)
  (define-key evil-motion-state-map (kbd "TAB") nil))

(use-package evil-org
  :commands evil-org-mode
  :ensure t
  :after (org evil)
  :init
  (add-hook 'org-mode-hook 'evil-org-mode)
  :config
  (add-hook 'evil-org-mode-hook
            (lambda ()
              (evil-org-set-key-theme '(navigation insert textobjects additional calendar return))))
  (evil-define-minor-mode-key '(normal motion) 'evil-org-mode
    "RET" 'evil-org-return)
  )

(use-package evil-numbers
  :ensure t
  :after evil
  :general
  (general-def 'normal
   "C-=" 'evil-numbers/inc-at-pt
   "C--" 'evil-numbers/dec-at-pt))

(use-package evil-surround
  :ensure t
  :after evil
  :config (global-evil-surround-mode 1))

(use-package evil-easymotion
  :ensure t
  :after evil
  :config
  (evilem-default-keybindings "gs"))

(use-package evil-commentary
  :ensure t
  :after evil
  :config (evil-commentary-mode 1)

  :general
  (general-def 'normal override-global-map
    "gc"  'evil-commentary
    "gC" 'evil-commentary-line))

(use-package evil-visualstar
  :ensure t
  :after evil
  :config
  (setq evilmi-always-simple-jump t)
  (global-evil-visualstar-mode 1))

(use-package evil-vimish-fold
  :ensure t
  :after evil
  :init
  (setq evil-vimish-fold-target-modes '(prog-mode conf-mode text-mode))
  :config
  (global-evil-vimish-fold-mode))

(use-package undo-fu
  :ensure t
  ;; :config
  ;; (global-undo-tree-mode -1)
  ;; (define-key evil-normal-state-map "u" 'undo-fu-only-undo)
  ;; (define-key evil-normal-state-map "\C-r" 'undo-fu-only-redo)
  )

(use-package undo-fu-session
  :ensure t
  :config
  (setq undo-fu-session-incompatible-files '("/COMMIT_EDITMSG\\'" "/git-rebase-todo\\'")))

(global-undo-fu-session-mode)

(use-package company
  :hook (after-init . global-company-mode)
  :config
  (define-key company-active-map (kbd "M-n") nil)
  (define-key company-active-map (kbd "M-p") nil)
  (define-key company-active-map (kbd "C-n") #'company-select-next-or-abort)
  (define-key company-active-map (kbd "C-p") #'company-select-previous-or-abort)
  (setq company-frontends '(company-echo-metadata-frontend
                            company-pseudo-tooltip-unless-just-one-frontend
                            company-preview-frontend))
  (setq company-backends '((company-capf
                            company-files)
                           (company-dabbrev-code company-keywords)
                            company-dabbrev company-yasnippet)))

(use-package company-quickhelp
  :defer 5
  :config (company-quickhelp-mode))

(use-package company-statistics
  :defer 5
  :config (company-statistics-mode))

(use-package projectile)

(defvar narrowing-system "helm"
  "Sets the narrowing system to use - helm or ivy")

(use-package ivy
    :if (equal narrowing-system "ivy")
    :hook (after-init . ivy-mode)
    :config (setq ivy-use-virtual-buffers t
                ivy-count-format "(%d/%d) "
                ivy-initial-inputs-alist nil
                ivy-re-builders-alist '((t . ivy--regex-ignore-order)))
    :commands (ivy-switch-buffer)
    :general
    (tyrant-def "bm"  'ivy-switch-buffer))

(use-package smex
  :if (equal narrowing-system "ivy"))

(use-package counsel
  :after (ivy)
  :general
  (tyrant-def
    "SPC" 'counsel-M-x
    "ff"  'counsel-find-file
    "fr"  'counsel-recentf
    "fL"  'counsel-locate))

(use-package flyspell-correct-ivy
  :if (equal narrowing-system "ivy")
  :commands (flyspell-correct-word-generic)
  :general
   (:keymaps '(flyspell-mode-map)
    :states '(normal visual)
    "zs" 'flyspell-correct-word-generic
    "z=" 'flyspell-buffer))

(use-package counsel-projectile
  :after (projectile ivy)
  :general
  (tyrant-def
   "p"   '(:ignore t :which-key "projectile")
   "pd"  'counsel-projectile-dired-find-dir
   "po"  'counsel-projectile-find-other-file
   "pf"  'counsel-projectile-find-file
   "fp"  'counsel-projectile-find-file
   "pb"  'counsel-projectile-switch-to-buffer))

(use-package helm
  :if (equal narrowing-system "helm")
  :hook (after-init . helm-mode)
  :config (require 'helm-config)
  :commands (helm-mini
             helm-find-files
             helm-recentf
             helm-locate
             helm-M-x
             helm-flyspell-correct)
  :general
  (tyrant-def
   "SPC" 'helm-M-x
   "bb"  'helm-mini
   "ff"  'helm-find-files
   "fr"  'helm-recentf
   "fL"  'helm-locate))

(use-package helm-flyspell
  :if (equal narrowing-system "helm")
  :commands (helm-flyspell-correct)
  :general
   (:keymaps '(flyspell-mode-map)
    :states '(normal visual)
    "zs" 'helm-flyspell-correct
    "z=" 'flyspell-buffer))

(use-package helm-projectile
  :after (projectile helm)
  :general
  (tyrant-def
   "p"   '(:ignore t :which-key "projectile")
   "pd"  'helm-projectile-dired-find-dir
   "po"  'helm-projectile-find-other-file
   "pf"  'helm-projectile-find-file
   "fp"  'helm-projectile-find-file
   "pb"  'helm-projectile-switch-to-buffer))

(use-package flycheck
  :commands (flycheck-mode)
  :general
  (tyrant-def
   "e"   '(:ignore t :which-key "Errors")
   "en"  'flycheck-next-error
   "ep"  'flycheck-previous-error))

(use-package magit
  :commands (magit-status)
  :general
  (tyrant-def
   "g"   '(:ignore t :which-key "git")
   "gs"  'magit-status))

;; (use-package evil-magit
;;   :hook (magit-mode . evil-magit-init))

(require 'tramp)
(setq tramp-ssh-controlmaster-options "")

(setq python-shell-interpreter "~/Software/miniconda3/bin/python3")
(use-package company-jedi
  :if (executable-find "virtualenv")
  :ensure t
  :hook (python-mode . my-python-mode-hook)
  :config
  (defun my-python-mode-hook ()
    (setq-local company-backends '(company-jedi)))
  (if (eq system-type 'darwin)
    (setq python-shell-exec-path "~/Software/miniconda3/bin"
          python-shell-interpreter "~/Software/miniconda3/bin/python")
    (setq python-shell-interpreter "python3"))
  :general
   ('(normal visual) python-mode-map
    "]]"  'python-nav-forward-defun
    "[["  'python-nav-backward-defun
    "gj"  'python-nav-forward-block
    "gk"  'python-nav-backward-block)
  (despot-def python-mode-map
   ""      nil
   "mg"   'jedi:goto-definition
   "mb"   'jedi:goto-definition-pop-marker))

;; (use-package yapfify
;;   :hook (python-mode . yapf-mode))

(use-package sphinx-doc
  :hook (python-mode . sphinx-doc-mode)
  :general
  (despot-def python-mode-map
   "ms"   'sphinx-doc))

(use-package yasnippet
  :hook ((prog-mode org-mode) . yas-minor-mode)
  :general
  (tyrant-def
   "y"   '(:ignore t :which-key "yasnippet")
   "yi"  'yas-insert-snippet
   "yv"  'yas-visit-snippet-file
   "yn"  'yas-new-snippet))

(use-package yasnippet-snippets
  :after yasnippet)

(use-package editorconfig
  :ensure t
  :config
  (editorconfig-mode 1))

(use-package undo-tree
  :ensure t
  :init
  (global-undo-tree-mode))

(defun set-org-general-config ()
  (setq org-todo-keywords
        '((sequence "TODO(t)" "|" "DONE(d)")
          (sequence "[.](T)" "[-](p)" "[?](m)" "|" "[X](D)")
          (sequence "NEXT(n)" "WAITING(w)" "LATER(l)" "|" "CANCELLED(c)")))

  ;; Highlight math in orgmode
  ;; (turn the pretty entities off in case of lagging)
  ;; (setq org-pretty-entities nil)
  (setq org-src-fontify-natively t)
  (setq org-highlight-latex-and-related nil)
  (setq org-highlight-latex-and-related '(latex))
  (setq org-highlight-latex-and-related '(latex script entities))

  ;; extend today for late sleepers
  ;; DO NOT SLEEP LATE!
  (setq org-extend-today-until 2)

  ;; Add time stamp and note to the task when it's done
  (setq org-log-done 'time)

  ;; Insert state change notes and time stamps into a drawer
  (setq org-log-into-drawer t)

  ;; use user preferred labels
  (setq org-latex-prefer-user-labels t)

  ;; Downscale image size
  ;; Source: https://emacs.stackexchange.com/questions/26363/downscaling-inline-images-in-org-mode
  (setq org-image-actual-width nil)

  ;; Add the REPORT drawer
  (setq org-drawers '("PROPERTIES" "CLOCK" "LOGBOOK" "REPORT"))

  (setq org-return-follows-link t)

  ;; id file
  (setq org-id-locations-file "~/.doom.d/.org-id-locations")

  ;; async export
  (setq org-export-async-debug t
        org-export-async-init-file (concat "~/.doom.d/local/ox-init.el")
        org-export-in-background t)

  (setq org-link-frame-setup
        '((vm . vm-visit-folder-other-frame)
          (vm-imap . vm-visit-imap-folder-other-frame)
          (gnus . org-gnus-no-new-news)
          (file . find-file-other-window)
          (wl . wl-other-frame)))
)

(use-package org
  :defer t
  :mode ("\\.org\\'" . org-mode)
  :ensure org-plus-contrib
  :init
  (defun my-org-mode-hooks ()
    (visual-line-mode)
    (display-line-numbers-mode t)
    (flyspell-mode)
    (org-indent-mode)
    (outline-minor-mode)
    ;; (electric-pair-mode)
    )
  (add-hook 'org-mode-hook 'my-org-mode-hooks)
  :general
  (despot-def org-mode-map
    "me"   'org-export-dispatch
    "mt"   'org-hide-block-toggle
    "mx"   'org-babel-execute-src-block
    "mX"   'org-babel-execute-and-next
    "md"   'org-babel-remove-result
    )
  :config
  (if (not (featurep 'ox-bibtex))
      (require 'ox-bibtex))
  (defun org-babel-execute-and-next ()
    (interactive)
    (progn (org-babel-execute-src-block)
           (org-babel-next-src-block)))
  (setq org-highlight-latex-and-related '(entities script latex)
        org-tags-column 90)
  (set-org-general-config))

(defun my/copy-idlink-to-clipboard()
  "Copy an ID link with the headline to killring, if no ID is there then create a new unique ID. This function works only in org-mode or org-agenda buffers. The purpose of this function is to easily construct id:-links to org-mode items. If its assigned to a key it saves you marking the text and copying to the killring."
     (interactive)
     (when (eq major-mode 'org-agenda-mode) ;switch to orgmode
   (org-agenda-show)
   (org-agenda-goto))
     (when (eq major-mode 'org-mode) ; do this only in org-mode buffers
   (setq mytmphead (nth 4 (org-heading-components)))
       (setq mytmpid (funcall 'org-id-get-create))
   (setq mytmplink (format "[[id:%s][%s]]" mytmpid mytmphead))
   (kill-new mytmplink)
   (message "Copied %s to killring (clipboard)" mytmplink)
   ))

(defun lookyhooky/org-mode-hook ()
"Stop the org-level headers from increasing in height relative to the other text."
(dolist (face '(org-level-1
                org-level-2
                org-level-3
                org-level-4
                org-level-5))
    (set-face-attribute face nil :weight 'semi-bold :height 1.0)))

(add-hook 'org-mode-hook 'lookyhooky/org-mode-hook)

(require 'org-colored-text)
;; Taken and adapted from org-colored-text

(org-add-link-type
 "color"
 (lambda (path)
   "No follow action.")
 (lambda (color description backend)
   (cond
    ((eq backend 'latex)                  ; added by TL
     (format "{\\color{%s}%s}" color description)) ; added by TL
    ((eq backend 'html)
     (let ((rgb (assoc color color-name-rgb-alist))
           r g b)
       (if rgb
           (progn
             (setq r (* 255 (/ (nth 1 rgb) 65535.0))
                   g (* 255 (/ (nth 2 rgb) 65535.0))
                   b (* 255 (/ (nth 3 rgb) 65535.0)))
             (format "<span style=\"color: rgb(%s,%s,%s)\">%s</span>"
                     (truncate r) (truncate g) (truncate b)
                     (or description color)))
         (format "No Color RGB for %s" color)))))))

(require 'org)
(add-to-list 'org-modules 'org-tempo t)
(setq org-structure-template-alist
  '(("lem" . "lemma")
    ("thm" . "theorem")
    ("cor" . "corollary")
    ("rmk" . "remark")
    ("prf" . "proof")
    ("prop" . "proposition")
    ("clm" . "claim")
    ("sol" . "solution")
    ("def" . "definition")
    ("emp" . "example")
    ("ltx" . "export latex")
    ("el" . "src emacs-lisp")
    ("sh" . "src sh")
    ("src" . "src")
    ("exp" . "export")
    ))

(define-skeleton org-latex-header
  "Header info for literature notes."
  "Inserting header for literature notes."
  "#+DATE: \n"
  "#+AUTHOR: Haoming Shen\n"
  "#+OPTIONS: author:nil date:nil title:nil toc:nil \n"
  "#+LaTeX_CLASS: notes \n"
  "#+LaTeX_HEADER: \\addbibresource{master.bib} \n"
 )

(define-skeleton org-header
  "Header info for org notes."
  "Inserting header for org notes."
  "#+DATE: \n"
  "#+AUTHOR: Haoming Shen\n"
 )

(define-skeleton org-latex-attr
  "Attributes for LaTeX segments"
  "Inserting attributes for LaTeX environment."
  "#+ATTR_LaTeX: :options[]"
  )

(use-package org-roam
  :ensure t
  :defer 10
  :hook
  (after-init . org-roam-mode)
  :custom
  (org-roam-directory (file-truename "~/Dropbox/Notes/roam"))
    ;; TODO key bindings
  :general
  (tyrant-def 
    "r"   '(:ignore t :which-key "org-roam")
    "rf"  'org-roam-find-file
    "ri"  'org-roam-insert
    )
  )

(setq org-my-inbox "~/Dropbox/Org/inbox.org")
(setq org-my-tickler "~/Dropbox/Org/tickler.org")
(setq org-my-diary "~/Dropbox/Org/diary.org")
(setq org-my-gtd "~/Dropbox/Org/gtd.org")

(setq org-capture-templates
      '(("t" "Todo [inbox]" entry
         (file+headline org-my-inbox "Tasks") "* TODO %i%?")
        ("T" "Tickler" entry
         (file+headline "~/Documents/Org/tickler.org" "Tickler") "* %i%? \n %U")
        ("d" "Daily Tasks" plain
         (file+olp+datetree "~/Documents/Org/diary.org") "RESEARCH: \n- [ ] \nCOURSES: \n- [ ] \nJOBS: \n- [ ] \nOTHERS: \n- [ ] Org my life. \n- [ ] Enjoy my day. \n- [ ] Personal Finance.")
        ("l" "Ledger entries")
        ("lC" "Chase CSP" plain
                 (file "~/Dropbox/Private/Finance/records.dat.gpg")
                 "%(org-read-date) * %^{Payee}
  Expenses:%^{Category}:%^{Details}  %^{Amount}
  Liabilities:Chase:SapphirePreferred
")
        ("lF" "Chase Freedom" plain
                 (file "~/Dropbox/Private/Finance/records.dat.gpg")
                 "%(org-read-date) * %^{Payee}
  Expenses:%^{Category}:%^{Details}  %^{Amount}
  Liabilities:Chase:FreedomUnlimited
")
        ("lB" "Amex BlueCash" plain
                 (file "~/Dropbox/Private/Finance/records.dat.gpg")
                 "%(org-read-date) * %^{Payee}
  Expenses:%^{Category}:%^{Details}  %^{Amount}
  Liabilities:Amex:BlueCash
")
        ))

;; ORG REFILE
(setq org-refile-targets '(("~/Documents/Org/gtd.org" :maxlevel . 3)
                           ("~/Documents/Org/someday.org" :level . 1)
                           ("~/Documents/Org/gcal.org" :level . 1)
                           ("~/Documents/Org/tickler.org" :maxlevel . 2)
                           ("~/Documents/Org/diary.org" :maxlevel . 4)))

(setq org-directory '("~/Documents/Org/" "~/Dropbox/Papers"))
(setq org-agenda-files
      '(
        "~/Documents/Org/inbox.org"
        "~/Documents/Org/gtd.org"
        "~/Documents/Org/tickler.org"
        "~/Documents/Org/diary.org"
        ;; "~/Dropbox/Papers/notes.org"
        "~/Dropbox/Notes/literature.org"
        ;; "~/Documents/Org/gcal.org"
        ))
(setq org-archive-location "~/Documents/Org/archives/archives.org::")

;; (defadvice org-agenda (around split-vertically activate)
;;   (let ((split-width-threshold 40)    ; or whatever width makes sense for you
;;         (split-height-threshold nil)) ; but never horizontally
;;     ad-do-it))

(use-package org-super-agenda
  :ensure t
  :after org-agenda
  :init
  (setq org-super-agenda-groups
       '(;; Each group has an implicit boolean OR operator between its selectors.
         (:name "Today"  ; Optionally specify section name
                :time-grid t  ; Items that appear on the time grid
                :todo "TODAY")  ; Items that have this TODO keyword
         (:name "Important"
                ;; Single arguments given alone
                :tag "Projects"
                :deadline today
                :priority "A")
         (:name "Overdue"
                :deadline past)
         (:name "Due soon"
                :deadline future)
         (:name "To read"
                :tag "Papers")
         (:name "Personal"
                :habit t)
         (:name "Less Important"
                :priority<= "B"
                :order 7)
         (:todo ("WAITING" "LATER")
                :order 8)
         (:todo "CANCELLED"
                :order 9)))
  (setq org-agenda-skip-scheduled-if-done t
        org-agenda-skip-deadline-if-done t
        org-agenda-include-deadlines t
        org-agenda-block-separator nil
        org-agenda-tags-column 100 ;; from testing this seems to be a good value
        org-agenda-compact-blocks t)
  :config
  (org-super-agenda-mode))

(setq org-clock-file "~/Documents/Org/diary.org")
(defun doom/org-clock-exit ()
  "Auto clock out daily.org when exist"
  (with-current-buffer (find-file-noselect org-clock-file)
    (save-excursion
      (org-clock-out nil t)
      (save-buffer))))
(add-hook 'kill-emacs-hook #'doom/org-clock-exit)

(require 'ox-latex)
(require 'ox-beamer)

(with-eval-after-load 'ox-latex
  ;; Compiler
  (setq bibtex-dialect 'biblatex)
  ;; (setq org-latex-pdf-process '("latexmk -shell-escape -interaction nonstopmode -bibtex -pdf %f"))
  (setq org-latex-pdf-process
        '("latexmk -pdflatex='pdflatex -shell-escape -interaction nonstopmode' -pdf -f  %f"))
  (setq org-latex-packages-alist
        (quote (("" "parskip" t)
                ("" "amsmath" t)
                ("" "amssymb" t)
                ("" "amsthm" t)
                ("" "amsfonts" t)
                ("" "mathtools" t)
                ("" "braket" t)
                ("" "bbm" t)
                ("" "listings" t)
                ("" "algpseudocode" t)
                ("" "algorithm" t)
                ("" "algorithmicx" t)
                ("" "xcolor" t)
                ("" "mymacros" t))))
  ;; org default header
  (add-to-list
   'org-latex-classes
   '("notes"
     "\\documentclass[11pt]{article}
  \\usepackage{mynotes}
  \\usepackage{mymacros}
  \\usepackage[normalem]{ulem}
  \\usepackage{booktabs}
  \\usepackage[inline, shortlabels]{enumitem}
  \\usepackage[backref=true,natbib=true,maxbibnames=99,doi=false,url=false,giveninits=true]{biblatex}
  \\usepackage{hyperref}
  [NO-DEFAULT-PACKAGES]
  [NO-PACKAGES]
  %%%% configs
  \\DefineBibliographyStrings{english}{backrefpage={page}, backrefpages={pages}}
  \\setlength\\parindent{0pt}
  \\setitemize{itemsep=1pt}"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")))
  
  (add-to-list 'org-latex-classes
               '("manuscripts"
                 "\\documentclass[11pt]{article}
  \\usepackage[utf8]{inputenc}
  \\usepackage[T1]{fontenc}
  \\usepackage[normalem]{ulem}
  \\usepackage[margin=1in]{geometry}
  [NO-DEFAULT-PACKAGES]
  [PACKAGES]
  \\usepackage{pgf,interval}
  \\usepackage{booktabs}
  \\usepackage[inline]{enumitem}
  \\usepackage[backref=true,natbib=true,maxbibnames=99,doi=false,url=false,giveninits=true,dashed=false]{biblatex}
  \\usepackage{hyperref}
  %%%% configs
  \\DefineBibliographyStrings{english}{backrefpage={page}, backrefpages={pages}}
  \\intervalconfig{soft open fences}
  \\setlength\\parindent{0pt}
  \\setitemize{itemsep=1pt}"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")))
  
  (add-to-list 'org-latex-classes
               '("slides"
                 "\\documentclass[notheorems]{beamer}
  \\usepackage[utf8]{inputenc}
  \\usepackage[T1]{fontenc}
  \\usepackage[normalem]{ulem}
  [NO-DEFAULT-PACKAGES]
  [PACKAGES]
  \\usepackage{booktabs}
  \\usepackage[natbib=true,backend=biber,style=authoryear-icomp,maxbibnames=1,maxcitenames=2,uniquelist=false,doi=false,isbn=false,url=false,eprint=false,dashed=false]{biblatex}
  \\usepackage{pgfpages}
  %%%% configs
  \\setlength\\parindent{0pt}"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")))
  (add-to-list 'org-latex-classes
               '("moderncv"
                 "\\documentclass{moderncv}
  [NO-DEFAULT-PACKAGES]"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))))

;; Compiler
(setq bibtex-dialect 'biblatex)
;; (setq org-latex-pdf-process '("latexmk -shell-escape -interaction nonstopmode -bibtex -pdf %f"))
(setq org-latex-pdf-process
      '("latexmk -pdflatex='pdflatex -shell-escape -interaction nonstopmode' -pdf -f  %f"))

(setq org-latex-packages-alist
      (quote (("" "parskip" t)
              ("" "amsmath" t)
              ("" "amssymb" t)
              ("" "amsthm" t)
              ("" "amsfonts" t)
              ("" "mathtools" t)
              ("" "braket" t)
              ("" "bbm" t)
              ("" "listings" t)
              ("" "algpseudocode" t)
              ("" "algorithm" t)
              ("" "algorithmicx" t)
              ("" "xcolor" t)
              ("" "mymacros" t))))

;; org default header
(add-to-list
 'org-latex-classes
 '("notes"
   "\\documentclass[11pt]{article}
\\usepackage{mynotes}
\\usepackage{mymacros}
\\usepackage[normalem]{ulem}
\\usepackage{booktabs}
\\usepackage[inline, shortlabels]{enumitem}
\\usepackage[backref=true,natbib=true,maxbibnames=99,doi=false,url=false,giveninits=true]{biblatex}
\\usepackage{hyperref}
[NO-DEFAULT-PACKAGES]
[NO-PACKAGES]
%%%% configs
\\DefineBibliographyStrings{english}{backrefpage={page}, backrefpages={pages}}
\\setlength\\parindent{0pt}
\\setitemize{itemsep=1pt}"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")))

(add-to-list 'org-latex-classes
             '("manuscripts"
               "\\documentclass[11pt]{article}
\\usepackage[utf8]{inputenc}
\\usepackage[T1]{fontenc}
\\usepackage[normalem]{ulem}
\\usepackage[margin=1in]{geometry}
[NO-DEFAULT-PACKAGES]
[PACKAGES]
\\usepackage{pgf,interval}
\\usepackage{booktabs}
\\usepackage[inline]{enumitem}
\\usepackage[backref=true,natbib=true,maxbibnames=99,doi=false,url=false,giveninits=true,dashed=false]{biblatex}
\\usepackage{hyperref}
%%%% configs
\\DefineBibliographyStrings{english}{backrefpage={page}, backrefpages={pages}}
\\intervalconfig{soft open fences}
\\setlength\\parindent{0pt}
\\setitemize{itemsep=1pt}"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")))

(add-to-list 'org-latex-classes
             '("slides"
               "\\documentclass[notheorems]{beamer}
\\usepackage[utf8]{inputenc}
\\usepackage[T1]{fontenc}
\\usepackage[normalem]{ulem}
[NO-DEFAULT-PACKAGES]
[PACKAGES]
\\usepackage{booktabs}
\\usepackage[natbib=true,backend=biber,style=authoryear-icomp,maxbibnames=1,maxcitenames=2,uniquelist=false,doi=false,isbn=false,url=false,eprint=false,dashed=false]{biblatex}
\\usepackage{pgfpages}
%%%% configs
\\setlength\\parindent{0pt}"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")))

(add-to-list 'org-latex-classes
             '("moderncv"
               "\\documentclass{moderncv}
[NO-DEFAULT-PACKAGES]"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")))

(use-package org-ref
  :ensure t
  :after org
  :init
  (setq org-ref-default-bibliography '("~/Documents/Papers/master.bib")
        org-ref-pdf-directory "~/Documents/Papers/pdfs/")
  (setq org-ref-notes-function
      (lambda (thekey)
        (let ((bibtex-completion-bibliography (org-ref-find-bibliography)))
          (bibtex-completion-edit-notes
           (list (car (org-ref-get-bibtex-key-and-file thekey)))))))
  (setq org-ref-note-title-format
        "* TODO %y - %t 
:PROPERTIES:
:Custom_ID: %k
:AUTHOR: %9a
:NOTER_DOCUMENT: %F
:JOURNAL: %j
:YEAR: %y
:VOLUME: %v
:PAGES: %p
:DOI: %D
:URL: %U
:END:
")
  :general
  (tyrant-def bibtex-mode-map
    "mc" 'org-ref-clean-bibtex-entry
    "ma" 'org-ref-bibtex-assoc-pdf-with-entry
    "mp" 'org-ref-bibtex-pdf)
  )

;; (defun my/org-ref-notes-function (candidates)
;;   (let ((key (helm-marked-candidates)))
;;     (funcall org-ref-notes-function (car key))))
;; (helm-delete-action-from-source "Edit notes" helm-source-bibtex)
;; ;; Note that 7 is a magic number of the index where you want to insert the command. You may need to change yours.
;; (helm-add-action-to-source "Edit notes" 'my/org-ref-notes-function helm-source-bibtex 7)

(use-package ob-ipython
  :hook (org-mode . my-ob-ipython-hook)
  :config
  (defun my-ob-ipython-hook ()
    (with-eval-after-load 'org-babel
      (progn
        (require 'ob-ipython)
        (setq ob-ipython-suppress-execution-count t)
        (add-to-list 'company-backends 'company-ob-ipython))))

  (org-babel-do-load-languages
   'org-babel-load-languages
   (append org-babel-load-languages
           '((python  . t)
             (ipython . t))))
  (setq org-confirm-babel-evaluate nil
        org-src-fontify-natively t
        ob-ipython-suppress-execution-count t)

  (add-hook 'org-babel-after-execute-hook 'org-display-inline-images
            'append)
  :general
  (tyrant-def org-mode-map
    "mb"   (general-simulate-key "C-c C-v")))

;; (use-package org-ref
;;   :hook (org-mode . load-org-ref)
;;   :config
;;   (defun load-org-ref ()
;;     (require 'org-ref))
;;   (setq org-ref-default-bibliography '("~/Zotero/papers.bib")
;;         org-ref-pdf-directory "~/gdrve2/pdfs2/"
;;         org-ref-bibliography-notes "~/Zotero/pdfs/notes.org"
;;         org-ref-default-citation-link "citet")
;;   :general
;;   (despot-def org-mode-map
;;     "mc"   'org-ref-helm-insert-cite-link
;;     "mr"   'org-ref-helm-insert-ref-link
;;     "ml"   'org-ref-helm-insert-label-link))

;; (use-package org-bullets
;;   :hook (org-mode . org-bullets-mode))

(use-package org-pomodoro
  :general
  (despot-def org-mode-map
   "mps"  'org-pomodoro))

(use-package ox-reveal
  :hook (org-mode . load-org-reveal)
  :config
  (defun load-org-reveal ()
    (if (not (featurep 'ox-reveal))
        (require 'ox-reveal))))

(use-package tex
  :defer t
  :mode ("\\.tex\\'" . TeX-latex-mode)
  :ensure auctex
  :init
  (add-hook 'LaTeX-mode-hook 'my-LaTeX-mode-hooks)
  (defun my-LaTeX-mode-hooks ()
    ;; (whitespace-mode)
    (show-paren-mode)
    (visual-line-mode)
    (flyspell-mode)
    (outline-minor-mode)
    ;; (electric-pair-mode)
    (display-line-numbers-mode t)
    (TeX-source-correlate-mode t))
  :config
  (setq TeX-auto-save t
        TeX-source-correlate-start-server 'synctex
        ;; LaTeX-electric-left-right-brace t
        )
  (defun insert-file-name-base (file)
    "Read file name and insert it at point.
    With a prefix argument, insert only the non-directory part."
    (interactive "FFile:")
    (insert (file-name-base file)))
  :general
  (despot-def TeX-mode-map
    "mb"   'TeX-command-master
    "ma"   'TeX-command-run-all
    "mv"   'TeX-view
    "mc"   'reftex-citation
    "mr"   'reftex-reference
    "mf"   'insert-file-name-base))

(use-package reftex
  :ensure t
  :hook (LaTeX-mode . turn-on-reftex)
  :config
  (setq reftex-plug-into-AUCTeX t))

(use-package cdlatex
  :ensure t
  ;; :after (:any org-mode LaTeX-mode)
  :hook
  (org-mode   . turn-on-org-cdlatex)
  (LaTeX-mode . turn-on-cdlatex)
  :config
  (add-to-list 'cdlatex-parens-pairs '("\\(" . "\\)"))
  (add-to-list 'cdlatex-parens-pairs '("\\[" . "\\]"))
  (setq cdlatex-math-symbol-alist
        '(
          (?0 ("\\varnothing" "\\emptyset" ""))
          (?{ ("\\min" "\\inf" ""))
          (?} ("\\max" "\\sup" ""))
          (?< ("\\subseteq" "\\subset" ""))
          (?> ("\\supseteq" "\\supset" ""))
          (?D  ("\\Delta" "\\nabla" "\\displaystyle"))
          (?: ("\\colon", "", ""))
          (?H ("\\hop", "", ""))
          (?T ("\\top" "" "\\arctan"))
          )
        cdlatex-math-modify-alist
        '(
          (?B "\\mathbb" nil t nil nil)
          (?a "\\abs" nil t nil nil)
          (?- "\\overline" nil t nil nil)
          (?0 "\\text" nil t nil nil)))
  (setq cdlatex-env-alist
        '(
          ("axiom" "\\begin{axiom}\n?\n\\end{axiom}\n" nil)
          ("proof" "\\begin{proof}\n?\n\\end{proof}\n" nil)
          ("lemma" "\\begin{lemma}\n?\n\\end{lemma}\n" nil)
          ("lem" "\\begin{lem}\n?\n\\end{lem}\n" nil)
          ("theorem" "\\begin{theorem}\n?\n\\end{theorem}\n" nil)
          ("thm" "\\begin{thm}\n?\n\\end{thm}\n" nil)
          ("corollary" "\\begin{corollary}\n?\n\\end{corollary}\n" nil)
          ("cor" "\\begin{cor}\n?\n\\end{cor}\n" nil)
          ("proposition" "\\begin{proposition}\n\n\\end{proposition}\n" nil)
          ("prop" "\\begin{prop}\n\n\\end{prop}\n" nil)
          ("problem" "\\begin{problem}\n?\n\\end{problem}\n" nil)
          ("solution" "\\begin{solution}\n?\n\\end{solution}\n" nil)
          ("remark" "\\begin{remark}\n?\n\\end{remark}\n" nil)
          ("aligned" "\\begin{aligned}\n?\n\\end{aligned}\n" nil)
          ("comment box" "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n% ?\n%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%", nil)
          )
        cdlatex-command-alist
        '(
          ("cmt" "Insert Comment Box" "" cdlatex-environment ("comment box") t nil)
          ("Set" "Insert \\Set{}" "\\Set{?}" cdlatex-position-cursor nil nil t)
          ("set" "Insert \\set{}" "\\set{?}" cdlatex-position-cursor nil nil t)
          ("alid" "Insert aligned env" "" cdlatex-environment ("aligned") t nil)
          ("axm" "Insert axiom env" "" cdlatex-environment ("axiom") t nil)
          ("thm" "Insert theorem env" "" cdlatex-environment ("theorem") t nil)
          ("lem" "Insert lemma env" "" cdlatex-environment ("lemma") t nil)
          ("cor" "Insert corollary env" "" cdlatex-environment ("corollary") t nil)
          ("prop" "Insert proposition env" "" cdlatex-environment ("proposition") t nil)
          ("prob" "Insert problem env" "" cdlatex-environment ("problem") t nil)
          ("sol" "Insert solution env" "" cdlatex-environment ("solution") t nil)
          ("rmk" "Insert remark env" "" cdlatex-environment ("remark")
           t nil)))
    ;; :general keybindings TODO
  :general
  (general-def '(normal insert) org-mode-map
    "M-;" 'cdlatex-tab)
  (general-def '(normal insert) LaTeX-mode-map
    "M-;" 'cdlatex-tab)
  )

(use-package auctex-latexmk
  :hook (LaTeX-mode . auctex-latexmk-setup)
  :config
  (setq auctex-latexmk-inherit-TeX-PDF-mode t))

(use-package company-reftex
  :after company
  :hook (reftex-mode . load-company-reftex)
  :config
  (defun load-company-reftex ()
    (add-to-list 'company-backends
                 '(company-reftex-citations
                   company-reftex-labels))))

(use-package company-bibtex
  :after company
  :hook (org-mode . load-company-bibtex)
  :config
  (defun load-company-bibtex ()
    (add-to-list 'company-backends 'company-bibtex))

  (if (eq system-type 'darwin)
    (setq company-bibtex-bibliography
          '("~/Documents/bib_file/papers.bib"
            "~/Documents/bib_file/selfpapers.bib"))
    (setq company-bibtex-bibliography
          '("~/bibtex/papers.bib"
            "~/bibtex/selfpapers.bib")))
  (setq company-bibtex-org-citation-regex (regexp-opt '("cite:" "\\cite{"))))

(defun set-bibtex-config ()
  (setq bibtex-completion-bibliography '("~/Documents/Papers/master.bib")
        bibtex-completion-library-path '("~/Documents/Papers/pdfs")
        bibtex-completion-notes-path "~/Documents/Papers/notes"
        bibtex-completion-find-additional-pdfs t
        bibtex-completion-additional-search-fields '(keywords)
        bibtex-completion-pdf-symbol "⌘"
        bibtex-completion-notes-symbol "✎"
        bibtex-autokey-year-length 4
        bibtex-autokey-name-year-separator "-"
        bibtex-autokey-year-title-separator "-"
        bibtex-autokey-titleword-separator "-"
        bibtex-autokey-titlewords 2
        bibtex-autokey-titlewords-stretch 1
        bibtex-autokey-titleword-length 5)

  (tyrant-def bibtex-mode-map
    "mi" 'doi-insert-bibtex)
  (general-def 'normal biblio-selection-mode-map
    "j" 'biblio--selection-next
    "k" 'biblio--selection-previous))

(use-package ivy-bibtex
  :after (ivy)
  :defines bibtex-completion-bibliography
  :config
  (set-bibtex-config)
  :general
  (tyrant-def "ab" 'ivy-bibtex))

(use-package helm-bibtex
  :after (helm)
  :defines bibtex-completion-bibliography
  :config
  (set-bibtex-config)
  :general
  (tyrant-def "ab" 'helm-bibtex))

(use-package pdf-tools
  :ensure t
 ;; :defer 5
  :config
  (pdf-tools-install)
  :general
  ;; (general-def 'normal pdf-view-mode-map
  ;;   "H"   'pdf-view-fit-page-to-window
  ;;   "W"   'pdf-view-fit-width-to-window
  ;;   "P"   'pdf-view-fit-page-to-window
  ;;   "j"   'pdf-view-next-line-or-next-page
  ;;   "k"   'pdf-view-previous-line-or-previous-page
  ;;   "gg"  'pdf-view-first-page
  ;;   "G"   'pdf-view-last-page
  ;;   "C-d" 'pdf-view-scroll-up-or-next-page
  ;;   "C-f" 'pdf-view-scroll-up-or-next-page
  ;;   "C-b" 'pdf-view-scroll-down-or-previous-page
  ;;   )
  )

(defun doom/open-agenda (&optional arg)
  "Open org-agenda directly"
  (interactive "p")
  (org-agenda arg "a"))

(defun doom/open-diary ()
  "Open org-agenda directly"
  (interactive)
  (find-file "~/Documents/Org/diary.org"))

(defun doom/open-gtd ()
  "Open org-agenda directly"
  (interactive)
  (find-file "~/Documents/Org/gtd.org"))

(defun doom/open-mybibs ()
  "Open org-agenda directly"
  (interactive)
  (find-file "~/Documents/5-Papers/master.bib"))

(defun doom/open-research ()
  "Open org-agenda directly"
  (interactive)
  (find-file "~/Documents/4-Notes/3-Research/research.org"))

(require 'general)
(general-define-key
 "M-x" 'helm-M-x)
(general-def 'normal
 "<f6>" 'helm-bibtex
 "<f7>" #'doom/open-diary
 "<f8>" #'doom/open-gtd
 "<f9>" #'doom/open-agenda
 "<f10>" 'my/copy-idlink-to-clipboard)

;;(global-set-key)

(eval-when-compile
(setq-default custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
(load custom-file)))

(eval-and-compile
(add-hook 'emacs-startup-hook '(lambda ()
                (setq gc-cons-threshold 16777216 gc-cons-percentage 0.1
                        file-name-handler-alist temp--file-name-handler-alist))))
(setq initial-buffer-choice 'about-emacs)
(setq initial-scratch-message (concat "Startup time: " (emacs-init-time)))
