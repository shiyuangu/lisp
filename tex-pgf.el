;;; tex-pgf.el --- 

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

;;  Handy functions for using pfg graphics package. 

;;; Code:
(require 'tex) ; load AUCTeX

(TeX-add-style-hook "latex"
  (lambda()
    (TeX-add-symbols
     '("pgfdeclarelayer" TeX-arg-pgf-declarelayer))))

(TeX-add-style-hook "beamer"
  (lambda()
    (TeX-add-symbols
     '("pgfdeclarelayer" TeX-arg-pgf-declarelayer))))

(define-skeleton pgf-insert-headers
      "Insert pgf/tikz libraries,ect."
      nil ; prompt string
      "\\usepackage{tikz}\n"
      "\\usetikzlibrary{positioning,shapes,shadows,arrows,calc,matrix}\n")
(define-skeleton pgf-insert-tikzstyle
  "Insert tikzstyle"
  "style's name:"
  "\\tikzstyle{" str &"}=[" (read-string "definition, RET: ") | "rectangle, draw=none, rounded corners=1mm, fill=blue, drop shadow, text centered, anchor=north, text=white"
  "]\n")

(define-skeleton pgf-insert-tikzpicture
  "Insert tikzpicture environment"
  "options,RET:"
   > "\\begin{tikzpicture}[" str | "scale=1.0" "]"\n
   > _ \n
   > "\\end{tikzpicture}" > \n)

(define-skeleton pgf-insert-scope
  "Insert scope environment"
  nil
  > "\\begin{scope}" \n
  > _ \n
  > "\\end{scope}"> \n)

(define-skeleton pgf-insert-coordinate
  "Insert pgf coordinate (an abbreviation for \\path coordinate)"
  "options,RET:"
  "\\coordinate[" str & ?\] | -1 " (" (read-string "name:") ") "
  "at (" (read-string "cooridnate:") ");" )

(define-skeleton pgf-insert-pgfonlayer
  "Insert pgfonlayer environment"
  "name(defined by \\pgfdeclarelayer{name}),RET:"
  "\\begin{pgfonlayer}{" str "}" > \n
  > _  \n "\\end{pgfonlayer}"  > \n )

(define-skeleton pgf-insert-node
  "Insert pgf node"
  "options:"
  "\\node[" str | "above, circle,fill=red!20, minimum height=1cm, minimum width=1cm" "] (" (read-string "name:") ") "    "at (" (read-string "cooridinate, optional:") & ")" | -4 "{" (read-string "text:") "};")

(define-skeleton pgf-insert-circle
  "Insert a circle (on a path)"
  "center:"
  "(" str ") circle (" (read-string "radius:") ")")

(define-skeleton pgf-insert-ellipse
  "Insert an ellipse (on a path)"
  "center:"
  " (" str ") circle [x radius=" (read-string "x radius:") ", y radius=" (read-string "y radius:") ", rotate=" (read-string "rotate:") "]")

(define-skeleton pgf-insert-matrix
  "Insert matrix layout"
  "position:"
   >"\\node [" (read-string "options:")| "matrix,ampersand replacement=\\&, row sep=0.3cm,left delimiter=\\{" "]" "(" (read-string "node name:") & ")"| -1  "at (" str &")" | -1 "{" \n
    > "% \\& \\\\" \n
    > _ \n 
    >"};"\n)

(define-skeleton pgf-draw-rectangle
  "Insert a rectangle as a path"
  nil
   (read-string "lower left corner: ") ") rectangle ("  (read-string "upper right corner: ") ")")

(define-skeleton pgf-draw-path
  "Draw a path"
  "options,RET:"
  "\\draw[" str & ?\] | -1 " (" (read-string "coordinate:") ") "
  ("next cooridinate:"
   " -- (" str ")" ) ";"
  )

(define-skeleton pgf-draw-rectangle
  "Draw a rectangle"
  "options:"
  "\\path [" str | "fill=yellow!40,rounded corners, draw=black!50, dashed" "] ("(read-string "lower left corner: ") ") rectangle ("  (read-string "upper right corner: ") ");\n")

(define-skeleton pgf-draw-cylinder
  "Draw a cylinder"
  "options:"
  "\\node [" str | "cylinder,shape border rotate=90, cylinder uses custom fill,cylinder end fill=blue!40, cylinder body fill=blue!20" "] ("(read-string "name:") ") {"  (read-string "text: ") "}" "at (" (read-string "position") ");\n")

(define-skeleton pgf-draw-ellipse
  "Draw an ellipse"
  "center:"
  "\\draw (" str ") circle [x radius=" (read-string "x radius:") ", y radius=" (read-string "y radius:") ", rotate=" (read-string "rotate:") "];")

(define-skeleton pgf-draw-circle
  "Draw a circle"
  "center:"
  "\\draw (" str ") circle [radius=" (read-string "radius:") "];")

(define-skeleton pgf-draw-grid
  "Draw a grid"
  nil
  "\\draw [help lines,step=1]" "("(read-string "lower left corner: ") ") grid ("  (read-string "bottom right corner: ") ");\n")

(define-skeleton pgf-draw-grid-whole-page
  "Draw a grid on the whole page"
  nil
   "\\begin{tikzpicture}[remember picture,overlay]" > \n
   "\\draw [help lines,step=1] (current page.south west) grid (current page.north east);" > \n
   "\\end{tikzpicture}" > \n)

(defun TeX-arg-pgf-declarelayer (optional &optional prompt)
  "Insert back/font layer"
  (let ((back (read-input "back layer name:"))
	(front (read-input "front layer name:")))
    (insert "{" back "}\n")
    (indent-according-to-mode)
    (insert "\\pgfdeclarelayer{" front "}\n")
    (indent-according-to-mode)
    (insert "\\pgfsetlayers{" back "," front"}\n")
    (indent-according-to-mode)))

;;;;optional:enable Auto-complete;;;;;
;;;;make sure this package is loaded after auto-complete.el
(when (boundp 'ac-modes)
 (add-to-list 'ac-modes 'latex-mode)
 (add-hook 'auto-complete-mode-hook (lambda() (define-key ac-mode-map (kbd "<C-tab>") 'auto-complete))) ;;; add avoid key collision with tex-mode key
 ;(add-hook 'auto-complete-mode-hook (lambda() (global-set-key (kbd "C-TAB") 'auto-complete))) ;;; add avoid key collision with tex-mode key
 )
(provide 'tex-pgf)
;;; tex-pgf.el ends here
   

