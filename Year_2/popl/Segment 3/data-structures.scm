#lang eopl
(require "syntax.scm")
(provide (all-defined-out))
;;
;; Expressed Values for CORE
;;    an expressed value is a number or a truth-value 
;;
(define-datatype  ExpVal ExpVal?
  (number-ExpVal  (a-number number?))
  (bool-ExpVal    (a-boolean boolean?))
  (list-ExpVal    (a-list list?))
  )
;; Injection function for taking a scheme value into the set of Expressed Values
(define (->ExpVal x)
  (cond
    ((number? x)  (number-ExpVal x))
    ((boolean? x) (bool-ExpVal x))
    ((list? x)    (list-ExpVal x))
    ;((ExpVal? x)  ((lambda (y) (y)) x)) ;incase we pass an expval, do nothing (for car)
    (else (eopl:error '->ExpVal "~s cannot be an Expressed Value" x))
    )
  )
;;; Specific extractors:
; EOPL p70
; ExpVal->num : ExpVal -> number
(define (ExpVal->number v)
  (cases ExpVal v
    (number-ExpVal (s) s)
    (else (ExpVal-extractor-error 'Number v))
    )
  )
; ExpVal->num : ExpVal -> truth-value
(define (ExpVal->bool v)
  (cases ExpVal v
    (bool-ExpVal (s) s)
    (else (ExpVal-extractor-error 'Boolean v))
    )
  )

; ExpVal->list : ExpVal -> list
(define (ExpVal->list v)
  (cases ExpVal v
    (list-ExpVal (s) s)
    (else (ExpVal-extractor-error 'List v))
    )
  )


;; Convenience function for translating an Expressed value into a scheme value
(define (<-ExpVal x)
  (cases ExpVal x    
    (number-ExpVal (v) v)
    (bool-ExpVal   (v) v)
    (list-ExpVal   (v) v)
    (else (ExpVal-extractor-error 'Unmatched))
    )
  )
;;
(define (ExpVal-extractor-error variant value)
  (eopl:error 'ExpVal-extractors "Looking for a ~s, found ~s"
              variant value)
  )

