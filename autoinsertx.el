;;; autoinsertx.el --- an extension of autoinsert by S. Gu

;; Copyright (C) 2013  S. Gu

;; Author: S. Gu <sgu@anl.gov>
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



(provide 'autoinsertx)

(require 'autoinsert)
(eval-after-load 'autoinsert
  '(define-auto-insert "\.package" "template.package"))
(eval-after-load 'autoinsert
  '(define-auto-insert "\.cfgx" "template.cfgx"))
(eval-after-load 'autoinsert
  '(define-auto-insert "\.pbs" "template.pbs"))

;;modified the auto-insert in latex-mode to includes standard amsmath packages
(add-to-list 'auto-insert-alist
	     '(latex-mode
     ;; should try to offer completing read for these
     "options, RET: "
     "\\documentclass[" str & ?\] | -1
     ?{ (read-string "class: ") "}\n"
     "\\usepackage{amsmath}\n"
     "\\usepackage{amssymb}\n"
     ("package, %s: "
      "\\usepackage[" (read-string "options, RET: ") & ?\] | -1 ?{ str "}\n")
     _ "\n\\begin{document}\n" _
     "\n\\end{document}"))
(add-to-list 'auto-insert-alist
      '(gnumodules-mode
        ;;;	
	"Some string"
	"#\%Module1.0\n"
	"#setenv\n"
	"#prepend-path\n"))
  
;;; autoinsertx.el ends here
