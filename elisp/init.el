(require 'cl-lib)

(defun elbot-doc (keyword)
  (cond ((fboundp keyword) (substring-no-properties (describe-function keyword)))
        ((boundp keyword) (substring-no-properties (describe-variable keyword)))
        (t (format "Not found '%s'" keyword))))
