;;; -*- coding: utf-8-unix; mode: scheme -*-
(import (scheme base))
(import (scheme show))
(import (scheme process-context))

(import (app son))

;;; # 概要
;;;   son 形式のパスを絶対パスに直す
;;;   son 形式のパスにファイルが存在しないなら(改行のみ)を返す
;;;
;;; # 使用法
;;;   `gosh app/son-path path to son-file`
;;;
;;; # 使用例
;;;
;;; 環境変数 GAUCHE_LOAD_PATH に /home/foo/bar が含まれているとき
;;; ```
;;; $ gosh app/son-path yokotan avatar fail 2026-02-17-0002
;;; /home/foo/bar/yokotan/avatar/fail/2026-02-17-0002.scm
;;; ```
;;;
;;; # 注意
;;;   - 引数に指定するパス名は son 形式で
;;;     GAUCHE_LOAD_PATH からのパスを空白区切りで指定する
;;;
;;; # 依存
;;;   (import (app son))
;;;

(let ((path (son-path (map string->symbol (cdr (command-line))))))
  (show #t (if path path "") nl))
