;;; mypython.el --- setup for python 

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

;; Prerequisite: myjedi.el 

;;; Code:

(require 'myjedi)
(add-hook 'python-mode-hook 'jedi:setup)
(add-hook 'python-mode-hook 'jedi-config:setup-keys)

(provide 'mypython)
;;; mypython.el ends here
