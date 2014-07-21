;;; myhelpers.el --- some helper functions and global keymap for myself. 

;; Copyright (C) 2013  S. Gu

;; Author: S. Gu <sgu@anl.gov>
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

(require 'browse-url)


;;;;;credit goes to dim-google.el
(defun dim:google (keywords)
  "Form a google query URL and give it to browse-url"
  (interactive 
   (list
    (if (use-region-p)
	(buffer-substring (region-beginning) (region-end))
      (read-string "Search google for: " (thing-at-point 'word)))))


  (browse-url 
   (read-string "Browse google URL: " 
		(concat "http://www.google.com/search?q=" 
			(replace-regexp-in-string 
			 "[[:space:]]+"
			 "+"
			 keywords)))))

(global-set-key (kbd "C-c g") 'dim:google)
(global-set-key (kbd "\e\el") 'goto-line)

(defun sgu-toggle-visual-line ()
  (interactive)
  "Toggle line-move-visual"
  (setq line-move-visual (not line-move-visual))
)

(provide 'myhelpers)
;;; myhelpers.el ends here
