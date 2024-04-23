;;; org-special-block-extras-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "org-special-block-extras" "org-special-block-extras.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from org-special-block-extras.el

(autoload 'org-special-block-extras-mode "org-special-block-extras" "\
Provide 30 new custom blocks & 34 link types for Org-mode.

If called interactively, enable Org-Special-Block-Extras mode if
ARG is positive, and disable it if ARG is zero or negative.  If
called from Lisp, also enable the mode if ARG is omitted or nil,
and toggle it if ARG is `toggle'; disable the mode otherwise.

All relevant Lisp functions are prefixed ‘org-’; e.g., `org-docs-insert'.

\(fn &optional ARG)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "org-special-block-extras" '("o-thread-blockcall" "org-")))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; org-special-block-extras-autoloads.el ends here
