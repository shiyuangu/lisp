;;; myein.el --- setup emacs-ipython-notebook

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

;;; Commentary:

;; 

;;; Code:

;;setup websocket; use git repos;this fixes some ein issues for ipython 2.x as in https://github.com/tkf/emacs-ipython-notebook/issues/146
(add-to-list 'load-path "~/.emacs.d/emacs-websocket")
(require 'websocket)

(add-to-list 'load-path "/Users/shiyuang/.emacs.d/emacs-request")
(require 'request)

(add-to-list 'load-path "~/.emacs.d/emacs-ipython-notebook/lisp")
(require 'ein)

(provide 'myein)
;;; myein.el ends here
