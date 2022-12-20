 
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#2e3436" "#a40000" "#4e9a06" "#c4a000" "#204a87" "#5c3566" "#729fcf" "#eeeeec"])
 '(custom-enabled-themes nil)
 '(matlab-shell-command-switches '("-nodesktop -nosplash"))
 '(org-agenda-files '("~/org/!TODO.org"))
 '(org-export-backends '(ascii html icalendar latex md odt))
 '(package-selected-packages
   '(tao-theme moe-theme session-async ox-beamer org-special-block-extras ox org-download ox-ipynb ox-pandoc pandoc-mode ox-gfm org-ref org-publish sunrise lisp-nc w3m sane-term matlab-emacs mh pdf-tools workgroups use-package treemacs-projectile treemacs-persp treemacs-magit treemacs-icons-dired treemacs-evil shell-pop pylint pyenv-mode org-mime org-ac org matlab-mode markdown-mode jedi google-this flycheck-pos-tip emms embrace elpy dockerfile-mode cdlatex bongo auctex ac-octave ac-math))
 '(safe-local-variable-values
   '((eval add-hook 'org-export-before-processing-hook #'my/org-export-markdown-hook-function nil t)
     (org-beamer-outline-frame-title . "Spis treści")))
 '(send-mail-function 'mailclient-send-it)
 '(tramp-default-user "marbor"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(menu ((t (:background "red"))))
 '(term-color-blue ((t (:background "blue2" :foreground "royal blue")))))
