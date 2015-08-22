#lang racket

(require net/url)
(require sxml/html)

(require "html-wrap.rkt")

(provide html-string->tag)
(provide download-page)

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

;;Test if there is a nested list inside the sexp
(define (nested-list? sexp)
  (ormap list? sexp))

;;Converts a sexp structure into a tag structure
(define (sexp->tag sexp)
  (when (list? sexp)
    (tag-init (sexp->name sexp) (sexp->string sexp) '() 
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

