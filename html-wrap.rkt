#lang typed/racket

(provide tag)
(provide tag?)
(provide tag-name)
(provide tag-content)
(provide tag-attr)
(provide tag-child)

(provide tag->string)
(provide prettify)
(provide tag-init)
;;Struct used to represent one HTML tag. Has a name, content, a list of pairs for the
;;attributes and a list of child tags
(struct tag(
            (name : String)
            (content : String)
            (attr : (Listof (Pair String String)))
            (child : (Listof tag))))

;;Function (with default arguments) for creating a tag struct
(: tag-init (->* (String) (String (Listof (Pair String String)) (Listof tag)) tag))
(define tag-init
  (case-lambda
    ((name) (tag name "" '() '()))
    ((name content) (tag name content '() '()))
    ((name content attrs) (tag name content attrs '()))
    ((name content attrs child) (tag name content attrs child))))

(: tag->string (-> tag String))
(define (tag->string tag)
  (string-join
    `("<",(tag-name tag)">",(tag-content tag)"</",(tag-name tag)">\n") ""))

(: prettify (-> tag String))
(define prettify
  (lambda (x)
    (string-join
      (cond
        [(not (null? (tag-child x)))
         `("\n""<",(tag-name x)">",(tag-content x),(string-join (map prettify (tag-child x)))"</",(tag-name x)">\n")]
        [else (list (tag->string x))]) "")))

;;Helper functions for "psuedo" dictionaries with lists of pairs
(: dict-get (-> (Listof (Pair String String)) String (Listof String)))
(define (dict-get dict key)
  (map (lambda ([a : (Pair String String)])
         (cdr a))
         (filter (lambda([x : (Pair String String)])
            (equal? (car x) key)) dict)))


