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

;;;###autoload
(define-derived-mode ion-mode c++-mode "ION"
  "Major mode for editing ION files"
  (set (make-local-variable 'font-lock-defaults) '(ion-font-lock-keywords)))

(provide 'ion-mode)
;;; ion-mode.el ends here
