#lang eopl
(provide (all-defined-out))
;; Syntax for CORE

; *** Requires relacing the ??? ***

; Lexical structure
(define the-lexical-spec
  '(
    (whitespace (whitespace)                         skip)
    (number     (digit (arbno digit))              number)
    (identifier (letter (arbno (or letter digit))) symbol)
    (unary-prim ("" (or "zero?" "minus" "car" "cdr" "null?")) string)
    (binary-prim("" (or "equal?" "greater?" "less?" "-" "+" "*" "/" "cons")) string) 
   )
)
; Grammar
(define the-grammar
  '(
    (program (expression) a-program)
    
    (expression (number)  const-exp)
    (expression 
     ("print(" expression ")") print-exp)
    (expression
     ("proc(" identifier ")" expression) proc-exp)
    (expression
     (unary-prim "(" expression ")") unary-prim-exp) 
    (expression
     (binary-prim "(" expression "," expression ")") binary-prim-exp)
    (expression
     ("let" (arbno identifier "=" expression)  "in" expression) let-exp)
    (expression ;sequential let
     ("let*" (arbno identifier "=" expression) "in" expression) slet-exp)
    (expression
     ("if" expression "then" expression "else" expression) if-exp)
    (expression
     ("cond" (arbno expression "==>" expression ";") "end") cond-exp)
    ;(cond expression "==>" expression (arbno expression "==>" expression))
     (expression (identifier) iden-exp)
    ;List stuff
    (expression
     ("[" expression (arbno "," expression) "]") list-exp) ;non-empty list
    (expression
     ("[]") empty-list-exp) ;empty list
    )
)
;;;;;;;;;;;;;;;; sllgen boilerplate ;;;;;;;;;;;;;;;;
;; Evaluating the following is *required* to construct the
;; data-types from the lexer and parser specs.
;; ... will be evaluated when this file is 'loaded'
(sllgen:make-define-datatypes the-lexical-spec the-grammar)

;; (sca&parse string) scans and parses the program represented
;; by the string argumnet. Produces an abstract syntax representation of
;; the program if no errors, which can be passed to (execute ...)
(define scan&parse
  (sllgen:make-string-parser the-lexical-spec the-grammar))
;; Applies the scanner given by lexical-spce to a string ...
;; used to test scanners
(define just-scan
  (sllgen:make-string-scanner the-lexical-spec the-grammar))
; (show-the-datatypes) displays the data-types created by the scanner
; and parser
(define (show-the-datatypes)
  (sllgen:list-define-datatypes the-lexical-spec the-grammar))
  