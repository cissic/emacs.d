;;; easy-hugo-autoloads.el --- automatically extracted autoloads (do not edit)   -*- lexical-binding: t -*-
;; Generated by the `loaddefs-generate' function.

;; This file is part of GNU Emacs.

;;; Code:

(add-to-list 'load-path (or (and load-file-name (directory-file-name (file-name-directory load-file-name))) (car load-path)))



;;; Generated autoloads from easy-hugo.el

(autoload 'easy-hugo-article "easy-hugo" "\
Open a list of articles written in hugo with dired." t)
(autoload 'easy-hugo-magit "easy-hugo" "\
Open magit at current blog." t)
(autoload 'easy-hugo-image "easy-hugo" "\
Generate image link." t)
(autoload 'easy-hugo-figure "easy-hugo" "\
Generate figure shortcode." t)
(autoload 'easy-hugo-put-image "easy-hugo" "\
Move image to image directory and generate image link." t)
(autoload 'easy-hugo-put-figure "easy-hugo" "\
Move image to image directory and generate figure shortcode." t)
(autoload 'easy-hugo-pull-image "easy-hugo" "\
Pull image from internet to image directory and generate image link." t)
(autoload 'easy-hugo-pull-figure "easy-hugo" "\
Pull image from internet to image directory and generate figure shortcode." t)
(autoload 'easy-hugo-publish-clever "easy-hugo" "\
Clever publish command.
Automatically select the deployment destination from init.el." t)
(autoload 'easy-hugo-publish "easy-hugo" "\
Adapt local change to the server with hugo." t)
(autoload 'easy-hugo-publish-timer "easy-hugo" "\
A timer that publish after the N number of minutes has elapsed.

(fn N)" t)
(autoload 'easy-hugo-cancel-publish-timer "easy-hugo" "\
Cancel timer that publish after the specified number of minutes has elapsed." t)
(autoload 'easy-hugo-firebase-deploy "easy-hugo" "\
Deploy hugo at firebase." t)
(autoload 'easy-hugo-firebase-deploy-timer "easy-hugo" "\
A timer that firebase deploy after the N number of minutes has elapsed.

(fn N)" t)
(autoload 'easy-hugo-cancel-firebase-deploy-timer "easy-hugo" "\
Cancel timer that firebase deploy after the specified number of minutes has elapsed." t)
(autoload 'easy-hugo-newpost "easy-hugo" "\
Create a new post with hugo.
POST-FILE needs to have and extension '.md' or '.org' or '.ad' or '.rst' or '.mmark' or '.html'.

(fn POST-FILE)" t)
(autoload 'easy-hugo-preview "easy-hugo" "\
Preview hugo at localhost." t)
(autoload 'easy-hugo-current-time "easy-hugo" "\
Generate current time in date format at the frontmatter." t)
(autoload 'easy-hugo-slugify "easy-hugo" "\
Slugify the region from START to END.

(fn START END)" t)
(autoload 'easy-hugo-github-deploy "easy-hugo" "\
Execute `easy-hugo-github-deploy-script' script locate at `easy-hugo-basedir'." t)
(autoload 'easy-hugo-github-deploy-timer "easy-hugo" "\
A timer that github-deploy after the N number of minutes has elapsed.

(fn N)" t)
(autoload 'easy-hugo-cancel-github-deploy-timer "easy-hugo" "\
Cancel timer that github-deploy after the specified number of minutes has elapsed." t)
(autoload 'easy-hugo-amazon-s3-deploy "easy-hugo" "\
Deploy hugo source at Amazon S3." t)
(autoload 'easy-hugo-amazon-s3-deploy-timer "easy-hugo" "\
A timer that amazon-s3-deploy after the N number of minutes has elapsed.

(fn N)" t)
(autoload 'easy-hugo-cancel-amazon-s3-deploy-timer "easy-hugo" "\
Cancel timer that amazon-s3-deploy after the specified number of minutes has elapsed." t)
(autoload 'easy-hugo-google-cloud-storage-deploy "easy-hugo" "\
Deploy hugo source at Google Cloud Storage." t)
(autoload 'easy-hugo-google-cloud-storage-deploy-timer "easy-hugo" "\
A timer that google-cloud-storage-deploy after the N number of minutes has elapsed.

(fn N)" t)
(autoload 'easy-hugo-cancel-google-cloud-storage-deploy-timer "easy-hugo" "\
Cancel timer that google-cloud-storage-deploy after the specified number of minutes has elapsed." t)
(autoload 'easy-hugo-ag "easy-hugo" "\
Search for blog article with `counsel-ag' or `helm-ag'." t)
(autoload 'easy-hugo-rg "easy-hugo" "\
Search for blog article with `counsel-rg' or `consult-ripgrep'." t)
(autoload 'easy-hugo-open-config "easy-hugo" "\
Open Hugo's config file." t)
(autoload 'easy-hugo-complete-tags "easy-hugo" "\
Auto-complete tags from your posts." t)
(autoload 'easy-hugo-complete-categories "easy-hugo" "\
Auto-complete categories from your posts." t)
(autoload 'easy-hugo-select-blog "easy-hugo" "\
Select blog url you want to go." t)
(autoload 'easy-hugo-select-postdir "easy-hugo" "\
Select postdir you want to go." t)
(autoload 'easy-hugo-select-filename "easy-hugo" "\
Select filename you want to open." t)
(autoload 'easy-hugo "easy-hugo" "\
Easy hugo mode." t)
(autoload 'easy-hugo-enable-menu "easy-hugo" "\
Enable transient menu for easy-hugo-mode." t)
(register-definition-prefixes "easy-hugo" '("easy-hugo-"))


;;; Generated autoloads from easy-hugo-transient.el

(register-definition-prefixes "easy-hugo-transient" '("easy-hugo-menu--header"))

;;; End of scraped data

(provide 'easy-hugo-autoloads)

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; no-native-compile: t
;; coding: utf-8-emacs-unix
;; End:

;;; easy-hugo-autoloads.el ends here
