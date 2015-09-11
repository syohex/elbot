#!/bin/sh
set -e

emacs -Q --daemon=elbot -l elisp/init.el
./bin/hubot --adapter slack
