(require 'emms-setup)
; (require 'emms-queue)
(require 'emms-playlist-mode)
(require 'emms-playlist-sort)
(require 'server)
; (require 'emms-cover)
(require 'emms-history)
(require 'emms-mark)
; (require 'emms-mobile-remote)
(ignore-errors ; Causes a stupid error
  (require 'thumbs))
(emms-minimalistic)

;;; FUNCTIONS
(defun emms-google-for-lyrics ()
  (interactive)
  (browse-url
   (concat "http://www.google.com/search?q="
           (replace-regexp-in-string
            " +" "+"
            (concat "lyrics "
                    (delete ?- (emms-track-description
                                (emms-playlist-current-selected-track))))))))

;; Stolen and adapted from TWB
(defun my-emms-info-track-description (track)
  "Return a description of the current track."

  (let (( pmin (emms-track-get track 'info-playing-time-min))
        ( psec (emms-track-get track 'info-playing-time-sec))
        ( ptot (emms-track-get track 'info-playing-time))
        ( art  (emms-track-get track 'info-artist))
        ( tit  (emms-track-get track 'info-title))
        ( tname (file-name-base (emms-track-get track 'name)))
        time name)
    (cond ( (and pmin psec)
            (setq time (format " [%02d:%02d]" pmin psec)))
          ( ptot
            (setq time (format " [%02d:%02d]" (/ ptot 60) (% ptot 60)))))
    (cond ( (and art tit)
            (setq name (format "%s - %s" art tit)))
          ( t (setq name tname)))
    (concat name time)))
(setq emms-track-description-function 'my-emms-info-track-description)

(defun emms-playlist-get-filename-at-point ()
  (cdr (assoc 'name (rest (emms-playlist-track-at)))))

(defun emms-playlist-dired-jump ()
  (interactive)
  (dired-jump nil (emms-playlist-get-filename-at-point)))

(defun emms-playlist-delete ()
  (interactive)
  (let (buffer-read-only)
    (if (region-active-p)
        (progn
          (expand-region-selection)
          (delete-region (region-beginning) (region-end)))
        (delete-region (line-beginning-position)
                       (min (1+ (line-end-position))
                            (point-max))))))

(defun playlist-remove-known ()
  (goto-char (point-min))
  (while (not (eobp))
    (if (looking-at "/")
        (forward-line)
        (emms-playlist-mode-kill-track))))

(defun emms-playlist-cleanup ()
  (interactive)
  (assert (eq major-mode 'emms-playlist-mode))
  (setq buffer-read-only nil)
  (save-excursion
    (goto-char (point-min))
    (while (not (= (point) (point-max)))
      (back-to-indentation)
      (if (memq (get-text-property (point) 'face)
                '(emms-browser-artist-face
                  emms-browser-album-face
                  emms-browser-year/genre-face))
          (delete-region (line-beginning-position)
                         (min (1+ (line-end-position))
                              (point-max)))
          (forward-line))))
  (setq buffer-read-only t))

(defun emms-browser-covers-thumbs (path size)
  (let (( file-name
          (concat (directory-file-name (file-name-directory path))
                  "/folder.jpg")))
    (when (file-exists-p file-name)
      (thumbs-make-thumb file-name))))

(defun emms-browser-dired-jump ()
  (interactive)
  (let* (( file1 (emms-browser-bdata-at-point))
         ( file2 (assoc 'data file1))
         ( file3 (cdr (assoc 'name (rest (car (cdr file2)))))))
    (when file3
      (dired-jump nil file3))))

(defun emms-start-server ()
  (unless (server-running-p)
    (setq server-name "emms")
    (server-start)))

(defun emms-track-description-and-time ()
  (if emms-player-playing-p
      (format "%s - %s %s"
              (emms-track-get
               (emms-playlist-current-selected-track)
               'info-artist)
              (emms-track-get
               (emms-playlist-current-selected-track)
               'info-title)
              (emms-format-time))
      ""))

(defun emms-add-dired-ask ()
  (interactive)
  (when (or (boundp 'emms-player-playing-p)
            (y-or-n-p "Start emms?"))
    (emms-add-dired)))

(defun emms-chanel-mplayer-output ()
  (let (( buffer
          (generate-new-buffer "*EMMS mplayer output*")))
    (set-process-buffer
     (get-process "emms-player-simple-process")
     buffer)))

(defun* memms-modeline ()
  (unless (emms-playlist-current-selected-track)
    (return-from memms-modeline "  -- EMMS --"))
  `(:eval
    (let (
          ( is-current
            (eq emms-playlist-buffer
                (current-buffer)))
          ( info-artist
            (emms-track-get
             (emms-playlist-current-selected-track)
             'info-artist))
          ( info-title
            (emms-track-get
             (emms-playlist-current-selected-track)
             'info-title))
          ( info-filename
            (file-name-base
             (emms-track-get
              (emms-playlist-current-selected-track)
              'name))))
      (concat
       "  "
       (when is-current
         (propertize
          "C" 'face
          'font-lock-warning-face))
       (when emms-repeat-playlist
         (propertize "R" 'face `(:weight bold)))
       " "
       (propertize
        (cond ( (and emms-player-paused-p
                     emms-player-playing-p) "||")
              ( emms-player-playing-p       ">>")
              ( t                           "[]"))
        'face 'font-lock-keyword-face)
       (when emms-player-playing-p
         (format "  \\  %s  /  %s"
                 (if (and info-artist info-title)
                     (format "%s - %s" info-artist info-title)
                     info-filename)
                 (emms-format-time)))
       ))))

(defun emms-format-time ()
  "Display playing time on the mode line."
  (let* (( min (/ emms-playing-time 60))
         ( sec (% emms-playing-time 60))
         ( total-playing-time
           (or (emms-track-get
                (emms-playlist-current-selected-track)
                'info-playing-time)
               0))
         ( total-min-only (/ total-playing-time 60))
         ( total-sec-only (% total-playing-time 60)))
    (emms-replace-regexp-in-string
     " " "0"
     (if (or emms-playing-time-display-short-p
             ;; unable to get total playing-time
             (eq total-playing-time 0))
         (format "%2d:%2d" min sec)
         (format "%2d:%2d/%2s:%2s"
                 min sec total-min-only total-sec-only)))))

(defun emms-mark-unmark-backward (arg)
  "Unmark one or more tracks and move the point past the tracks.
See `emms-mark-unmark-track' for further details."
  (interactive "p")
  (forward-line -1)
  (emms-mark-unmark-track arg))

;;; ADVICES

(defadvice emms-playing-time-display (around maybe activate)
  (when (and emms-player-playing-p
             (not emms-player-paused-p))
    ad-do-it))

(defadvice cua-cut-region (around emms-cut activate)
  (let* (( buffer-read-only
           (if (eq major-mode 'emms-playlist-mode)
               nil
               buffer-read-only)))
    (when (eq major-mode 'emms-playlist-mode)
      (expand-region-selection))
    ad-do-it))

(defadvice cua-copy-region (around emms-copy activate)
  (when (eq major-mode 'emms-playlist-mode)
    (expand-region-selection))
  ad-do-it)

(defun mu4e-win-conf-change ()
  (let (( buffers
          (remove-if-not
           'mvi-buffer-has-window-p
           (es-buffers-with-mode
            emms-playlist-default-major-mode))))
    (when buffers
        (emms-playlist-set-playlist-buffer
         (first buffers)))))

(defun music ()
  (interactive)
  (when (and (not emms-playlist-buffer)
             (es-buffers-with-mode
              emms-playlist-default-major-mode))
    (setq emms-playlist-buffer
          (first (es-buffers-with-mode
                  emms-playlist-default-major-mode))))
  (if (es-buffers-with-mode
       emms-playlist-default-major-mode)
      (switch-to-buffer emms-playlist-buffer)
      (emms))
  (unless (daemonp)
    (setq icon-title-format
          (setq frame-title-format
                '(:eval (format "=:{ EMMS%s }:="
                         (if emms-player-playing-p
                             (concat ": "
                                     (emms-track-description
                                      (emms-playlist-current-selected-track)))
                             "")
                         )))))
  (emms-start-server)
  (setq-default mode-line-format nil)
  (mapc 'emms-mark-mode
        (es-buffers-with-mode 'emms-playlist-mode)))


;;; REDEFINITIONS

(eval-after-load 'emms-playlist-mode
  '(progn
    ;; +Ignore errors
    (defun emms-playlist-mode-startup ()
      "Instigate emms-playlist-mode on the current buffer."
      ;; when there is neither a current emms track or a playing one...
      (when (not (or emms-playlist-selected-marker
                     emms-player-playing-p))
        ;; ...then stop the player.
        (emms-stop)
        ;; why select the first track?
        (when emms-playlist-buffer-p
          (ignore-errors
            (emms-playlist-select-first))))
      ;; when there is a selected track.
      (when emms-playlist-selected-marker
        (emms-playlist-mode-overlay-selected))
      (emms-with-inhibit-read-only-t
       (add-text-properties (point-min)
                            (point-max)
                            '(face emms-playlist-track-face)))
      (setq buffer-read-only t)
      (setq truncate-lines t)
      (setq buffer-undo-list nil))
    ))

(eval-after-load 'emms-queue
  '(defun emms-queue-target ()
    "Queue the track at `point'.
Append the track at point, adjusting the existing queue as necessary.
This will sort the queue so that the non-queued track is always last."
    (setq
     emms-queue-overlay-list
     (nreverse
      (if (eq emms-player-next-function 'emms-queue-or-next)
          (cons (emms-queue-add-track-overlay)
                (nreverse emms-queue-overlay-list))
          (cons (emms-queue-add-track-overlay) emms-queue-overlay-list))))))

(eval-after-load 'emms-browser
  '(defun* emms-browse-by (type)
    "Render a top level buffer based on TYPE."
    ;; FIXME: assumes we only browse by info-*
    (let* ((name (substring (symbol-name type) 5))
           (modedesc (concat "Browsing by: " name))
           (hash (emms-browser-make-hash-by type)))
      (when emms-browser-current-filter-name
        (setq modedesc (concat modedesc
                               " [" emms-browser-current-filter-name "]")))
      (when (get-buffer modedesc)
        (switch-to-buffer modedesc)
        (return-from emms-browse-by))
      ;; (emms-browser-clear)
      (emms-browser-create)
      (rename-buffer modedesc)
      (emms-browser-render-hash hash type)
      (setq emms-browser-top-level-hash hash)
      (setq emms-browser-top-level-type type)
      (unless (> (hash-table-count hash) 0)
        (emms-browser-show-empty-cache-message))
      (goto-char (point-min)))))

(define-emms-playlist-sort info-tracknumber)
(define-emms-simple-player spc '(file)
  (regexp-opt '(".spc" ".SPC")) "ospc" "-l" "-t " "3:00")


(emms-mode-line-disable)
(emms-playing-time-disable-display)
(emms-history-load)

(defun emms-source-add (source &rest args)
  "Add the tracks of SOURCE at the current position in the playlist."
  (let* (( window-buffers
           (mapcar 'window-buffer (window-list)))
         ( emms-playlists
           (emms-playlist-buffer-list))
         ( visible-emms-buffers
           (cl-intersection
            window-buffers
            emms-playlists))
         ( emms-playlist-buffer
           (cond ( (or (not visible-emms-buffers)
                       (memq emms-playlist-buffer
                             visible-emms-buffers))
                   emms-playlist-buffer)
                 ( t (car visible-emms-buffers)))))
    ;; Could be defadvice
    (with-current-emms-playlist
      (save-excursion
        (goto-char (point-max))
        (apply 'emms-playlist-current-insert-source source args))
      (when (or (not emms-playlist-selected-marker)
                (not (marker-position emms-playlist-selected-marker)))
        (emms-playlist-select-first)))))

(provide 'emms-opts) 
