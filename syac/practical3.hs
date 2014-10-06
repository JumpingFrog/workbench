--From slides <http://www-module.cs.york.ac.uk/syac/compilers/SLIDES/3_Parsing.pdf>
type Parse t = (Bool, [t])
type Parser t = [t] -> Parse t

terminal :: Eq t => t -> Parser t --match terminal
terminal t [] = (False, [])
terminal t (e:es) 	| t==e = (True, es)
					| otherwise = (False, (e:es))

--combinator
infixr 5 +> -- infix, right associative, priority 5
(+>) :: Eq t => Parser t -> Parser t -> Parser t
(f +> g) ts	| qf = g rf --if f is successful, apply g
			| otherwise = (False, ts) -- return false + input
			where (qf, rf) = f ts

--alternative combinator Choice
infixr 4 <> -- infix, left associative, priority 4
(<>) :: Eq t => Parser t -> Parser t -> Parser t
(f <> g) ts	| b = fts --apply f to ts, return if success
			| otherwise = g ts --else return g to ts.
			where fts@(b,_) = f ts
--End slide code.
itr' :: Eq t => Parser t -> Parser t
itr' _ [] = (False, [])
itr' p s@(_:[]) = (p s) --one only.
itr' p s@(x1:x2:_)	| fb && sb = itr' p (tail s) --x2 will be true, itr further
					| fb = (True, tail s) --x1 was only true, return here
					| otherwise = (False, s) --whole string failed
					where
					(fb,_) = (p [x1])
					(sb,_) = (p [x2])

itr :: Eq t => Parser t -> Parser t --parser iterator
itr _ [] = (False, [])
itr p s | (length s) == (length r) = (False, s)
		| otherwise = (True, r)
		where r = dropWhile (\x->(fst (p [x]))) s
		
--1
empty :: Parser t
empty [] = (True, [])
empty ts = (False, ts)

--2.1
v :: Parser Char
v = itr (foldl1 (\p n-> (p <> n)) (map (\i->terminal i) ['a'..'z']))

p :: Parser Char
p = (terminal 'T') <> (terminal 'F') <> v <> ((terminal '-') +> p) <>
	((terminal '(') +> p +> (terminal '*') +> p +> (terminal ')'))

t2a = "-(x*(--F*y))"
t2b = "-(T*(-F*))"
--2.2
data PTok = T | F | Var String | CON | NEG | LEFT | RIGHT | DIS | IMP | EQL deriving (Eq, Show) --extended for fuller p (3)
v2 :: Parser PTok
v2 ((Var x):r)	| a && (b == []) = (True, r)
		   		| otherwise = error ("Invalid variable name: " ++ x)
				where (a, b) = v x
v2 x = (False, x) 

p2 :: Parser PTok
p2 = (terminal T) <> (terminal F) <> ((terminal NEG) +> p2) <> v2 <>
	 ((terminal LEFT) +> p2 +> (terminal CON) +> p2 +> (terminal RIGHT))

t22a = [NEG, LEFT, Var "x", CON, LEFT, NEG, NEG, F, CON, Var "y", RIGHT, RIGHT] --(x*(--F*y))"
t22b = [NEG, LEFT, T, CON, LEFT, NEG, F, CON, RIGHT, RIGHT] --"-(T*(-F*))"
--3
-- p ::= T | F | v | -p | p * p | p + p | p > p | p = p | (p)
-- v ::= [a-z]+
--
--1. Remove ambiguity:
--p5 ::= (p) | T | F | v
--p4 ::= p5 | -p4
--p3 ::= p4 | p3*p4
--p2 ::= p3 | p2+p3
--p1 ::= p2 | p2>p1
--p  ::= p1 | p=p1
--
--v ::= [a-z]+
--
--2. Left factor:
--p5 ::= (p) | T | F | v
--p4 ::= p5 | -p4
--p3 ::= p4 | p3*p4
--p2 ::= p3 | p2+p3
--p1 ::= p2r
--r	 ::= ε | >p1
--p  ::= p1 | p=p1
--
--v ::= [a-z]+
--
--3. Remove left recursion:
--p5 ::= (p) | T | F | v
--p4 ::= p5 | -p4
--p3 ::= p4p3`
--p3`::= ε | *p4p3`
--p2 ::= p3p2`
--p2`::= ε | +p3p2`
--p1 ::= p2r
--r	 ::= ε | >p1
--p  ::= p1p`
--p` ::= ε | =p1p`
--
--v ::= [a-z]+
nil :: Parser PTok
nil xs = (True, xs)

o5 :: Parser PTok
o5 = ((terminal LEFT) +> o +> (terminal RIGHT)) <> (terminal T) <> (terminal F) <> v2

o4 :: Parser PTok
o4 = o5 <> ((terminal NEG) +> o4)

o3 :: Parser PTok
o3 = o4 +> o3'

o3' :: Parser PTok
o3' = ((terminal CON) +> o3 +> o2') <> nil

o2 :: Parser PTok
o2 = o3 +> o2'

o2' :: Parser PTok
o2' = ((terminal DIS) +> o3 +> o2') <> nil

o1 :: Parser PTok
o1 = o2 +> o1'

o1' :: Parser PTok --aka r
o1' = ((terminal IMP) +> o1) <> nil

o :: Parser PTok
o = o1 +> o'

o' :: Parser PTok
o' =  ((terminal EQL) +> o1 +> o') <> nil

t3a = [NEG, LEFT, Var "x", DIS, NEG, NEG, F, CON, LEFT, T, DIS, F, RIGHT, RIGHT]
t3b = [LEFT, T, CON, NEG, F, CON, NEG, RIGHT]
t3c = [LEFT, T, CON, NEG, F,RIGHT]
--4
--p5 ::= (p) | T | F | v
--p4 ::= p5 | -p4
--p3 ::= p4p3`
--p3`::= ε | *p4p3`
--p2 ::= p3p2`
--p2`::= ε | +p3p2`
--p1 ::= p2r
--r	 ::= ε | >p1
--p  ::= p1p`
--p` ::= ε | =p1p`
--
--v ::= [a-z]+
--First Sets:
--first(p5)		= {(, T, F, [a-z]}
--first(p4)		= {-,(, T, F, [a-z]}
--first(p3)		= {-, (, T, F, [a-z]}
--first(p3')	= {ε, *}
--first(p2)		= {-, (, T, F, [a-z]}
--first(p2')	= {ε, +}
--first(p1)		= {-, (, T, F, [a-z]}
--first(r)		= {ε, >}
--first(p)		= {-, (, T, F, [a-z]}
--first(p')		= {ε, =}
--
--follow(p5)	= {*, +, >, =, ), $}
--follow(p4)	= {*, +, >, =, ), $}
--follow(p3)	= {+, >, =, ), $}
--follow(p3')	= {+, >, =, ), $}
--follow(p2)	= {>, =, ), $}
--follow(p2')	= {>, =, ), $}
--follow(p1)	= {=, ), $}
--follow(r)		= {=, ), $}
--follow(p)		= {), $}
--follow(p')	= {), $}