;;; ion-mode.el --- 

;; Copyright (C) 2014  Shiyuan Gu (shiyuangu@gmail.com)


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
  (regexp-opt '("define" "diverge" "exist" "and" "andp"
				"or" "quote" "now" "count" 
				"if" "ifexist" "override"
				"min" "max" "sum" "sort" "true" "false"
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
  "A wrapper for insert-tab to allow interactive call.
   The function insert-tab is defined in indent.el. In case of indent-tabs-mode is nil,
   insert-tab eventually calls indent-to.
   The function indent-to inserts only spaces when indent-tabs-mode is nil"
  (interactive "P")
  (insert-tab arg))

(defun ion-indent-region ()
  (interactive)
  (if (use-region-p)
	  (let ((start (region-beginning))
			(end (region-end)))
		(save-excursion
		  (goto-char start)
		  (while (< (point) end)
			(insert-tab 1)
			(forward-line 1))))))

(defun ion-indent-dwim (&optional arg)
  "indent do-what-i-mean"
  (interactive "P")
  (if (use-region-p)
	  (ion-indent-region)
	  (ion-insert-tab 1)))

(defvar ion-dp20-src-dir (getenv "DP20_SRC_DIR")
  "Datapath 2.0 src directory for development.
   DP20_SRC_DIR must be absolute full path.")

(defvar ion-dp20-tst-dir (getenv "DP20_TST_DIR")
  "Datapath 2.0 direcotry for unit tests.
DP20_TST_DIR must be absolute full path.")

(defvar ion-dp20-template-dir (getenv "DP20_TMPL_DIR")
  "Directory where templates are ")

(defvar ion-test-highlight-regexp nil
   "regexp for capturing the unit test error")

(defvar ion-dired-buffer nil
  "pointed to dired buffer if not nil. Intern use only")

(defvar ion-grep-find-command (concat "find " (or (and ion-dp20-src-dir (concat ion-dp20-src-dir "/src/fma")) ".") " -type  f -exec grep -nH -e {} +")
  "default command to run grep-find")

(defun ion-dired ()
  "create or switch to the dired buffer of ion-dp20-src-dir"
  (interactive)
  (if (and 
	   ion-dp20-src-dir
	   (file-directory-p ion-dp20-src-dir))
	  (if (null ion-dired-buffer)
	    (progn
		 (dired-other-window ion-dp20-src-dir)
		 (rename-buffer "fma-src")
		 (setq ion-dired-buffer (current-buffer)))
		(switch-to-buffer-other-window ion-dired-buffer))
	(message "Please set env DP20_SRC_DIR")))

(defun ion-test-command()
  "ion unit test command; It assumes DP20 directory structure.
   It will first cd to the unit test directory(), do a `rsync`,
   then run `brazil-build` This command assume FMA DP direcotry structure"
  (let ((command))
	(and 
	 (or ion-dp20-src-dir (error "Please set shell env DP20_SRC_DIR"))
	 (or ion-dp20-tst-dir (error "Please set shell env DP20_TST_DIR")))
	(setq command
		  (format "cd %s;rsync -av --delete --include '*.ion' %s/src/fma/ %s/src/fma ;rsync -av --delete --include '*.ion' %s/tst/fma/ %s/tst/fma/;brazil-build test" ion-dp20-tst-dir ion-dp20-src-dir ion-dp20-tst-dir ion-dp20-src-dir ion-dp20-tst-dir))
	command))

(defun ion-test-this-command()
  "ion unit test for the current query.
   This function assumes directory structure and naming convention."
  (let (command this-query)
	(and 
	 (or ion-dp20-src-dir (error "Please set shell env DP20_SRC_DIR"))
	 (or ion-dp20-tst-dir (error "Please set shell env DP20_TST_DIR")))
	(setq this-query (file-name-nondirectory buffer-file-name))
	(and (not (string-match "Tst.ion\\'" this-query))
		 (string-match ".ion\\'" this-query)
		 (setq this-query (replace-match "Tst.ion" nil nil this-query)))
	(setq command
		  (format "cd %s;rsync -av %s/src/fma/ %s/src/fma;rsync -av %s/tst/fma/ %s/tst/fma/; brazil-build test %s" ion-dp20-tst-dir ion-dp20-src-dir ion-dp20-tst-dir ion-dp20-src-dir ion-dp20-tst-dir this-query))))

(defun ion-test()
  "Run DP20 query unit test defined by ion-test-command"
  (interactive)
  ;;;call compilation-start (instead of compile) in compile.el.
  ;;;compilation-start will not affect the compilation-directory.
  ;;; The last two argument, if not nil, is a function which
  ;;; computes the buffer name based on the mode, and is a regexp
  ;;; which will use to capture the error.
  ;;; TODO: define regex
  (if (yes-or-no-p "Run all unit tests? ")
  (compilation-start (ion-test-command) nil nil ion-test-highlight-regexp)))

(defun ion-test-this()
  "Run this query."
  (interactive)
  (let ((command (ion-test-this-command)) test-name)
	(setq test-name (substring command (string-match "[^ ]+.ion\\'" command) nil))
	(and (yes-or-no-p (format "Run unit test: %s?" test-name))
		 (compilation-start (ion-test-this-command) nil nil ion-test-highlight-regexp))
  ))

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
  ;;TODO: allow more n-dir structure
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
  (let (query-name-guess prompt query-name full-path)
	(setq query-name-guess (thing-at-point 'query))
	(setq query-name (read-string "Find query: " query-name-guess))
	(setq full-path (ion-query-to-path query-name))
	(if (or (file-exists-p full-path)
			(yes-or-no-p (format "query %s doesn't exist, create it? " full-path)))
		(find-file-other-frame (ion-query-to-path query-name)))))

(defun ion-grep-find ()
  (interactive)
  (let ((command-to-run (read-string "command to run:" ion-grep-find-command)))
	;;(add-to-history 'grep-history command-to-run) ;;TODO:FIXIT.
	(grep-find command-to-run) 
	))
  
(defun ion-src-tst-path(full-path)
  "Compute src/tst file assuming the directory structure and naming convention
   return nil if full-path is not undet ion-dp20-src-dir"
   (if (string-match-p ion-dp20-src-dir full-path)
	 (let (stem stem-2 stem-3)
	   (setq stem (substring full-path (length ion-dp20-src-dir) nil))
	   (cond  
		((string-match "\\`/tst/" stem)
		 (setq stem-2 (replace-match "/src/" nil nil stem))
		 (if (string-match "Tst.ion\\'" stem-2)
			 (setq stem-3 (replace-match ".ion" nil nil stem-2))
		   nil))
		((string-match "\\`/src/" stem)
		 (setq stem-2 (replace-match "/tst/" nil nil stem))
		 (if (string-match ".ion\\'" stem-2)
			 (setq stem-3 (replace-match "Tst.ion" nil nil stem-2))
		   nil))
		(t (message (format "%s is not in ion-dp20-src-dir" full-path))))
	   (if stem-3
		  (concat ion-dp20-src-dir stem-3)
		 nil))))

(defun ion-load-src-tst()
  "Open the correspondent source and unit test file."
  (interactive)
  (let ((target-path (ion-src-tst-path buffer-file-name)))
	(cond
	 ((not target-path)
	  (message (format "Error:%s doesn't conform to the directory structure or naming convention." buffer-file-name)))
	 ((or (file-exists-p target-path)
			(yes-or-no-p (format "%s doesn't exist. Create it? " target-path)))
		   (find-file-other-frame target-path))
		  )))

(defun ion-pretty-format(beg end)
  "Replace \n with a newline. This is used for line-break for ion file."
  (interactive (if (use-region-p)
				   (list (region-beginning) (region-end))
			   (list (point-min) (point-max))))
  (if (yes-or-no-p "pretty-format?")
	  (replace-string "\\n" "\n" nil beg end))
)

(defun ion-yank-symbol-at-point ()
  (interactive)
  (let ((bounds (bounds-of-thing-at-point 'symbol)))
	(if bounds
		(kill-ring-save (car bounds) (cdr bounds))))
 )

;;;;; The followings are for inserting templates
(defun ion-insert-tst-fmaVersionConfig()
  "Insert override fmaVersionConfig template"
  (interactive)
  (let ((file-name "fmaVersionConfig.ion")
		full-path)
	(if ion-dp20-template-dir
		(if (string-match "/\\'" ion-dp20-template-dir)
			(setq full-path (concat ion-dp20-template-dir file-name))
		  (setq full-path (concat ion-dp20-template-dir "/" file-name)))
	  (message "Error: Please set env DP20_TMPL_DIR for auto-inserting"))
	(if full-path
	    (if (and 
			 (file-exists-p full-path)
			 (yes-or-no-p (format "Insert template: %s" full-path)))
			(insert-file-contents full-path))
	  (message (format "Error: file %s doesn't exist" full-path)))))

(defun ion-insert-tst-offers()
  "Insert override fmaVersionConfig template"
  (interactive)
  (let ((file-name "offers.ion")
		full-path)
	(if ion-dp20-template-dir
		(if (string-match "/\\'" ion-dp20-template-dir)
			(setq full-path (concat ion-dp20-template-dir file-name))
		  (setq full-path (concat ion-dp20-template-dir "/" file-name)))
	  (message "Error: Please set env DP20_TMPL_DIR for auto-inserting"))
	(if full-path
	    (if (and 
			 (file-exists-p full-path)
			 (yes-or-no-p (format "Insert template: %s" full-path)))
			(insert-file-contents full-path))
	  (message (format "Error: file %s doesn't exist" full-path)))))

(defun ion-insert-tst-offerFMAPrice()
  "Insert override fmaVersionConfig template"
  (interactive)
  (let ((file-name "offerFMAPrice.ion")
		full-path)
	(if ion-dp20-template-dir
		(if (string-match "/\\'" ion-dp20-template-dir)
			(setq full-path (concat ion-dp20-template-dir file-name))
		  (setq full-path (concat ion-dp20-template-dir "/" file-name)))
	  (message "Error: Please set env DP20_TMPL_DIR for auto-inserting"))
	(if full-path
	    (if (and 
			 (file-exists-p full-path)
			 (yes-or-no-p (format "Insert template: %s" full-path)))
			(insert-file-contents full-path))
	  (message (format "Error: file %s doesn't exist" full-path)))))


;;;;;end of the functions for inserting templates

(defvar ion-mode-map
  (let ((ion-mode-map (make-keymap)))
    (define-key ion-mode-map "\t" 'ion-indent-dwim)
	(define-key ion-mode-map "\C-m" 'newline-and-indent)
	(define-key ion-mode-map "\C-j" 'newline)
	(define-key ion-mode-map "\M-." 'ion-find-query)
	(define-key ion-mode-map [f9] 'ion-test)
	(define-key ion-mode-map (kbd "C-c l") 'ion-load-src-tst)
	(define-key ion-mode-map (kbd "C-c t") 'ion-test-this)
	(define-key ion-mode-map (kbd "C-c d") 'ion-dired)
    ion-mode-map)
  "Keymap for ion major mode")

;;;###autoload
(define-derived-mode ion-mode prog-mode "ION"
  "Major mode for editing ION files"
  ;The follows codes will run before all hooks and parents' mode's hook
  (message "running ion-mode code....")
  (use-local-map ion-mode-map)
  (set (make-local-variable 'font-lock-defaults) '(ion-font-lock-keywords))
  (set-syntax-table ion-mode-syntax-table)
  (column-number-mode t)
  (global-hi-lock-mode t))

(setq-default tab-width 4)
(defun ion-setup()
  ;(setq c-basic-offset 4)
  (setq indent-tabs-mode nil) ;;inserting tab is not allowed
  (setq compilation-scroll-output t);; automatically scroll when compiling
)
(add-hook 'ion-mode-hook 'ion-setup)
 
(provide 'ion-mode)
;;; ion-mode.el ends here
