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
--2.2 ???

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
--v ::= (v) | [a-z]+
--
--2. Left factoring.

