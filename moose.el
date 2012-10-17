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
;(add-to-list 'hs-special-modes-alist '(moose-mode "\\[begin]" "\\[end]" "#"  moose-forward-sexp-func nil))
(add-to-list 'hs-special-modes-alist '(moose-mode "\\[\\./[^.]+]\\|\\[[a-zA-z]+]" "\\[\\.\\./]\\|\\[]" "#" moose-forward-sexp-func nil))

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
        ;( ,(regexp-opt '("Variables" "\[TensorMechanics\]") 'word) . font-lock-function-name-face)
	( ,"\\[.*\\]" . font-lock-function-name-face)
        ( ,(regexp-opt '("Pi" "Infinity") 'word) . font-lock-constant-face)
        )
      )

;; syntax table
(defvar moose-syntax-table nil "Syntax table for `moose-mode'.")
(setq moose-syntax-table
      (let ((synTable (make-syntax-table)))

        ;; bash style comment: “# …” 
        (modify-syntax-entry ?# "< b" synTable)
        (modify-syntax-entry ?\n "> b" synTable)

        synTable))

;; define the major mode.
(define-derived-mode moose-mode fundamental-mode
  "moose-mode is a major mode for editing MOOSE input file."
  :syntax-table moose-syntax-table
  
  (setq font-lock-defaults '(moose-keywords))
  (setq mode-name "MOOSE")
  (setq comment-start "#")
  (setq comment-end "")
  (hs-minor-mode 1)
  ;(add-to-list 'hs-special-modes-alist '(moose-mode "\\[\\./[^.]+]\\|\\[[a-zA-z]+]" "\\[\\.\\./]\\|\\[]" "#" nil nil))
  ;; modify the keymap
  (define-key moose-mode-map [remap comment-dwim] 'moose-comment-dwim)
)
;;for hide/show moose blocks defined by tags
;;(add-to-list 'hs-special-modes-alist '(moose-mode "{" "}" "/[*/]" nil nil))