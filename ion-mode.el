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
;; This mode is for editing ion files used internally at Amazon.
;; It supports (partially) Datapath 2.0 query language. 

;; 

;;; Code:

;;; Define some variables 
(defconst ion-datatype
  (regexp-opt '("null" "bool" "int" "float"
				"decimal" "timestamp" "string" "symbol"
				"blob" "clob" "struct" "list" "sexp") 'words) "Ion data types")
(defconst ion-keywords
  (regexp-opt '("define" "exist" "and" "andp"
				"or" "quote" "now" "count" 
				"if" "ifexist" "override"
				"min" "max" "sum" "sort"
				"set" "bitset" "annotation") 'words) "Ion keywords")

 (defvar ion-font-lock-keywords
   (list `(,ion-datatype . font-lock-type-face)
		 `(,ion-keywords . font-lock-keyword-face))
   "Font lock for ion-mode")

(defvar ion-mode-syntax-table
  (let ((ion-mode-syntax-table (make-syntax-table)))
	
    ; This is added so entity names with underscores can be more easily parsed
	(modify-syntax-entry ?- "w" ion-mode-syntax-table)
	
	; Comment styles are same as C++
	(modify-syntax-entry ?/ ". 124b" ion-mode-syntax-table)
	(modify-syntax-entry ?* ". 23" ion-mode-syntax-table)
	(modify-syntax-entry ?\n "> b" ion-mode-syntax-table)
	ion-mode-syntax-table)
  "Syntax table for ion-mode")

(defun ion-insert-tab (&optional arg)
  "A wrapper for insert-tab to allow interactive call"
  (interactive "P")
  (insert-tab arg))

(defvar ion-mode-map
  (let ((ion-mode-map (make-keymap)))
    (define-key ion-mode-map "\t" 'ion-insert-tab)
    ion-mode-map)
  "Keymap for ion major mode")

;;;###autoload
(define-derived-mode ion-mode prog-mode "ION"
  "Major mode for editing ION files"
  ;The follows codes will run before all hooks and parents' mode's hook
  (message "running ion-mode code....")
  (use-local-map ion-mode-map)
  (set (make-local-variable 'font-lock-defaults) '(ion-font-lock-keywords))
  (set-syntax-table ion-mode-syntax-table))

(setq-default tab-width 4)
(defun my-indent-setup()
  ;(setq c-basic-offset 4)
  (setq indent-tabs-mode nil)) ;;inserting tab is not allowed

(add-hook 'ion-mode-hook 'my-indent-setup)

(provide 'ion-mode)
;;; ion-mode.el ends here
