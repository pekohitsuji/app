;;; -*- coding: utf-8-unix; mode: scheme; -*-
(import (scheme base))
(import (scheme show))
(import (scheme process-context)) ; command-line
(import (scheme regex))
(import (srfi 13)) ; string-join

(import (gauche parseopt))

(import (app base markup))

(define (show-help)
  (let ((cmd (car (command-line)))
        (join (lambda strs (string-join strs " "))))
    (for-each
     (lambda (str) (show #t str nl))
     (list
      ""
      "# 概要"
      ""
      "  コマンドライン引数を SRC 属性にした IMG or VIDEO タグを出力する"
      ""
      "# 使用法"
      ""
      (join "  gosh" cmd "[-w str] [-h] [file ...]")
      ""
      "  -w | --width       str : デフォルト 16%"
      "  -v | --video-width str : デフォルト 504px"
      "  -c | --controls        : デフォルト OFF"
      "  -m | --muted           : デフォルト OFF"
      "  -l | --loop            : デフォルト OFF"
      "  -h | --help"
      ""
      "# 使用例"
      ""
      (join "  gosh" cmd "*.png")
      ""
      "  find \( -name \"*.jpg\" -o -name \"*.png\" \) | sort \\"
      (join "    | xargs gosh" cmd "-w 16%")
      ""))))

(let-args
 (cdr (command-line))
 ((width       "w|width=s"       "16%")
  (video-width "v|video-width=s" "16%")
  (controls    "c|controls")
  (loop        "l|loop")
  (muted       "m|muted")
  (help        "h|help" => show-help)
  . restargs)
 (let _loop ((srcs restargs) (count 1))
   (cond
    ((null? srcs) (values))
    (else
     (let ((src (car srcs)))
       (cond
        ((regexp-search '(w/nocase (or ".jpg" ".png" ".gif") eos) src)
         (tag 'img     (attr width src)))
        ((regexp-search '(w/nocase (or ".mov" ".mp4") eos) src)
         (let ((width video-width))
           (tag 'video (attr width src controls loop muted) (text)))))
       (_loop (cdr srcs) (+ count 1)))))))

;;; Local Variables:
;;; indent-tabs-mode: nil
;;; End:
