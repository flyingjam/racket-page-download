#lang racket
(require "html-wrap.rkt")
(require "sexp-processing.rkt")

(define image "<img src = 'hi' width = 50>")
;(define proc (download-page "http://www.baka-tsuki.org/project/index.php?title=Rakudai_Kishi_no_Eiyuutan:Volume1_Prologue"))
(define proc (html-string->tag image))
(define (dict key d)
  (map (lambda (x) (cadr x))
       (filter (lambda (x)
            (equal? (car x) key)) d)))
(print (dict "src" (tag-attr (car (tag-child proc)))))
;(display (prettify proc))
