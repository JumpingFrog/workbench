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
alt r0 r1 s	| isNothing (fst (r0 s)) = (r0 s)
			| isNothing (fst (r1 s)) = (r1 s)
			| otherwise = (Nothing, s)

--1.6
sqn :: Eq a => RegExp a-> RegExp a -> RegExp a
sqn _ _ [] = (Nothing, [])
sqn r0 r1 s = (x,y)
			where	
				y = snd (r1 (snd (r0 s)))
				x = if (isNothing (fst (r0 s))) || (isNothing (fst (r1 (snd (r0 s))))) then Nothing
					else Just (concat (catMaybes [fst (r0 s), fst (r1 (snd (r0 s)))]))  

sqns :: Eq a => [RegExp a] -> RegExp a
sqns [] s = (Nothing, s)
sqns _ [] = (Nothing, [])
sqns rs s = (foldl1 (\p n->sqn p n) rs) s

--1.7
itr :: Eq a => RegExp a -> RegExp a
itr _ [] = (Nothing, [])
itr r s	| isNothing (fst (r s)) = (Nothing, s)
		| otherwise = (Just (concat (catMaybes [fst (r s), fst (itr r (snd (r s)))])), snd (itr r (snd (r s))))
--1.8
lexemes :: Show a => RegExp a -> RegExp a -> [a] -> [[a]]
lexemes rs ws s = | itr rs

