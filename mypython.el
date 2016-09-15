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
(setq py-install-directory "/home/sgu/python-mode")
(add-to-list 'load-path py-install-directory)
(require 'python-mode) ;use autoload instead http://emacswiki.org/emacs/ProgrammingWithPythonModeDotEl
(setq py-shell-name "ipython")  ;; sgu:refer to py-switch-shell function in python-model.el
(define-key python-mode-map (kbd "C-c C-x p") (lambda()(interactive) (py-execute-statement) (py-forward-statement)))
(setq py-keep-windows-configuration t) ;; avoid messing up the layout after execution. 
;(autoload 'python-mode "python-mode" "Python Mode." t)
;(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
;(add-to-list 'interpreter-mode-alist '("python" . python-mode))

;;; Set up Jedi 
;;; To setup Emacs-Jedi, follows: 
;;; https://github.com/tkf/emacs-jedi 
;;; http://tkf.github.io/emacs-jedi/latest/
;;; TODO: python-enviroment.el is a listed requirement, but has errors when installed through install-package which complains the deferred.el. As of 10/11/2015 Not set-up to use virtualenv yet. https://github.com/shiyuangu/jedi-starter suggests use (setq jedi-config:use-system-python t); however, jedi-config:use-system-python seems no longer in the code as of jedi.el version 0.2.5 and jedi-core.el version 0.2.5

;(add-hook 'python-mode-hook 'jedi:setup)
;(setq jedi:complete-on-dot t)      ;optional; sgu: this redefines the key "."
;(setq jedi:use-shortcuts t) ;; enable the following shortcut M-. jedi:goto-definition; M-, jedi:goto-definition-pop-marker
;(setq jedi:server-args '("--log-traceback")) ; sgu: run: jedi:pop-to-epc-buffer to open the EPC traceback in EPC buffer. 
;(setq jedi:server-args '("--log-level" "DEBUG" "--log" "/home/sgu/tmp/jedi.log")) ;Turn on for debug; very slow!
;(setq jedi:tooltip-method nil) ; use eldoc-style instead of popup-style
(provide 'mypython)
;;; mypython.el ends here









