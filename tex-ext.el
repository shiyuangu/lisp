;;; tex-ext.el --- 

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

;; This file extents AUCTeX functions.  

;;; Code:
(require 'tex)
(TeX-add-style-hook "latex"
  (lambda()
    (TeX-add-symbols
     '("def" (lambda (env &rest ignore)
	       (insert "\\ab#1#2{\\only<1>{#1}\\only<2>{#2}}"))))))
(define-skeleton tex-insert-figure-side-by-side
  "Insert side by side figure using minipage"
  nil
  "\\hspace{\\stretch{1}}%" > \n
  "\\begin{minipage}[c]{0.3\\textwidth}" > \n
  "\\includegraphics{}\\\\" > \n
  "{\\scriptsize caption....}" > \n 
  "\\end{minipage}\\hspace{\\stretch{1}}%" > \n
  "\\begin{minipage}[t]{0.3\\textwidth}"> \n
  "\\includegraphics{}\\\\" > \n
  "{\\scriptsize caption....}" > \n
  "\\end{minipage}\\hspace{\\stretch{1}}%"> \n)
(provide 'tex-ext)
;;; tex-ext.el ends here
