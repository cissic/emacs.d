;;; init.el

;; TODO:  tidy up the code following: https://github.com/jeffpollock9/.emacs.d/blob/master/init.el

;; TODO: fine tutorial https://medium.com/@suvratapte/configuring-emacs-from-scratch-intro-3157bed9d040

;; TODO: tidy up code using fine tutorial above (i.e. usepackage, and custom-file.el)
;; use-package -> https://jwiegley.github.io/use-package/keywords/
;;  and https://github.com/jwiegley/use-package



;;; Comment out if you've already loaded this package...
;;; (require 'cl-lib) ; ale czy to jest wogole potrzebne?
;; <- not needed since it's a forward compatibility library for emacs<24.3

(require 'package)
(package-initialize)
(require 'use-package)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Setting default font

;;; To get the list of available fonts:
;;; Type the following in the *scratch* buffer, and press C-j at the end of it:
;;;    (font-family-list)
;;; You may need to expand the result to see all of them, by hitting enter on the ... at the end.
;;; Source: https://stackoverflow.com/questions/13747749/font-families-for-emacs

(set-frame-font "liberation mono 11" nil t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Setting names of the days of the week and months to arbitrarily language
;; https://emacs.stackexchange.com/questions/50543/insert-date-using-a-calendar-where-other-language-rather-than-english-is-desir
;; https://emacs.stackexchange.com/questions/19602/org-calendar-change-date-language/19611#19611

;; (setq calendar-week-start-day 1
;;           calendar-day-name-array ["Domenica" "Lunedì" "Martedì" "Mercoledì" 
;;                                    "Giovedì" "Venerdì" "Sabato"]
;;           calendar-month-name-array ["Gennaio" "Febbraio" "Marzo" "Aprile" "Maggio"
;;                                      "Giugno" "Luglio" "Agosto" "Settembre" 
;;                                      "Ottobre" "Novembre" "Dicembre"])
;; (setq calendar-week-start-day 1
;;       calendar-day-name-array["Sunday" "Monday" "Tuesday"
;; 			      "Wednesday" "Thursday" "Friday" "Saturday"]
;;       calendar-month-name-array ["January" "February" "March" "April" "May" "June"
;;    			         "July" "August" "September" "October" "November" "December"])

;; https://emacs.stackexchange.com/questions/50543/insert-date-using-a-calendar-where-other-language-rather-than-english-is-desir

;;(let ((system-time-locale "en_GB.UTF-8")
;;      (time (org-read-date nil 'to-time nil "Date:  ")))
;;  (insert (format-time-string "(KW%W) (%A) %d. %B %Y" time)))(KW37) (poniedziałek) 12. września 2022
;; => (KW19) (Samstag) 18. Mai 2019


;; https://stackoverflow.com/questions/28913294/emacs-org-mode-language-of-time-stamps
;; System locale to use for formatting time values.
(setq system-time-locale "C")         ; Make sure that the weekdays in the
                                      ; time stamps of your Org mode files and
                                      ; in the agenda appear in English.


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; https://stackoverflow.com/questions/2518647/is-it-possible-to-evaluate-entire-buffer-in-emacs

;; (defun eval-region-or-buffer ()
;;   (interactive)
;;   (let ((debug-on-error t))
;;     (cond
;;      (mark-active
;;       (call-interactively 'eval-region)
;;       (message "Region evaluated!")
;;       (setq deactivate-mark t))
;;      (t
;;       (eval-buffer)
;;       (message "Buffer evaluated!")))))

;; (add-hook 'emacs-lisp-mode-hook
;;           (lambda ()
;; ;	    (local-set-key (kbd "C-x e") 'eval-region-or-buffer)))
;; 	    (local-set-key (kbd "<f5iłem piątkę o ponad minutę w czasie interwałów :D No ale nie myślę o pierdołach. Takie tam rozważania. Od kiedy kupiłem pierwsze buty to dalej w nich biegam. Ale mam dosyć spory drop 12mm, w sumie amortyzację raczej stosunkowo małą i zastanawiam się czy to może powodować u m>") 'eval-region-or-buffer)))

(use-package emacs-lisp-mode
  :bind (("<f5>" . eval-buffer)) ) 



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Do not use `init.el` for `custom-*` code - use `custom-file.el`.
(setq custom-file "~/.emacs.d/custom-file.el")

;;;; Assuming that the code in custom-file is execute before the code
;;;; ahead of this line is not a safe assumption. So load this file
;;;; proactively.
(load-file custom-file)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Forcing emacs to use user's .bashrc
;;;; -> https://stackoverflow.com/questions/6411121/how-to-make-emacs-use-my-bashrc-file

(defun set-exec-path-from-shell-PATH ()
 (let ((path-from-shell (replace-regexp-in-string
                         "[ \t\n]*$"
                         ""
                         (shell-command-to-string "$SHELL --login -i -c 'echo $PATH'"))))
   (setenv "PATH" path-from-shell)
   (setq eshell-path-env path-from-shell) ; for eshell users
   (setq exec-path (split-string path-from-shell path-separator))))

(when window-system (set-exec-path-from-shell-PATH))

;; (setq shell-command-switch "-ic")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;; Highlight current line.
;; (global-hl-line-mode 1)

;; ;; disable highlighting in shell and ansi-term
;; (add-hook 'eshell-mode-hook (lambda ()
;;                                     (setq-local global-hl-line-mode
;;                                                 nil)))
;; (add-hook 'term-mode-hook (lambda ()
;;                                     (setq-local global-hl-line-mode
;;                                                 nil)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Highlight matching parenthesis
(show-paren-mode 1)

;; (use-package paren
;;   :demand t
;;   :config (show-paren-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Truncate lines 
;;;; https://stackoverflow.com/questions/7577614/emacs-truncate-lines-in-all-buffers
;;;; (setq-default truncate-lines t)        ; ugly way of truncating

;; (setq-default global-visual-line-mode t) ; fancier way of truncating (word truncating) THIS DOES NOT WORK!!!
(global-visual-line-mode t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Replace selected text
(delete-selection-mode 1)

;; (use-package delsel
;;   :config (delete-selection-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Do not deselect after M-w copying
;;;; https://www.reddit.com/r/emacs/comments/1vdumz/emacs_to_keep_selection_after_copy/

(defadvice kill-ring-save (after keep-transient-mark-active ())
  "Override the deactivation of the mark."
  (setq deactivate-mark nil))
(ad-activate 'kill-ring-save)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Line numbering 

(global-linum-mode 1)

;; (use-package linum
;;   :init
;;   (progn
;;     (global-linum-mode 1)
;;     ;; (setq linum-format "%d")  ; This adds unnecessary spaces
;;       (set-face-background 'linum nil)
;;       ))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; New line auto-indent
(define-key global-map (kbd "RET") 'newline-and-indent)  


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Easily restore previous/next windows layout 
;;; C-c left - undo = previous window view
;;; C-c right - redo (undo undo)

;; 2DEL  (winner-mode 1)

(use-package winner
  :init
  (winner-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;; Useful shortcuts

;;;; Backspace/Insert remapping
(global-set-key (kbd "C-d") 'delete-forward-char)
(global-set-key (kbd "C-S-d") 'delete-backward-char)
;;;; Open eww bookmarks
(global-set-key (kbd "C-c C-e C-w C-w") 'eww-list-bookmarks) ;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Making emacs shell environment settings the same as system's shell (.bashrc)
; (setq shell-command-switch "-ic")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Googling from inside emacs

(require 'google-this) ; use-package couldn't manage to install it...
;; (use-package google-this
;;    :ensure t)
;; ;;; (setq google-this-wrap-in-quotes nil)

(defun google-this-in-quotes ()  (interactive) (google-this-region "\"" t))
(global-set-key (kbd "C-c g") 'google-this-in-quotes)
(global-set-key (kbd "C-c h") 'google-this-region)


;; ; -> C-c / g (w/ asking for confirmation)
;; ; -> C-c / b in quotes (w/out asking for confirmation)
;; ; -> C-c / n without quotes (w/out asking for confirmation)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Save windows layout on closing
(desktop-save-mode 1)
;; or workgroups -> https://github.com/howardabrams/dot-files/blob/master/emacs.org

;; (use-package workgroups
;;   :ensure t
;;   :diminish workgroups-mode
;;   :config
;;   (setq wg-prefix-key (kbd "C-c a"))
;;   (workgroups-mode 1)
;;   (wg-load "~/.emacs.d/workgroups"))

;; Short answer for using it:
;; C-c a c to create and name a new view
;; Configure the screen as you like it
;; C-c a u to have that view as the base for that name
;; C-c a v to switch to a particular workgroup view.
;; C-c a C-s to save all workgroup views to the file.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; https://emacs.stackexchange.com/a/48968/30699
(defun my-sh-send-command (command)
      "Send COMMAND to current shell process.

    Creates new shell process if none exists.

    See URL `https://stackoverflow.com/a/7053298/5065796'"
      (let ((proc (get-process "shell"))
            pbuf)
        (unless proc
          (let ((currbuff (current-buffer)))
            (shell)
            (switch-to-buffer currbuff)
            (setq proc (get-process "shell"))
            ))
        (setq pbuff (process-buffer proc))
        (setq command-and-go (concat command "\n"))
        (with-current-buffer pbuff
          (goto-char (process-mark proc))
          (insert command-and-go)
          (move-marker (process-mark proc) (point))
          )
        (process-send-string proc command-and-go)))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Easy moving between windows

;;; https://www.emacswiki.org/emacs/WindMove
;; (windmove-default-keybindings)

;;; including cl package in order to have ignore-error-wrapper function working properly ->
;;; -> https://emacs.stackexchange.com/questions/18726/void-function-lexical-let
;; (use-package cl) 
(eval-when-compile (use-package cl))

(defun ignore-error-wrapper (fn)
  "Funtion return new function that ignore errors.
   The function wraps a function with `ignore-errors' macro."
  (lexical-let ((fn fn))
    (lambda ()
      (interactive)
      (ignore-errors
        (funcall fn)))))

;;; setting windmove-default-keybindings to Shift-super-<arrow> in order
;;; to avoid org-mode conflicts (I cannot set s-<arrow> alone for this keybinding)
;;; different approach is here: https://orgmode.org/manual/Conflicts.html

(global-set-key (kbd "S-s-<left>") (ignore-error-wrapper 'windmove-left))
(global-set-key (kbd "S-s-<right>") (ignore-error-wrapper 'windmove-right))
(global-set-key (kbd "S-s-<up>") (ignore-error-wrapper 'windmove-up))
(global-set-key (kbd "S-s-<down>") (ignore-error-wrapper 'windmove-down))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Easy windows resize
(define-key global-map (kbd "C-s-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "C-s-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "C-s-<down>") 'shrink-window)
(global-set-key (kbd "C-s-<up>") 'enlarge-window)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; ido-mode

;; (ido-mode 1)          
;; (setq ido-enable-flex-matching t)
;; (setq ido-everywhere t)  ; ido dziala rowniez dla szukania plikow

(use-package ido
  :config
  (setq ido-enable-flex-matching t)
  (ido-mode 1)
  (ido-everywhere 1) )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; doconce 
;;; activating org-mode for doconce pub files:
;;; https://github.com/doconce/publish/blob/master/doc/manual/publish-user-manual.pdf

(setq auto-mode-alist
      (append '(("\\.org$" . org-mode))
              '(("\\.pub$" . org-mode))
              auto-mode-alist))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Recently opened files

;;;;;;; 2DEL
;; (recentf-mode 1)
;; (setq recentf-max-menu-items 25)
;; (setq recentf-max-saved-items 25)
;; ;; in original emacs this binding is for "Find file read-only"
;; (global-set-key "\C-x\ \C-r" 'recentf-open-files)
;;;;;;;; 2DEL


(use-package recentf
  :bind ("C-x C-r" . recentf-open-files)
  :config
  (progn
    (setq recentf-max-saved-items 200
          recentf-max-menu-items 15)
    (recentf-mode 1)
    )
  ;; (global-set-key "\C-x\ \C-r" 'recentf-open-files)
  )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Projectile

(require 'projectile)
(projectile-global-mode)
; (define-key projectile-mode-map (kbd "C-c C-p") 'projectile-command-map)
(projectile-mode +1)
(define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)


(let ((projectile-dir (concat "~/" "projects/")))
  (make-directory projectile-dir :parents))
(let ((projectile-dir (concat "~/" "projects/ZZZ_Testy")))
  (make-directory projectile-dir :parents))


(projectile-discover-projects-in-directory "~/projects/")
(projectile-discover-projects-in-directory "~/projects/ZZZ_Testy")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; org-mode

;; Enable Org mode
(require 'org)
;; Make Org mode work with files ending in .org
;; (add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
;; The above is the default in recent emacsen

;;; redefine shortcut for expanding ALL element
;;; default S-<Tab> is used in plasma-shell to toggle between the activites
;;; There is also C-u TAB
;; (local-set-key (kbd "<\C-\M-\TAB>") 'org-global-cycle)

(add-hook 'org-mode-hook
          (lambda ()
            (local-set-key (kbd "C-?") #'org-global-cycle)))

;; Now it's bounded to S-tab


;; enabling org-babel

(org-babel-do-load-languages
 'org-babel-load-languages '(
			     (C . t)
			     (matlab . t)
			     ;;(perl . t)
			     (octave . t)
			     (org . t)
			     (python . t)
			     (shell . t)
 			     ))

;; set python3 as a default interpreter
(setq org-babel-python-command "python3")

;; no question about confirmation of evaluating babel code block
(setq org-confirm-babel-evaluate nil)

;; (org-babel-do-load-languages 'org-babel-load-languages
;;                              (append org-babel-load-languages
;; 			      '(
;; 			        (matlab     . t)
;; 				(octave     . t)
;; 				(python     . t)
;; 				))

 ;; (after-load 'org
 ;;    (org-babel-do-load-languages
 ;;     'org-babel-load-languages
 ;;     '(
 ;;       ;;(awk . t)
 ;;       ;;(calc .t)
 ;;       ;;(C . t)
 ;;       ;;(emacs-lisp . t)
 ;;       ;;(haskell . t)
 ;;       (gnuplot . t)
 ;;       (latex . t)
 ;;       ;;(ledger . t)
 ;;       ;;(js . t)
 ;;       ;;(haskell . t)
 ;;       ;;(http . t)
 ;;       (matlab . t)
 ;;       ;;(perl . t)
 ;;       (octave . t)
 ;;       (org . t)
 ;;       (python . t)
 ;;       ;; org-babel does not currently support php.  That is really sad.
 ;;       ;;(php . t)
 ;;       ;;(R . t)
 ;;       ;;(scheme . t)
 ;;       ;;(sh . t)
 ;;       ;;(sql . t)
 ;;       ;;(sqlite . t)
 ;;       )))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;; Blogging with org-mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (require 'ox-publish)
;; (setq debug-on-error t)
;; (setq org-publish-project-alist
;;       '(("org-cissic" (name1)
;;          ;; Path to your org files.
;;          :base-directory "~/projects/cissicblog" (srcdir)
;;          :base-extension "org" (extension)
;;          ;; Path to your Jekyll project.
;;          :publishing-directory "~/projects/cissicblog/_posts" (destination)
;;          :recursive t
;;          ;; this was for org-mode pre-version 8
;;          ;;:publishing-function org-publish-org-to-html
;;          ;; this is for org-mode version 8 and on
;;          :publishing-function org-html-publish-to-html
;;          :headline-levels 4
;;          :html-extension "html"
;;          :body-only t ;; Only export section between <body> </body> (body-only)
;;          )
;;         ("org-static-cissic" (name2)
;;          :base-directory "~/projects/cissicblog/images" (imgsrc)
;;          :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf\\|php" (imgext)
;;          :publishing-directory "~/projects/cissicblog/assets" (imgdest)
;;          :recursive t
;;          :publishing-function org-publish-attachment)

;;         ("blog" :components ("org-cissic" "org-static-cissic")) (combo)
;;         ))


;;;; These are settings for Project-Template-For-OrgMode
(require 'project)
(require 'org-ref)
(require 'htmlize)

(defun my-new-project-configuration ()
  "Sets my-project-root as root project directory and load
my-project-root/setup/setup.el project configuration file "
  (interactive)
  (setq my-project-root (expand-file-name (car (project-roots (project-current)))))

  (if my-project-root
      (let ((my-project-setup-file (concat my-project-root "setup/setup.el")))
	(if (file-exists-p my-project-setup-file)
	    (load my-project-setup-file nil t t nil)
	  (error "Project %s setup file not found" my-project-setup-file)))
    (error "Project root dir not found (missing .git ?)")))




;;;;; These are settings for happyblogger (2DELETE ??)


(setq org-publish-project-alist
      '(
        ("blog-posts"
         :base-directory "~/blog/_org/posts/"
         :base-extension "org"
         :publishing-directory "~/blog/_posts"
         :inline-images t
         :table-of-contents nil
         :drawers nil
         :todo-keywords nil ; Skip todo keywords
         :exclude "draft*" ; TODO fix
         :section-numbers nil
         :auto-preamble nil
         :auto-postamble nil
         )
        ("blog-pages" ;; This section is optional.
         :base-directory "~/blog/_org/pages/"
         :base-extension "org"
         :publishing-directory "~/blog/pages"
         :inline-images t
         :table-of-contents nil
         :drawers nil
         :todo-keywords nil ; Skip todo keywords
         :section-numbers nil
         :auto-preamble nil
         :auto-postamble nil
         ;; :completion-function
         )
        ("blog" :components ("blog-posts" "blog-pages"))))


(setq org-md-headline-style "atx")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; forcing new window to open below all other windows of the frame

(defun new-window-at-the-bottom ()
  (interactive)
  (split-window
   (frame-root-window)
   (truncate (* (window-total-height (frame-root-window)) 0.75)) 'below)
 )
(global-set-key (kbd "C-x 9 <down>") 'new-window-at-the-bottom)

(defun new-window-at-the-right ()
  (interactive)
  (split-window
   (frame-root-window)
   (truncate (* (window-total-width (frame-root-window)) 0.5)) 'right)
 )
(global-set-key (kbd "C-x 9 <right>") 'new-window-at-the-right)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;  Treemacs

(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn
    (setq treemacs-collapse-dirs                 (if treemacs-python-executable 3 0)
          treemacs-deferred-git-apply-delay      0.5
          treemacs-directory-name-transformer    #'identity
          treemacs-display-in-side-window        t
          treemacs-eldoc-display                 t
          treemacs-file-event-delay              5000
          treemacs-file-extension-regex          treemacs-last-period-regex-value
          treemacs-file-follow-delay             0.2
          treemacs-file-name-transformer         #'identity
          treemacs-follow-after-init             t
          treemacs-git-command-pipe              ""
          treemacs-goto-tag-strategy             'refetch-index
          treemacs-indentation                   2
          treemacs-indentation-string            " "
          treemacs-is-never-other-window         nil
          treemacs-max-git-entries               5000
          treemacs-missing-project-action        'ask
          treemacs-move-forward-on-expand        nil
          treemacs-no-png-images                 nil
          treemacs-no-delete-other-windows       t
          treemacs-project-follow-cleanup        nil
          treemacs-persist-file                  (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
          treemacs-position                      'left
          treemacs-recenter-distance             0.1
          treemacs-recenter-after-file-follow    nil
          treemacs-recenter-after-tag-follow     nil
          treemacs-recenter-after-project-jump   'always
          treemacs-recenter-after-project-expand 'on-distance
          treemacs-show-cursor                   nil
          treemacs-show-hidden-files             t
          treemacs-silent-filewatch              nil
          treemacs-silent-refresh                nil
          treemacs-sorting                       'alphabetic-asc
          treemacs-space-between-root-nodes      t
          treemacs-tag-follow-cleanup            t
          treemacs-tag-follow-delay              1.5
          treemacs-user-mode-line-format         nil
          treemacs-user-header-line-format       nil
          treemacs-width                         35
          treemacs-workspace-switch-cleanup      nil
	  ;; https://github.com/Alexander-Miller/treemacs/issues/553
	  treemacs-define-doubleclick-action     'file-node-open    #'treemacs-visit-node-in-most-recently-used-window
	  treemacs-define-doubleclick-action     'file-node-closed  #'treemacs-visit-node-in-most-recently-used-window)

    ;; The default width and height of the icons is 22 pixels. If you are
    ;; using a Hi-DPI display, uncomment this to double the icon size.
    ;;(treemacs-resize-icons 44)

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode t)
    (pcase (cons (not (null (executable-find "git")))
                 (not (null treemacs-python-executable)))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple))))
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)))

;; (use-package treemacs-evil
;;   :after treemacs evil
;;   :ensure t)

(use-package treemacs-projectile
  :after treemacs projectile
  :ensure t)

(use-package treemacs-icons-dired
  :after treemacs dired
  :ensure t
  :config (treemacs-icons-dired-mode))

(use-package treemacs-magit
  :after treemacs magit
  :ensure t)

(use-package treemacs-persp ;;treemacs-persective if you use perspective.el vs. persp-mode
  :after treemacs persp-mode ;;or perspective vs. persp-mode
  :ensure t
  :config (treemacs-set-scope-type 'Perspectives))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; EMMS

;; ; https://superuser.com/questions/179186/emms-emacs-multimedia-system-error-in-emacs-dont-know-how-to-play-track
;; (require 'emms-setup)
;; (emms-all)
;; (emms-default-players)

;; ;;; emms shortcuts

;; ;; (setq emms-source-file-default-directory "/media/mb/HA/MuzykaA/")
;; ;; (emms-add-directory-tree emms-source-file-default-directory)
;; ;; https://www.gnu.org/software/emms/manual/

;; (global-set-key (kbd "C-x x <up>") 'emms-play-dired)
;; (global-set-key (kbd "C-x x <right>") 'emms-next)
;; (global-set-key (kbd "C-x x <left>") 'emms-previous)
;; (global-set-key (kbd "C-x x <down>") 'emms-pause)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; dockerfile-mode
(require 'dockerfile-mode)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; makefile mode
(require 'make-mode)
(defconst makefile-nmake-statements
    `("!IF" "!ELSEIF" "!ELSE" "!ENDIF" "!MESSAGE" "!ERROR" "!INCLUDE" ,@makefile-statements)
    "List of keywords understood by nmake.")
  
  (defconst makefile-nmake-font-lock-keywords
    (makefile-make-font-lock-keywords
     makefile-var-use-regex
     makefile-nmake-statements
     t))
  
  (define-derived-mode makefile-nmake-mode makefile-mode "nMakefile"
    "An adapted `makefile-mode' that knows about nmake."
    (setq font-lock-defaults
          `(makefile-nmake-font-lock-keywords ,@(cdr font-lock-defaults))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Git integration
(global-set-key (kbd "C-x g") 'magit-status)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;  AUTO-COMPLETE

;; ;; https://emacs.stackexchange.com/questions/5938/how-to-make-auto-complete-work-in-auctex-mode

;; (require 'auto-complete)
;; (add-to-list 'ac-modes 'latex-mode 'org-mode) ; beware of using 'LaTeX-mode instead
;; (require 'ac-math) ; package should be installed first 
;; (defun my-ac-latex-mode () ; add ac-sources for latex
;;    (setq ac-sources
;;          (append '(ac-source-math-unicode
;;            ac-source-math-latex
;;            ac-source-latex-commands)
;;                  ac-sources)))
;; (add-hook 'LaTeX-mode-hook 'my-ac-latex-mode)
;; (setq ac-math-unicode-in-math-p t)
;; (ac-flyspell-workaround) ; fixes a known bug of delay due to flyspell (if it is there)

;; (require 'auto-complete-config)
;; (ac-config-default)
;; (setq ac-show-menu-immediately-on-auto-complete t)

;;  ;; autocomplete in org-mode
;; (require 'org-ac)
;; (org-ac/config-default)






;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;  SHELL 


;;; going back and forth in shell command history
(require 'comint)
(define-key comint-mode-map (kbd "<up>") 'comint-previous-input)
(define-key comint-mode-map (kbd "<down>") 'comint-next-input)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; shell-pop
;;; http://pragmaticemacs.com/emacs/pop-up-a-quick-shell-with-shell-pop/

;; (use-package shell-pop
;;   :bind (("C-t" . shell-pop))
;;   :config
;;   (setq shell-pop-shell-type (quote ("ansi-term" "*ansi-term*" (lambda nil (ansi-term shell-pop-term-shell)))))
;;   ;; MB commented (setq shell-pop-term-shell "/bin/zsh")
;;   ;; need to do this manually or not picked up by `shell-pop'
;;   (shell-pop--set-shell-type 'shell-pop-shell-type shell-pop-shell-type))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; my popup-shell -> toggle on/off ansi-term window
;;  https://www.reddit.com/r/emacs/comments/bed0ne/dry0_quickly_popup_a_terminal_run_a_command_close/

(defun my/ansi-term-toggle ()
  "Toggle ansi-term window on and off with the same command."
  (interactive)
  (defvar my--ansi-term-name "ansi-term-popup")
  (defvar my--window-name (concat "*" my--ansi-term-name "*"))
  (cond ((get-buffer-window my--window-name)
         (ignore-errors (delete-window
                         (get-buffer-window my--window-name))))
        (t (new-window-at-the-bottom) ;(split-window-below)
           (other-window 1)
           (cond ((get-buffer my--window-name)
                  (switch-to-buffer my--window-name))
                 (t (ansi-term "bash" my--ansi-term-name))))))

(global-set-key (kbd "<f12>") 'my/ansi-term-toggle)

(defun my/test ()
  "Test fun"
  (interactive)
  ;; (defvar cur-win-name (window-parameter nil 'name))
  (defvar cur-frame-name (window-parameter nil 'name) )
    (message cur-frame-name )
)

(global-set-key (kbd "<f11>") 'my/test)
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; ansi-term window opened (at the bottom of the frame) at the start of the emacs 
;; https://stackoverflow.com/questions/19970814/emacs-how-to-load-an-ansi-term-buffer-at-startup

;; (add-hook 'emacs-startup-hook
;;   (lambda ()
;;     (select-window (new-window-at-the-bottom))
;;     (ansi-term "/bin/bash")
;;   ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; forcing shell to open in the window with focus on it...

;; https://stackoverflow.com/questions/40301732/m-x-shell-open-shell-in-other-windows
(push (cons "\\*shell\\*" display-buffer--same-window-action)
      display-buffer-alist)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Copy/paste in ansi-term with the use of Ctrl-C/Ctrl-V (Ctrl-Ins/Shift-Ins by default)

; based on:
;; https://oremacs.com/2015/01/01/three-ansi-term-tips/
;; https://stackoverflow.com/questions/2886184/copy-paste-in-emacs-ansi-term-shell

(eval-after-load "term"
  '(define-key term-raw-map (kbd "C-V") 'term-paste))

(eval-after-load "ansi-term"
  '(define-key term-raw-map (kbd "C-C") 'term-copy-old-input))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; auto-completion in ansi-term buffer using <tab>
;; https://stackoverflow.com/questions/18278310/emacs-ansi-term-not-tab-completing
(add-hook 'term-mode-hook (lambda()
        (setq yas-dont-activate t)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Setting finer colors for ansi-term console

; based on:
; https://stackoverflow.com/questions/24164696/how-to-change-colors-in-bash-in-seansi-term-in-emacs
; https://stackoverflow.com/questions/21635332/modifying-ansi-term-colors-in-emacs

;; (set-face-attribute 'term-color-blue nil :foreground "royal blue")

;; (defmacro term-color (name color)
;;   `(set-face-attribute ',(intern (concat "term-color-" (symbol-name name)))
;;                        nil :foreground ,color))

;; (term-color blu "#5555FF")


(custom-set-faces
 '(term-color-blue ((t (:background "blue2" :foreground "royal blue")))))

;; (custom-set-faces
;;  ;; custom-set-faces was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(term-color-blue ((t (:background "blue2" :foreground "royal blue"))))
;;  )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; embrace
(global-set-key (kbd "C-,") #'embrace-commander)
(add-hook 'org-mode-hook #'embrace-org-mode-hook)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (require 'org-mime)
;; (setq org-mime-library 'mml)

;; (defun org-mime-org-buffer-htmlize ()
;;   "Create an email buffer containing the current org-mode file
;;   exported to html and encoded in both html and in org formats as
;;   mime alternatives."
;;   (interactive)
;;   (org-mime-send-buffer 'html)
;;   (message-goto-to))



;; (setq smtpmail-smtp-server "mail.example.org")

(setq gnus-select-method
     '(nnmaildir ""
         (directory "/home/mb/.icedove/1w0kslzi.maildirProfile/ImapMail/imap.prz.edu.pl")
         (get-new-mail nil)))
(setq mail-sources nil)
(setq gnus-secondary-select-methods nil)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; matlab  
(autoload 'matlab-mode "matlab" "Matlab Editing Mode" t)
 (add-to-list
  'auto-mode-alist
  '("\\.m$" . matlab-mode))
 (setq matlab-indent-function t)
 ;; (setq matlab-shell-command "matlab")
(custom-set-variables
 '(matlab-shell-command-switches '("-nodesktop -nosplash")))
(add-hook 'matlab-mode-hook 'auto-complete-mode)
(setq auto-mode-alist
    (cons
     '("\\.m$" . matlab-mode)
     auto-mode-alist))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; markdown
(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; LATEX

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; minor-mode for LaTeX - cdlatex
(use-package cdlatex
  :defer t
  :ensure t
  :init
  (add-hook 'org-mode-hook 'turn-on-org-cdlatex)
  (add-hook 'LaTeX-mode-hook 'turn-on-cdlatex) )

;; (local-set-key (kbd "<\C-\M-\TAB>") 'cdlatex-tab)  ; why is that???

(add-hook 'LaTeX-mode-hook
          (lambda ()
            (local-set-key (kbd "C-?") #'cdlatex-tab)))

(add-hook 'latex-mode-hook
          (lambda ()
            (local-set-key (kbd "C-?") #'cdlatex-tab)))

(add-hook 'cdlatex-mode-hook
          (lambda ()
            (local-set-key (kbd "C-?") #'cdlatex-tab)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; embrace.el for latex

(add-hook 'LaTeX-mode-hook 'embrace-LaTeX-mode-hook)
(defun embrace-LaTeX-mode-hook ()
  (dolist (lst '((?= "\\verb|" . "|")
                 (?~ "\\texttt{" . "}")
                 (?/ "\\emph{" . "}")
		 (?# "\\emphB{" . "}")
                 (?* "\\textbf{" . "}")))
    (embrace-add-pair (car lst) (cadr lst) (cddr lst))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Deleting comments in LaTeX file
; https://tex.stackexchange.com/questions/82972/delete-comments-in-tex-file-with-emacsauctex/82981#82981
(defun delete-latex-comments()
  (interactive)
  (query-replace-regexp "\\(^\\| *[^\\\\]\\)%.*" "" nil nil)
  )

;; (global-set-key "\C-z\ \C-d" 'delete-latex-comments)
; C-z C-d !  -> deletes all comments at once




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; AucTeX + Okular
;; https://tex.stackexchange.com/questions/161797/how-to-configure-emacs-and-auctex-to-perform-forward-and-inverse-search

;;;; C-c C-v for forward search (Emacs -> Okular)
;;;; Shift + LMouse for reverse search (Okular -> Emacs)

(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)
(server-start)

(setq TeX-source-correlate-method (quote synctex))
(setq TeX-source-correlate-mode t)
(setq TeX-source-correlate-start-server t)
(setq TeX-view-program-list (quote (("Okular" "okular --unique %o#src:%n%b"))))

(setq TeX-view-program-selection
   (quote
    ((engine-omega "dvips and gv")
     (output-dvi "xdvi")
     (output-pdf "Okular")
     (output-html "xdg-open"))))


(add-hook 'LaTeX-mode-hook
          (lambda ()
            (local-set-key (kbd "C-x C-g") #'TeX-view)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; aligning columns in latex tables
;;; according to -> https://tex.stackexchange.com/questions/557959/emacs-auctex-tabular-vertical-alignment-of-cells

(defun iw/tabular-magic ()
  (interactive)
  (unless (string= (LaTeX-current-environment) "document")
    (let ((s (make-marker))
          (e (make-marker)))
      (set-marker s (save-excursion
                      (LaTeX-find-matching-begin)
                      (forward-line)
                      (point)))
      (set-marker e (save-excursion
                      (LaTeX-find-matching-end)
                      (forward-line -1)
                      (end-of-line)
                      (point)))
      ;; Delete the next 2 lines if you don't like indenting and removal
      ;; of whitespaces:
      (LaTeX-fill-environment nil)
      (whitespace-cleanup-region s e)
      (align-regexp s e "\\(\\s-*\\)&" 1 1 t)
      (align-regexp s e "\\(\\s-*\\)\\\\\\\\")
      (set-marker s nil)
      (set-marker e nil))))

;; Choose a key binding for LaTeX mode:
(add-hook 'LaTeX-mode-hook
          (lambda ()
            (local-set-key (kbd "C-c e") #'iw/tabular-magic)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; RefTeX
;; (require 'reftex)
(setq reftex-mode t)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)   ; with AUCTeX LaTeX mode
(add-hook 'latex-mode-hook 'turn-on-reftex)   ; with Emacs latex mode
(setq reftex-plug-into-AUCTeX t)

;; https://tex.stackexchange.com/questions/54739/reftex-wont-find-my-bib-file-in-local-library-tree
;; So that RefTeX finds my bibliography
(setq reftex-default-bibliography '("~/texmf/bibtex/bib/base/cissic.bib"))

;; So that RefTeX also recognizes \addbibresource. Note that you
;; can't use $HOME in path for \addbibresource but that "~"
;; works.
(setq reftex-bibliography-commands '("bibliography" "nobibliography" "addbibresource"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Open/close window with latex compilation errors
;; https://tex.stackexchange.com/questions/221028/how-can-i-configure-auctex-to-automatically-switch-to-the-compilation-log-after
; (setq TeX-error-overview-open-after-TeX-run t)


;;;; Open information window when there were errors during compilation
;;;; Close information window when there were no errors
;; https://emacs.stackexchange.com/questions/38258/close-latex-compilation-window-when-successful

(defcustom TeX-buf-close-at-warnings-only t
  "Close TeX buffer if there are only warnings."
  :group 'TeX-output
  :type 'boolean)

(defun my-tex-close-TeX-buffer (_output)
  "Close compilation buffer if there are no errors.
Hook this function into `TeX-after-compilation-finished-functions'."
  (let ((buf (TeX-active-buffer)))
    (when (buffer-live-p buf)
      (with-current-buffer buf
        (when (progn (TeX-parse-all-errors)
                     (or
                      (and TeX-buf-close-at-warnings-only
                           (null (cl-assoc 'error TeX-error-list)))
                      (null TeX-error-list)))
          (cl-loop for win in (window-list)
                   if (eq (window-buffer win) (current-buffer))
                   do (delete-window win)))))))

(add-hook 'TeX-after-compilation-finished-functions #'my-tex-close-TeX-buffer)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; pythontex
; https://tex.stackexchange.com/questions/503176/how-to-let-auctex-launch-automatically-pythontex-py-script

; script works assuming there is pythontex3 script in the load path


(with-eval-after-load "tex"
  (add-to-list 'TeX-command-list
               '("PythonTeX" "pythontex3 %s" TeX-run-command nil (latex-mode)
                 :help "Run PythonTeX script")
               t))

; cleaning auxiliary files 
(with-eval-after-load "tex"
  (add-to-list 'TeX-command-list
               '("ClearPythonTeXAux" "rm -rf pythontex-files-%s" TeX-run-command nil (latex-mode)
                 :help "Clear pythontex auxiliary files")
               t))


(defun my/TeX-run-TeX-pythontex ()
  "Save current master file, run LaTeX, PythonTeX and start the viewer."
  (interactive)
  (unless (featurep 'tex-buf)
    (require 'tex-buf))
  (TeX-save-document (TeX-master-file))
  (TeX-command-sequence '("LaTeX" "PythonTeX" "LaTeX" "View") 
                        t))

;; (defun my/TeX-run-TeX-pythontex ()
;;   "Save current master file, run LaTeX, PythonTeX and start the viewer."
;;   (interactive)
;;   (unless (featurep 'tex-buf)
;;     (require 'tex-buf))
;;   (TeX-save-document (TeX-master-file))
;;   (TeX-command-sequence '("ClearPythonTeXAux" "LaTeX" "PythonTeX" "LaTeX" "View") 
;;                         t))

(add-hook 'LaTeX-mode-hook
          (lambda ()
            (local-set-key (kbd "C-c C-p") #'my/TeX-run-TeX-pythontex)))




;; MB's own ad-hoc shorcuts

;; (add-hook 'LaTeX-mode-hook
;;           (lambda ()
;;             (local-set-key (kbd "C-x C-g") #'TeX-view)))


(defun my/insert-comment ()
  (interactive)
  (insert "\\MBp{}")
  (backward-char))

;; (defun my/add-tex-insert-comment-binding ()
;;    (local-set-key (kbd "<M-f12>") #'my/insert-comment))
;; (add-hook 'latex-mode-hook #'my/add-text-insert-comment-binding) 
;; (add-hook 'tex-mode-hook #'my/add-text-insert-comment-binding)
;; (add-hook 'LaTeX-mode-hook #'my/add-text-insert-comment-binding)

(add-hook 'LaTeX-mode-hook
	  (lambda ()
	    (local-set-key (kbd "<M-f12>") #'my/insert-comment)))






;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; PYTHON

;; ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; ;;;;  ELPY
;; ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ;; (elpy-enable)
;; ;; ; (pyenv-mode)
;; ;; ;; (setq python-shell-interpreter "ipython"
;; ;; ;;       python-shell-interpreter-args "-i --simple-prompt")
;; ;; (setq python-shell-interpreter "python3" ; zmienione przeze mnie MB
;; ;;       python-shell-interpreter-args "-i")

;; (use-package elpy 
;;   :ensure t
;;   :defer t
;;   :init
;;   (advice-add 'python-mode :before 'elpy-enable)
;;   :config
;;   (setq python-shell-interpreter "python3"
;; 	python-shell-interpreter-args "-i") ;; set the default interpreter to python3
;;   (setq elpy-shell-echo-input nil) )    ;; do not repeat lines in the python command line


;; ;; Make C-c C-c behave like C-u C-c C-c in Python mode
;; ;; https://stackoverflow.com/questions/23654334/python-in-emacs-name-main-but-somehow-not
;; ;; MBcomment: by default "C-u C-c C-c" makes python interpret things like I'd want it to
;; ;; On the other hand "C-c C-c" does not interpret 

;; ;; (require 'python)
;; ;; (define-key python-mode-map (kbd "C-c C-c")
;;   ;; (lambda () (interactive) (python-shell-send-buffer t)))



;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;  flycheck (newer version of flymake)

;; (use-package flycheck
;;   :ensure t
;;   :init (global-flycheck-mode))

;; (add-hook 'after-init-hook #'global-flycheck-mode)

;; ; tooltips for flycheck -> flycheck-pos-tip package
;; (with-eval-after-load 'flycheck
;;   (flycheck-pos-tip-mode))





;; ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; ;;;;  JEDI / EPC
;; ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ;; M-x jedi:install-server  ;; trzeba uruchomic raz 
;; (require 'jedi)
;; ;; Hook-up to autocomplete
;; (add-to-list 'ac-sources 'ac-source-jedi-direct)
;; ;; Enable for python-mode
;; (add-hook 'python-mode-hook 'jedi:setup)
;;    (setq jedi:setup-keys t)                      ; optional
;;    (setq jedi:complete-on-dot t)                 ; optional

   
;; (defvar jedi-config:with-virtualenv nil
;; "Set to non-nil to point to a particular virtualenv.")

;; ;; Variables to help find the project root
;; (defvar jedi-config:vcs-root-sentinel ".git")
;; (defvar jedi-config:python-module-sentinel "__init__.py")

;; ;; Function to find project root given a buffer
;; (defun get-project-root (buf repo-type init-file)
;; (vc-find-root (expand-file-name (buffer-file-name buf)) repo-type))

;; (defvar jedi-config:find-root-function 'get-project-root)


;; ;; And call this on initialization
;; (defun current-buffer-project-root ()
;;   (funcall jedi-config:find-root-function
;;            (current-buffer)
;;            jedi-config:vcs-root-sentinel
;;            jedi-config:python-module-sentinel))
           
           
;; ;; (defun jedi-config:setup-server-args ()
;; ;;        ;; little helper macro
;; ;;        (defmacro add-args (arg-list arg-name arg-value)
;; ;;          `(setq ,arg-list (append ,arg-list (list ,arg-name ,arg-value))))
;; ;;        (let ((project-root (current-buffer-project-root)))  ;;;; TUTAJ NIE DZIALA !!!!
;; ;;          ;; Variable for this buffer only
;; ;;          (make-local-variable 'jedi:server-args)

;; ;;          ;; And set our variables
;; ;;          (when project-root
;; ;;            (add-args jedi:server-args "--sys-path" project-root))
;; ;;          (when jedi-config:with-virtualenv
;; ;;                (add-args jedi:server-args "--virtual-env"
;; ;;                          jedi-config:with-virtualenv))))



;; ;; ;; And set our variables
;; ;; (when project-root
;; ;;   (add-args jedi:server-args "--sys-path" project-root))
;; ;; (when jedi-config:with-virtualenv
;; ;;       (add-args jedi:server-args "--virtual-env"
;; ;;                 jedi-config:with-virtualenv))
                
                
                
;; ;;;; ;;;; SIDE-BAR
;; ;;;; (defvar jedi-config:use-system-python t)
;; ;;;; (defun jedi-config:set-python-executable ()
;; ;;;;        (set-exec-path-from-shell-PATH) ;; for OS X
;; ;;;;        (make-local-variable 'jedi:server-command)
;; ;;;;        (set 'jedi:server-command
;; ;;;;              (list (executable-find "python")
;; ;;;;                    (cadr default-jedi-server-command))))
;; ;;;;                    
;; ;;;;                    
;; ;;;; (add-hook 'python-mode-hook
;; ;;;;            'jedi-config:setup-server-args)
;; ;;;; (when jedi-config:use-system-python
;; ;;;;       (add-hook 'python-mode-hook
;; ;;;;                  'jedi-config:set-python-executable))
;; ;;;;                 
                
                
;; (defun jedi-config:setup-keys ()
;;        (local-set-key (kbd "M-.") 'jedi:goto-definition)
;;        (local-set-key (kbd "M-,") 'jedi:goto-definition-pop-marker)
;;        (local-set-key (kbd "M-?") 'jedi:show-doc)
;;        (local-set-key (kbd "M-/") 'jedi:get-in-function-call))
;; (add-hook 'python-mode-hook 'jedi-config:setup-keys)


;; ;; ;; a little hack
;; (setq jedi:get-in-function-call-delay 10000000)


;; ;; ;;;; Complete when you type a dot:
;; (setq jedi:complete-on-dot t)




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; https://emacs.stackexchange.com/questions/18672/how-to-define-a-function-that-calls-a-console-process-using-ansi-term

;;; https://stackoverflow.com/questions/6286579/emacs-shell-mode-how-to-send-region-to-shell
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (defvar my-terminal-run-history nil)

;; (defun my-terminal-run (command &optional name)
;;   "Runs COMMAND in a `term' buffer."
;;   (interactive
;;    (list (read-from-minibuffer "$ " nil nil nil 'my-terminal-run-history)))
;;   (let* ((name (or name command))
;;          (switches (split-string-and-unquote command))
;;          (command (pop switches))
;;          (termbuf (apply 'make-term name command nil switches)))
;;     (set-buffer termbuf)
;;     (term-mode)
;;     (term-char-mode)
;;     (switch-to-buffer termbuf)))

;; (global-set-key (kbd "C-c s c") 'my-terminal-run)

(defun ansi-term-send-line-or-region (&optional step)
  (interactive ())
  (let ((proc (get-process "*ansi-term*"))
         pbuf
         min
         max
         command)
    (unless proc
      (let ((currbuff (current-buffer)))
        (sane-term)
        (switch-to-buffer currbuff)
        (setq proc (get-process "*ansi-term*"))))

    (setq pbuff (process-buffer proc))

    (if (use-region-p)
      (setq min (region-beginning)
            max (region-end))
      (setq min (point-at-bol)
            max (point-at-eol)))

    (setq command (concat (buffer-substring min max) "\n"))
    (process-send-string proc command)
    (display-buffer (process-buffer proc) t)
    (when step
      (goto-char max)
      (next-line))))

(defun ansi-term-send-line-or-region-and-step ()
  (interactive)
  (ansi-term-send-line-or-region t))

(defun ansi-term-switch-to-process-buffer ()
  (interactive)
  (pop-to-buffer (process-buffer (get-process "*ansi-term*")) t))

;; (define-key sh-mode-map [(control ?j)] 'sh-send-line-or-region-and-step)
;; (define-key sh-mode-map [(control ?c) (control ?z)] 'sh-switch-to-process-buffer)

(global-set-key (kbd "<f9>") 'ansi-term-send-line-or-region-and-step)
(global-set-key (kbd "<f8>") 'ansi-term-switch-to-process-buffer)

;;
(defun ansi-term-send-command (command2run)
  (interactive ())
  (let ((proc (get-process "*ansi-term*"))
         pbuf
         min
         max
         command)
    (unless proc
      (let ((currbuff (current-buffer)))
        (sane-term)
        (switch-to-buffer currbuff)
        (setq proc (get-process "*ansi-term*"))))

    (setq pbuff (process-buffer proc))

    (if (use-region-p)
      (setq min (region-beginning)
            max (region-end))
      (setq min (point-at-bol)
            max (point-at-eol)))

    ;; (setq command (concat "ls " (buffer-file-name)  "\n"))
    (setq command (concat command2run  "\n"))
    (process-send-string proc command)
    (display-buffer (process-buffer proc) t)
    ))

(defun cd-to-current-buffers-dir ()
  (interactive)
  (ansi-term-send-command (concat "cd " (file-name-directory buffer-file-name))
  )
)

(defun python-run-in-shell ()
  (interactive)
  (ansi-term-send-command
   (concat "python3 " (file-name-nondirectory buffer-file-name))
  )
)

(defun python-run-maketest-in-shell ()
  (interactive)
  (ansi-term-send-command
   (concat "make test-s file=tests/"
	  (file-name-nondirectory(buffer-file-name))
   )
  )
)

(local-set-key (kbd "<f4>") 'cd-to-current-buffers-dir)
;; (local-set-key (kbd "<f5>") 'python-run-in-shell)
;; (local-set-key (kbd "<f6>") 'python-run-maketest-in-shell)

(local-set-key (kbd "<f4>") 'cd-to-current-buffers-dir)


;;;; setting keybindings for python-mode only
(with-eval-after-load 'python
  (define-key python-mode-map (kbd "<f5>") #'python-run-in-shell))
(with-eval-after-load 'python
  (define-key python-mode-map (kbd "<f6>") #'python-run-maketest-in-shell))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Manually downloaded

;;; Set location for external packages.
(add-to-list 'load-path "~/.emacs.d/manual-download/")

; (require 'nc)

(load-file "~/.emacs.d/manual-download/.doconce-mode.el")

(add-to-list 'load-path "~/.emacs.d/manual-download/sunrise")
(require 'sunrise)








;;;;;;;;;;;;;;;; SHORTCUTS SUMMARY
;; <f5> emacs-lisp-mode-hook
;; (global-set-key (kbd "S-s-<left>") (ignore-error-wrapper 'windmove-left))
;; (global-set-key (kbd "S-s-<right>") (ignore-error-wrapper 'windmove-right))
;; (global-set-key (kbd "S-s-<up>") (ignore-error-wrapper 'windmove-up))
;; (global-set-key (kbd "S-s-<down>") (ignore-error-wrapper 'windmove-down))
;; (define-key global-map (kbd "C-s-<left>") 'shrink-window-horizontally)
;; (global-set-key (kbd "C-s-<right>") 'enlarge-window-horizontally)
;; (global-set-key (kbd "C-s-<down>") 'shrink-window)
;; (global-set-key (kbd "C-s-<up>") 'enlarge-window)
;; (define-key comint-mode-map (kbd "<up>") 'comint-previous-input)
;; (define-key comint-mode-map (kbd "<down>") 'comint-next-input)
;; (global-set-key "\C-x\ \C-r" 'recentf-open-files)


;; (global-set-key "\C-x\ \C-g" 'TeX-view)
;; (add-hook 'LaTeX-mode-hook
;;           (lambda ()
;;             (local-set-key (kbd "C-c e") #'iw/tabular-magic)))

;; (global-set-key "\C-z\ \C-d" 'delete-latex-comments)
;; (global-set-key (kbd "C-,") #'embrace-commander)

;; (local-set-key (kbd "<C-M-tab>") 'org-global-cycle)
;; (local-set-key (kbd "<C-M-tab>") 'cd-latex-tab)

;; (global-set-key (kbd "<f4>") 'cd-to-current-buffers-dir)
;; (global-set-key (kbd "<f5>") 'python-run-in-shell)
;; (global-set-key (kbd "<f6>") 'python-run-maketest-in-shell)

;; (global-set-key (kbd "C-x 9 <down>") 'new-window-at-the-bottom)
;; (global-set-key (kbd "C-x 9 <right>") 'new-window-at-the-right)

;; :bind (("C-t" . shell-pop))

;;; GOOGLE-THIS
; -> C-c / g (z potwierdzeniem)
; -> C-c / n (bez potwierdzenia) bez cudzyslowu
; -> C-c / b (bez potwierdzenia)   z cudzyslowem

;; (global-set-key (kbd "C-x g") 'magit-status)

;; (global-set-key (kbd "C-d") 'delete-forward-char)
;; (global-set-key (kbd "C-S-d") 'delete-backward-char)

(put 'upcase-region 'disabled nil)
