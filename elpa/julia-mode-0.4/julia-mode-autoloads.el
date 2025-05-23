;;; julia-mode-autoloads.el --- automatically extracted autoloads (do not edit)   -*- lexical-binding: t -*-
;; Generated by the `loaddefs-generate' function.

;; This file is part of GNU Emacs.

;;; Code:

(add-to-list 'load-path (or (and load-file-name (directory-file-name (file-name-directory load-file-name))) (car load-path)))



;;; Generated autoloads from julia-mode.el

(add-to-list 'auto-mode-alist '("\\.jl\\'" . julia-mode))
(autoload 'julia-mode "julia-mode" "\
Major mode for editing julia code.

(fn)" t)
(autoload 'inferior-julia "julia-mode" "\
Run an inferior instance of `julia' inside Emacs." t)
(defalias 'run-julia #'inferior-julia "\
Run an inferior instance of `julia' inside Emacs.")
(register-definition-prefixes "julia-mode" '("inferior-julia-" "julia-" "latexsub"))

;;; End of scraped data

(provide 'julia-mode-autoloads)

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; no-native-compile: t
;; coding: utf-8-emacs-unix
;; End:

;;; julia-mode-autoloads.el ends here
