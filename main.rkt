#lang typed/racket

(require "html-wrap.rkt")
(require/typed "sexp-processing.rkt" 
               [html-string->tag (-> String tag)] 
               [download-page (-> String tag)])

(define example
  "<html>
  <title>Hello World!</title>
  <body>
  <p>This is text</p>
  <p>More text</p>
  <div>
  <p>Mooooree text</p>
  </div>
  </body>
  </html>")

(define proc (download-page 
               "http://www.baka-tsuki.org/project/index.php?title=Rakudai_Kishi_no_Eiyuutan:Volume1_Prologue"))
(display (prettify proc))
