;;; mypython-simple.el --- Simple python setup;

;; Copyright (C) 2014  Shiyuan Gu

;; Author: Shiyuan Gu <shiyuang@amazon.com>
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

;;; Commentary: This file provides basic setup for python. It doesn't depend on any third party packages. Use mypython.el for full-fledged IDE like features.  

;; 

;;; Code:
(defun mypython-simple-setup() 
  "use mypython.el for full-fledged IDE like features"
  (interactive)
  (define-key python-mode-map "\C-\M-n" 'python-nav-end-of-block)
 (define-key python-mode-map "\C-\M-p" 'python-nav-beginning-of-block))

(add-hook 'python-mode-hook 'mypython-simple-setup)
(provide 'mypython-simple)
;;; mypython-simple.el ends here
