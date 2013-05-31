;;; moose.el --- defines major mode/functions to ease Moose Application developement 

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



(provide 'moose)

(require 'hideshow)
(defun moose-forward-sexp-func (arg)
  "move over ARG balanced blocks; This is needed by hs-minor-mode"  
  (dotimes (number arg)
    (let ((counter 0))
      (catch 'done
        (while t
          (search-forward-regexp "\\[\\./[^.]+]\\|\\[[a-zA-z]+]\\|\\[\\.\\./]\\|\\[]")
          (setq counter (+ counter (if (looking-back "\\[\\./[^.]+]\\|\\[[a-zA-z]+]") 1 -1)))
          (when (= counter 0) (throw 'done t)))))))
(add-to-list 'hs-special-modes-alist '(moose-i-mode "\\[\\./[^.]+]\\|\\[[a-zA-z]+]" "\\[\\.\\./]\\|\\[]" "#" moose-forward-sexp-func nil))

(defun moose-comment-dwim (arg)
  "Comment or uncomment current line or region in a smart way.
For detail, see `comment-dwim'."
  (interactive "*P")
  (require 'newcomment)
  (let (
        (comment-start "#") (comment-end "")
        )
    (comment-dwim arg)))

;; keywords for syntax coloring

(setq moose-keywords
      `(
	;( ,(regexp-opt '("Mesh" "Variables"  "Kernels" "BCs" "Executioner" "Output") t) . font-lock-constant-face)
	(,(regexp-opt '("CHANGEME")) . font-lock-warning-face)
	( "\\[.*\\]" . font-lock-function-name-face)
	;( "\\[\\|\\]" . font-lock-function-name-face)
        )
      )

;; syntax table
(defvar moose-syntax-table nil "Syntax table for `moose-i-mode'.")
(setq moose-syntax-table
      (let ((synTable (make-syntax-table)))

        ;; bash style comment: “# …” 
        (modify-syntax-entry ?# "< b" synTable)
        (modify-syntax-entry ?\n "> b" synTable)

        synTable))

;; define the major mode for editing .i input files
(define-derived-mode moose-i-mode fundamental-mode "Moose-i"
  "Major mode for editing MOOSE input file."
  :syntax-table moose-syntax-table
  
  (setq font-lock-defaults '(moose-keywords))
  (setq comment-start "#")
  (setq comment-end "")
  (hs-minor-mode 1)
  ;; modify the keymap
  (define-key moose-i-mode-map [remap comment-dwim] 'moose-comment-dwim)
)
;;for hide/show moose blocks defined by tags
;;(add-to-list 'hs-special-modes-alist '(moose-i-mode "{" "}" "/[*/]" nil nil))


;; define a major mode for source code development
;;;;;;;;;;for MOOSE programming environment;;;;;;;;;;;;;;;;;;
;; switch C++ source/header files assuming MOOSE directory structure
(defun moose-loadCh ()
  "Load the current buffers corresponding .C/.h file"
  (interactive)
  ;; Make seaches case-sensitive
  (let ((case-fold-search nil)
	(fn ""))
  ;; Build the sibling file name
  (if (string-match "\.h$" buffer-file-name)
      ;; Change from .h to .C
      (progn
	(setq fn (concat (file-name-sans-extension buffer-file-name) ".C"))
	(if (string-match "/include/" fn)
	    (setq fn (replace-match "/src/" nil nil fn))
	  ))
    ;;Change from .C to .h
    (progn
      (setq fn (concat (file-name-sans-extension buffer-file-name) ".h"))
      (if (string-match "/src/" fn)
    	  (setq fn (replace-match "/include/" nil nil fn))
    	)))
  (if (file-exists-p fn)
      (find-file fn)
      (and (y-or-n-p (format "File doesn't exist: %s. Create it?(y/n)" fn))
	   (find-file fn)
	   ))))

(defvar moose-template-directory "~/moose_templates")

(define-derived-mode moose-c++-mode c++-mode "Moose-C++"
  "Major Mode for editing moose cpp files"
  (define-key moose-c++-mode-map "\C-cc" 'moose-loadCh)
)

(defun moose-insert-kernel-cpp (kernel-name)
  "Insert kernel cpp template"
  (interactive (let 
		((default-kernel-name 
		  (file-name-sans-extension
		   (file-name-nondirectory buffer-file-name))))
	       (list (read-string (format "Enter kernel's name(default:%s):" default-kernel-name) nil nil default-kernel-name))))
  (let ((filename "KernelTemplate.C") full-filename)
    (if (file-readable-p
	 (setq full-filename (expand-file-name
			      filename moose-template-directory)))
	(progn
	  (insert-file-contents full-filename)
	  (goto-char (point-min))
	  (message "kernel name :%s" kernel-name)
	  (while (re-search-forward "NAME_TO_BE_REPLACED" nil t)
	    (replace-match kernel-name t t))
	  )
      (message "The template file %s does not exist." full-filename)))
  )
(defun moose-insert-kernel-h (kernel-name)
  "Insert kernel header template"
  (interactive (let 
		((default-kernel-name 
		  (file-name-sans-extension
		   (file-name-nondirectory buffer-file-name))))
	       (list (read-string (format "Enter kernel's name(default:%s):" default-kernel-name) nil nil default-kernel-name))))
  (let ((filename "KernelTemplate.h") full-filename)
    (if (file-readable-p
	 (setq full-filename (expand-file-name
			      filename moose-template-directory)))
	(progn
	  (insert-file-contents full-filename)
	  (goto-char (point-min))
	  (message "kernel name :%s" kernel-name)
	  (while (re-search-forward "NAME_TO_BE_REPLACED" nil t)
	    (replace-match kernel-name t t))
	  )
      (message "The template file %s does not exist." full-filename)))
  )

(defun copy-block-from-file (blockname filename)
  "copy a block from the file and put it into the kill-ring"
  (interactive)
  (with-temp-buffer
    (if
     (file-readable-p (setq full-filename (expand-file-name
			      filename moose-template-directory)))
     (let (start-point end-point)
       (insert-file-contents full-filename)
       (search-forward blockname nil nil)
       (backward-char (length blockname))  
       (setq start-point (point))
       (search-forward "[]" nil nil)
       (setq end-point (point))
       (kill-region start-point end-point)
       )
     (message "Template file %s doesn't exist" full-filename))
      )
  )

(defun moose-insert-kernel-i()
  "Insert a [Kernels] block"
  (interactive)
  (copy-block-from-file "[Kernels]" "InputTemplate.i")
  (yank)
  )
;;; moose.el ends here
