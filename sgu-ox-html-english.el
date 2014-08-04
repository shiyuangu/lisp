;;; sgu-ox-html-english.el : org-backend for html-English.

;; Copyright (C) 2014  S. Gu

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

;;; Commentary: A backend derived from 'html to make some words pop out. 

;; 

;;; Code:

;; This backend overrides transcodes for HTML types/elements. 
(org-export-define-derived-backend 'sgu-html-enlish 'html
  :translate-alist '((bold . sgu-org-html-english-bold))
   :menu-entry
  '(?E "Export to HTML-ENGLISH"
       ((?H "As HTML buffer" sgu-org-html-english-export-as-html)
		(?h "As HTML file" sgu-org-html-english-export-to-html)
		(?o "As HTML file and open"
	    (lambda (a s v b)
	      (if a (sgu-org-html-english-export-to-html t s v b)
			(org-open-file (sgu-org-html-english-export-to-html nil s v b)))))
	)))

(defun sgu-org-html-english-export-as-html
  (&optional async subtreep visible-only body-only ext-plist)
 "This is almost copied from org-html-export-as-html except using sgu newly defined backend"
  (interactive)
  (org-export-to-buffer 'sgu-html-enlish "*Org HTML-ENG Export*"
    async subtreep visible-only body-only ext-plist
    (lambda () (set-auto-mode t))))

(defun sgu-org-html-english-export-to-html
  (&optional async subtreep visible-only body-only ext-plist)
  "See docstring of org-html-export-to-html"
  (interactive)
  (let* ((extension (concat "." (or (plist-get ext-plist :html-extension)
				    org-html-extension
				    "html")))
	 (file (org-export-output-file-name extension subtreep))
	 (org-export-coding-system org-html-coding-system))
    (org-export-to-file 'sgu-html-enlish file
      async subtreep visible-only body-only ext-plist)))

(defun sgu-org-html-english-bold (bold contents info)
  "Transcode BOLD from Org to HTML. Intead of using ordinary bold, we use color to highlight the 
CONTENTS is the text with bold markup.  INFO is a plist holding
contextual information."
  (format "<i><b><span style=\"color: #ff0000\"> %s </span></b></i>"
	  contents))

(provide 'sgu-ox-html-english)
;;; sgu-ox-html-english.el ends here
