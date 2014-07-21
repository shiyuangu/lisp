;;; myxml.el --- my xml related packages and customization

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

(setq org2blog/wp-blog-alist
      '(("wordpress"
         :url "http://shiyuangu.wordpress.com/xmlrpc.php"
         :username "shiyuangu"
         :default-title "Hello World"
         :default-categories ("default-sub" "default")
         :tags-as-categories nil)
        ("my-blog"
         :url "http://username.server.com/xmlrpc.php"
         :username "admin")))

(setq org2blog/wp-buffer-template
 "-----------------------
#+TITLE: %s
#+DATE: %s
-----------------------\n")

(defun my-format-function (format-string)
   (format format-string
           org2blog/wp-default-title
           (format-time-string "%d-%m-%Y" (current-time))))

(setq org2blog/wp-buffer-format-function 'my-format-function)

(provide 'myxml)
;;; myxml.el ends here
