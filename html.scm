;;; -*- coding: utf-8-unix; mode: scheme -*-
(import (scheme base))
(import (scheme show))
(import (scheme process-context))

(show #t "<!DOCTYPE html>" nl)
(show #t "<html lang=\"ja\">" nl)
(show #t "  <head>" nl)
(show #t "  </head>" nl)
(show #t "  <body>" nl)
(let loop ()
  (let ((line (read-line)))
    (cond
     ((eof-object? line) (values))
     (else (show #t line nl) (loop)))))
(show #t "  </body>" nl)
(show #t "</html>" nl)
