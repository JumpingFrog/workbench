--From slides <http://www-module.cs.york.ac.uk/syac/compilers/SLIDES/3_Parsing.pdf>
type Parse t = (Bool, [t])
type Parser t = [t] -> Parse t

terminal :: Eq t => t -> Parser t --match terminal
terminal t (e:es) 	| t==e = (True, es)
					| otherwise = (False, (e:es))

--combinator
infixr 5 +> -- infix, right associative, priority 5
(+>) :: Eq t => Parser t -> Parser t -> Parser t
(f +> g) ts	| qf = g rf --if f is successful, apply g
			| otherwise = (False, ts) -- return false + input
			where (qf, rf) = f ts

--alternative combinator Choice
infixl 4 <> -- infix, left associative, priority 4
(<>) :: Eq t => Parser t -> Parser t -> Parser t
(f <> g) ts	| b = fts --apply f to ts, return if success
			| otherwise = g ts --else return g to ts.
			where fts@(b,_) = f ts
--End slide code.
itr :: Eq t => Parser t -> Parser t
itr _ [] = (False, [])
itr p s@(_:[]) = (p s) --one only.
itr p s@(x1:x2:_)	| fb && sb = itr p (tail s) --x2 will be true, itr further
					| fb = (True, tail s) --x1 was only true, return here
					| otherwise = (False, s) --whole string failed
					where
					(fb,_) = (p [x1])
					(sb,_) = (p [x2])
		
--1
empty :: Parser t
empty [] = (True, [])
empty ts = (False, ts)

--2.1
v :: Parser Char
v = foldl1 (\p n-> (p <> n)) (map (\i->terminal i) ['a'..'z'])

p :: Parser Char
p = (terminal 'T') <> (terminal 'F') <> v <> ((terminal '-') +> p) <>
	((terminal '(') +> p +> (terminal '*') +> p +> (terminal ')'))

t2a = "-(x*(--F*y))"
t2b = "-(T*(-F*))"
--2.2
data PTok = T | F | Var String | CON | NEG | LEFT | RIGHT  deriving (Eq, Show)
--v2 :: Parser PTok
--v2 (Var x) = foldl1 (\p n-> (p <> n)) (map (\i->terminal i) ['a'..'z'])
--v2 x = (False, x) 

p2 :: Parser PTok
p2 = (terminal T) <> (terminal F) <> ((terminal NEG) +> p2) <>
	 ((terminal LEFT) +> p2 +> (terminal CON) +> p2 +> (terminal RIGHT))
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
