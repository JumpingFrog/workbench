#lang racket
(define nil null)
;;;;;;;;;;;;;;;;;;;;;;;
;
;;;;;;;;;;;;;;;;;;;;;;;
(define (solve search-type)
  (cond ( (equal? search-type 'bfs)
            (breadth-first-search (initialise-fringe (make-node 'ARAD nil nil 0 0)))
        )
;       ( (equal? search-type 'dfs)
;           (depth-first-search (initialise-fringe (make-node 'ARAD nil nil 0 0)))
;       )
        (else "UNKNOWN SEARCH TYPE")
  )
)

(define (breadth-first-search fringe)
   (cond 
      ( (null? fringe) #f)
      ( (goalstate? (get-state (first-element fringe))) ;if the first element in the queue is a goal state...
                    (list
                       "BFS "
                       "SOLUTION="
                       (get-path (first-element fringe)) 
                       "COST="
                       (get-path-cost (first-element fringe)) 
                    ))
      (else (breadth-first-search (add-to-the-end-of-queue (rest-of-queue fringe) (successor-nodes (first-element fringe)))))
   )
)

(define (depth-first-search lim fringe)
   (cond 
      ( (null? fringe) #f)
      ( (goalstate? (get-state (first-element fringe))) ;if the first element in the queue is a goal state...
                    (list
                       "DFS "
                       "SOLUTION="
                       (get-path (first-element fringe)) 
                       "COST="
                       (get-path-cost (first-element fringe)) 
                    ))
      ( (>= (get-depth (first-element fringe)) lim) ;exceeded lim? don't add successors
        (depth-first-search lim (rest-of-queue fringe)))
      (else (depth-first-search lim (add-to-the-front-of-queue (rest-of-queue fringe) (successor-nodes (first-element fringe)))))
   )
)


;retrieve full path (=solution)
(define (get-path node)
   (if (null? (get-parent-node node)) '()
       (append (get-path (get-parent-node node)) (list (get-action node)))
   )
)

; HARDWIRED goal state
(define (goalstate? state)
     (equal? state 'BUCHAREST)
)

;fringe constructors:
;creates a queue with the root node in it
(define (initialise-fringe node)
   (list node)
) 

;adds a list of nodes to the end of the queue 
; <<very handy for breath-first search!>>
(define (add-to-the-end-of-queue fringe list-of-nodes)
   (if (list? list-of-nodes) (append fringe list-of-nodes)
       #f ;should never get here
   )
) 

;adds a list of nodes to the front of the queue 
; <<very handy for depth-first search!>>
(define (add-to-the-front-of-queue fringe list-of-nodes)
   (if (list? list-of-nodes) (append list-of-nodes fringe)
       #f ;should never get here
   )
) 


;fringe predicate
(define (empty-fringe? fringe)
   (null? fringe)
) 

;fringe selectors
;returns the first element (aka head)
(define (first-element fringe)
   (if (null? fringe) #f
      (car fringe)
   )
) 

;returns all but the first element of the queue
(define (rest-of-queue fringe)
   (if (null? fringe) #f
      (cdr fringe)
   )
) 


;node constructor
(define (make-node state parent_node action path_cost depth)
     (list state parent_node action path_cost depth)
)

;selectors
(define (get-state node)
   (car node)
)

(define (get-parent-node node)
   (cadr node)
)

(define (get-action node)
   (caddr node)
)

(define (get-path-cost node)
   (cadddr node)
)

(define (get-depth node)
   (car (cdr (cdr (cdr (cdr node)))))
)

;take a node and return all successor nodes
(define (successor-nodes node)
   (turn-states-into-nodes node (successor-states (get-state node)))
)

;
(define (turn-states-into-nodes node succ-states)
   (if 
      (null? succ-states) '()
      (cons                        ;this will glue together the 1st node with the rest
            (make-node             ;create the first node...
                 (car succ-states) ;the state
                 node              ;the parent node
                 (list (get-state node) (car succ-states)) ;the action (as a '(from to)' list)
                 (+ (get-path-cost node) (find-next-step-cost (get-state node) (car succ-states))) ;the cost
                 (+ (get-depth node) 1);the depth
            )
            (turn-states-into-nodes node (cdr succ-states)) ;the recursive call
      )
   )
)

; returns a list of successor states
(define (successor-states state) 
   (cond
     ((equal? state 'ORADEA)  (list 'SIBIU 'ZERIND))
     ((equal? state 'ZERIND)  (list 'ORADEA 'ARAD))
     ((equal? state 'ARAD)    (list 'TIMISOARA 'SIBIU 'ZERIND))
     ((equal? state 'TIMISOARA) (list 'ARAD 'LUGOJ))
     ((equal? state 'LUGOJ)   (list 'TIMISOARA 'MEHADIA))
     ((equal? state 'MEHADIA) (list 'LUGOJ 'DOBRETA))
     ((equal? state 'DOBRETA) (list 'MEHADIA 'CRAIOVA))
     ((equal? state 'SIBIU)   (list 'ORADEA 'ARAD 'RIMNICU 'FAGARAS))
     ((equal? state 'RIMNICU)   (list 'SIBIU 'CRAIOVA 'PITESTI))
     ((equal? state 'CRAIOVA)   (list 'DOBRETA 'RIMNICU 'PITESTI))
     ((equal? state 'PITESTI)   (list 'RIMNICU 'CRAIOVA 'BUCHAREST))
     ((equal? state 'FAGARAS)   (list 'SIBIU 'BUCHAREST))
     ((equal? state 'BUCHAREST)   (list 'FAGARAS 'PITESTI 'GIURGIU 'URZICENI))
     ((equal? state 'GIURGIU)   (list 'BUCHAREST))
     ((equal? state 'URZICENI)   (list 'BUCHAREST 'VASLUI 'HIRSOVA))
     ((equal? state 'VASLUI)   (list 'URZICENI 'IASI))
     ((equal? state 'IASI)   (list 'VASLUI 'NEAMT))
     ((equal? state 'NEAMT)   (list 'IASI))
     ((equal? state 'HIRSOVA)   (list 'URZICENI 'EFORIE))
     ((equal? state 'EFORIE)   (list 'HIRSOVA))     
     (else '()) ;unknown state, returning an empty list. BTW, '() is equal to #f .
   )
)

(define (find-next-step-cost from to)
   (cond
     ( (equal? (list from to)   (list 'ORADEA 'ZERIND)) 71.0)
     ( (equal? (list to from)   (list 'ORADEA 'ZERIND)) 71.0)

     ( (equal? (list from to)   (list 'ORADEA 'SIBIU)) 151.0)
     ( (equal? (list to from)   (list 'ORADEA 'SIBIU)) 151.0)
     
     ( (equal? (list from to)   (list 'ZERIND 'ARAD)) 75.0)
     ( (equal? (list to from)   (list 'ZERIND 'ARAD)) 75.0)

     ( (equal? (list from to)   (list 'ARAD 'TIMISOARA)) 118.0)
     ( (equal? (list to from)   (list 'ARAD 'TIMISOARA)) 118.0)

     ( (equal? (list from to)   (list 'ARAD 'SIBIU)) 140.0)
     ( (equal? (list to from)   (list 'ARAD 'SIBIU)) 140.0)

     ( (equal? (list from to)   (list 'TIMISOARA 'LUGOJ)) 111.0)
     ( (equal? (list to from)   (list 'TIMISOARA 'LUGOJ)) 111.0)
     
     ( (equal? (list from to)   (list 'LUGOJ 'MEHADIA)) 70.0)
     ( (equal? (list to from)   (list 'LUGOJ 'MEHADIA)) 70.0)

     ( (equal? (list from to)   (list 'MEHADIA 'DOBRETA)) 75.0)
     ( (equal? (list to from)   (list 'MEHADIA 'DOBRETA)) 75.0)

     ( (equal? (list from to)   (list 'DOBRETA 'CRAIOVA)) 120.0)
     ( (equal? (list to from)   (list 'DOBRETA 'CRAIOVA)) 120.0)

     ( (equal? (list from to)   (list 'SIBIU 'FAGARAS)) 99.0)
     ( (equal? (list to from)   (list 'SIBIU 'FAGARAS)) 99.0)

     ( (equal? (list from to)   (list 'SIBIU 'RIMNICU)) 80.0)
     ( (equal? (list to from)   (list 'SIBIU 'RIMNICU)) 80.0)
     
     ( (equal? (list from to)   (list 'RIMNICU 'PITESTI)) 97.0)
     ( (equal? (list to from)   (list 'RIMNICU 'PITESTI)) 97.0)

     ( (equal? (list from to)   (list 'RIMNICU 'CRAIOVA)) 146.0)
     ( (equal? (list to from)   (list 'RIMNICU 'CRAIOVA)) 146.0)

     ( (equal? (list from to)   (list 'CRAIOVA 'PITESTI)) 138.0)
     ( (equal? (list to from)   (list 'CRAIOVA 'PITESTI)) 138.0)

     ( (equal? (list from to)   (list 'FAGARAS 'BUCHAREST)) 211.0)
     ( (equal? (list to from)   (list 'FAGARAS 'BUCHAREST)) 211.0)

     ( (equal? (list from to)   (list 'PITESTI 'BUCHAREST)) 101.0)
     ( (equal? (list to from)   (list 'PITESTI 'BUCHAREST)) 101.0)

     ( (equal? (list from to)   (list 'GIURGIU 'BUCHAREST)) 90.0)
     ( (equal? (list to from)   (list 'GIURGIU 'BUCHAREST)) 90.0)

     ( (equal? (list from to)   (list 'BUCHAREST 'URZICENI)) 85.0)
     ( (equal? (list to from)   (list 'BUCHAREST 'URZICENI)) 85.0)

     ( (equal? (list from to)   (list 'NEAMT 'IASI)) 87.0)
     ( (equal? (list to from)   (list 'NEAMT 'IASI)) 87.0)

     ( (equal? (list from to)   (list 'URZICENI 'VASLUI)) 142.0)
     ( (equal? (list to from)   (list 'URZICENI 'VASLUI)) 142.0)

     ( (equal? (list from to)   (list 'URZICENI 'HIRSOVA)) 98.0)
     ( (equal? (list to from)   (list 'URZICENI 'HIRSOVA)) 98.0)

     ( (equal? (list from to)   (list 'IASI 'VASLUI)) 92.0)
     ( (equal? (list to from)   (list 'IASI 'VASLUI)) 92.0)

     ( (equal? (list from to)   (list 'HIRSOVA 'EFORIE)) 92.0)
     ( (equal? (list to from)   (list 'HIRSOVA 'EFORIE)) 86.0)
     (else  #f); 
  )
)   
