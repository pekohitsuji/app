;;; -*- coding: utf-8-unix; mode: scheme -*-
(import (scheme base))
(import (scheme show))
(import (scheme process-context))

(define (show-img width)
  (lambda (src)
    (show #t "<img width=\"" width "\" src=\"" src "\">" nl)))

(let ((args (cdr (command-line))))
  (for-each (show-img "9%") args))
