import Data.Maybe
--1.1
type RegExp a = [a] -> (Maybe [a], [a])

--1.2
nil :: RegExp a
nil as = (Nothing, as)

--1.3
--range :: (a->Bool)->[a] -> (Maybe [a], [a])
range :: (a->Bool)->RegExp a
range _ [] = (Nothing, [])
range p s	| p(head s) = (Just [head s], tail(s))
			| otherwise = (Nothing, s)
--1.4
one :: Eq a => a->RegExp a
one _ [] = (Nothing, [])
one c s = range (\x->(c == x)) s

arb :: RegExp a
arb [] = (Nothing, [])
arb s = (Just [head s], tail s)

--1.5
--RegExp a -> RegExp b -> [a] -> (Maybe [a], [a])
alt :: Eq a => RegExp a -> RegExp a -> RegExp a
alt r0 r1 s	| isJust (fst (r0 s)) = (r0 s)
			| isJust (fst (r1 s)) = (r1 s)
			| otherwise = (Nothing, s)

--1.6
sqn :: Eq a => RegExp a-> RegExp a -> RegExp a
sqn _ _ [] = (Nothing, [])
sqn r0 r1 s = (x,y)
			where 
			t1 = (r0 s)
			t2 = (r1 (snd t1))
			p = (isNothing (fst t1)) || (isNothing (fst t2)) --predicate
			x = if p then Nothing
				else Just (concat (catMaybes [fst t1, fst t2]))
			y = if p then s
				else (snd t2)


sqns' :: Eq a => [RegExp a] -> RegExp a
sqns' [] s = (Nothing, s)
sqns' _ [] = (Nothing, [])
sqns' rs s = (foldl1 (\p n->sqn p n) rs) s

nullr :: RegExp a --Null RegExp for fold initial
nullr s = (Just [], s)

sqns :: Eq a => [a] -> RegExp a
sqns [] s = (Nothing, s)
sqns _ [] = (Nothing, [])
sqns m s = (foldl (\p n->sqn p (one n) ) nullr m) s
--1.7
itr :: Eq a => RegExp a -> RegExp a
itr _ [] = (Nothing, [])
itr r s	| isNothing (fst (r s)) = (Nothing, s)
		| otherwise = (Just (concat (catMaybes [fst (r s), fst (itr r (snd (r s)))])), snd (itr r (snd (r s)))) --rewrite with where clause
--1.8
lexemes :: Show a => RegExp a -> RegExp a -> [a] -> [[a]] --N.B. Does not handle leading white space.
lexemes _ _ [] = [] --base case, entire string consumed.
lexemes r w s	| isNothing (fst x)  = error ("Unmatched lexeme token: " ++ (show (snd x)))
				| otherwise = (maybeToList(fst x)) ++ lexemes r w (snd (w(snd x)))
				where x = (r s)
--1.9
scanner :: Show a => RegExp a -> RegExp a -> ([a]->b) -> [a] -> [b]
scanner r w f s = map f (lexemes r w s)

--2.1
isLet :: Char -> Bool --is Letter
isLet c = c `elem` ['a'..'z']

isDig :: Char -> Bool
isDig c = c `elem` ['0'..'9']

isWsp :: Char -> Bool
isWsp c = c `elem` " \n\r\t"

--2.2
nspace :: RegExp Char
nspace c = range isWsp c

nletter :: RegExp Char
nletter c = range isLet c

ndigit :: RegExp Char
ndigit c = range isDig c
--2.3
nword :: RegExp Char
nword c = itr nletter c 

nnumeral :: RegExp Char
nnumeral c = itr nnumeral c

nwhitespace :: RegExp Char
nwhitespace c = itr nspace c
--3.1
data Token = TRUE | FALSE | EQUALS | LESS | PLUS | MINUS | TIMES | ASSIGN | SEQ |
			 SKIP | IF | THEN | ELSE | WHILE  | LEFT | RIGHT | VAR String | NUM String

--3.2
nr2t :: String -> Token
nr2t "true" = TRUE
nr2t "false" = FALSE
nr2t "=" = EQUALS
nr2t "<" = LESS
nr2t "+" = PLUS
nr2t "-" = MINUS


		


