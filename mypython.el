;;; mypython.el --- setup for python 

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

;; Prerequisite: myjedi.el 

;;; Code:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; sgu: the following session is commented since emacs built-in python mode (python.el) seems to have problems echoing commands in the shell when sending-region.   
;(require 'python)

;; my personal jedi setup. Is it compatible with ein:jedi-setup? 
;; myjedi key setup shadows the ein:jedi-setup
;(require 'myjedi)
;(add-hook 'python-mode-hook 'jedi:setup)
;(add-hook 'python-mode-hook 'jedi-config:setup-keys)

;;;;;;;;the following is taken from python.el by Fabian E. Gallina;;;;;
;;;;; This completion uses ipython auto-completion feature provided by the module_completion("import scipy.") and get_ipython().completer.all_completions(); But the autocomplete only works in the python shell. 
;; (setq
;;   python-shell-interpreter "ipython"
;;   python-shell-interpreter-args ""
;;   python-shell-prompt-regexp "In \\[[0-9]+\\]: "
;;   python-shell-prompt-output-regexp "Out\\[[0-9]+\\]: "
;;   python-shell-completion-setup-code
;;     "from IPython.core.completerlib import module_completion"
;;   python-shell-completion-module-string-code
;;     "';'.join(module_completion('''%s'''))\n"
;;   python-shell-completion-string-code
;;     "';'.join(get_ipython().Completer.all_completions('''%s'''))\n")

;; ;;;;setup ein;;;;;;
;; (require 'myein)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq py-install-directory "/hom/sgu/python-mode")
(add-to-list 'load-path py-install-directory)
(require 'python-mode) ;use autoload instead http://emacswiki.org/emacs/ProgrammingWithPythonModeDotEl
(setq py-shell-name "ipython")
(define-key python-mode-map (kbd "C-c C-x p") (lambda()(interactive) (py-execute-statement) (py-forward-statement)))
(setq py-keep-windows-configuration t) ;; avoid messing up the layout after execution. 
;(autoload 'python-mode "python-mode" "Python Mode." t)
;(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
;(add-to-list 'interpreter-mode-alist '("python" . python-mode))

(provide 'mypython)
;;; mypython.el ends here









