;;; -*- coding: utf-8-unix; mode: scheme; -*-
(import (scheme base))
(import (scheme show))
(import (scheme process-context))

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
      "  引数が SRC 属性の IMG タグを出力する"
      ""
      "# 使用法"
      ""
      (join "  gosh" cmd "[-t str] [-j url] [-c url] [-h] [file ...]")
      ""
      "  -t | --title str : デフォルト title  タグなし"
      "  -j | --js    url : デフォルト script タグなし"
      "  -c | --css   url : デフォルト link   タグなし"
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
 ((title "t|title=s" #f)
  (js    "j|js=s"    #f)
  (css   "c|css=s"   #f)
  (help  "h|help" => show-help)
  . restargs)
 (show #t "<!DOCTYPE html>" nl)
 (show #t "<html lang=\"ja\">" nl)
 (show #t "  <head>" nl)
 (and title (show #t "    <title>" title "</title>" nl))
 (and js    (show #t "    <script src=\"" js "\"></script>" nl))
 (and css   (show #t "    <link rel=\"stylesheet\" href=\"" css "\" />" nl))
 (show #t "  </head>" nl)
 (show #t "  <body>" nl)
 (let loop ()
   (let ((line (read-line)))
     (cond
      ((eof-object? line) (values))
      (else (show #t line nl) (loop)))))
 (show #t "  </body>" nl)
 (show #t "</html>" nl))

;;; Local Variables:
;;; indent-tabs-mode: nil
;;; End:
