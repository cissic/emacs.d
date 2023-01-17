;; ____________________________________________________________________________78
;; install-mb-packages.el
;; The full description of what is done in this file is included in 
;; accompanying .org file (configuring-and-installing-emacs.org) that is
;; described here:
;; https://cissic.github.io/posts/configuring-and-installing-emacs/


;; Path to your Emacs directory:
(setq my-emacs-dir "~/.emacs.d/")
;;;; (let (my-emacs-dir "~/.emacs.d/"))

;; Make a git commit of your repository.
;; 
(let ((default-directory my-emacs-dir)) ; run command `git add -u` in the context of my-emacs-dir
  (shell-command "git add -u"))
(let ((default-directory my-emacs-dir)) ; run command `git commmit` in the context of my-emacs-dir
  (shell-command
   "git commit -m 'Precautionary commit before running install-mb-packages.el'"))

(when (< emacs-major-version 27)
  (package-initialize)) ;  set up the load-paths and autoloads for installed packages
(setq package-check-signature nil)

;;first, declare repositories
(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")  ;; default value of package-archives in Emacs 27.1
        ("melpa" . "https://melpa.org/packages/")
	("melpa-stable" . "http://stable.melpa.org/packages/")
	))

;; Refresh the repositories to have the newest versions of the packages
(package-refresh-contents)

(setq my-packages
  '(

; counsel ; for ivy
  company
  ;dockerfile-mode    
  ;flycheck
  ;flycheck-pos-tip
  flyspell
  ;; google-this
  ido
  ; ivy
  ; jedi
  magit
  markdown-mode
  ;matlab-mode 
  modus-themes ; theme by Protesilaos Stavrou
  ;moe-theme ; https://github.com/kuanyui/moe-theme.el
  ;mh
  ;ob-async
  org   ; ver. 9.3  built-in in Emacs 27.1; this install version 9.6 from melpa
  org-ac
  ;org-download
  ;org-mime
  ;org-ref
  org-special-block-extras
  ;ox-gfm
  ;ox-pandoc
  ; ox-ipynb -> manual-download
  ;pandoc-mode
  ;pdf-tools
  popup   ; for yasnippet
  ;projectile
  ;pyenv-mode
  ;Pylint  ; zeby dzialal interpreter python'a po:  C-c C-c 
  ;rebox2
  ;recentf
  ;session-async
  ;shell-pop
  smex
  ; tramp  ; ver. 2.4.2 built-in in Emacs 27.1
  ;tao-theme ; https://github.com/11111000000/tao-theme-emacs
  ;treemacs
  ;use-package
  workgroups2
  ;w3m
  yasnippet
  )
;; "A list of packages to be installed at Emacs launch."
)

(defun my-packages-installed-p ()
  (cl-loop for p in my-packages
           when (not (package-installed-p p)) do (cl-return nil)
           finally (cl-return t)))

(unless (my-packages-installed-p)
  ;; check for new packages (package versions)
  (package-refresh-contents)
  ;; install the missing packages
  (dolist (p my-packages)
    (when (not (package-installed-p p))
      (package-install p))))

;; ; (jedi:install-server)

(message "All done in install-packages.")
