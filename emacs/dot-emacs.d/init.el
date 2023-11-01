(defvar m2/default-font-size 140)
(defvar m2/default-variable-font-size 160)
(defvar m2/frame-transparency '(100 . 100))
(setq lsp-use-plists t)
(setenv "LSP_USE_PLISTS" "1")

(setq gc-cons-threshold (* 50 1000 1000))

(defun m2/display-startup-time ()
  (message "Emacs loaded in %s with %d garbage collections."
           (format "%.2f seconds"
                   (float-time
                    (time-subtract after-init-time before-init-time)))
           gcs-done))

(add-hook 'emacs-startup-hook #'m2/display-startup-time)

(defvar elpaca-installer-version 0.5)
(defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-repos-directory (expand-file-name "repos/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
                              :ref nil
                              :files (:defaults (:exclude "extensions"))
                              :build (:not elpaca--activate-package)))
(let* ((repo  (expand-file-name "elpaca/" elpaca-repos-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (when (< emacs-major-version 28) (require 'subr-x))
    (condition-case-unless-debug err
        (if-let ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
                 ((zerop (call-process "git" nil buffer t "clone"
                                       (plist-get order :repo) repo)))
                 ((zerop (call-process "git" nil buffer t "checkout"
                                       (or (plist-get order :ref) "--"))))
                 (emacs (concat invocation-directory invocation-name))
                 ((zerop (call-process emacs nil buffer nil "-Q" "-L" "." "--batch"
                                       "--eval" "(byte-recompile-directory \".\" 0 'force)")))
                 ((require 'elpaca))
                 ((elpaca-generate-autoloads "elpaca" repo)))
            (progn (message "%s" (buffer-string)) (kill-buffer buffer))
          (error "%s" (with-current-buffer buffer (buffer-string))))
      ((error) (warn "%s" err) (delete-directory repo 'recursive))))
  (unless (require 'elpaca-autoloads nil t)
    (require 'elpaca)
    (elpaca-generate-autoloads "elpaca" repo)
    (load "./elpaca-autoloads")))
(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))

;; Install use-package support
(elpaca elpaca-use-package
  ;; Enable :elpaca use-package keyword.
  (elpaca-use-package-mode)
  ;; Assume :elpaca t unless otherwise specified.
  (setq elpaca-use-package-by-default t))

;; Block until current queue processed.
(elpaca-wait)

(setq custom-file (concat user-emacs-directory "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))

(use-package general
  :demand t
  :config
  (general-create-definer m2/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (m2/leader-keys
    "b" '(:ignore t :wk "Buffers")
    "b b" '(consult-buffer :wk "Ibuffer")
    "b B" '(ibuffer-list-buffers :wk "Ibuffer list buffers")
    "b n" '(next-buffer :wk "Next Buffer")
    "b p" '(previous-buffer :wk "Previous Buffer")
    "b K" '(kill-buffer :wk "Kill Buffer")
    "b d" '(evil-delete-buffer :wk "Delete Buffer"))

  (m2/leader-keys
    "f" '(:ignore t :wk "Files")
    "f c" '((lambda () (interactive)
              (find-file (concat (expand-file-name user-emacs-directory) "config.org")))
            :wk "Open Emacs config.org")
    "f e" '((lambda () (interactive)
              (dired user-emacs-directory))
            :wk "Open user-emacs-directory in Dired")
    "f f" '(find-file :wk "Find Files")
    "f r" '(recentf :wk "Find Recent Files")
    "f g" '(consult-ripgrep :wk "Grep")
    "d" '(dired :wk "Dired")
    "e" '(treemacs :wk "Treemacs"))

  (m2/leader-keys
    "h" '(:ignore t :wk "Helpful")
    "h h" '(helpful-at-point :wk "Helpful Here")
    "h f" '(helpful-callable :wk "Helpful Callable")
    "h v" '(helpful-variable :wk "Helpful Variable")
    "h k" '(helpful-key :wk "Helpful Key")
    "h c" '(helpful-command :wk "Helpful Command"))

  (m2/leader-keys
    "c" '(:ignore t :wk "Code")
    "c ." '(lsp-describe-thing-at-point :wk "Describe")
    "c a" '(lsp-execute-code-action :wk "Rename")
    "c f" '(lsp-format-buffer :wk "Format Buffer")
    "c d" '(dap-hydra t :wk "debugger")
    "c r" '(lsp-rename :wk "Rename"))

  (m2/leader-keys
    "g" '(:ignore t :wk "Git")
    "g /" '(magit-dispatch :wk "Magit Dispatch")
    "g ." '(magit-file-dispatch :wk "Magit File Dispatch")
    "g b" '(magit-branch-checkout :wk "Switch Branch")
    "g c" '(:ignore t :wk "Create")
    "g c b" '(magit-branch-and-checkout :wk "Create Branch and Checkout")
    "g c c" '(magit-commit-create :wk "Create Commit")
    "g c f" '(magit-commit-fixup :wk "Create Fixup Commit")
    "g C" '(magit-clone :wk "Clone Repo")
    "g f" '(:ignore t :wk "Find")
    "g f c" '(magit-show-commit :wk "Show commit")
    "g f f" '(magit-find-file :wk "Magit find file")
    "g f g" '(magit-find-git-config-file :wk "Find gitconfig file")
    "g F" '(magit-fetch :wk "Git fetch")
    "g g" '(magit-status :wk "Magit status")
    "g i" '(magit-init :wk "Initialize git repo")
    "g l" '(magit-log-buffer-file :wk "Magit buffer log")
    "g r" '(vc-revert :wk "Git revert file")
    "g s" '(magit-stage-file :wk "Git stage file")
    "g u" '(magit-stage-file :wk "Git unstage file"))

  (m2/leader-keys
    "t" '(:ignore t :wk "Terminals")
    "t e" '(eshell-toggle :wk "Toggle Eshell")
    "t v" '(vterm :wk "Create Vterm Terminal")
    "t t" '(eat :wk "Create Eat Terminal"))
  )

(elpaca-wait)

(setq inhibit-startup-message t)

(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)
(menu-bar-mode -1)
(scroll-bar-mode -1)

(setq visible-bell t)

(global-tab-line-mode t)
(global-visual-line-mode t)

(set-frame-parameter (selected-frame) 'alpha m2/frame-transparency)
(add-to-list 'default-frame-alist `(alpha . ,m2/frame-transparency))
(set-frame-parameter (selected-frame) 'fullscreen 'maximized)
(add-to-list 'default-frame-alist '(fullscreen . maximized))

(use-package rainbow-delimiters
  :hook ((prog-mode . rainbow-delimiters-mode)))

(set-face-attribute 'default nil
                    :font "CaskaydiaCove Nerd Font" :height m2/default-font-size)

(set-face-attribute 'fixed-pitch nil
                    :font "CaskaydiaCove Nerd Font" :height m2/default-font-size)

(set-face-attribute 'variable-pitch nil
                    :font "Cantarell" :height m2/default-variable-font-size
                    :weight 'regular)

(use-package ligature
  :config
  ;; Enable the "www" ligature in every possible major mode
  (ligature-set-ligatures 't '("www"))
  ;; Enable traditional ligature support in eww-mode, if the
  ;; `variable-pitch' face supports it
  (ligature-set-ligatures 'eww-mode '("ff" "fi" "ffi"))
  ;; Enable all Cascadia and Fira Code ligatures in programming modes
  (ligature-set-ligatures 'prog-mode
                          '(;; == === ==== => =| =>>=>=|=>==>> ==< =/=//=// =~
                            ;; =:= =!=
                            ("=" (rx (+ (or ">" "<" "|" "/" "~" ":" "!" "="))))
                            ;; ;; ;;;
                            (";" (rx (+ ";")))
                            ;; && &&&
                            ("&" (rx (+ "&")))
                            ;; !! !!! !. !: !!. != !== !~
                            ("!" (rx (+ (or "=" "!" "\." ":" "~"))))
                            ;; ?? ??? ?:  ?=  ?.
                            ("?" (rx (or ":" "=" "\." (+ "?"))))
                            ;; %% %%%
                            ("%" (rx (+ "%")))
                            ;; |> ||> |||> ||||> |] |} || ||| |-> ||-||
                            ;; |->>-||-<<-| |- |== ||=||
                            ;; |==>>==<<==<=>==//==/=!==:===>
                            ("|" (rx (+ (or ">" "<" "|" "/" ":" "!" "}" "\]"
                                            "-" "=" ))))
                            ;; \\ \\\ \/
                            ("\\" (rx (or "/" (+ "\\"))))
                            ;; ++ +++ ++++ +>
                            ("+" (rx (or ">" (+ "+"))))
                            ;; :: ::: :::: :> :< := :// ::=
                            (":" (rx (or ">" "<" "=" "//" ":=" (+ ":"))))
                            ;; // /// //// /\ /* /> /===:===!=//===>>==>==/
                            ("/" (rx (+ (or ">"  "<" "|" "/" "\\" "\*" ":" "!"
                                            "="))))
                            ;; .. ... .... .= .- .? ..= ..<
                            ("\." (rx (or "=" "-" "\?" "\.=" "\.<" (+ "\."))))
                            ;; -- --- ---- -~ -> ->> -| -|->-->>->--<<-|
                            ("-" (rx (+ (or ">" "<" "|" "~" "-"))))
                            ;; *> */ *)  ** *** ****
                            ("*" (rx (or ">" "/" ")" (+ "*"))))
                            ;; www wwww
                            ("w" (rx (+ "w")))
                            ;; <> <!-- <|> <: <~ <~> <~~ <+ <* <$ </  <+> <*>
                            ;; <<-> <= <=> <<==<<==>=|=>==/==//=!==:=>
                            ;; << <<< <<<<
                            ("<" (rx (+ (or "\+" "\*" "\$" "<" ">" ":" "~"  "!"
                                            "-"  "/" "|" "="))))
                            ;; >: >- >>- >--|-> >>-|-> >= >== >>== >=|=:=>>
                            ;; >> >>> >>>>
                            (">" (rx (+ (or ">" "<" "|" "/" ":" "=" "-"))))
                            ;; #: #= #! #( #? #[ #{ #_ #_( ## ### #####
                            ("#" (rx (or ":" "=" "!" "(" "\?" "\[" "{" "_(" "_"
                                         (+ "#"))))
                            ;; ~~ ~~~ ~=  ~-  ~@ ~> ~~>
                            ("~" (rx (or ">" "=" "-" "@" "~>" (+ "~"))))
                            ;; __ ___ ____ _|_ __|____|_
                            ("_" (rx (+ (or "_" "|"))))
                            ;; Fira code: 0xFF 0x12
                            ("0" (rx (and "x" (+ (in "A-F" "a-f" "0-9")))))
                            ;; Fira code:
                            "Fl"  "Tl"  "fi"  "fj"  "fl"  "ft"
                            ;; The few not covered by the regexps.
                            "{|"  "[|"  "]#"  "(*"  "}#"  "$>"  "^="))
  ;; Enables ligature checks globally in all buffers. You can also do it
  ;; per mode with `ligature-mode'.
  (global-ligature-mode t))

(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                pdf-view-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(add-hook 'prog-mode-hook (lambda () (setq display-line-numbers 'relative)))
(add-hook 'emacs-lisp-mode-hook (lambda () (setq display-line-numbers 'relative)))

(use-package all-the-icons)

(use-package all-the-icons-completion
  :after (marginalia all-the-icons)
  :hook (marginalia-mode . all-the-icons-completion-marginalia-setup)
  :init
  (all-the-icons-completion-mode))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  (setq evil-want-Y-yank-to-eol t)
  (setq evil-split-window-below t)
  (setq evil-vsplit-window-right t)
  (setq evil-insert-state-message nil)
  (setq evil-replace-state-message nil)
  (setq evil-visual-state-message nil)
  (setq evil-undo-system 'undo-tree)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)
  (global-set-key (kbd "C-M-u") 'universal-argument)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)
  (evil-define-key '(normal motion) 'global
    (kbd "H") 'evil-prev-buffer
    (kbd "L") 'evil-next-buffer
    (kbd "C-S-H") 'evil-window-left
    (kbd "C-S-J") 'evil-window-down
    (kbd "C-S-K") 'evil-window-up
    (kbd "C-S-L") 'evil-window-right)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'eshell-mode 'emacs)
  (evil-set-initial-state 'eat-mode 'emacs)
  (evil-set-initial-state 'vterm-mode 'emacs)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package evil-commentary
  :after evil
  :config
  (evil-commentary-mode))

(use-package undo-tree
  :config
  (global-undo-tree-mode)
  (setq undo-tree-auto-save-history nil))

(use-package helpful
  :custom
  (describe-function-function #'helpful-callable)
  (describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . describe-variable)
  ([remap describe-key] . helpful-key))

(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  (load-theme 'doom-gruvbox t)
  (doom-themes-visual-bell-config))

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :config
  (setq doom-modeline-height 25
        doom-modeline-bar-width 5
        doom-modeline-persp-name t
        doom-modeline-persp-icon t))

(defun m2/configure-eshell ()
  (add-hook 'eshell-pre-command-hook 'eshell-save-some-history)
  (add-to-list 'eshell-output-filter-functions 'eshell-truncate-buffer)
  (evil-define-key '(normal insert visual) eshell-mode-map (kbd "C-r") 'consult-history)
  (evil-define-key '(normal insert visual) eshell-mode-map (kbd "<home>") 'eshell-bol)
  (evil-normalize-keymaps)
  (setq eshell-history-size 10000
        eshell-buffer-maximum-lines 10000
        eshell-hist-ignoredups t
        eshell-scroll-to-bottom-on-input t))

(use-package eshell
  :elpaca nil
  :hook ((eshell-first-time-mode . m2/configure-eshell)
         (eshell-first-time-mode . eat-eshell-mode)
         (eshell-first-time-mode . eat-eshell-visual-command-mode))
  :config
  (with-eval-after-load 'esh-opt
    (setq eshell-destroy-buffer-when-process-dies t))
  (eshell-git-prompt-use-theme 'powerline))

(use-package eshell-syntax-highlighting
  :after esh-mode
  :config
  (eshell-syntax-highlighting-global-mode +1))

(use-package eshell-git-prompt
  :after eshell)

(use-package eat
  :config
  (setq eat-kill-buffer-on-exit t)
  (defvar eat--prevent-use-package-config-recursion nil)
  (unless eat--prevent-use-package-config-recursion
    (unless eat--prevent-use-package-config-recursion t)
    (eat-reload))
  (makunbound 'eat--prevent-use-package-config-recursion)
  (setq eshell-visual-command '()))

(with-eval-after-load 'eshell
  (eat-eshell-mode +1)
  (eat-eshell-visual-command-mode +1))

(use-package eshell-toggle
  :custom
  (esheel-toggle-window-side 'below)
  (eshell-toggle-use-projectile-root t)
  (eshell-toggle-run-command nil)
  :bind
  ("C-|" . eshell-toggle))

(use-package vterm)

(use-package dired
  :elpaca nil
  :after evil-collection
  :commands (dired dired-jump)
  :bind (("C-x C-j" . dired-jump))
  :custom ((dired-listing-switches "-agho --group-directories-first"))
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
    "h" 'dired-single-up-directory
    "l" 'dired-single-buffer))

(use-package dired-single
  :commands (dired dired-jump))

(use-package dired-hide-dotfiles
  :hook (dired-mode . dired-hide-dotfiles-mode)
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
    "H" 'dired-hide-dotfiles-mode))

(defun m2/prog-mode-setup ()
  (setq-local completion-at-point-functions
              (list (cape-capf-super
                     #'cape-file
                     #'yasnippet-capf
                     #'cape-keyword))))

(use-package prog-mode
  :elpaca nil
  :after cape
  :hook (prog-mode . m2/prog-mode-setup))

(defun m2/lsp-mode-setup ()
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (setf (alist-get 'styles
                   (alist-get 'lsp-capf completion-category-defaults))
        '(orderless))
  (lsp-headerline-breadcrumb-mode)
  (setq-local completion-at-point-functions
              (list (cape-capf-super
                     #'cape-file
                     #'yasnippet-capf
                     #'lsp-completion-at-point))))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook ((lsp-mode . m2/lsp-mode-setup))
  :init
  (setq lsp-keymap-prefix "C-c l")
  (defun m2/orderless-dispatch-flex-first (_pattern index _total)
    (and (eq index 0) 'orderless-flex))
  (add-hook 'orderless-style-dispatchers #'m2/orderless-dispatch-flex-first nil 'local)
  (advice-add 'lsp-completion-at-point :around #'cape-wrap-buster)
  (advice-add 'cape-file :around #'cape-wrap-buster)
  :bind (:map lsp-mode-map
              ("C-c d" . lsp-describe-thing-at-point) 
              ("C-c a" . lsp-execute-code-action)
              ("C-c f" . lsp-format-buffer)
              ("C-c r" . lsp-rename))

  :config
  (with-eval-after-load 'lsp
    (setq completion-category-defaults nil))
  (setq lsp-log-io nil
        lsp-restart 'auto-restart
        lsp-signature-render-documentation t
        lsp-ui-sideline-enable t
        lsp-modeline-code-actions-enable t
        lsp-modeline-diagnostics-enable t
        lsp-enable-on-type-formatting t
        lsp-idle-delay 0.5
        lsp-completion-provider :none
        lsp-completion-enable nil
        lsp-enable-which-key-integration t))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :config (setq lsp-ui-doc-delay 0.2
                lsp-ui-doc-position 'top
                lsp-ui-doc-alignment 'frame
                lsp-ui-doc-header nil
                lsp-ui-doc-include-signature t
                lsp-ui-doc-use-childframe t
                lsp-ui-sideline-show-hover t
                lsp-ui-sideline-delay 0.5
                lsp-ui-sideline-ignore-duplicates t)
  :bind(:map evil-normal-state-map
             ("g d" . lsp-ui-peek-find-definitions)
             ("g r" . lsp-ui-peek-find-references)))

(setq treesit-language-source-alist
      '((bash "https://github.com/tree-sitter/tree-sitter-bash")
        (c "https://github.com/tree-sitter/tree-sitter-c")
        (cpp "https://github.com/tree-sitter/tree-sitter-cpp")
        (cmake "https://github.com/uyha/tree-sitter-cmake")
        (css "https://github.com/tree-sitter/tree-sitter-css")
        (dockerfile "https://github.com/camdencheek/tree-sitter-dockerfile")
        (elisp "https://github.com/Wilfred/tree-sitter-elisp")
        (go "https://github.com/tree-sitter/tree-sitter-go")
        (html "https://github.com/tree-sitter/tree-sitter-html")
        (javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")
        (json "https://github.com/tree-sitter/tree-sitter-json")
        (make "https://github.com/alemuller/tree-sitter-make")
        (markdown "https://github.com/ikatyang/tree-sitter-markdown")
        (python "https://github.com/tree-sitter/tree-sitter-python")
        (toml "https://github.com/tree-sitter/tree-sitter-toml")
        (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
        (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
        (yaml "https://github.com/ikatyang/tree-sitter-yaml")))

(unless (file-exists-p (concat user-emacs-directory "tree-sitter/libtree-sitter-c.so"))
  (mapc #'treesit-install-language-grammar (mapcar #'car treesit-language-source-alist)))

(setq major-mode-remap-alist
      '((bash-mode . bash-ts-mode)
        (c-mode . c-ts-mode)
        (json-mode . json-ts-mode)
        (yaml-mode . yaml-ts-mode)
        (python-mode . python-ts-mode)))

(use-package treemacs
  :commands (treemacs)
  :bind
  (:map global-map
        ("M-0" . treemacs-select-window)
        ("C-x t 1" . treemacs-delete-other-windows)
        ("C-x t t" . treemacs)
        ("C-x t d" . treemacs-select-directory)
        ("C-x t B" . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)))

(use-package treemacs-evil
  :after (treemacs evil))

(use-package treemacs-projectile
  :after (treemacs projectile))

(use-package treemacs-all-the-icons
  :after treemacs)

(use-package treemacs-tab-bar
  :after (treemacs)
  :config (treemacs-set-scope-type 'Tabs))

(use-package treemacs-icons-dired
  :hook (dired-mode . treemacs-icons-dired-enable-once))

(use-package lsp-treemacs
  :after treemacs
  :config
  (lsp-treemacs-sync-mode 1))

(use-package dap-mode
  :commands dap-debug)

(electric-pair-mode t)
(electric-indent-mode t)
(delete-selection-mode t)

(use-package flycheck
  :defer t
  :init (global-flycheck-mode))

(use-package python-mode
  :mode
  (("\\.py\\'" . python-ts-mode)))

(use-package pyvenv
  :after python-mode
  :config
  (pyvenv-mode 1))

(use-package lsp-pyright
  :ensure t
  :hook (python-ts-mode . (lambda ()
                            (require 'lsp-pyright)
                            (lsp-deferred))))  ; or lsp-deferred

(use-package ein
  :after org-mode)

(use-package julia-mode
  :hook
  ((julia-mode . lsp-deferred)))

(use-package lsp-julia
  :config
  (setq lsp-julia-default-environment "~/.julia/environments/v1.9"))

(use-package julia-snail
  :after vterm
  :bind
  (:map vterm-mode-map
        ("C-c C-o" . julia-snail-repl-go-back))
  (:map julia-snail-mode-map
        ("C-c C-o" . julia-snail))
  :hook
  (julia-mode . julia-snail-mode))

(use-package cc-mode
  :elpaca nil
  :hook ((c-ts-mode . lsp-deferred)
         (c-mode . lsp-deferred)))

(use-package bash-mode
  :elpaca nil
  :mode (("\\.bash\\'" . bash-ts-mode))
  :hook ((bash-ts-mode . lsp-deferred)))

(use-package shell-script-mode
  :elpaca nil
  :hook ((shell-script-mode . lsp-deferred)))

(defun m2/emacs-lisp-mode-setup ()
  (setq-local completion-at-point-functions
              (list (cape-capf-super
                     #'yasnippet-capf
                     #'cape-keyword
                     #'elisp-completion-at-point
                     #'cape-file))))

(use-package lisp-mode
  :elpaca nil
  :after cape
  :commands emacs-lisp-mode
  :hook ((after-save-hook . check-parens)
         (emacs-lisp-mode . m2/emacs-lisp-mode-setup)))

(use-package just-mode)
(use-package justl)

(use-package dockerfile-ts-mode
  :elpaca nil
  :hook (dockerfile-ts-mode . lsp-deferred)
  :mode (("Containerfile" . dockerfile-ts-mode)
         ("Dockerfile" . dockerfile-ts-mode)))

(use-package yaml-ts-mode
  :elpaca nil
  :mode
  (("\\.yml\\'" . yaml-ts-mode)
   ("\\.yaml\\'" . yaml-ts-mode)))

(use-package auctex
  :elpaca (auctex :pre-build (("./autogen.sh") ("./configure" "--without-texmf-dir" "--with-lispdir=.") ("make")))
  :mode
  ("\\.tex\\'" . TeX-latex-mode)
  :hook
  ((LaTeX-mode . lsp-deferred)
   (LaTeX-mode . (lambda ()
                   (push (list 'output-pdf "Zathura")
                         TeX-view-program-selection)))))

(use-package pdf-tools
  :defer t)

(use-package markdown-mode)

(use-package magit)

(use-package projectile
  :diminish
  :config (projectile-mode)
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :custom
  ((setq projectile-completion-system 'default))
  :init
  (when (file-directory-p "~/Projects")
    (setq projectile-project-search-path '("~/Projects")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package consult-projectile)

(use-package which-key
  :defer 0
  :diminish which-key-mode
  :config
  (setq which-key-prefix-prefix "◉ ")
  (setq which-key-idle-delay 1)
  (setq which-key-min-display-lines 3)
  (setq which-key-max-display-columns nil)
  (which-key-mode))

(use-package vertico
  :diminish
  :init (vertico-mode))

(use-package marginalia
  :diminish
  :after vertico
  :bind (:map minibuffer-local-map
              ("M-A" . marginalia-cycle))
  :init (marginalia-mode))

(use-package consult
  :after vertico
  ;; Replace bindings. Lazily loaded due by `use-package'.
  :bind (;; C-c bindings in `mode-specific-map'
         ("C-c M-x" . consult-mode-command)
         ("C-c h" . consult-history)
         ("C-c k" . consult-kmacro)
         ("C-c m" . consult-man)
         ("C-c i" . consult-info)
         ([remap Info-search] . consult-info)
         ;; C-x bindings in `ctl-x-map'
         ("C-x M-:" . consult-complex-command)
         ("C-x b" . consult-buffer)
         ("C-x 4 b" . consult-buffer-other-window)
         ("C-x 5 b" . consult-buffer-other-frame)
         ("C-x r b" . consult-bookmark)
         ("C-x p b" . consult-project-buffer)
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)
         ;; M-g bindings in `goto-map'
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flymake)
         ("M-g g" . consult-goto-line)
         ("M-g M-g" . consult-goto-line)
         ("M-g o" . consult-outline)
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings in `search-map'
         ("M-s d" . consult-find)
         ("M-s D" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)
         ("M-s e" . consult-isearch-history)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history)
         ("M-r" . consult-history))

  :hook (completion-list-mode . consult-preview-at-point-mode)
  :init
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format)
  (advice-add #'register-preview :override #'consult-register-window)
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)
  :config
  ;; (setq consult-preview-key 'any)
  (setq consult-preview-key "M-.")
  ;; (setq consult-preview-key '("S-<down>" "S-<up>"))
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   consult--source-bookmark consult--source-file-register
   consult--source-recent-file consult--source-project-recent-file
   ;; :preview-key "M-."
   :preview-key '(:debounce 0.4 any))
  (setq consult-narrow-key "<")
  (setq completion-in-region-function 'consult-completion-in-region))

(use-package embark
  :bind
  (("C-." . embark-act)
   ("C-;" . embark-dwim)
   ("C-h B" . embark-bindings))
  :init
  (setq prefix-help-command #'embark-prefix-help-command)
  (add-hook 'eldoc-documentation-functions #'embark-eldoc-first-target)
  :config
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

(use-package embark-consult
  :hook (embark-collect-mode . consult-preview-at-point-mode))

(use-package savehist
  :diminish
  :elpaca nil
  :init (savehist-mode))

(use-package orderless
  :diminish
  :init
  (setq completion-styles '(orderless partial-completion basic)
        completion-category-defaults nil
        completion-category-overrides nil))

(use-package corfu
  :demand t
  :init
  (global-corfu-mode)
  (setq corfu-popupinfo-delay 0.2)
  (corfu-popupinfo-mode)
  :bind (:map corfu-map
              ("C-n" . corfu-next)
              ("C-p" . corfu-previous)
              ("<" . corfu-insert-separator)
              ("C-j" . corfu-popupinfo-scroll-down)
              ("C-k" . corfu-popupinfo-scroll-up)
              ("M-d" . corfu-info-documentation)
              ("<escape>" . evil-collection-corfu-quit-and-escape))
  :config
  (setq corfu-auto-delay 0.1
        corfu-auto-prefix 1
        corfu-echo-documentation t
        corfu-cycle t
        corfu-auto t
        corfu-scroll-margin 0
        corfu-count 8
        corfu-max-width 50
        corfu-on-exact-match #'nil
        corfu-popupinfo-hide #'nil
        corfu-min-width corfu-max-width
        tab-always-indent 'complete)
  (corfu-history-mode))

(defun corfu-send-shell (&rest _)
  "Send completion candidate when inside comint/eshell."
  (cond
   ((and (derived-mode-p 'eshell-mode) (fboundp 'eshell-send-input))
    (eshell-send-input))
   ((and (derived-mode-p 'comint-mode)  (fboundp 'comint-send-input))
    (comint-send-input))))

(advice-add #'corfu-insert :after #'corfu-send-shell)

(use-package cape
  :config
  (setq cape-dabbrev-check-other-buffers nil
        cape-dabbrev-min-length 6))

(use-package yasnippet-capf
  :after cape)

(use-package kind-icon
  :after corfu
  :config
  (setq kind-icon-default-face 'corfu-default)
  (setq kind-icon-default-style '(:padding 0 :stroke 0 :margin 0 :radius 0 :height 0.9 :scale 1))
  (setq kind-icon-blend-frac 0.08)
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter)
  (add-hook 'counsel-load-theme #'(lambda () (interactive) (kind-icon-reset-cache)))
  (add-hook 'load-theme         #'(lambda () (interactive) (kind-icon-reset-cache))))

(defun corfu-enable-always-in-minibuffer ()
  "Enable Corfu in the minibuffer if Vertico/Mct are not active."
  (unless (or (bound-and-true-p mct--active)
              (bound-and-true-p vertico--input)
              (eq (current-local-map) read-passwd-map))
    ;; (setq-local corfu-auto nil) ;; Enable/disable auto completion
    (setq-local corfu-echo-delay nil ;; Disable automatic echo and popup
                corfu-popupinfo-delay nil)
    (corfu-mode 1)))
(add-hook 'minibuffer-setup-hook #'corfu-enable-always-in-minibuffer 1)

(use-package yasnippet
  :init (yas-global-mode 1))

(use-package yasnippet-snippets)

(use-package company)

(use-package company-org-block
  :custom
  (company-org-block-edit-style 'auto))

(defun m2/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (visual-line-mode 1)
  (setq-local completion-at-point-functions
              (list (cape-capf-super
                     (cape-company-to-capf #'company-org-block)
                     #'cape-elisp-block
                     #'yasnippet-capf
                     #'cape-file
                     #'cape-dabbrev))))

(defun m2/org-font-setup ()
  ;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

  ;; Set faces for heading levels
  (dolist (face '((org-level-1 . 1.4)
                  (org-level-2 . 1.2)
                  (org-level-3 . 1.1)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "Cantarell" :weight 'regular :height (cdr face)))

  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil    :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-table nil    :inherit 'fixed-pitch)
  (set-face-attribute 'org-formula nil  :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil     :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil    :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil  :inherit 'fixed-pitch)
  (set-face-attribute 'line-number nil :inherit 'fixed-pitch)
  (set-face-attribute 'line-number-current-line nil :inherit 'fixed-pitch))

(use-package org
  :elpaca nil
  :commands (org-capture org-agenda)
  :hook ((org-mode . m2/org-mode-setup))
  :config
  (m2/org-font-setup)
  (setq org-edit-src-content-indentation 2
        org-return-follows-link t
        org-agenda-start-with-log-mode t
        org-log-done 'time
        org-log-into-drawer t
        org-startup-folded t
        org-ellipsis " ▾"))

(use-package org-bullets
  :diminish
  :hook (org-mode . org-bullets-mode))

(defun m2/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . m2/org-mode-visual-fill))

(with-eval-after-load 'org
  ;; This is needed as of Org 9.2
  (require 'org-tempo)

  (add-to-list 'org-structure-template-alist '("sh" . "src shell"))
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
  (add-to-list 'org-structure-template-alist '("py" . "src python :results output raw")))

(add-hook 'org-mode-hook (lambda ()
                           (setq-local electric-pair-inhibit-predicate
                                       `(lambda (c)
                                          (if (char-equal c ?<) t (,electric-pair-inhibit-predicate c))))))

(with-eval-after-load 'org
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (python . t)))

  (push '("conf-unix" . conf-unix) org-src-lang-modes))

(defun org-babel-edit-prep:python (babel-info)
  ;; (setq-local default-directory (->> babel-info caddr (alist-get :dir)))
  (setq-local buffer-file-name (->> babel-info caddr (alist-get :tangle)))
  (lsp))

(defun m2/org-present-prepare-slide ()
  (org-overview)
  (org-show-entry)
  (org-show-children))

(defun m2/org-present-hook ()
  (setq-local face-remapping-alist '((default (:height 1.5) variable-pitch)
                                     (header-line (:height 4.5) variable-pitch)
                                     (org-document-title (:height 1.75) org-document-title)
                                     (org-code (:height 1.55) org-code)
                                     (org-verbatim (:height 1.55) org-verbatim)
                                     (org-block (:height 1.25) org-block)
                                     (org-block-begin-line (:height 0.7) org-block)))
  (setq header-line-format " ")
  (org-appear-mode -1)
  (org-display-inline-images)
  (m2/org-present-prepare-slide))

(defun m2/org-present-quit-hook ()
  (setq-local face-remapping-alist '((default variable-pitch default)))
  (setq header-line-format nil)
  (org-present-small)
  (org-remove-inline-images)
  (org-appear-mode 1))

(defun m2/org-present-prev ()
  (interactive)
  (org-present-prev)
  (m2/org-present-prepare-slide))

(defun m2/org-present-next ()
  (interactive)
  (org-present-next)
  (m2/org-present-prepare-slide))

(use-package org-present
  :after org
  :bind (:map org-present-mode-keymap
              ("C-c C-j" . m2/org-present-next)
              ("C-c C-k" . m2/org-present-prev))
  :hook
  ((org-present . m2/org-present-hook)
   (org-present-quit . m2/org-present-quit-hook)))

(use-package hydra
  :defer t
  :general
  (m2/leader-keys
    "w" '(hydra-window/body :wk "Window Mangement")
    "+" '(hydra-text-scale/body :wk "Scale Text"))
  :config
  (defhydra hydra-text-scale (:timeout 4)
    "scale-text"
    ("j" text-scale-increase "in")
    ("k" text-scale-decrease "out")
    ("f" nil "finished" :exit t))

  (defhydra hydra-window (:hint nil)
    "
Movement      ^Split^            ^Switch^        ^Resize^
----------------------------------------------------------------
_h_  <          _/_ vertical      _b_uffer        _<left>_  <
_l_  >          _-_ horizontal    _f_ind file     _<down>_  ↓
_k_  ↑          _m_aximize        _s_wap          _<up>_    ↑
_j_  ↓          _c_lose           _[_backward     _<right>_ >
_q_uit          _e_qualize        _]_forward     ^
^               _F_rame           _K_ill         ^
^               ^                  ^             ^
"
    ;; Movement
    ("h" windmove-left)
    ("j" windmove-down)
    ("k" windmove-up)
    ("l" windmove-right)

    ;; Split/manage
    ("-" evil-window-split)
    ("/" evil-window-vsplit)
    ("c" evil-window-delete)
    ("d" evil-window-delete)
    ("m" delete-other-windows)
    ("e" balance-windows)
    ("F" consult-buffer-other-frame)

    ;; Switch
    ("b" consult-buffer)
    ("f" consult-find-file)
    ("P" consult-project-find-file)
    ("s" ace-swap-window)
    ("[" previous-buffer)
    ("]" next-buffer)
    ("K" kill-this-buffer)

    ;; Resize
    ("<left>" windresize-left)
    ("<right>" windresize-right)
    ("<down>" windresize-down)
    ("<up>" windresize-up)

    ("q" nil)))

(use-package tramp
  :elpaca nil
  :config
  (if (file-exists-p "/run/.containerenv") 
    (push
     (cons
      "distrobox"
      '((tramp-login-program "distrobox-host-exec distrobox")
        (tramp-login-args (("enter -nw") ("%h")))
        (tramp-remote-shell "/bin/sh")
        (tramp-remote-shell-login ("-l"))
        (tramp-remote-shell-args ("-i" "-c"))))
     tramp-methods)
    (push
     (cons
      "distrobox"
      '((tramp-login-program "distrobox")
        (tramp-login-args (("enter -nw") ("%h")))
        (tramp-remote-shell "/bin/sh")
        (tramp-remote-shell-login ("-l"))
        (tramp-remote-shell-args ("-i" "-c"))))
     tramp-methods)))

(use-package toolbox-tramp
  :elpaca (toolbox-tramp :type git
                         :host github
                         :repo "fejfighter/toolbox-tramp"))

(use-package super-save
  :diminish super-save-mode
  :defer 2
  :config
  (setq super-save-auto-save-when-idle t
	super-save-idle-duration 5
	super-save-triggers
	'(evil-window-next evil-window-prev balance-windows other-window next-buffer previous-buffer)
	super-save-max-buffer-size 10000000)
  (super-save-mode +1))

(defun m2/clear-echo-area-timer ()
  (run-at-time "2 sec" nil (lambda () (message " "))))
(advice-add 'super-save-command :after 'm2/clear-echo-area-timer)

;; Make gc pauses faster by decreasing the threshold.
(setq gc-cons-threshold (* 2 1024 1024))
(setq read-process-output-max (* 1024 1024))
