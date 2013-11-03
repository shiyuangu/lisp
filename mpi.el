;;; mpi.el --- 

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

;;; Commentary:provide mpi support

;; 

;;; Code:
(defun prepare-mpi ()
  "prepare mpi"
  (interactive)
  (when (boundp 'ac-sources)
    (add-to-list 'ac-sources 'ac-source-gtags)))

(define-skeleton mpi-insert-template
  "Insert mpi template"
  nil ;prompt string
  >"MPI::Init(argc, argv);" \n
  >"int size = MPI::COMM_WORLD.Get_size();"\n
  >"int rank = MPI::COMM_WORLD.Get_rank();"\n
  > _ \n
  >"MPI::Finalize();"\n)

(provide 'mpi)
;;; mpi.el ends here
