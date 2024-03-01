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

(setq list-command-history-max 500) ; no of available commands in  =command-history=

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

(defadvice ido-find-file (after find-file-sudo activate)
"Find file as root if necessary."
(unless (and buffer-file-name
             (file-writable-p buffer-file-name))
  (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))

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
             (setq python-shell-interpreter "python") ))

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

;; BIBLIOGRAPHY 
(setq org-cite-csl-styles-dir "~/Zotero/styles")

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
("????"         . (:foreground "red" :weight bold))
("POSTPONED"    . (:foreground "orange" :weight bold))
("DONE"         . (:foreground "purple" :weight bold))
("ABANDONED"    . (:foreground "blue" :weight bold))
("DEPRECATED"   . (:foreground "blue" :weight bold))
("[OPTIONALLY]" . (:foreground "violet" :weight bold))
("[OPCJONALNIE]" . (:foreground "violet" :weight bold))
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

(defun mb/org-babel-tangle-block()
  (interactive)
  (let ((current-prefix-arg '(4)))
     (call-interactively 'org-babel-tangle)
))

(defun mb/org-babel-tangle-named-block(block-name)
  (interactive)
  (save-excursion 
   (org-babel-goto-named-src-block block-name)
    (mb/org-babel-tangle-block)) 
)

(defun mb/tangle-file (tangle-file)
  (interactive "P")
  (run-hooks 'org-babel-pre-tangle-hook)
  ;; Possibly Restrict the buffer to the current code block
  (save-restriction
    (save-excursion
      (let ((block-counter 0)
        (org-babel-default-header-args org-babel-default-header-args)
        path-collector)
    (mapc ;; map over file-names
     (lambda (by-fn)
       (let ((file-name (car by-fn)))
         (when file-name
               (let ((lspecs (cdr by-fn))
             (fnd (file-name-directory file-name))
             modes make-dir she-banged lang)
             ;; drop source-blocks to file
             ;; We avoid append-to-file as it does not work with tramp.
             (with-temp-buffer
           (mapc
            (lambda (lspec)
              (let* ((block-lang (car lspec))
                 (spec (cdr lspec))
                 (get-spec (lambda (name) (cdr (assq name (nth 4 spec)))))
                 (she-bang (let ((sheb (funcall get-spec :shebang)))
                         (when (> (length sheb) 0) sheb)))
                 (tangle-mode (funcall get-spec :tangle-mode)))
                (unless (string-equal block-lang lang)
              (setq lang block-lang)
              (let ((lang-f (org-src-get-lang-mode lang)))
                (when (fboundp lang-f) (ignore-errors (funcall lang-f)))))
                ;; if file contains she-bangs, then make it executable
                (when she-bang
              (unless tangle-mode (setq tangle-mode #o755)))
                (when tangle-mode
              (add-to-list 'modes (org-babel-interpret-file-mode tangle-mode)))
                ;; Possibly create the parent directories for file.
                (let ((m (funcall get-spec :mkdirp)))
              (and m fnd (not (string= m "no"))
                   (setq make-dir t)))
                ;; Handle :padlines unless first line in file
                (unless (or (string= "no" (funcall get-spec :padline))
                    (= (point) (point-min)))
              (insert "\n"))
                (when (and she-bang (not she-banged))
              (insert (concat she-bang "\n"))
              (setq she-banged t))
                (org-babel-spec-to-string spec)
                (setq block-counter (+ 1 block-counter))))
            lspecs)
           (when make-dir
             (make-directory fnd 'parents))
                   (unless
                       (and (file-exists-p file-name)
                            (let ((tangle-buf (current-buffer)))
                              (with-temp-buffer
                                (insert-file-contents file-name)
                                (and
                                 (equal (buffer-size)
                                        (buffer-size tangle-buf))
                                 (= 0
                                    (let (case-fold-search)
                                      (compare-buffer-substrings
                                       nil nil nil
                                       tangle-buf nil nil)))))))
                     ;; erase previous file
                     (when (file-exists-p file-name)
                       (delete-file file-name))
             (write-region nil nil file-name)
             (mapc (lambda (mode) (set-file-modes file-name mode)) modes))
                   (push file-name path-collector))))))
       (org-babel-tangle-collect-blocks nil tangle-file))
    (message "Tangled %d code block%s from %s" block-counter
         (if (= block-counter 1) "" "s")
         (file-name-nondirectory
          (buffer-file-name
           (or (buffer-base-buffer)
                       (current-buffer)
                       (and (org-src-edit-buffer-p)
                            (org-src-source-buffer))))))
    ;; run `org-babel-post-tangle-hook' in all tangled files
    (when org-babel-post-tangle-hook
      (mapc
       (lambda (file)
         (org-babel-with-temp-filebuffer file
           (run-hooks 'org-babel-post-tangle-hook)))
       path-collector))
        (run-hooks 'org-babel-tangle-finished-hook)
    path-collector))))

(defun mb/org-babel-tangle-to-target-file-from-the-file (file target-file)
  (interactive "fFile to tangle: \nP")
    (let* ((visited (find-buffer-visiting file))
	   (buffer (or visited (find-file-noselect file))))
      (prog1
	  (with-current-buffer buffer
	    (org-with-wide-buffer
	     (mapcar #'expand-file-name
		     (mb/tangle-file target-file))))
	(unless visited (kill-buffer buffer)))))

(defun mb/org-babel-export-org-file-to-latex (filename)
  (interactive "fFile to export: \nP")
    (let* ((visited (find-buffer-visiting filename))
	   (buffer (or visited (find-file-noselect filename))))
      (prog1
	  (with-current-buffer buffer
	     (org-latex-export-to-pdf nil) )
	(unless visited (kill-buffer buffer)))))

(defun mb/org-babel-tangle-and-export (file target-file)
  (interactive)
  (mb/org-babel-tangle-to-target-file-from-the-file file target-file)
  (mb/org-babel-export-org-file-to-latex target-file)
  )

;; enabling plantuml

(setq plantuml-executable-path "plantuml")
(setq org-plantuml-exec-mode 'plantuml)

;; setup matlab in babel
(setq org-babel-default-header-args:matlab
  '((:results . "output") (:session . "*MATLAB*")))

;; Python in org-babel
(setq org-babel-python-command "python3")

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
;; ;; (setq org-latex-packages-alist '((""))) ; there's no need to add minted package anymore here, we're using engraved, special options for engraved are passed in org-latex-engraved-preamble

(setq org-latex-engraved-preamble
  "\\usepackage{fvextra}

  [FVEXTRA-SETUP]

  % Make line numbers smaller and grey.
  \\renewcommand\\theFancyVerbLine{\\footnotesize\\color{black!40!white}\\arabic{FancyVerbLine}}

  \\usepackage{xcolor}

  % In case engrave-faces-latex-gen-preamble has not been run.
  \\providecolor{EfD}{HTML}{f7f7f7}
  \\providecolor{EFD}{HTML}{28292e}

  % Define a Code environment to prettily wrap the fontified code.
  \\usepackage[breakable,xparse]{tcolorbox}
  \\DeclareTColorBox[]{Code}{o}%
  {colback=EfD!98!EFD, colframe=EfD!95!EFD,
    fontupper=\\footnotesize\\setlength{\\fboxsep}{0pt},
    colupper=EFD,
    IfNoValueTF={#1}%
    {boxsep=2pt, arc=2.5pt, outer arc=2.5pt,
      boxrule=0.5pt, left=2pt}%
    {boxsep=2.5pt, arc=0pt, outer arc=0pt,
      boxrule=0pt, leftrule=1.5pt, left=0.5pt},
    right=2pt, top=1pt, bottom=0.5pt,
    breakable}

  [LISTINGS-SETUP]

  \\newenvironment{ai}
  {
  \\begin{Code}
  }
  {
  \\end{Code}
  }"
)

(setq org-latex-engraved-options
  '(
    ("commandchars" . "\\\\\\{\\}")
    ("highlightcolor" . "white!95!black!80!blue")
    ("breaklines" . "true")
    ("breaksymbol" . "\\color{white!60!black}\\tiny\\ensuremath{\\hookrightarrow}")
    ("highlightcolor" . "lightgray")
    ("frame" . "single")
    ("numbers" . "left")
    )
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; *** Reftex default bibliography - though it's easier to use org-cite
;;     This is left in case org-ref doesn't work at all without it....
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'org-ref)

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

(load-file (concat user-emacs-directory "../.mysecrets/openaiapi.el"))

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

;; sunrise
(add-to-list 'load-path "~/.emacs.d/manual-download/ox-extra")
(require 'ox-extra)
(ox-extras-activate '(ignore-headlines))

;; [DEPRECATED] - use sunrise instead of this
;; midnight-commander emulation
;; (require 'mc)

;; org to ipython exporter
;;(use-package ox-ipynb
;  :load-path "~/.emacs.d/manual-download/ox-ipynb")

(defun cissic-blog-stencil  (title )
 "Create and open a file with the given stencil."
 (interactive "sEnter the title: ")
 (let* ((date (format-time-string "%Y-%m-%d"))
	(dateDay (format-time-string "%Y-%m-%d %a"))
	(titleUnspaced (replace-regexp-in-string " " "-" title))
	(file-name (concat date "-" (downcase titleUnspaced) ".org"))
	(file-path (concat "~/projects/cissic.github.io/mysource/public-notes-org/" file-name))

	(stencil (concat "#+TITLE: " title "\n"
			 "#+DESCRIPTION: \n"
			 "#+AUTHOR: cissic \n"
			 "#+DATE: <" dateDay ">\n"
			 "#+TAGS: \n"
			 "#+OPTIONS: -:nil\n"
			 "\n"
			 "* TODO " title "\n"
			 ":PROPERTIES:\n"
			 ":PRJ-DIR: ./" date "-" (car (split-string titleUnspaced)) "/\n"
			 ":END:\n"
			 "\n"
			 "** Problem description\n"
			 "#+begin_src org :tangle (concat (org-entry-get nil \"PRJ-DIR\" t) \"script.org\") :mkdirp yes :exports none :results none\n"
			 "\n"
			 "#+end_src\n"
			 ))) 
   (with-temp-file file-path
     (insert stencil))
   (find-file file-path)))

(defun mb/org-entry-stencil  (title )
 "Create and open a file with the given stencil."
 (interactive "sEnter the title: ")
 (let* ((date (format-time-string "%Y.%m.%d"))
	(dateDay (format-time-string "%Y-%m-%d %a"))
	(titleUnspaced (replace-regexp-in-string " " "-" title))
	(file-name (concat date "-" (downcase titleUnspaced) ".org"))
	(file-path (concat "~/org/" file-name))

	(stencil (concat "#+TITLE: " title "\n"
			 "#+DESCRIPTION: \n"
			 "#+AUTHOR: \n"
			 "#+DATE: <" dateDay ">\n"
			 "#+TAGS: \n"
			 "#+OPTIONS: -:nil\n"
			 "\n"
			 ))) 
   (with-temp-file file-path
     (insert stencil))
   (find-file file-path)
   (goto-char (point-max))
   ))

(defun mb/orgpriv-entry-stencil  (title )
 "Create and open a file with the given stencil."
 (interactive "sEnter the title: ")
 (let* ((date (format-time-string "%Y.%m.%d"))
	(dateDay (format-time-string "%Y-%m-%d %a"))
	(titleUnspaced (replace-regexp-in-string " " "-" title))
	(file-name (concat date "-" (downcase titleUnspaced) ".org"))
	(file-path (concat "~/orgpriv/" file-name))

	(stencil (concat "#+TITLE: " title "\n"
			 "#+DESCRIPTION: \n"
			 "#+AUTHOR: \n"
			 "#+DATE: <" dateDay ">\n"
			 "#+TAGS: \n"
			 "#+OPTIONS: -:nil\n"
			 "\n"
			 ))) 
   (with-temp-file file-path
     (insert stencil))
   (find-file file-path)
   (goto-char (point-max))
   ))

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
(put 'upcase-region 'disabled nil)
