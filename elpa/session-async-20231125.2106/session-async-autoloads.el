;;; session-async-autoloads.el --- automatically extracted autoloads (do not edit)   -*- lexical-binding: t -*-
;; Generated by the `loaddefs-generate' function.

;; This file is part of GNU Emacs.

;;; Code:

(add-to-list 'load-path (or (and load-file-name (directory-file-name (file-name-directory load-file-name))) (car load-path)))



;;; Generated autoloads from session-async.el

(autoload 'session-async-new "session-async" "\
Create a new Emacs process ready to communicate through TCP.

Returned session is named as SESSION-NAME

Creates a server on random port, creates separate Emacs session who will connect
here (user-facing Emacs porcess).

(fn &optional (SESSION-NAME (session-async--create-unique-session-name)))")
(autoload 'session-async-start "session-async" "\
Like `async-start', execute REMOTE-SEXP in separate process.

The result will be passed to RECEIVE-FUNCTION, which defaults to `ignore'

If RUNNING-SESSION is not provided, will create a new one-shot session.

Returns nil.

(fn &optional (REMOTE-SEXP \\=`(lambda nil)) (RECEIVE-FUNCTION \\='ignore) RUNNING-SESSION)")
(autoload 'session-async-future "session-async" "\
Return an iterator for future value for running REMOTE-SEXP in separate proc.

Underneath calls `session-async-start' and returns an iterator that can be
`iter-next'-ed for its value, for which Emacs will block until value is
available.

If RUNNING-SESSION is not provided, will create a new one-shot session.

(fn &optional (REMOTE-SEXP \\=`(lambda nil)) RUNNING-SESSION)")
(autoload 'session-async-get-session-create "session-async" "\
Get a running session and create it if it's necessary.

SYM is the symbol the session is being used to handle the session.
SYM should be quoted (see `set' and `symbol-value').

SESSION-NAME is ignored if session is already running.

(fn SYM &key (SESSION-NAME (session-async--create-unique-session-name)))")
(register-definition-prefixes "session-async" '("session-async-"))

;;; End of scraped data

(provide 'session-async-autoloads)

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; no-native-compile: t
;; coding: utf-8-emacs-unix
;; End:

;;; session-async-autoloads.el ends here
