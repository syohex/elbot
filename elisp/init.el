(require 'cl-lib)

(defun elbot-doc (keyword)
  (cond ((fboundp keyword) (substring-no-properties (describe-function keyword)))
        ((boundp keyword) (substring-no-properties (describe-variable keyword)))
        (t (format "Not found '%s'" keyword))))

(defvar elbot-forbidden-functions
  '(kill-emacs
    save-buffers-kill-emacs save-buffers-kill-terminal

    delete-file delete-directory

    shell-command shell-command-to-string
    call-process call-process-shell-command call-process-region
    process-file process-file-shell-command

    defun cl-defun defmacro cl-defmacro defsubst cl-defsubst setf))

(dolist (fn elbot-forbidden-functions)
  (fset fn `(lambda (&rest _args) ,(format "Can't use \"%s\" function. :scream:" fn))))
(fset 'fset (lambda (&rest _args) "Can't use \"fset\" function. :scream:"))
