;;; sgu.el --- some convenient functions, global keymaps, and helper function which might be used in other packages. 

;; Copyright (C) 2013  S. Gu

;; Author: S. Gu <shiyuangu@gmail.com>
;; Keywords: 

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; 

;;; Code:


;; (require 'browse-url)
;; ;;;;;credit goes to dim-google.el
;; (defun dim:google (keywords)
;;   "Form a google query URL and give it to browse-url"
;;   (interactive 
;;    (list
;;     (if (use-region-p)
;; 	(buffer-substring (region-beginning) (region-end))
;;       (read-string "Search google for: " (thing-at-point 'word)))))


;;   (browse-url 
;;    (read-string "Browse google URL: " 
;; 		(concat "http://www.google.com/search?q=" 
;; 			(replace-regexp-in-string 
;; 			 "[[:space:]]+"
;; 			 "+"
;; 			 keywords)))))
;; (defun sgu-wikilize-link (beg end)
;;   "Url-encode wiki special characters [] {}"
;;   (interactive (if (use-region-p)
;; 			       (list (region-beginning) (region-end))
;; 				   (list nil nil)))
;;   (if (and beg end)
;; 	  (progn
;; 		(replace-string "{" "%7B" nil beg end)
;; 		(replace-string "}" "%7D" nil beg end)
;; 		(replace-string "[" "%5B" nil beg end)
;; 		(replace-string "]" "%5D" nil beg end))
;; 	  (message "Please define a region")))

;; (global-set-key (kbd "\e\eg") 'dim:google)
;; (global-set-key (kbd "\e\el") 'goto-line)
;  (global-set-key (kbd "\e\ew") 'sgu-wikilize-link)

(defun sgu-toggle-visual-line ()
  (interactive)
  "Toggle line-move-visual. When line-move-visual is non-nil, next-line(C-n) will move to next logical line instead of next visual line."
  (setq line-move-visual (not line-move-visual))
)

;; the following function is taken from 
;;https://stackoverflow.com/questions/1587972/how-to-display-indentation-guides-in-emacs/4459159#4459159
(defun sgu-toggle-fold ()
  "Toggle fold all lines larger than indentation on current line.
   This is intended for python-mode, yaml-mode which use spaces for
   indentation"
  (interactive)
  (let ((col 1))
    (save-excursion
      (back-to-indentation)
      (setq col (+ 1 (current-column)))
      (set-selective-display
       (if selective-display nil (or col 1))))))
;;(global-set-key [(M C i)] 'sgu-toggle-fold) ;; this seems not working due to other mode often overwrote this key.

;;
(defun sgu-org-insert-img-from-clipboard ()
"create an png image from the clipboard(MacOS) and insert the link. Make sure the sgu-paste-img is executable and is in PATH 
The image will be displayed immediately once inserted. 
We can toggle the display of images by org-toggle-inline-images 
We can also open the image link externally via C-u C-u C-c C-o (org-open-at-point)
Cf: https://www.reddit.com/r/emacs/comments/8wikaj/paste_image_from_clipboard_on_both_mac_pc"
	  (interactive)
	  (setq sgu/org-insert-folder-path (concat default-directory "img/")) ;make the img directory
	  (if (not (file-exists-p sgu/org-insert-folder-path))
		  (mkdir sgu/org-insert-folder-path)) ;create the directory if it doesn't exist
	  (let* ((img-file (format-time-string "%Y%m%d-%H.%M.%S"))
			 (img-file-abs (concat sgu/org-insert-folder-path img-file)) 
			 (exit-status
			  (call-process "sgu-paste-img" nil nil nil img-file-abs)))
	   (if (and (integerp exit-status) (= 0 exit-status))
		   (org-insert-link nil (concat "file:" "img/" img-file ".png") "")
		 (message "sgu-paste-img is unsuccessful to paste to  %s" img-file-abs))))

(defun sgu-buffer-fileline-at-point()
  (interactive)
  "print filename:line_no to clipboard"
  (kill-new (message "%s:%d" (buffer-file-name) (count-lines 1 (point)))))

;;;;;;;;;swap C-j and C-m; by Gu;;;;;;;;;;;;;;;;;;;;
(defun sgu-swap-cj-cm ()
  (local-set-key (kbd "C-m") 'newline-and-indent)
  (local-set-key (kbd "C-j") 'newline))

(defun sgu/send-line-or-region-terminal ()
"Send line or region to the buffer named *terminal* and then send the carriage return
If the buffer is in terminal mode and its input mode is line, then this command simply 
send and execute. 
Cf: https://emacs.stackexchange.com/questions/24190/send-orgmode-sh-babel-block-to-eshell-term-in-emacs"
(interactive)
(if (use-region-p) 
  (append-to-buffer (get-buffer "*terminal*") (mark)(point))
  (let (p1 p2)
    (setq p1 (line-beginning-position))
    (setq p2 (line-end-position))
    (append-to-buffer (get-buffer "*terminal*") p1 p2)
  ))
  (let (b)
    (setq b (get-buffer (current-buffer)))
    (switch-to-buffer-other-window (get-buffer "*terminal*"))
    (execute-kbd-macro "\C-m")
    (switch-to-buffer-other-window b)))

(defun sgu/new-scratch-buffer-in-org-mode ()
  (interactive)
  (switch-to-buffer (generate-new-buffer-name "*temp*"))
  (org-mode))

;;;;;;;; begin: url processing helpers
;; Cf: https://stackoverflow.com/questions/611831/how-can-i-url-decode-a-string-in-emacs-lisp
(defun sgu-func-region (start end func)
  "run a function over the region between START and END in current buffer."
  (save-excursion
    (let ((text (delete-and-extract-region start end)))
      (insert (funcall func text)))))

(defun sgu-url-encode-region (start end)
  "urlencode the region between START and END in current buffer."
  (interactive "r")
  (sgu-func-region start end #'url-hexify-string))

(defun sgu-url-decode-region (start end)
  "de-urlencode the region between START and END in current buffer."
  (interactive "r")
  (sgu-func-region start end #'url-unhex-string))

;;;;;;;; end: url processing helpers 

(provide 'sgu)
;;; sgu.el ends here
