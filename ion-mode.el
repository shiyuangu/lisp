;;; ion-mode.el --- 

;; Copyright (C) 2014  Shiyuan Gu


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
;; This mode is for editing  Datapath 2.0 query language. 
;; 

;;; Code:

;;; Define some variables 
(defconst ion-datatype
  (regexp-opt '("null" "bool" "int" "float"
				"decimal" "timestamp" "string" "symbol"
				"blob" "clob" "struct" "list" "sexp") 'words) "Ion data types")
(defconst ion-keywords
  (regexp-opt '("define" "exist" "and" "andp"
				"or" "quote" "now" "count" 
				"if" "ifexist" "override"
				"min" "max" "sum" "sort"
				"set" "bitset" "annotation") 'words) "Ion keywords")

 (defvar ion-font-lock-keywords
   (list `(,ion-datatype . font-lock-type-face)
		 `(,ion-keywords . font-lock-keyword-face))
   "Font lock for ion-mode")

(defvar ion-mode-syntax-table
  (let ((ion-mode-syntax-table (make-syntax-table)))
	
    ; This is added so entity names with underscores can be more easily parsed
	(modify-syntax-entry ?_ "w" ion-mode-syntax-table)
	(modify-syntax-entry ?- "w" ion-mode-syntax-table)
	; Comment styles are same as C++
	(modify-syntax-entry ?/ ". 124b" ion-mode-syntax-table)
	(modify-syntax-entry ?* ". 23" ion-mode-syntax-table)
	(modify-syntax-entry ?\n "> b" ion-mode-syntax-table)
	ion-mode-syntax-table)
  "Syntax table for ion-mode")

(defun ion-insert-tab (&optional arg)
  "A wrapper for insert-tab to allow interactive call"
  (interactive "P")
  (insert-tab arg))

(defvar ion-dp20-src-dir (getenv "DP20_SRC_DIR")
  "Datapath 2.0 src directory for development.")

(defvar ion-dp20-tst-dir (getenv "DP20_TST_DIR")
  "Datapath 2.0 direcotry for unit tests")

(defvar ion-test-highlight-regexp nil
   "regexp for capturing the unit test error")

(defun ion-test-command()
  "ion unit test command; It assumes DP20 directory structure.
   It will first cd to the unit test directory(), do a `rsync`,
   then run `brazil-build` This command assume FMA DP direcotry structure"
  (let ((command))
	(and 
	 (or ion-dp20-src-dir (error "Please set shell env DP20_SRC_DIR"))
	 (or ion-dp20-tst-dir (error "Please set shell env DP20_TST_DIR")))
	(setq command
		  (format "cd %s;rsync -av %s/src/fma/ %s/src/fma;rsync -av %s/tst/fma/ %s/tst/fma/;brazil-build" ion-dp20-tst-dir ion-dp20-src-dir ion-dp20-tst-dir ion-dp20-src-dir ion-dp20-tst-dir))
	command))
   
(defun ion-test()
  "run DP20 query unit test defined by ion-test-command"
  (interactive)
  ;;;call compilation-start (instead of compile) in compile.el.
  ;;;compilation-start will not affect the compilation-directory.
  ;;; The last two argument, if not nil, is a function which
  ;;; computes the buffer name based on the mode, and is a regexp
  ;;; which will use to capture the error.
  ;;; TODO: define regex
  (if (yes-or-no-p "Run unit tests? ")
  (compilation-start (ion-test-command) nil nil ion-test-highlight-regexp)))

;;;the following functions are used by thingatpt.el for
;;;thing-at-point, forward-thing ect.
(defvar query-chars "[:alnum:]:"
  "Characters allowable in DP20 query")

(defun ion-end-of-query ()
  "Move point to the beginning of the current Datapath 2.0 query"
  (re-search-forward (concat "\\=[" thing-at-point-file-name-chars "]*")
			  nil t) ;;\= means match succeeds if it is located at point
  )
(defun ion-beginning-of-query ()
  "Move point to the beginning of the current Datapath 2.0 query"
  (if (re-search-backward (concat "[^" thing-at-point-file-name-chars "]")
			  nil t)
	  (forward-char)
	(goto-char (point-min))))
(put 'query 'beginning-op 'ion-beginning-of-query)
(put 'query 'end-op 'ion-end-of-query)

(defun ion-query-to-path (query-name)
  "convert query of format dir1::dir2::dir3 or dir1::dir2::dir3::dir4 to path"
  ;;FIXME: allow more n-dir structure
	(cond
	 ((string-match "\\([[:alnum:]]+\\)::\\([[:alnum:]]+\\)::\\([[:alnum:]]+\\)::\\([[:alnum:]]+\\)" query-name)
		(let ((dir1 (substring query-name (match-beginning 1) (match-end 1)))
			  (dir2 (substring query-name (match-beginning 2) (match-end 2)))
			  (dir3 (substring query-name (match-beginning 3) (match-end 3)))
			  (dir4 (substring query-name (match-beginning 4) (match-end 4))))
		  (if ion-dp20-src-dir
			  (format "%s/src/%s/%s/%s/%s.ion" ion-dp20-src-dir dir1 dir2 dir3 dir4)
			  (message "Error: env ion-dp20-src-dir is not set" ))))
	 ((string-match "\\([[:alnum:]]+\\)::\\([[:alnum:]]+\\)::\\([[:alnum:]]+\\)" query-name)
		(let ((dir1 (substring query-name (match-beginning 1) (match-end 1)))
			  (dir2 (substring query-name (match-beginning 2) (match-end 2)))
			  (dir3 (substring query-name (match-beginning 3) (match-end 3))))
		  (if ion-dp20-src-dir
			  (format "%s/src/%s/%s/%s.ion" ion-dp20-src-dir dir1 dir2 dir3)
			  (message "Error: env ion-dp20-src-dir is not set" ))))
	 (t  (message (format "Error: invalid query: %s" query-name)))))

(defun ion-find-query ()
  "Open query. Implement similar function as gtags-find-tag"
  (interactive)
  (let (query-name-guess prompt query-name)
	(setq query-name-guess (thing-at-point 'query))
	(setq query-name (read-string "Find query: " query-name-guess))
	(if query-name
		(find-file-other-window (ion-query-to-path query-name)))))

(defvar ion-mode-map
  (let ((ion-mode-map (make-keymap)))
    (define-key ion-mode-map "\t" 'ion-insert-tab)
	(define-key ion-mode-map "\C-m" 'newline-and-indent)
	(define-key ion-mode-map "\C-j" 'newline)
	(define-key ion-mode-map "\M-." 'ion-find-query)
	(define-key ion-mode-map [f9] 'ion-test)
    ion-mode-map)
  "Keymap for ion major mode")

;;;###autoload
(define-derived-mode ion-mode prog-mode "ION"
  "Major mode for editing ION files"
  ;The follows codes will run before all hooks and parents' mode's hook
  (message "running ion-mode code....")
  (use-local-map ion-mode-map)
  (set (make-local-variable 'font-lock-defaults) '(ion-font-lock-keywords))
  (set-syntax-table ion-mode-syntax-table))

(setq-default tab-width 4)
(defun ion-setup()
  ;(setq c-basic-offset 4)
  (setq indent-tabs-mode nil) ;;inserting tab is not allowed
  (setq compilation-scroll-output t);; automatically scroll when compiling
)
(add-hook 'ion-mode-hook 'ion-setup)
 
(provide 'ion-mode)
;;; ion-mode.el ends here
