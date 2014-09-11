;;; mytex.el --- My setup for AUCTeX/latex
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

;; 

;;; Code:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;for AUCTeX by Gu;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (eval-after-load "tex"
;;   '(add-to-list 'TeX-command-list
;; 		'("pdflatex" "pdflatex %s" TeX-run-command t t :help "Run pdflatex") t))

(require 'tex-site)
 (load "auctex.el" nil t t)
 (load "preview-latex.el" nil t t)

 (setq TeX-auto-save t)
 (setq TeX-parse-self t)
 (setq-default TeX-master nil)

(require 'tex-beamer) ; load my extenstion to beamer.el
;;;the following let LaTeX-mode-map take precedence. 
 (add-hook 'LaTeX-mode-hook (lambda()(define-key LaTeX-mode-map (kbd "<M-tab>") 'TeX-complete-symbol)))
;setup reftex according to auctex-ref.pdf
(add-hook 'latex-mode-hook 'turn-on-reftex)
(add-hook 'latex-mode-hook 'turn-on-flyspell)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(add-hook 'LaTeX-mode-hook 'turn-on-flyspell)
(setq reftex-plug-into-auctex t)

(add-hook 'LaTeX-mode-hook (lambda()
			     (local-set-key (kbd "C-j") 'newline)))
(add-hook 'LaTeX-mode-hook (lambda ()
                            (local-set-key (kbd "C-m") 'reindent-then-newline-and-indent)))

(setq TeX-source-correlate-method 'synctex)

(defun skim-make-url () (concat
		(TeX-current-line)
		" "
		(expand-file-name (funcall file (TeX-output-extension) t)
			(file-name-directory (TeX-master-file)))
		" "
		(shell-quote-argument buffer-file-name)))
(add-hook 'LaTeX-mode-hook
	  (lambda ()
	    (add-to-list 'TeX-expand-list
			 '("%qq" skim-make-url))))
(setq  TeX-view-program-list 
       '(("Skim" "/Applications/Skim.app/Contents/SharedSupport/displayline %qq")))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;(if (system-type-is-gnu)
;   (setq TeX-view-program-selection '((output-pdf "Okular") (output-dvi "Okular"))))
 
;(if (system-type-is-darwin)
;    (setq TeX-view-program-selection '((output-pdf "Skim"))))

;(server-start)
;;;;;the above is from http://www.bleedingmind.com/index.php/2010/06/17/synctex-on-linux-and-mac-os-x-with-emacs/
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;for tex-pgf;;;;;;
(require 'tex-pgf)

(provide 'mytex)
;;; mytex.el ends here
