#lang eopl
;; Semantic interpreter for CORE
(provide  (all-defined-out))
(require "syntax.scm")
(require "data-structures.scm")
;; 
;; (execute ...) takes an abstract syntax representation of a program,
;; and returns its Expressed Value
;;
(define (execute prog)
  (cases program prog
    (a-program (exp) (value-of exp)) ;;?
  )
)
;;
;; (value-of ...) takes an abstract syntax representation of an expression
;; and returns its Expressed Value

;; ** Requires editing the ???s **
(define (value-of expr)                     
  (cases expression expr    
    (const-exp (num) (number-ExpVal num)) ;;Here
    (unary-prim-exp (op exp)
        (apply-unary op exp))
    (binary-prim-exp (op exp1 exp2)
        (apply-binary op exp1 exp2))
    (if-exp (test true-exp false-exp)
         (if (ExpVal->bool (value-of test))
                  (value-of true-exp)        
                  (value-of false-exp)       
         ) 
    )
  )
)
(define unary-ops (list (cons "minus" -) (cons "zero?" zero?)))
(define binary-ops (list (cons "equal?" equal?) (cons "greater?" >)
                         (cons "less?" <) (cons "-" -) (cons "+" +)
                         (cons "*" *) (cons "/" /)))

(define (apply-binary op exp1 exp2)
  (let ((tmp (assoc op binary-ops)))
   (if tmp
        (->ExpVal ((cdr tmp) (<-ExpVal (value-of exp1))
                             (<-ExpVal (value-of exp2))))
        (eopl:error 'apply-unary "Operator not found.")
   ))
)

(define (apply-unary op exp)
  (let ((tmp (assoc op unary-ops)))
   (if tmp
        (->ExpVal ((cdr tmp) (<-ExpVal (value-of exp))))
        (eopl:error 'apply-unary "Operator not found.")
   ))
)


