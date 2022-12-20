;;; install-mb-packages.el

;;; Commentary:

;; Comment out if you've already loaded this package...
(require 'cl-lib)
(require 'package)
(require 'use-package)

(package-initialize)

;;(when (not package-archive-contents)
;;(package-refresh-contents)
(package-refresh-contents)

(setq package-check-signature nil) 

;;first, declare repositories
(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")
        ; ("marmalade" . "http://marmalade-repo.org/packages/")
        ("melpa" . "https://melpa.org/packages/")
	("melpa-stable" . "http://stable.melpa.org/packages/")
	; ("org" . "https://orgmode.org/elpa/")    ;;; removed as a way of dealing with https://emacs.stackexchange.com/questions/70081/how-to-deal-with-this-message-important-please-install-org-from-gnu-elpa-as-o
	))

;; (add-to-list 'package-archives
;;          '("melpa-stable" . "http://stable.melpa.org/packages/"))
;; (add-to-list 'package-archives
;;          '("melpa" . "http://melpa.org/packages/"))


;;; https://thoughtbot.com/blog/emacs-as-a-python-ide -> projectile auto-complete epc jedi

(defvar my-packages
  '(; use-package
    auctex
    auto-complete    
    ac-math
    ac-octave    
    cdlatex
    dockerfile-mode    
    elpy  
    embrace
    emms
    epc
    flycheck
    flycheck-pos-tip
    google-this
    ido
    ; jedi
    magit
    markdown-mode
    matlab-mode
    moe-theme ; https://github.com/kuanyui/moe-theme.el
    ;mh
    ;ob-async
    org
    org-ac
    org-download
    org-mime
    org-ref
    org-special-block-extras
    ox-gfm
    ox-pandoc
    ; ox-ipynb -> manual-download
    pandoc-mode
    pdf-tools
    projectile
    pyenv-mode
    pylint  ; zeby dzialal interpreter python'a po:  C-c C-c 
    recentf
    session-async
    shell-pop
    ; tramp  ; domyślnie jest zainstalowany w najnowszych emacsach?
    tao-theme ; https://github.com/11111000000/tao-theme-emacs
    treemacs
    workgroups
    w3m
    )
  "A list of packages to ensure are installed at launch.")

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



; (jedi:install-server)

