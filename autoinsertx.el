;;; autoinsertx.el --- Wrapper of autoinsert with some specific setting
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

(require 'autoinsert)
(setq auto-insert t) ;;; mark region as modified if t
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
     "\\usepackage{amsthm}\n"
     "\\usepackage{graphicx}\n"
     ("package, %s: "
      "\\usepackage[" (read-string "options, RET: ") & ?\] | -1 ?{ str "}\n")
      "\n\\begin{document}\n" _
     "\n\\end{document}"))
(add-to-list 'auto-insert-alist
      '(gnumodules-mode
        ;;;	
	"Some string"
	"%%%"
	"#setenv\n"
	"#prepend-path\n"))

(add-to-list 'auto-insert-alist
      '(matlab-mode
        ;;;	
	"Short description: "
	"% " (file-name-nondirectory (buffer-file-name)) " --- " str "\n"
        "% Copyright (C)" (substring (current-time-string) -4) "  "
        (getenv "ORGANIZATION") | (progn user-full-name) "\n"
	"% author: " (user-full-name)
	'(if (search-backward "&" (line-beginning-position) t)
	     (replace-match (capitalize (user-login-name)) t t))
	'(end-of-line 1) " <" (progn user-mail-address) ">\n" 
	 "% brief:\n"))

(add-to-list 'auto-insert-alist
      '(("\\.sh" . "shell script")	
	"Short description: "
	"#!/usr/bin/env bash"
	"# " (file-name-nondirectory (buffer-file-name)) " --- " str "\n"
        "# Copyright (C)" (substring (current-time-string) -4) "  "
        (getenv "ORGANIZATION") | (progn user-full-name) "\n"
	"# author: " (user-full-name)
	'(if (search-backward "&" (line-beginning-position) t)
	     (replace-match (capitalize (user-login-name)) t t))
	'(end-of-line 1) " <" (progn user-mail-address) ">\n" 
	 "# brief:\n"))

 ;;The following customize the c template in autoinsert.el 
(add-to-list 'auto-insert-alist
     '(("\\.\\([Cc]\\|cc\\|cpp\\)\\'" . "C / C++ program")
     "Short description: "
       "/*" \n
       (file-name-nondirectory (buffer-file-name))
       " -- " str \n
       " */" > \n \n
       "#include <iostream>" \n
     "#include \""
     (let ((stem (file-name-sans-extension buffer-file-name)))
       (cond ((file-exists-p (concat stem ".h"))
	      (file-name-nondirectory (concat stem ".h")))
	     ((file-exists-p (concat stem ".hh"))
	      (file-name-nondirectory (concat stem ".hh")))))
     & "\"\n" | -10
      "using namespace std;" \n \n
       "int main(int argc, char* argv[]){" \n
       > _ \n  ;;> means indent lines according major mode
       "return 0;"> \n
       "}" > \n))

(add-to-list 'auto-insert-alist
     '(("\\.\\(java\\)\\'" . "Java Skeleton")
     "Short description: "
       "/*" \n
       (file-name-nondirectory (buffer-file-name))
       " -- " str \n
       >" */" \n 
      ( "import package: %s: " "import " & str & ";"  & "\n" | -7)
      "package " (read-string "define package:") & ";" & "\n" | -8
      > "public class " (file-name-sans-extension (file-name-nondirectory (buffer-file-name)))|(or (read-string "enter class name") " NameMe" nil) " {" \n
      > "public static void main(String[] args){" \n
       > _ \n  ;;> means indent lines according major mode
       >"System.out.println(\"End\");"> \n
       > "}" > \n
       > "}" > \n))

(provide 'autoinsertx)
;;; autoinsertx.el ends here
