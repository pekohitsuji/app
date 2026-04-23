;;; -*- coding: utf-8-unix; mode: scheme -*-
(import (scheme base))
(import (scheme show))
(import (scheme process-context))

;;; # 概要
;;;
;;;   引数が SRC 属性の IMG タグを出力する
;;;
;;; # 使用法
;;;
;;;   find -name "*.png" | xargs app/img
;;;

(define (show-video width)
  (lambda (src)
    (show #t "<video"
          " width=\"" width "\""
          " src=\"" src "\""
          " controls loop muted></video>" nl)))

(let ((args (cdr (command-line))))
  (for-each (show-video "504px") args))
