;;; tex-beamer.el --- 

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

;; This file provides beamer support for LaTeX; It extends the beamer.el which comes with beamer. 

;;; Code:
(require 'tex-ext) ;; load my auctex extension
(load "beamer.el")
(TeX-add-style-hook "beamer"
  (function
   (lambda()
     (TeX-add-symbols
      '("animategraphics" TeX-arg-beamer-animategraphics)
      '(def beamer-insert-def))
     
     (LaTeX-add-environments
      '("frame" (lambda (env &rest ignore)
                   (LaTeX-insert-environment
                    env
                    (let ((title (read-input "title:"))
			  (subtitle (read-input "subtitle:"))
			  titles subtitles)
                      (if (not (zerop (length title)))
                          (setq titles (format "{%s}" title)))
		      (if (not (zerop (length subtitle)))
                          (setq subtitles (format "{%s}" subtitle)))
		      (concat "[t]" titles subtitles)
		      )))))
     )))
(define-skeleton beamer-insert-template
  "Insert packages"
  nil ;prompt string
  "%%%%%"\n
  "% author: S. Gu"\n
  "% Comments:"\n
  "% Incompatibility:"\n
  "% enumitem: if used, no bullets"\n
  "%%%%%"\n
  "\\documentclass[compress]{beamer}  %compress:make navigation bar as small as possible" \n
  "\\setbeamertemplate{navigation symbols}{}" \n
  "\\usepackage{amsmath,amsthm,amssymb,latexsym,amscd}" \n
  "\\usepackage{mathabx} %for \topdoteq" \n
  "\\usepackage{slashbox} %%for slash in tables" \n
  "\\usepackage{array}  %%for m{} in tabular" \n
  ;"%\\usepackage[pdftex]{xcolor}" \n
  "\\usepackage{graphicx}" \n
  "\\usepackage{subfigure}" \n 
  "\\usepackage{color}"  \n
  "\\usepackage{tikz}" \n
  "\\usepackage{setspace}  %for linespacing" \n
  "\\usepackage{url}" \n
  "\\usepackage{multimedia}" \n
  "\\usepackage{animate}   %for animategraphics" \n
  "\\usepackage{scalefnt}  %for scalefont" \n
  "\\input{argonne_beamer/argonne_beamer} %include necessary files"\n
  "\\begin{document}" \n
  > _ \n
  "\\end{document}" \n)

(define-skeleton beamer-insert-setbeamertemplate
  "setbeamertemplate"
  "beamer element's name:"
  >"\\setbeamertemplate{" str | "headline" "}{" \n
  >"\\leavevmode%" \n
  >"\\hbox{%"\n
  >"\\begin{beamercolorbox}[wd=.5\\paperwidth,ht=2.25ex,dp=1ex,left]{title in head/foot}%"\n
  >"\\usebeamerfont{title in head/foot}\\centering\\insertsection"\n
  >"\\end{beamercolorbox}%"\n
  >"\\begin{beamercolorbox}[wd=.5\\paperwidth,ht=2.25ex,dp=1ex,right]{section in head/foot}%"\n
  >"\\usebeamerfont{date in head/foot}\\insertshortdate{}\\hspace*{2em}"\n
  >"\\insertframenumber{} / \\inserttotalframenumber\\hspace*{2ex}" \n
  >"\\insertpagenumber{}/$35$\\hspace*{2ex}"\n
  >"\\insertpagenumber{}\\hspace*{2ex}"\n
  >"\\insertdate\\hspace*{5ex}" \n
  >"\\usebeamerfont{section in head/foot}\\insertpart"\n
  >"\\end{beamercolorbox}}"\n
  >"\\vskip2pt"\n
  >"}"\n)

(define-skeleton beamer-insert-defbeamertemplate
  "defbeamertemplate"
  nil
  "\\newlength{\\gnat} %create a length" \n
  "\\defbeamertemplate*{part page}{my part}[1][]" \n
  "%\\defbeamertemplate<mode specification>*{element name}{predefined option}"\n
  "%[argument number][default optional argument]{predefined tex}"\n
  "%the * version calls setbeamertemplate immediately with this option"\n
  "{"\n
  "\\begin{centering}" \n
  "%%{\\usebeamerfont{part name}\\usebeamercolor[fg]{part name}"\n
  "%%\\partname~\\insertromanpartnumber}"\n
  "\\vskip1em\\par"\n
  "\\settowidth{\\gnat}{\\insertsection}% set the length matching to the title"\n
  "\\addtolength{\\gnat}{4em}% raise the length  a bit"\n
  "\\hfill" \n
  "%now we use that length" \n
  "%\\begin{beamercolorbox}[sep=8pt,center,wd=\\gnat,#1]{part title}" \n
  "\\begin{beamercolorbox}[sep=5pt,center,wd=1.2\\gnat,#1]{part title}" \n
  "\\usebeamerfont{part title}\\insertsection\\par" \n
  "\\end{beamercolorbox}" \n
  "\\hfill" \n
  "\\end{centering}" \n
  "}" \n
  "%change to at-letter mode and set part page to the option"
  "\\makeatletter" \n
  "\\setbeamertemplate{part page}[my part][colsep=-4bp,rounded=true,"\n
  "shadow=\\beamer@themerounded@shadow]" \n
  "\\makeatother" \n)

(define-skeleton beamer-insert-define-partpage
  "an example to define a partpage"
  nil
  "\\newlength{\\gnat} %create a length" > \n
  "\\defbeamertemplate*{part page}{my part}[1][]" > \n
  "%\\defbeamertemplate<mode specification>*{element name}{predefined option}"> \n
  "%[argument number][default optional argument]{predefined tex}"> \n
  "{" > \n
  "\\begin{centering}" > \n
  "%%{\\usebeamerfont{part name}\\usebeamercolor[fg]{part name}"> \n
  "%%\\partname~\\insertromanpartnumber}"> \n
  "\\vskip1em\\par"> \n
  "\\settowidth{\\gnat}{\\insertsection}% set the length matching to the title"> \n
  "\\addtolength{\\gnat}{4em}% raise the length  a bit"> \n
  "\\hfill"> \n
  "%now we use that length"> \n
  "%\\begin{beamercolorbox}[sep=8pt,center,wd=\\gnat,#1]{part title}"> \n
  "\\begin{beamercolorbox}[sep=5pt,center,wd=1.2\\gnat,#1]{part title}"> \n
  "\\usebeamerfont{part title}\\insertsection\\par"> \n
  "\\end{beamercolorbox}"> \n
  "\\hfill"> \n
  "\\end{centering}"> \n
  "}"> \n
  "%change to at-letter mode and set part page to the option"> \n
  "\\makeatletter" > \n
  "\\setbeamertemplate{part page}[my part][colsep=-4bp,rounded=true,"> \n
  "shadow=\\beamer@themerounded@shadow]" >\n
  "\\makeatother" >\n)

(define-skeleton beamer-insert-preamble
  "Insert a title page"
  nil
  "%Move the following part to the preamble"\n
  "\\title[" (read-string "short title:") & "]" | -1 "{" (read-string "full title:") "}"\n
  "\\author{" (read-string "author:") "}"\n
  "\\institute[" (read-string "short institute:") "]{" (read-string "full institute:") "}"\n
  "\\date[" (read-string "short date:") "]{" (read-string "full date:") "}"\n)
(define-skeleton beamer-insert-title-outline-frame
  "Insert title and outline frames"
  nil
  "%Insert the following frame inside document" \n
  "\\argonnebeamertitle %use specific setup for title"\n
  "\\begin{frame}"\n
  "\\titlepage"\n
  "\\end{frame}"\n
  "\\argonnebeameroutline %use specific setup for outline"\n
  "\\begin{frame}"\n 
  "\\frametitle{Outline}"\n
  "{\\scriptsize Joint work with....}"\n
  "\\tableofcontents"\n
  "\\end{frame}"\n
  "\\argonnebeamerregular %change back to regular setup"\n)

(defun TeX-arg-beamer-animategraphics (optional &optional prompt)
  "Insert animategraphics(from the package animate)"
  (let ((options (read-input "options:"))
	(frame-rate (read-input "frame rate:"))
	(file-name (read-input "file name:"))
	(start-no (read-input "start frame no (>=0):"))
	(end-no (read-input "end frame no:")))
      (if (not (zerop (length options)))
	  (insert "[" options "]")
	(insert "[autoplay,loop, trim=lefttrimsize bottom right top, scale=0.4]"))
      (insert "{" frame-rate "}")
      (insert "{" file-name "}")
      (insert "{" start-no "}")
      (insert "{" end-no "}")))

(provide 'tex-beamer)
  
;;; tex-beamer.el ends here
