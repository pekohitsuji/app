;;; -*- coding: utf-8-unix; mode: scheme -*-
(import (scheme base))
(import (scheme show))
(import (scheme process-context))
(import (srfi 13)) ; string-prefix?

(import (only (gauche base) read-from-string))

(import (app son))

;;; # 概要
;;;   son データを Tcl 用文字データに変換し、標準出力に出力する
;;;
;;; # 使用法
;;;   - `gosh app/son2tcl \[son-file | "(path to son-file)"\]`
;;;
;;; # 使用例
;;;   - `gosh app/son2tcl ../yokotan/avatar/fail/2026-02-17-0002.scm`
;;;
;;; # 注意
;;;   - 引数に指定するパス名は
;;;     - son 形式
;;;     - 絶対パスまたはカレントディレクトリからの相対パス
;;;
;;; # 依存
;;;   (import (app son))
;;;

(define (son? x) (string=? (substring x 0 1) "("))

(let ((args (cdr (command-line))))
  (map
   (lambda (arg)
     (let ((path (son-read (if (son? arg) (read-from-string arg) arg))))
       (if path
           (begin (son2tcl path) (show #t nl))
           (show #t "Not found: " arg nl))))
   args))
