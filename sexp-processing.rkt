#lang racket

(require net/url)
(require sxml/html)
(require racket/match)
(require "html-wrap.rkt")

(provide html-string->tag)
(provide download-page)
(provide dict)
;;Wrapper around racket url procedure. Reads in page as string.
;;Shamelessly stolen from a stackoverflow answer
(define (urlopen url)
  (call/input-url
   (string->url url)
   (curry get-pure-port #:redirections 5)
   port->string))

;;Helper functions for processing sexp

;;Returns a string consisting of all strings in the sexp
(define (sexp->string sexp)
  (when (list? sexp)
    (string-join (map (lambda (x)
                        (if (string? x)
                          x
                          "")) sexp))))

;;Returns a string consisting of the name of the tag the sexp
;;represents
(define (sexp->name sexp)
  (when (list? sexp)
    (symbol->string (car sexp))))

;;Returns a "psuedo" dictionary of all attributes in tags
(define (sexp->attrs sexp)
  (define-values (a-tag) (filter (lambda (x)
            (if (list? x) (equal? (car x) '@) #f)) sexp))
  (cond
    [(null? a-tag) '()]
    [else (map (lambda (x)
                  `(,(symbol->string (car x)) . ,(cdr x))) (cdr (car a-tag)))]))

;;Test if there is a nested list inside the sexp
(define (nested-list? sexp)
  (ormap list? sexp))

;;Converts a sexp structure into a tag structure
(define (sexp->tag sexp)
  (when (list? sexp)
    (tag-init (sexp->name sexp) (sexp->string sexp) (sexp->attrs sexp)
              (filter (lambda (x)
                        (tag? x)) (map sexp->tag sexp)))))

;;Converts html in the form of a string into a tag structure
(define (html-string->tag html)
  (sexp->tag 
    (html->xexp html)))

;;Reads in a url in the form of a string, reads the content as
;;a string, converts it a sexp, and then converts it into a tag
;;structure
(define (download-page url)
  (html-string->tag
    (urlopen url)))

(define (dict key d)
  (map (lambda (x) (cadr x))
       (filter (lambda (x)
            (equal? (car x) key)) d)))
