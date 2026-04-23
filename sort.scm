;;; -*- coding: utf-8-unix; mode: scheme -*-
(import (scheme base))
(import (scheme show))
(import (scheme process-context))
(import (scheme comparator))
(import (srfi 95))

(import (file util))

(define (read-lines)
  (let loop ((acc ()))
    (let ((line (read-line)))
      (cond
       ((eof-object? line) (reverse acc))
       (else (loop (cons line acc)))))))

(define (show-line)
  (lambda (str) (show #t str nl)))

(define (make-filename-order func)
  (lambda (a b)
    (let ((bas-a (path-sans-extension a))
          (ext-a (path-extension      a))
          (bas-b (path-sans-extension b))
          (ext-b (path-extension      b)))
      (cond
       ((func     bas-a bas-b) #t)
       ((string=? bas-a bas-b)
        (cond
         ((and (not ext-a) (not ext-b)) #t)
         ((not ext-a) #t)
         ((not ext-b) #f)
         ((func ext-a ext-b) #t)
         (else #f)))
       (else #f)))))

(for-each
 (show-line)
 (sort (read-lines)
       (make-comparator string?
                        string=?
                        (make-filename-order string<?)
                        #f)))
