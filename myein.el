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

;;; Commentary: This file is  a refactor of zeroin.el in EIN; 

;; 

;;; Code:

;;setup websocket; use git repos;this fixes some ein issues for ipython 2.x as in https://github.com/tkf/emacs-ipython-notebook/issues/146
(add-to-list 'load-path "~/.emacs.d/emacs-websocket")
(require 'websocket)

(add-to-list 'load-path "~/.emacs.d/emacs-request")
(require 'request)

;; change to point to ein source
(defvar ein-root-dir "~/.emacs.d/emacs-ipython-notebook/")


(add-to-list 'load-path (concat ein-root-dir "lisp"))
;;; the following line is needed for commit 28a0c53 in repos git@github.com:millejoh/emacs-ipython-notebook.git
(require 'ein-loaddefs)
(eval-when-compile (require 'ein-notebooklist))
(require 'ein)

;; setup auto-complete
;; run `sudo git submodule update --init` regularly to update the dict
(setq ein:use-auto-complete-superpack t)
(unless (featurep 'auto-complete-config)
  (require 'auto-complete-config)
  (ac-config-default))
(add-to-list 'ac-dictionary-files (concat ein-root-dir "lib/auto-complete/dict"))

;; This is suggested in http://tkf.github.io/emacs-ipython-notebook/#jedi-el;;;
;; Is it compatible with my personal setup myjedi.el? 
(add-hook 'ein:connect-mode-hook 'ein:jedi-setup)

(provide 'myein)
;;; myein.el ends here
