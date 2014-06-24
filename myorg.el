;;; myorg.el --- My customization of org-mode

;; Copyright (C) 2014  Gu

;; Author: Gu <shiyuang@685b35881646.ant.amazon.com>
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
(require 'htmlize)
(require 'myess)
;;active Babel languages
(package-initialize)
(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
   (emacs-lisp . t)
   (latex . t)
   (R . t)))
;(setq python-shell-interpreter "ipython")
;; (setq python-shell-interpreter-args "--pylab")
;(setq org-babel-python-command "ipython --no-banner --classic --no-confirm-exit")e

(setq org-image-actual-width nil)

(provide 'myorg)
;;; myorg.el ends here
