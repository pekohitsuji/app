(define-library (app son)
;;; -*- coding: utf-8-unix; mode: scheme -*-
  (import (scheme base)) ; string-append, string-length, symbol->string
  (import (scheme read)) ; read
  (import (scheme file)) ; call-with-input-file, file-exists?
  (import (scheme show))
  (import (scheme char)) ; char-whitespace?
  (import (srfi 152)) ; string-split string-any
  (import (only (srfi 13) string-join))

  ;;; Not compatible R7RS, specified Gauche
  (import (only (gauche base) *load-path*))

  (export son-path son-read son-find son-file son2tcl)

  (begin
    ;;; Not compatible R7RS, specified Gauche
    (define (load-paths) *load-path*)

    ;;; Not export
    (define path-separator '/)

    (define (list->path lst)
      (string-join
       (map symbol->string
            (cond
             ((null? lst) '())
             ((eq? path-separator (car lst)) (cdr lst))
             (else lst)))
       (symbol->string path-separator)))

    ;;; Export

    ;;; Require existing of file specified path-list
    (define (son-path path-list)
      (let* ((sep (symbol->string path-separator))
             (ext ".scm")
             (extlen (string-length ext))
             (base (list->path path-list))
             (baselen (string-length base))
             (basescm (string-append base ext)))
        (if (string=? "" base)
            ""
            (let loop ((paths (load-paths)))
              (cond ((null? paths) #f)
                    ((file-exists? (string-append (car paths) sep base))
                     (string-append (car paths) sep base))
                    ((file-exists? (string-append (car paths) sep basescm))
                     (string-append (car paths) sep basescm))
                    (else (loop (cdr paths))))))))

    (define (son-read path-list-or-string)
      (cond
       ((pair? path-list-or-string)
        (let ((path (son-path path-list-or-string)))
          (and path (call-with-input-file path read))))
       ((string? path-list-or-string)
        (call-with-input-file path-list-or-string read))
       (else #f)))

    (define (son-find data k)
      (let ((res (assoc k data)))
        (and (pair? res) (cdr res))))

    (define (son-file data k)
      (let ((res (assoc k data)))
        (and (pair? res) (list->path (cdr res)))))

    (define (son2tcl-car x)
      (cond
       ((pair? x)
        (show #t "{")
        (son2tcl x)
        (show #t "}"))
       ((symbol? x)
        (let ((str (symbol->string x)))
          (if (string-any char-whitespace? str)
              (show #t "{" str "}")
              (show #t str))))
       ((string? x) (show #t "\"" x "\""))
       (else (show #t x))))

    (define (son2tcl-cdr x)
      (cond
       ((pair? x)
        (show #t " {")
        (son2tcl x)
        (show #t "}"))
       ((symbol? x)
        (let ((str (symbol->string x)))
          (if (string-any char-whitespace? str)
              (show #t " {" str "}")
              (show #t " " str))))
       ((string? x) (show #t " \"" x "\""))
       (else (show #t " " x))))

    (define (son2tcl x)
      (son2tcl-car (car x))
      (map son2tcl-cdr (cdr x)))))
