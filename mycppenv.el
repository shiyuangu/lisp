;;; mycpp-env.el --- set up a c/cpp programming environment

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

;;; Commentary: Use this in the hook
;;; (add-hook 'c-mode-common-hook '(lambda() (require 'mycppenv) nil))

;; 

;;; Code:


;; switch C++ source/header files assuming directory structure that directory of src and include and under the project root.
(defun loadcpph ()
  "Load the current buffers corresponding .cpp/.hpp file"
  (interactive)
  ;; Make seaches case-sensitive
  (let ((case-fold-search nil)
	(fn ""))
  ;; Build the sibling file name
  (if (string-match "\.hpp$" buffer-file-name)
      ;; Change from .h to .cpp
      (progn
	(setq fn (concat (file-name-sans-extension buffer-file-name) ".cpp"))
	(if (string-match "/include/" fn)
	    (setq fn (replace-match "/src/" nil nil fn))
	  ))
    ;;Change from .cpp to .h
    (progn
      (setq fn (concat (file-name-sans-extension buffer-file-name) ".hpp"))
      (if (string-match "/src/" fn)
    	  (setq fn (replace-match "/include/" nil nil fn))
    	)))
  (if (file-exists-p fn)
      (find-file fn)
      (and (y-or-n-p (format "File doesn't exist: %s. Create it?(y/n)" fn))
	   (find-file fn)
	   ))))

(eval-after-load "cc-mode" '(define-key c++-mode-map (kbd "C-c c") 'loadcpph))

(define-skeleton mycppenv-insert-makefile
  "insert makefile"
   "application name:" ;prompt string
  "#fix the spaces in the path"\n
  "empty:= "\n
  "space:=$(empty) $(empty)"\n
  "subspace:=\\$(empty) $(empty)"\n
  "ROOT_DIR=$(subst $(space),$(subspace),$(shell pwd))"\n
  "SRC_DIR=src"\n
  "INC_DIR=include"\n
  "SRC=$(wildcard $(SRC_DIR)/*.cpp)"\n
  "OBJ_DIR=obj"\n
  "OBJ=$(patsubst $(SRC_DIR)/%.cpp, $(OBJ_DIR)/%.o,$(SRC))"\n
  "CPPFLAGS=-I $(INC_DIR)"\n \n
  "$(OBJ_DIR)/%.o:$(SRC_DIR)/%.cpp"\n
  "\t$(CPP) $(CPPFLAGS) -g -c -o $@ $<"\n
   str | "all" ":$(OBJ)"\n
  "\t$(CPP) -o " str | "test" " $(OBJ)"\n)

;;;;;;;;;;for gtags;;;;;;;;;;;;;;;;;
(require 'gtags)
(define-key gtags-mode-map "\C-cf" 'gtags-find-file)
(define-key gtags-mode-map  "\M-." 'gtags-find-tag)
(define-key gtags-mode-map (kbd "C-c r") 'gtags-find-rtag)
(define-key gtags-mode-map (kbd "C-c p") 'gtags-pop-stack)
(define-key gtags-select-mode-map (kbd "C-m") 'gtags-select-tag)
;(add-hook 'c-mode-common-hook '(lambda () (gtags-mode t)))
(gtags-mode t)
;;;;;;;;;;;;;;;;for doxymacs;;;;;;;;;;;;;;
(require 'doxymacs)
;(add-hook 'c-mode-common-hook 'doxymacs-mode)
(doxymacs-mode)
;; (defun my-doxymacs-font-lock-hook ()
;;       (if (or (eq major-mode 'c-mode) (eq major-mode 'c++-mode))
;; 	  (doxymacs-font-lock)))
;(add-hook 'font-lock-mode-hook 'my-doxymacs-font-lock-hook)
;(add-hook 'font-lock-mode-hook 'doxymacs-font-lock)

;;;;;;;;;;;;;;;;;for MOOSE ;;;;;;;;;;;;;;;;;
;;;;;;;moose.el should be load after auto-complete.el is loaded;;;;;
;(require 'moose)
;(setq moose-template-directory "~/moose_templates")

;;;;;for mpi;;;;;
(require 'mpi)

(provide 'mycppenv)
;;; mycpp-env.el ends here
