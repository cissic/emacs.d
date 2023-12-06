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

; Enable line numbering
;; DEPRECATED, CAUSES LAGS WHEN TYPING: (global-linum-mode 1)			
(global-display-line-numbers-mode 1) 

(scroll-bar-mode 1)        ; Enable scrollbar
(menu-bar-mode 1)          ; Enable menubar
(tool-bar-mode -1)         ; Disable toolbar since it's rather useless

(setq line-number-mode t)  ; Show line number

(setq column-number-mode t); Show column number

(define-key global-map (kbd "RET") 'newline-and-indent) ; Auto-indent new lines

(if (not (daemonp))           ; if this is not a --daemon session -> see: [[emacs-everywhere]] section
   (desktop-save-mode 1)      ; Save buffers on closing and restore them at startup
)
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

;; now this setting is done much lower in the code due to
;; problems with fonts in  emacsclient/daemonp instances -> see [[emacs-everywhere]]
;; (set-frame-font "liberation mono 11" nil t) ; Set default font

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
(setq display-fill-column-indicator-column 81)

(defun my-default-text-buffer-settings-mode-hook()
  (display-fill-column-indicator-mode 1)
  )
  ;; <- Fill column indicator

;; Setting alarms in Emacs -> 
(setq-default visible-bell t) 
(setq ring-bell-function 'ignore)

;; Advanced buffer mode
(global-set-key (kbd "C-x C-b") 'ibuffer)

;; Resize the whole frame, and not only a window
;; Adapted from https://stackoverflow.com/a/24714383/5103881
(defun acg/zoom-frame (&optional amt frame)
  "Increaze FRAME font size by amount AMT. Defaults to selected
frame if FRAME is nil, and to 1 if AMT is nil."
  (interactive "p")
  (let* ((frame (or frame (selected-frame)))
         (font (face-attribute 'default :font frame))
         (size (font-get font :size))
         (amt (or amt 1))
         (new-size (+ size amt)))
    (set-frame-font (font-spec :size new-size) t `(,frame))
    (message "Frame's font new size: %d" new-size)))

(defun acg/zoom-frame-out (&optional amt frame)
  "Call `acg/zoom-frame' with negative argument."
  (interactive "p")
  (acg/zoom-frame (- (or amt 1)) frame))

(global-set-key (kbd "C-x C-=") 'acg/zoom-frame)
(global-set-key (kbd "C-x C--") 'acg/zoom-frame-out)
(global-set-key (kbd "<C-down-mouse-4>") 'acg/zoom-frame)
(global-set-key (kbd "<C-down-mouse-5>") 'acg/zoom-frame-out)

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

;; ;; abbrev-mode ->
;;   (setq-default abbrev-mode t)          
;;   ; (read-abbrev-file "~/.emacs.d/abbrev_defs")
;;   (read-abbrev-file "~/.emacs.d/abbrev_defs_autocorrectionEN")
;;   (read-abbrev-file "~/.emacs.d/abbrev_defs_autocorrectionPL")  
;;   (read-abbrev-file "~/.emacs.d/abbrev_defs_cis")  
;;   (setq save-abbrevs t)  
;; ;; <- abbrev-mode

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; *** Auto-completing
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-hook 'after-init-hook 'global-company-mode)

;; Recently opened files ->
  (recentf-mode 1)
  (setq recentf-max-menu-items 100)
  (setq recentf-max-saved-items 100)
  ;; in original emacs this binding is for "Find file read-only"
  (global-set-key "\C-x\ \C-r" 'recentf-open-files)
;; <- Recently opened files

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; *** Minor mode settings and keybindings
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Emacs-Lisp mode...
(defun my-emacs-lisp-mode-hook ()
(define-key emacs-lisp-mode-map (kbd "C-e b") 'eval-buffer)
(define-key emacs-lisp-mode-map (kbd "C-e e") 'eval-expression)
(define-key emacs-lisp-mode-map (kbd "C-e r") 'eval-region)  
)

;; Octave mode...
(defun my-octave-mode-hook()
  (define-key octave-mode-map (kbd "C-c C-s") 'octave-send-buffer)
  (define-key octave-mode-map (kbd "<f8>") 'octave-send-buffer)
          (lambda ()
            (abbrev-mode 1)
            (auto-fill-mode 1)
            (if (eq window-system 'x)
                (font-lock-mode 1))))

; Matlab mode...
(defun my-matlab-mode-hook()
  (define-key matlab-mode-map (kbd "<f8>")
    '(lambda () (interactive)
      (matlab-shell-send-command "emacsrun('/home/mb/projects/TSdistributed/srcMTLB/main')" ))
     )
)

;; Python mode...

(defun my-python-mode-hook()
           (lambda ()
             (setq python-shell-interpreter "python3") ))

;; Org mode...
(setq org-export-in-background t)

(defun my-org-mode-hook()
  (define-key org-mode-map (kbd "<f9>")
    '(lambda () (interactive)
      (org-latex-export-to-pdf :async t)
      (org-beamer-export-to-pdf :async t)
      (org-odt-export-to-odt :async t)
      (org-odt-export-as-pdf :async t)
      )
     )  
)

(setq org-export-async-init-file (expand-file-name "~/.emacs.d/myarch/async_init.el"))
(setq org-export-async-debug nil) ;; when set to 't' it stores all "*Org Export Process*" buffers, when set to 'nil' it leaves only the last one in the buffer list, but already killed

;; Add all of the hooks...
;(add-hook 'c++-mode-hook 'my-c++-mode-hook)
;(add-hook 'c-mode-hook 'my-c-mode-hook)
(add-hook 'emacs-lisp-mode-hook 'my-emacs-lisp-mode-hook)
(add-hook 'octave-mode-hook 'my-octave-mode-hook)
(add-hook 'matlab-mode-hook 'my-matlab-mode-hook)
(add-hook 'python-mode-hook 'my-python-mode-hook)
(add-hook 'org-mode-hook 'my-org-mode-hook)

; (add-hook 'lisp-mode-hook 'my-lisp-mode-hook)
;(add-hook 'perl-mode-hook 'my-perl-mode-hook)

;; Add a hook to the list of modes
(defun my-add-to-multiple-hooks (function hooks)
  (mapc (lambda (hook)
	  (add-hook hook function))
	hooks))

(defun my-turn-on-auto-fill ()
    my-default-text-buffer-settings-mode-hook  )

(my-add-to-multiple-hooks
 'my-default-text-buffer-settings-mode-hook         ;; my-turn-on-auto-fill
 '(DocOnce-hook
   emacs-lisp-mode-hook
   matlab-mode-hook
   octave-mode-hook
   org-mode-hook
   python-mode-hook
 ))

;; Change font color for eww
(defun my-eww-mode-faces ()
  (face-remap-add-relative 'default '(:foreground "#BD8700")))

(add-hook 'eww-mode-hook 'my-eww-mode-faces)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; *** Org customization
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; customized todo-done sequence
(setq org-todo-keywords
  '(
(sequence "TODO" "????" "POSTPONED" "|" "DONE")
(sequence "TODO" "ABANDONED"  "|" "DEPRECATED" "DONE")
(sequence "TODO" "????" "ABANDONED" "POSTPONED" "|" "DEPRECATED" "DONE")
))

(setq org-todo-keyword-faces
'(
("????" . (:foreground "red" :weight bold))
("POSTPONED" . (:foreground "blue" :weight bold))
("ABANDONED" . (:foreground "orange" :weight bold))
("DEPRECATED" . (:foreground "green" :weight bold))
)
)

;; customized todo-done keywords in latex documents
(defun org-latex-format-headline-colored-keywords-function
    (todo _todo-type priority text tags _info)
  "Default format function for a headline.
See `org-latex-format-headline-function' for details."
  (concat
   ;; (and todo (format "{\\bfseries\\sffamily %s} " todo))
  (cond
   ((string= todo "TODO")(and todo (format "{\\color{red}\\bfseries\\sffamily %s} " todo)))
   ((string= todo "????")(and todo (format "{\\color{red}\\bfseries\\sffamily %s} " todo)))
   ((string= todo "POSTPONED")(and todo (format "{\\color{blue}\\bfseries\\sffamily %s} " todo)))
   ((string= todo "DONE")(and todo (format "{\\color{green}\\bfseries\\sffamily %s} " todo)))
   )
   (and priority (format "\\framebox{\\#%c} " priority))
   text
   (and tags
	(format "\\hfill{}\\textsc{%s}"
		(mapconcat #'org-latex--protect-text tags ":")))))

(setq org-latex-format-headline-function 'org-latex-format-headline-colored-keywords-function)

(defun mb/org-toggle-org-keywords-right ()
    "Toggle between todo-done keywords for all subnodes of the current node."
    (interactive)
    (org-map-entries (lambda () (org-shiftright)) nil 'tree)
  )
(defun mb/org-toggle-org-keywords-left ()
    "Toggle between todo-done keywords for all subnodes of the current node."
    (interactive)
    (org-map-entries (lambda () (org-shiftleft)) nil 'tree)
  )

;; org-agenda activation
(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)

;; **** org-special-block-extras -> 
(add-hook #'org-mode-hook #'org-special-block-extras-mode)
;; <- **** org-special-block-extras

;; enabling org-babel
(org-babel-do-load-languages
 'org-babel-load-languages '(
			     (C . t) ; enable processing C, C++, and D source blocks
			     (matlab . t)
			     ;;(perl . t)
			     (octave . t)
			     (org . t)
			     (python . t)
                             (plantuml . t)
			     (shell . t)
 			     ))
			     
;; no question about confirmation of evaluating babel code block
(setq org-confirm-babel-evaluate nil)

;; enabling plantuml

(setq plantuml-executable-path "plantuml")
(setq org-plantuml-exec-mode 'plantuml)

;; setup matlab in babel
(setq org-babel-default-header-args:matlab
  '((:results . "output") (:session . "*MATLAB*")))

;; Python in org-babel
(setq org-babel-python-command "/bin/python3")

;; **** org-to-markdown exporter customization  -> 

(defun org-export-md-format-front-matter ()
  (let* ((kv-alist (org-element-map (org-element-parse-buffer 'greater-element)
		       'keyword
		     (lambda (keyword)
		       (cons (intern (downcase (org-element-property :key keyword)))
			     (org-element-property :value keyword)))))
	 (lines (mapcar (lambda (kw)
			  (let ((val (alist-get kw kv-alist)))
			    (format (pcase kw
				      ('author "%s: %s")
				      ((or 'tags 'title) "%s: '%s'")
				      (_ "%s: %s"))
				    (downcase (symbol-name kw))
				    (pcase kw
				      ('date (substring val 1 -1))
				      (_ val)))))
			'(author date tags title))))
    (concat "---\n" (concat (mapconcat #'identity lines "\n")) "\n---")))

(defun my/org-export-markdown-hook-function (backend)
    (if (eq backend 'md)
	(insert (org-export-md-format-front-matter) "\n")))

;; This hook should be added per file in my org posts. Unfortunately, so far I don't know
;; how to do this.
;; (add-hook 'org-export-before-processing-hook #'my/org-export-markdown-hook-function)

(require 'ox-md nil t)

;; <- **** org-to-markdown exporter customization

;; alphabetical ordered lists
(setq org-list-allow-alphabetical t)

;; org-to-latex exporter to have nice code formatting
(setq org-latex-src-block-backend 'engraved)

;; Managing org-mode #+NAME properties like in reftex-mode
(defun my/get-name (e)
      (org-element-property :name e))

(defun my/latex-environment-names ()
      (org-element-map (org-element-parse-buffer) 'latex-environment #'my/get-name))

(defun my/report-latex-environment-names ()
    (interactive)
    (message (format "%S" (my/latex-environment-names))))

  (define-key org-mode-map (kbd "C-z z") #'my/report-latex-environment-names)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; *** Flyspell 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(flyspell-mode t)

    (defun flyspell-on-for-buffer-type ()
      "Enable Flyspell appropriately for the major mode of the current buffer.  Uses `flyspell-prog-mode' for modes derived from `prog-mode', so only strings and comments get checked.  All other buffers get `flyspell-mode' to check all text.  If flyspell is already enabled, does nothing."
      (interactive)
      (if (not (symbol-value flyspell-mode)) ; if not already on
	(progn
	  (if (derived-mode-p 'prog-mode)
	    (progn
	      (message "Flyspell on (code)")
	      (flyspell-prog-mode))
	    ;; else
	    (progn
	      (message "Flyspell on (text)")
	      (flyspell-mode 1)))
	  ;; I tried putting (flyspell-buffer) here but it didn't seem to work
	  )))
    
    (defun flyspell-toggle ()
      "Turn Flyspell on if it is off, or off if it is on.  When turning on, it uses `flyspell-on-for-buffer-type' so code-vs-text is handled appropriately."
      (interactive)
      (if (symbol-value flyspell-mode)
	  (progn ; flyspell is on, turn it off
	    (message "Flyspell off")
	    (flyspell-mode -1))
	  ; else - flyspell is off, turn it on
	  (flyspell-on-for-buffer-type)))

 (global-set-key (kbd "C-c f") 'flyspell-toggle )

(defun fd-switch-dictionary()
      (interactive)
      (let* ((dic ispell-current-dictionary)
    	 (change (if (string= dic "polish") "english" "polish")))
        (ispell-change-dictionary change)
        (message "Dictionary switched from %s to %s" dic change)
        ))
    
      (global-set-key (kbd "C-c s")   'fd-switch-dictionary)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; *** Flymake
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(flymake-mode t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; *** Bash completions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(bash-completion-setup)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Add this hook in order to run pdf-tools without a warning message.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-hook 'pdf-view-mode-hook (lambda() (linum-mode -1)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; AI - ChatGPT, Dall-E, Stable Diffusion and ...
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (require 'org-ai)
(add-hook 'org-mode-hook #'org-ai-mode)
(org-ai-global-mode)
;; (setq org-ai-default-chat-model "gpt-4") ; if you are on the gpt-4 beta:
;; (org-ai-install-yasnippets) ; if you are using yasnippet and want `ai` snippets

(load-file "../.mysecrets/openaiapi.el")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Useful global shortcuts (text operations)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(global-set-key (kbd "C-d") 'delete-forward-char)    ; Backspace/Insert remapping
(global-set-key (kbd "C-S-d") 'delete-backward-char) 
; (global-set-key (kbd "M-S-d") 'backward-kill-word)
(global-set-key (kbd "C-c C-e s") 'mark-end-of-sentence)

(global-set-key (kbd "C-C C-e C-w C-w") 'eww-list-bookmarks) ; Open eww bookmarks
(defun mynet ()  (interactive) (eww-list-bookmarks))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; my own prefix keymap
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-prefix-command 'mb-map)
(global-set-key (kbd "C-z") 'mb-map)
; (define-key mb-map (kbd "C-k") "\C-a\C- \C-e\M-w\M-;\C-e\C-m\C-y")
; (define-key mb-map (kbd "C-l")  "\M-w\M-;\C-e\C-m\C-y")

;; fast copy-line-comment-it-and-paste-below
;(global-set-key "\C-c\C-k"        "\C-a\C- \C-e\M-w\M-;\C-e\C-m\C-y")
(define-key mb-map (kbd "C-k") "\C-a\C- \C-e\M-w\M-;\C-e\C-m\C-y")

;; copy-selection-comment-it-and-paste-below (works ok provided selection is
;; performed from left to right....
; (global-set-key "\C-c\C-l" "\M-w\M-;\C-e\C-m\C-y")
 (define-key mb-map (kbd "C-l")  "\M-w\M-;\C-e\C-m\C-y")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Useful global shortcuts (system-wide operations)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun mb/browse-file-directory()
  (interactive)
  (call-process "dolphin" nil 0 nil "."))

(define-key global-map (kbd "<s-f12>") 'mb/browse-file-directory)

;; setting up configuration for emacs-everywhere:
;; 1. font size
;(if (daemonp)
;(
(defun my-after-frame (frame)
  (if (display-graphic-p frame)
      (progn
         (set-frame-font "liberation mono 11" nil t) )))

(mapc 'my-after-frame (frame-list))
(add-hook 'after-make-frame-functions 'my-after-frame)
;)
;)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Diary
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 'american’ - month/day/year
; ‘european’ - day/month/year
; ‘iso’      - year/month/day

(setq calendar-date-style "iso")
(setq diary-date-forms diary-iso-date-forms)
(setq diary-comment-start ";;")
(setq diary-comment-end "")
(setq diary-nonmarking-symbol "!")
; (setq diary-show-holidays-flag t)

(setq calendar-mark-diary-entries-flag t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; *** Emacs theme
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; **** Modus theme by Protesilaos Stavrou
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Add all your customizations prior to loading the themes
(setq modus-themes-italic-constructs t
      modus-themes-bold-constructs nil
      modus-themes-region '(bg-only no-extend))

;; Load the theme of your choice:
; (load-theme 'modus-operandi) ;; bright 
; (load-theme 'modus-vivendi) ;; dark



(setq modus-themes-headings ; this is an alist: read the manual or its doc string
      '((1 . (rainbow overline background 1.4))
        (2 . (rainbow background 1.3))
	(3 . (rainbow bold 1.2))
        (t . (semilight 1.1))))

(setq modus-themes-scale-headings t)
(setq modus-themes-org-blocks 'tinted-background)

;; Auxiliary function to toggle betwen bright and dark theme
(defun toggle-theme ()
  (interactive)
  (if (eq (car custom-enabled-themes) 'modus-vivendi)
      (disable-theme 'modus-vivendi)
    (load-theme 'modus-vivendi :noconfirm)))
(global-set-key [f6] 'toggle-theme)

;; load theme after defining 
(load-theme 'modus-vivendi :noconfirm)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; *** Manually downloaded packages
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Set location for external packages.
(add-to-list 'load-path "~/.emacs.d/manual-download/")

;; doconce (M-x DocOnce) may be needed to activate it -> 
(load-file "~/.emacs.d/manual-download/.doconce-mode.el")


;; activating org-mode for doconce pub files:
;; https://github.com/doconce/publish/blob/master/doc/manual/publish-user-manual.pdf
(setq auto-mode-alist
      (append '(("\\.org$" . org-mode))
              '(("\\.pub$" . org-mode))
              auto-mode-alist))
;; <- doconce

(global-set-key "\C-c\C-j" "\C-k =====")

;; sunrise
(add-to-list 'load-path "~/.emacs.d/manual-download/sunrise")
(require 'sunrise)
(require 'sunrise-buttons)
(require 'sunrise-modeline)
(add-to-list 'auto-mode-alist '("\\.srvm\\'" . sr-virtual-mode))

(add-hook 'sunrise-mode-hook
   '(lambda ()
     (local-set-key (kbd "C-x k") 'kill-buffer)
     (local-set-key (kbd "C-x j") 'sunrise-kill-pane-buffer)))

;; buffer-move - swap buffers easily
(require 'buffer-move)

;; octave/matlab-fix
;;;; (require 'ob-octave-fix nil t)    ; This is for older approach
(require 'ob-octave-fix)

;; custom org-special-block-extras blocks
(add-to-list 'load-path "~/.emacs.d/myarch")
(require 'MB-org-special-block-extras)

;; [DEPRECATED] - use sunrise instead of this
;; midnight-commander emulation
;; (require 'mc)

;; org to ipython exporter
;;(use-package ox-ipynb
;  :load-path "~/.emacs.d/manual-download/ox-ipynb")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; *** The ending
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(workgroups-mode 1)    ; session manager for emacs
(setq wg-session-file "~/.emacs.d/.emacs_workgroups") ;

(if (not noninteractive)
    ( ; if Emacs is started in graphical environment
      progn
      (add-hook 'kill-emacs-hook (
		     lambda () (wg-create-workgroup "currentsession")))
      (setq inhibit-startup-message t)
      (add-hook 'window-setup-hook (
		       lambda () (wg-open-workgroup "currentsession")))
    )
   (
    ; if Emacs is run in batch mode - do not care about workgroups
   )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; *** Finishing touches
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; All done
(message "All done in init.el.")
