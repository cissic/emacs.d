;; ____________________________________________________________________________78
;; init.el
;; The full description of what is done in this file is included in 
;; accompanying .org file (configuring-and-installing-emacs.org).

(require 'package)
(package-initialize)

(setq custom-file "~/.emacs.d/custom-file.el")

(load-file custom-file)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; *** Global emacs customization
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(auto-revert-mode 1)       ; Automatically reload file from a disk after change
(global-auto-revert-mode 1) 

(delete-selection-mode 1)  ; Replace selected text

(show-paren-mode 1)        ; Highlight matching parenthesis

(global-linum-mode 1)      ; Enable line numbering

(scroll-bar-mode 1)        ; Enable scrollbar
(menu-bar-mode 1)          ; Enable menubar
(tool-bar-mode -1)         ; Disable toolbar since it's rather useless

(setq line-number-mode t)  ; Show line number

(setq column-number-mode t); Show column number

(define-key global-map (kbd "RET") 'newline-and-indent) ; Auto-indent new lines

(desktop-save-mode 1)      ; Save windows layout on closing
(setq desktop-load-locked-desktop t) ; and don't ask for confirmation when 
			   ; opening locked desktop
(setq desktop-save t)

(save-place-mode t)        ; When re-entering a file, return to the place, 
			   ; where I was when I left it the last time.

(savehist-mode 1)          ; Save history for future sessions

(winner-mode 1)            ; Toggle between previous window layouts

(global-visual-line-mode t) ; Truncate lines

;; Do not deselect after M-w copying -> 
 (defadvice kill-ring-save (after keep-transient-mark-active ())
   "Override the deactivation of the mark."
   (setq deactivate-mark nil))
 (ad-activate 'kill-ring-save)
;; <- Do not deselect after M-w copying

(set-frame-font "liberation mono 11" nil t) ; Set default font

;;Highlight an active window/buffer or dim all other windows
  
  (defun highlight-selected-window ()
    "Highlight selected window with a different background color."
    (walk-windows (lambda (w)
      (unless (eq w (selected-window)) 
	(with-current-buffer (window-buffer w)
	  (buffer-face-set '(:background "#111"))))))
    (buffer-face-set 'default))
  
    (add-hook 'buffer-list-update-hook 'highlight-selected-window)
;;

(setq system-time-locale "C")         ; Force Emacs to use English timestamps

;; Calendar ->
(defun calendar-insert-date ()
  "Capture the date at point, exit the Calendar, insert the date."
  (interactive)
  (seq-let (month day year) (save-match-data (calendar-cursor-to-date))
    (calendar-exit)
    (insert (format "%d-%02d-%02d" year month day))))

(eval-after-load "calendar"
  `(progn
     (define-key calendar-mode-map (kbd "RET") 'calendar-insert-date)))
;; <- Calendar

;; windmove ->
;; Easy moving between windows
  
  ;; setting windmove-default-keybindings to super-<arrow> in order
  ;; to avoid org-mode conflicts
  (global-set-key (kbd "s-<left>")  'windmove-left)
  (global-set-key (kbd "s-<right>") 'windmove-right)
  (global-set-key (kbd "s-<up>")    'windmove-up)
  (global-set-key (kbd "s-<down>")  'windmove-down)
;; <- windmove

;; Easy windows resize ->
  (define-key global-map (kbd "C-s-<left>") 'shrink-window-horizontally)
  (global-set-key        (kbd "C-s-<right>") 'enlarge-window-horizontally)
  (global-set-key        (kbd "C-s-<down>") 'shrink-window)
  (global-set-key        (kbd "C-s-<up>") 'enlarge-window)
;; <- Easy windows resize

;; Fill column indicator -> 
(require 'fill-column-indicator)
(setq fci-rule-column 81)
; (add-hook 'after-change-major-mode-hook 'fci-mode)
(define-globalized-minor-mode global-fci-mode fci-mode (lambda () (fci-mode 1)))
(global-fci-mode 1)
;; <- Fill column indicator

;; ido-mode ->
  (ido-mode 1)          
  (setq ido-enable-flex-matching t)
  (setq ido-everywhere t)  ; ido-mode for file searching
;; <- ido-mode

;; smex ->
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;; This is your old M-x.
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command) 
;; <- smex

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; *** Ivy
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (setq ivy-wrap t)
;; (setq ivy-height 8)
;; (setq ivy-display-style 'fancy)
;; (setq ivy-use-virtual-buffers t)
;; (setq ivy-case-fold-search-default t)
;; (setq ivy-re-builders-alist '((t . ivy--regex-ignore-order)))
;; (setq enable-recursive-minibuffers t)
;; (ivy-mode t)
