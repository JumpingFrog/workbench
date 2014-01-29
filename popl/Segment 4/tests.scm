#lang eopl
(require "syntax.scm")
(require "semantics.scm")
(require "data-structures.scm")
(require "driver.scm")
(require "envs.scm")
(require srfi/1)
;;
;
; CORE
;
(define ten   "10")               ;; 10
(define true  "zero?(0)")         ;; #t
(define nope! "zero?(10)")        ;; #f
(define Hmm?  "zero?(zero?(0))")  ;; semantic error
(define HmHm!  "-( 2, zero?(2))") ;; semantic error
(define e1 ;; 3
    "if zero?( -( 2, 3) ) then 4 else -( 4, -(2,1))")
(define if1  ;; 2    
     "if zero?(1) then 10 else if zero?(1) then 1 else 2")
(define if2 ;; 398    
     "if zero?(1) then 10 else -( 400, if zero?(1) then 1 else 2)")
;
; ** Add more tests ***
(define eq1 "equal?(10, 10)") ;; k
(define l1 "less?(10, 10)")
(define l2 "less?(10, 5)")

(define g1 "greater?(10, 10)")
(define g2 "greater?(5, 10)")

(define g3 "greater?(hi, 10)")

(define con1 "cond equal?(1,2) ==> print(10); equal?(2,3) ==> print(12); equal?(+(2,2), 4) ==> print(+(2,3)); end")
(define con2 "cond equal?(1,2) ==> print(10); equal?(2,3) ==> print(12); equal?(+(2,2), 5) ==> print(+(2,3)); end")

(define ls1 "null?([])")
(define ls2 "print([10])")
(define ls3 "cdr([1, 2, 3])")
(define ls4 "car([1, 2, 3])")
(define ls5 "car(cons([1, 2, 3], [4, 5, 6]))")

(define l3 "let x = 20 in +(x, 1)")
(define l4 "let x = 20 y = 5 in +(+(x, 1), y)")
(define l5 "let* x = 20 y = +(x, 1) in +(y, 1)")
(define l6 "let* y = +(x, 2) x = 10 in +(y, 1)")
(define l7 "let x = proc(y) { +(y, 1) } in (x 20)")

(define p1 "letp inc(x) = +(x,1) in (x 5)")