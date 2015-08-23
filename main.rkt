#lang typed/racket

(require "html-wrap.rkt")
(require/typed "sexp-processing.rkt" 
               [html-string->tag (-> String tag)] 
               [download-page (-> String tag)]
               [dict (-> String (Listof (Pair Any Any)) (Listof Any))])

(define example
  "<html>
  <title>Hello World!</title>
  <body>
  <p>This is text</p>
  <p>More text</p>
  <img src = 'hi'>
  <div>
  <p>Mooooree text</p>
  </div>
  </body>
  </html>")

(define image "<img src = 'hi' width = 50>")
;(define proc (download-page "http://www.baka-tsuki.org/project/index.php?title=Rakudai_Kishi_no_Eiyuutan:Volume1_Prologue"))
(define proc (html-string->tag image))

(print (dict "src" (tag-attr (car (tag-child proc)))))
;(display (prettify proc))

