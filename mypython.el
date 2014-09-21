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

(require 'python)
;;;;;;;;;;;;;;;;;setup Jedi;;;;;;;;;;;;;;;;;
;; (require 'myjedi)
;; (add-hook 'python-mode-hook 'jedi:setup)
;; (add-hook 'python-mode-hook 'jedi-config:setup-keys)

;;;;;;;;the following is taken from python.el by Fabian E. Gallina;;;;;
;;;;; This completion uses ipython auto-completion feature provided by the module_completion("import scipy.") and get_ipython().completer.all_completions()
(setq
  python-shell-interpreter "ipython"
  python-shell-interpreter-args ""
  python-shell-prompt-regexp "In \\[[0-9]+\\]: "
  python-shell-prompt-output-regexp "Out\\[[0-9]+\\]: "
  python-shell-completion-setup-code
    "from IPython.core.completerlib import module_completion"
  python-shell-completion-module-string-code
    "';'.join(module_completion('''%s'''))\n"
  python-shell-completion-string-code
    "';'.join(get_ipython().Completer.all_completions('''%s'''))\n")

;;;;setup ein;;;;;;
(require 'myein)


(provide 'mypython)
;;; mypython.el ends here
