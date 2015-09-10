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

    insert-file insert-file-1 insert-file-contents insert-file-contents-literally
    insert-file-literally

    find-alternate-file find-alternate-file-other-window
    find-file find-file--read-only find-file-at-point find-file-existing
    find-file-literally find-file-literally-at-point find-file-name-handler
    find-file-noselect find-file-noselect-1 find-file-other-frame find-file-other-window
    find-file-read-args find-file-read-only find-file-read-only-other-frame
    find-file-read-only-other-window

    defun cl-defun defmacro cl-defmacro defsubst cl-defsubst setf))

(dolist (fn elbot-forbidden-functions)
  (fset fn `(lambda (&rest _args) ,(format "[ELBOT_ERROR] '%s'は使用できません. :scream:" fn))))

(defvar elbot-forbidden-games
  '(animate-birthday-present
    blackbox mpuz 5x5 bubbles decipher dissociated-press dunnet hanoi gomoku
    life landmark morse-region unmorse-region nato-region denato-region
    pong snake tetris solitaire zone doctor))

(dolist (fn elbot-forbidden-games)
  (fset fn `(lambda (&rest _args) ,(format "[ELBOT_ERROR]仕事しろ :hamster:" fn))))

(fset 'fset (lambda (&rest _args) "'fset'は使用できません"))
