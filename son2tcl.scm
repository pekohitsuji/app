;;; -*- coding: utf-8-unix; mode: scheme -*-
(import (scheme base))
(import (scheme process-context))

(import (app son))

;;; # 概要
;;;   son データを Tcl 用文字データに変換する
;;;
;;; # 使用法
;;;   `gosh app/son2tcl son-file`
;;;
;;; # 使用例
;;;   - `gosh app/son2tcl yokotan/avatar/fail/2026-02-17-0002.scm`
;;;
;;; # 注意
;;;   - 引数に指定するパス名は son 形式でなく
;;;     絶対パスまたはカレントディレクトリからの相対パス
;;;
;;; # 依存
;;;   (import (app son))
;;;

(son2tcl (son-read (cadr (command-line))))
