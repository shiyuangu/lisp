;;; myblog.el --- setup blog

;; Copyright (C) 2014  Gu

;; Author: Gu <shiyuangu@gmail.com>
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
(add-to-list 'load-path "~/org2blog/")
(add-to-list 'load-path "~/metaweblog/")
(require 'org2blog-autoloads)
(require 'ox-wp) ;;this line is needed since we need to override a function later
(require 'sgu-ox-html-english)

(setq org2blog/wp-use-sourcecode-shortcode t)
(setq org2blog/wp-blog-alist
      '(("wordpress"
         :url "http://shiyuangu.wordpress.com/xmlrpc.php"
         :username "shiyuangu"
         :default-title "ADDME"
         :default-categories ("default-sub" "default")
         :tags-as-categories nil)))

(setq org2blog/wp-buffer-template
 "-----------------------
#+TITLE: %s
#+DATE: %s
#+CATEGORY: %s
-----------------------\n")

(defun sgu-format-function (format-string)
   (format format-string
           "ADDME"
           ""
		   ""))

;;Enable wordpress's sourcecode shortcode blocks; Use 'wp backend to use
(setq org2blog/wp-buffer-format-function 'sgu-format-function) 

;;a convenient function for inserting the blog template
(defun sgu-wp-insert-template()
  "A convenient function to insert the blog template"
  (interactive)
  (insert (funcall org2blog/wp-buffer-format-function org2blog/wp-buffer-template)))


;; Redefine org-wp-export-as-wordpress in ox-wp.el
;;; Define Back-End
;;; the transcoders are defined in ox-wp.el
(org-export-define-derived-backend 'sgu-wp-english 'sgu-html-enlish
  :translate-alist '((src-block . org-wp-src-block)
                     (example-block . org-wp-src-block)
                     (latex-environment . org-wp-latex-environment)
                     (latex-fragment . org-wp-latex-fragment))
  :filters-alist '(
                   (:filter-paragraph . org-wp-filter-paragraph)
                   ))

(defun org-wp-export-as-wordpress (&optional async subtreep ext-plist)
  "(Redefined by sgu. The original one is defined in ox-wp.el)
Export current buffer to a text buffer.

If narrowing is active in the current buffer, only export its
narrowed part.

If a region is active, export that region.

A non-nil optional argument ASYNC means the process should happen
asynchronously.  The resulting buffer should be accessible
through the `org-export-stack' interface.

When optional argument SUBTREEP is non-nil, export the sub-tree
at point, extracting information from the headline properties
first.

Export is done in a buffer named \"*Org WP Export*\", which will
be displayed when `org-export-show-temporary-export-buffer' is
non-nil."
  (interactive)
  (let (choice)
	(setq choice (string-to-int (read-string " 1-wp-html; 2-wp-english;3-html Please choose:")))
	(cond
	 ((= choice 1) (org-export-to-buffer 'wp "*Org WP Export*"
    async subtreep nil t ext-plist (lambda () (html-mode))))
	 ((= choice 2) (org-export-to-buffer 'sgu-wp-english "*Org WP Export*"
    async subtreep nil t ext-plist (lambda () (html-mode))))
	 ((= choice 3) (org-export-to-buffer 'html "*Org WP Export*"
    async subtreep nil t ext-plist (lambda () (html-mode))))
	 (t (error "Unknow chose %d" choice)))))


(provide 'myblog)
;;; myxml.el ends here
