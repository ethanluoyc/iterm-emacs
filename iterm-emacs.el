;;; iterm-emacs.el --- Run commands in iTerm from Emacs easily -*- lexical-binding: t -*-

;; Copyright © 2011-2016 Ethan Luo <ethanluoyc@gmail.com>

;; Author: Ethan Luo <ethanluoyc@gmail.com>
;; URL:
;; Package-Version:
;; Keywords: convenience
;; Version:
;; Package-Requires:

;; This file is NOT part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:
;;
;; This library provides integration with the iTerm application.  It
;; allows you to send commands to the iTerm application.
;;
;;; Code:


(require 'projectile)

(defvar iTerm-default-command nil
  "The default command to run in iTerm.")

(defun call-iTerm-with-command (command activate)
  "Send `COMMAND' to the last active iTerm session.

If `ACTIVATE' is set to t, it will toggle focus on the
iTerm application."
  (interactive (list
                (read-string "Command: " iTerm-default-command nil nil nil)
                (yes-or-no-p "Activate iTerm?")))
  (setq iTerm-default-command command)
  ;; http://irreal.org/blog/?p=4865 This link contains inspiration
  ;; for calling Apple Script from Emacs
  (do-applescript (format "
       tell application \"iTerm\"
         %s
	       tell current session of first window
		       write text \"%s\"
	       end tell
       end tell " (if activate "activate" "") command))
  )

(defun call-iTerm-and-activate (command)
  "Invoke `COMMAND' in iTerm and toggle focus on the iTerm application."
  (interactive (list
                (read-string "Command: " iTerm-default-command nil nil nil)))
  (call-iTerm-with-command command "activate"))

(defun projectile-run-in-iTerm (command)
  "Invoke `COMMAND' at the root of the projectile project."
  (interactive (list
                (read-string "Command: " iTerm-default-command nil nil nil)))
  (call-iTerm-with-command (format "cd %s" (projectile-project-root)) t)
  (call-iTerm-with-command command t)
  )


(provide 'iterm-emacs)

;;; iterm-emacs.el ends here
