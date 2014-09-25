;;; myorg.el --- My customization of org-mode

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
(add-to-list 'load-path "~/org-mode/lisp") ;;;CHANGEME to point to orgmode src
(add-to-list 'load-path "~/org-mode/contrib/lisp" t) ;;add to the end of load-path
(require 'htmlize)
(require 'ox-latex)
(require 'ox-html)
(require 'sgu-ox-html-english)
;;active Babel languages
;(package-initialize)
(require 'myess) ;; for Babel
(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
   (emacs-lisp . t)
   (R . t)
   (sh . t)))

;; (setq python-shell-interpreter "ipython"
;;       ;;python-shell-interpreter-args "--pylab"
;;       );;; should set in mypython.el
(setq org-babel-python-command "ipython --no-banner --classic --no-confirm-exit")

;;setup for source code export in LaTex. 
;;;;;(setq org-latex-listings t)
;;;;;(add-to-list 'org-latex-packages-alist '("" "listings"))
;;;;;(add-to-list 'org-latex-packages-alist '("" "color"))

;;Alternatively, We can use minted. However, this setup might cause problem for org-preview-latex. Consult (C-h v org-latex-listings) for details.
(setq org-latex-listings 'minted)
(add-to-list 'org-latex-packages-alist '("" "minted"))
(setq org-latex-pdf-process
	  '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f" "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"  "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))

(setq org-image-actual-width nil)

;;add more templates:
(add-to-list 'org-structure-template-alist '("T" "#+TITLE: "))
(add-to-list 'org-structure-template-alist '("C" "#+CATEGORY: "))

;;set up capture
(setq org-default-notes-file (concat org-directory "/notes.org"))
(define-key global-map (kbd "\e\ec") 'org-capture)
(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/org/taskdiary.org" "Tasks")
             "* TODO %?\n  %i\n  %a")
        ("j" "Journal" entry (file+datetree "~/org/journal.org")
             "* %?\nEntered on %U\n  %i\n  %a")
		("a" "Appointment" entry (file+headline "~/org/taskdiary.org" "Calendar") "* APPT %^{Description} %^g \n%? \nAdded: %U") 
		))

;;set up MobileOrg
;; Set to <your Dropbox root directory>/MobileOrg.
(setq org-mobile-directory "~/Dropbox/Apps/MobileOrg")
;; Set to the name of the file where new notes will be stored
(setq org-mobile-inbox-for-pull "~/org/flagged.org")


(provide 'myorg)
;;; myorg.el ends here
