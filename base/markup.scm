(define-library (app base markup)
;;; -*- coding: utf-8-unix; mode: scheme; -*-
  (import (scheme base))
  (import (scheme show))
  (export text tag attr)
  (begin

    (define-syntax text
      (syntax-rules ()
        ((_) (values))
        ((_ str ...)
         (begin
           (let loop ((lst (list 'str ...)) (first? #t))
             (cond
              ((null? lst) (show #t nl))
              (else
               (and (not first?) (show #t " "))
               (show #t (car lst))
               (loop (cdr lst) #f))))))))

    (define (tag-loop lst)
      (cond
       ((null? lst) (show #t ">" nl))
       ((not (cdar lst)) (tag-loop (cdr lst)))
       ((eq? (cdar lst) #t)
        (show #t " " (caar lst))
        (tag-loop (cdr lst)))
       (else
        (show #t " " (caar lst) "=\"" (cdar lst) "\"")
        (tag-loop (cdr lst)))))

    (define-syntax tag
      (syntax-rules ()
        ((_ name attrs)
         (begin
           (show #t "<" name)
           (tag-loop attrs)))
        ((_ name attrs body ...)
         (begin
           (show #t "<" name)
           (tag-loop attrs)
           body ...
           (show #t "</" name ">" nl)))))

    (define-syntax attr
      (syntax-rules ()
        ((_ name ...)
         (list
          `(name . ,name)
          ...))))

    ))
