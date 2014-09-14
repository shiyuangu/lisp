;;; myjedi.el ---  setup for jedi for python development. 

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

;;; Commentary: Cf. https://github.com/shiyuangu/jedi-starter.git

;;  Prerequisite: auto-complete(from ELPA)
;;  TODO: integrate with Projectile: https://github.com/shiyuangu/jedi-starter.git

;;; Code:

;;;;;;;;for jedi;;;;;;;
;; This should be after auto-complete
;; Install the following pacakges from melpa: (jedi auto-complete popup python-environment epc ctable concurrent deferred)
;; `M-x jedi:show-setup-info` shows the configuratiosn in the buffer *jedi:show-setup-info* 
(require 'jedi)

;; Now hook everything up
;; Hook up to autocomplete
(add-to-list 'ac-sources 'ac-source-jedi-direct)

(defun jedi-config:setup-keys ()
      (local-set-key (kbd "M-.") 'jedi:goto-definition)
      (local-set-key (kbd "M-,") 'jedi:goto-definition-pop-marker)
      (local-set-key (kbd "M-?") 'jedi:show-doc)
      (local-set-key (kbd "M-/") 'jedi:get-in-function-call))

;; Don't let tooltip show up automatically
(setq jedi:server-args '("--log-traceback")) ;; turn on log-traceback
(setq jedi:get-in-function-call-delay 10000000)
(setq jedi:complete-on-dot t)                 ; optional

;;(add-hook 'python-mode-hook 'jedi:setup)
;;(add-hook 'python-mode-hook 'jedi-config:setup-keys)
(provide 'myjedi)
;;; myjedi.el ends here
