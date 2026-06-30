;;; -*- coding: utf-8-unix; mode: scheme -*-
(import (scheme base))
(import (scheme show))
(import (scheme process-context))
(import (only (srfi 152) string-split))

(import (app son))

;;; # 概要
;;;   son データから画像生成AIのプロンプト用 markdown を作る
;;;
;;; # 使用法
;;;   `gosh app/aip son-file`
;;;
;;; # 使用例
;;;   - `gosh app/aip yokotan/avatar/fail/2026-02-17-0002`
;;;   - `gosh app/aip yokotan/avatar/fail/2026-02-17-0002.scm`
;;;
;;; # 依存
;;;   (import (app son))
;;;

(define (show-img src width)
  (show #t "<img src=\"" src "\" width=\"" width "px\">"nl))

;; (define (show-image  son key)
;;   (let ((src (son-path (son-find son key))))
;;     (show-img key src)))

(define (show-image src) (show-img src 200))

(define (show-prompt son key)
  (show #t "### " key nl "```" nl)
  (for-each (lambda (x) (show #t (symbol->string x) nl))
            (son-find son key))
  (show #t "```" nl nl))

(define (chext path-str)
  (let* ((ext ".scm")
         (extlen (string-length ext))
         (len (string-length path-str)))
    (cond
     ((string=? ext (substring path-str (- len extlen) len)) ; 末尾が .scm
      (string-append (substring path-str 0 (- len extlen)) ".png"))
     (else (string-append path-str ".png")))))

;;; エントリー
(let* ((path-strs (string-split (cadr (command-line)) "/"))
       (path-list (map string->symbol path-strs))
       (path-str  (son-path path-list))
       (son       (son-read path-list)))
  (show #t "<!-- coding: utf-8-unix; mode: markdown -->" nl)

  (show #t    "## Source data" nl nl)
  (show #t "- " path-list nl)
  (show #t "- " path-str  nl)
  (show #t nl "## Stable Diffusion" nl)
  (show #t nl "### output images" nl nl)
  (map
   (lambda (output-str)
    (cond (output-str (show-image output-str))
          (else       (show-image (chext path-str)))))
   (map son-path (son-find son 'output)))
  (show #t nl "### input images" nl nl)
  (map (lambda (input-str) (show-image input-str))
       (map son-path (son-find son 'input)))
  (show #t nl)
  (show-prompt son 'prompt)
  (show-prompt son 'negative))
