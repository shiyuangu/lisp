;;; myoctave.el --- 

;; Copyright (C) 2014  Gu

;; Author: Gu <shiyuang@685b35881646.ant.amazon.com>
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
;(autoload 'octave-mode "octave-mod" nil t)
(setq auto-mode-alist
      (cons '("\\.m$" . octave-mode) auto-mode-alist))
(setq-default tab-width 4)
(defun my-c++-indent-setup ()
  (setq c-basic-offset 4)
  (setq indent-tabs-mode nil))
(defun octave-my-setting ()
  (local-set-key (kbd "C-j") 'newline)
  (local-set-key (kbd "C-m") 'reindent-then-newline-and-indent)
  (local-set-key (kbd "s-<return>") 'octave-send-line)
  (setq c-basic-offset 4)
  (setq indent-tabs-mode nil)
  (setq octave-help-files '("octave" "octave-LG")))
;(defun RET-behaves-as-LFD ()
;  (let ((x (key-binding "\C-j")))
;    (local-set-key "\C-m" x)))
;(add-hook 'octave-mode-hook 'RET-behaves-as-LFD)
(add-hook 'octave-mode-hook 'octave-my-setting)

(provide 'myoctave)
;;; myoctave.el ends here
