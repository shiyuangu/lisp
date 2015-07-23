;;; sql.el --- helper functions for inserting query template

;; Copyright (C) 2015  sgu

;; Author: sgu <sgu@sgu-VirtualBox>
;; Keywords: 
(defvar sgu-sql-template-directory "~/templates")
(defun sgu-sql-copy-block-from-file (blockname filename)
  "copy a block from the file and put it into the kill-ring"
  (interactive)
  (with-temp-buffer
    (if
     (file-readable-p (setq full-filename (expand-file-name
			        filename sgu-sql-template-directory)))
     (let (start-point end-point)
       (insert-file-contents full-filename)
       (search-forward blockname nil nil)
	   (beginning-of-line)
       (setq start-point (point))
       (search-forward ";" nil nil)
       (setq end-point (point))
       (kill-region start-point end-point)
       )
     (message "Template file %s doesn't exist" full-filename))))

(defun sgu-sql-insert-query-schema()
  "Insert query for listing all table_name, columns in the database"
  (interactive)
  (sgu-sql-copy-block-from-file "query-schema" "template.sql")
  (yank))

(provide 'sgu-sql)
