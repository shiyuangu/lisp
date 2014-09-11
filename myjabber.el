;;; myjabber.el --- my setup for emacs  jabber

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

;; 

;;; Code:

(add-to-list 'load-path "~/lisp/emacs-jabber-0.8.0")
(require 'jabber-autoloads)
(defun jabber-presence-default-message-sgu (who oldstatus newstatus statustext)
  "This function returns nil if OLDSTATUS and NEWSTATUS are equal, and in other
cases a string of the form \"'name' (jid) is now NEWSTATUS (STATUSTEXT)\".

This function is not called directly, but is the default for
`jabber-alert-presence-message-function'."
  (cond
   ((equal oldstatus newstatus)
      nil)
   (t
    (let ((formattedname
	   (if (> (length (get who 'name)) 0)
	       (get who 'name)
	     (symbol-name who)))
	  (formattedstatus
	   (or
	    (cdr (assoc newstatus
			'(("subscribe" . " requests subscription to your presence")
			  ("subscribed" . " has granted presence subscription to you")
			  ("unsubscribe" . " no longer subscribes to your presence")
			  ("unsubscribed" . " cancels your presence subscription"))))
	    (concat " is now "
		    (or
		     (cdr (assoc newstatus jabber-presence-strings))
		     newstatus))))
	  (formattedtext
	   (if (> (length statustext) 0)
	       (concat " (" statustext ")")
	     "")))
      (concat (current-time-string) ":" formattedname formattedstatus formattedtext)))))

(provide 'myjabber)
;;; myjabber.el ends here
