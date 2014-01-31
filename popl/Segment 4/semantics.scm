#lang eopl
;; Semantic interpreter for CORE
(provide  (all-defined-out))
(require "syntax.scm")
(require "data-structures.scm")
(require "envs.scm")
(require srfi/1)


(define myenv (empty-env)) ;Variable environment
;; 
;; (execute ...) takes an abstract syntax representation of a program,
;; and returns its Expressed Value
;;
(define (execute prog)
  (cases program prog
    (a-program (exp) (value-of exp (empty-env))) ;;?
  )
)
;;
;; (value-of ...) takes an abstract syntax representation of an expression
;; and returns its Expressed Value
(define (value-of expr env)                     
  (cases expression expr    
    (const-exp (num) (number-ExpVal num))
    (unary-prim-exp (op exp)
        (apply-unary op exp env))
    (binary-prim-exp (op exp1 exp2)
        (apply-binary op exp1 exp2 env))
    (iden-exp (exp)
              (apply-env env exp))
    (print-exp (exp)
               (display (<-ExpVal (value-of exp env)))
               (value-of exp env))
    (if-exp (test true-exp false-exp)
         (if (ExpVal->bool (value-of test))
                  (value-of true-exp env)        
                  (value-of false-exp env)       
         ) 
    )
    (cond-exp (cond-list exp-list)
              (eval-cond (zip cond-list exp-list) env))
    ;let
    (let-exp (idd idexp letexp)
             (value-of letexp (extend-env-list idd (map (lambda (exp) (value-of exp env)) idexp) env))
    )
    (slet-exp (idd idexp letexp) ;Sequential let
              (value-of letexp (fold (lambda (p e)
                                       (extend-env (car p) (value-of (cadr p) e) e)) 
                                        env (zip idd idexp)))
    )
    ;procedures
    (proc-exp (id exp)
             (->ExpVal (procedure id exp env))
    )
    (call-exp (id exp)
              ((<-ExpVal (apply-env env id)) (value-of exp env)) ;applying and extracting id gives a lambda (val) so apply exp to it.
    )
    (letp-exp (ids args exps lexp) ;procedure let
              (value-of lexp (fold (lambda (p e) (extend-env (car p) (->ExpVal (procedure (car (cadr p)) (cadr (cadr p)) e)))
                                env (zip ids (zip args exps)))))
    )
    ; ("letp" (arbno identifier "(" identifier ")" "=" expression ",") "in" expression) letp-exp)
    ;lists
    (empty-list-exp ()
             (->ExpVal '())
    )
    (list-exp (exp1 exp2)
          (->ExpVal (map (lambda (x) (<-ExpVal (value-of x env))) (cons exp1 exp2)))
    )
  )
)

(define (procedure id exp env) ;create a function that evaluates the proc procedure
       (lambda (val)
        (value-of exp (extend-env id val env))))

(define unary-ops (list (cons "minus" -) 
                        (cons "zero?" zero?)
                        (cons "car" car)
                        (cons "cdr" cdr)
                        (cons "null?" null?)
                  )
)

(define binary-ops (list (cons "equal?" equal?) 
                         (cons "greater?" >)
                         (cons "less?" <) 
                         (cons "-" -) 
                         (cons "+" +)
                         (cons "*" *) 
                         (cons "/" /)
                         (cons "cons" cons)
                   )
)

(define (apply-binary op exp1 exp2 env)
  (let ((tmp (assoc op binary-ops)))
   (if tmp
        (->ExpVal ((cdr tmp) (<-ExpVal (value-of exp1 env))
                             (<-ExpVal (value-of exp2 env))))
        (eopl:error 'apply-unary "Operator not found.")
   ))
)

(define (apply-unary op exp env)
  (let ((tmp (assoc op unary-ops)))
   (if tmp
        (->ExpVal ((cdr tmp) (<-ExpVal (value-of exp env))))
        (eopl:error 'apply-unary "Operator not found.")
   ))
)

(define (eval-cond pair-list env)
   (if (equal? (length pair-list) 0)
       (eopl:error "No condition is true.{Multi-way cond}")
   (if (ExpVal->bool (value-of (car (car pair-list)) env))
                  (value-of (cdr (car pair-list)) env)               
        (eval-cond (cdr pair-list) env)
   ))
)

;(define (slet-fold ipairs env) ;accept a pair and an env + extend env
  
;)
;(foldr (lambda (e p) (apply-env (car p) (cadr (value-of p e)) e)) env (zip ids id-exps) )

