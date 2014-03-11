;;; ion-mode.el --- 

;; Copyright (C) 2014  Shiyuan Gu


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
;; This mode is based on json-mode and modified for the ion files used
;; internally at Amazon. 

;; 

;;; Code:
(require 'json-mode)

;;;###autoload
(define-derived-mode ion-mode json-mode "ION"
  "Major mode for editing ION files")

(add-hook 'ion-mode-hook
		  (lambda()
			(font-lock-add-keywords nil
									'(("\\<\\(\\(?:null\\|bool\\|int\\|float\\|decimal\\|timestamp\\|string\\|symbol\\|blob\\|clob\\|struct\\|list\\|sexp\\)\\)\\>" 1 'font-lock-type-face t)
									  ("\\<\\(define\\|override\\|exist\\|andp\\|and\\|or\\|not\\|if\\)\\>" 0 'font-lock-keyword-face t)))))
(provide 'ion-mode)
;;; ion-mode.el ends here
