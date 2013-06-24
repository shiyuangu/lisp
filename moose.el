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

(setq moose-i-keywords
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
  
  (setq font-lock-defaults '(moose-i-keywords))
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

(defun moose-insert-kernel-cpp (class-name)
  "Insert kernel cpp template"
  (interactive (let 
		((default-class-name 
		  (file-name-sans-extension
		   (file-name-nondirectory buffer-file-name))))
	       (list (read-string (format "Enter kernel's name(default:%s):" default-class-name) nil nil default-class-name))))
  (let ((filename "KernelTemplate.C") full-filename)
    (if (file-readable-p
	 (setq full-filename (expand-file-name
			      filename moose-template-directory)))
	(progn
	  (insert-file-contents full-filename)
	  (goto-char (point-min))
	  (while (re-search-forward "NAME_TO_BE_REPLACED" nil t)
	    (replace-match class-name t t))
	  )
      (message "The template file %s does not exist." full-filename)))
  )
(defun moose-insert-kernel-h (class-name)
  "Insert kernel header template"
  (interactive (let 
		((default-class-name 
		  (file-name-sans-extension
		   (file-name-nondirectory buffer-file-name))))
	       (list (read-string (format "Enter kernel's name(default:%s):" default-class-name) nil nil default-class-name))))
  (let ((filename "KernelTemplate.h") full-filename)
    (if (file-readable-p
	 (setq full-filename (expand-file-name
			      filename moose-template-directory)))
	(progn
	  (insert-file-contents full-filename)
	  (goto-char (point-min))
	  (while (re-search-forward "NAME_TO_BE_REPLACED" nil t)
	    (replace-match class-name t t))
	  (goto-char (point-min))
	  (while (search-forward (concat class-name "_H") nil t)
	    (replace-match (concat (upcase class-name) "_H") t t))
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

(defun moose-insert-postprocessor-h (class-name)
  "Insert postprocessor header template"
  (interactive (let 
		((default-class-name 
		  (file-name-sans-extension
		   (file-name-nondirectory buffer-file-name))))
	       (list (read-string (format "Enter class's name(default:%s):" default-class-name) nil nil default-class-name))))
  (let ((filename "PostprocessorTemplate.h") full-filename)
    (if (file-readable-p
	 (setq full-filename (expand-file-name
			      filename moose-template-directory)))
	(progn
	  (insert-file-contents full-filename)
	  (goto-char (point-min))
	  (while (re-search-forward "NAME_TO_BE_REPLACED" nil t)
	    (replace-match class-name t t))
	  (goto-char (point-min))
	  (while (search-forward (concat class-name "_H") nil t)
	    (replace-match (concat (upcase class-name) "_H") t t))
	  )
      (message "The template file %s does not exist." full-filename)))
  )
(defun moose-insert-postprocessor-cpp (class-name)
  "Insert kernel cpp template"
  (interactive (let 
		((default-class-name 
		  (file-name-sans-extension
		   (file-name-nondirectory buffer-file-name))))
	       (list (read-string (format "Enter class name(default:%s):" default-class-name) nil nil default-class-name))))
  (let ((filename "PostprocessorTemplate.C") full-filename)
    (if (file-readable-p
	 (setq full-filename (expand-file-name
			      filename moose-template-directory)))
	(progn
	  (insert-file-contents full-filename)
	  (goto-char (point-min))
	  (while (re-search-forward "NAME_TO_BE_REPLACED" nil t)
	    (replace-match class-name t t))
	  )
      (message "The template file %s does not exist." full-filename)))
  )
(defun moose-insert-material-h (class-name)
  "Insert Material header template"
  (interactive (let 
		((default-class-name 
		  (file-name-sans-extension
		   (file-name-nondirectory buffer-file-name))))
	       (list (read-string (format "Enter class's name(default:%s):" default-class-name) nil nil default-class-name))))
  (let ((filename "MaterialTemplate.h") full-filename)
    (if (file-readable-p
	 (setq full-filename (expand-file-name
			      filename moose-template-directory)))
	(progn
	  (insert-file-contents full-filename)
	  (goto-char (point-min))
	  (while (re-search-forward "NAME_TO_BE_REPLACED" nil t)
	    (replace-match class-name t t))
	  (goto-char (point-min))
	  (while (search-forward (concat class-name "_H") nil t)
	    (replace-match (concat (upcase class-name) "_H") t t))
	  )
      (message "The template file %s does not exist." full-filename)))
  )
(defun moose-insert-material-cpp (class-name)
  "Insert Material cpp template"
  (interactive (let 
		((default-class-name 
		  (file-name-sans-extension
		   (file-name-nondirectory buffer-file-name))))
	       (list (read-string (format "Enter class name(default:%s):" default-class-name) nil nil default-class-name))))
  (let ((filename "MaterialTemplate.C") full-filename)
    (if (file-readable-p
	 (setq full-filename (expand-file-name
			      filename moose-template-directory)))
	(progn
	  (insert-file-contents full-filename)
	  (goto-char (point-min))
	  (while (re-search-forward "NAME_TO_BE_REPLACED" nil t)
	    (replace-match class-name t t))
	  )
      (message "The template file %s does not exist." full-filename)))
  )
(defun moose-insert-mesh()
  "Insert a [Mesh] block"
  (interactive)
  (copy-block-from-file "[Mesh]" "InputTemplate.i")
  (yank)
  )
(defun moose-insert-variables()
  "Insert a [Variables] block"
  (interactive)
  (copy-block-from-file "[Variables]" "InputTemplate.i")
  (yank)
  )
(defun moose-insert-output()
  "Insert a [Output] block"
  (interactive)
  (copy-block-from-file "[Output]" "InputTemplate.i")
  (yank)
  )
(defun moose-insert-bcs()
  "Insert a [BCs] block"
  (interactive)
  (copy-block-from-file "[BCs]" "InputTemplate.i")
  (yank)
  )
(defun moose-insert-executioner()
  "Insert a [Executioner] block"
  (interactive)
  (copy-block-from-file "[Executioner]" "InputTemplate.i")
  (yank)
  )
(defun moose-insert-postprocessors-i()
  "Insert a [Postprocessors] block"
  (interactive)
  (copy-block-from-file "[Postprocessors]" "InputTemplate.i")
  (yank)
  )
(defun moose-insert-preconditioning-i()
  "Insert a [Preconditioning] block"
  (interactive)
  (copy-block-from-file "[Preconditioning]" "InputTemplate.i")
  (yank)
  )
(defun moose-insert-materials-i()
  "Insert a [Materials] block"
  (interactive)
  (copy-block-from-file "[Materials]" "InputTemplate.i")
  (yank)
  )
(defun moose-insert-ics-i()
  "Insert a [ICs] block"
  (interactive)
  (copy-block-from-file "[ICs]" "InputTemplate.i")
  (yank)
  )
(defun moose-insert-input()
  "Insert an input file template"
  (interactive)
  (if
     (file-readable-p (setq full-filename (expand-file-name
			      "InputTemplate.i" moose-template-directory)))
     
       (insert-file-contents full-filename)
   (message "Template file %s doesn't exist" full-filename))
)

(defun moose-insert-kernel(class-name)
  "Insert a Kernel cpp/h/block based on the current file name"
  (interactive (let 
		((default-class-name 
		  (file-name-sans-extension
		   (file-name-nondirectory buffer-file-name))))
	       (list (read-string (format "Enter kernel's name(default:%s):" default-class-name) nil nil default-class-name))))
  (let (filename-extension)
    (setq filename-extension (file-name-extension buffer-file-name))
    (cond ((equal filename-extension "C") (moose-insert-kernel-cpp class-name))
	  ((equal filename-extension "h") (moose-insert-kernel-h class-name))
	  ((equal filename-extension "i") (moose-insert-kernel-i))
	  (t (message "filename extension is not recognized."))
	  ))
  )
(defun moose-insert-postprocessors(class-name)
  "Insert a Material cpp/h/block based on the current file name"
  (interactive (let 
		((default-class-name 
		  (file-name-sans-extension
		   (file-name-nondirectory buffer-file-name))))
	       (list (read-string (format "Enter class name(default:%s):" default-class-name) nil nil default-class-name))))
  (let (filename-extension)
    (setq filename-extension (file-name-extension buffer-file-name))
    (cond ((equal filename-extension "C") (moose-insert-postprocessors-cpp class-name))
	  ((equal filename-extension "h") (moose-insert-postprocessors-h class-name))
	  ((equal filename-extension "i") (moose-insert-postprocessors-i))
	  (t (message "filename extension is not recognized."))
	  ))
  )
(defun moose-insert-material(class-name)
  "Insert a Material cpp/h/block based on the current file name"
  (interactive (let 
		((default-class-name 
		  (file-name-sans-extension
		   (file-name-nondirectory buffer-file-name))))
	       (list (read-string (format "Enter class name(default:%s):" default-class-name) nil nil default-class-name))))
  (let (filename-extension)
    (setq filename-extension (file-name-extension buffer-file-name))
    (cond ((equal filename-extension "C") (moose-insert-material-cpp class-name))
	  ((equal filename-extension "h") (moose-insert-material-h class-name))
	  ((equal filename-extension "i") (moose-insert-materials-i))
	  (t (message "filename extension is not recognized."))
	  ))
  )

;;; for auto-complete ;;;;
(when (boundp 'ac-modes)
 (add-to-list 'ac-modes 'moose-c++-mode))
;;; moose.el ends here
