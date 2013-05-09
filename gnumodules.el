;;; gnumodules.el --- define a major mode for GNU Modules

;; Copyright (C) 2013  S. Gu

;; Author: S. Gu <sgu@anl.gov>

;;; Code:

(provide 'gnumodules)

;; define the major mode.
(define-derived-mode gnumodules-mode tcl-mode
  "gnumodules-mode is a major mode for editing GNU Modules modulefile."

  
  (setq mode-name "GNU Modules")
)
;;; gnumodules.el ends here
