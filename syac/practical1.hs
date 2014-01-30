isDigit' :: Char -> Bool
isDigit' c = (c >= '0') && (c <= '9')

d2n :: Char -> Int
d2n c | isDigit' c = (read [c])::Int

s2n :: String -> Int
s2n cs	| (length (filter isDigit' cs)) == (length cs) = (read cs)::Int
		| otherwise = error "Not a numeric stirng."

s2n' :: String -> Int
s2n' = (foldl1 f).(map d2n)
		where f x y = x*10 + y

wspace :: Char -> Bool
wspace ' ' = True
wspace '\n' = True
wspace '\r' = True
wspace '\t' = True
wspace c = False

dropLeadingWhitespace :: String -> String
dropLeadingWhitespace cs = dropWhile wspace cs

--3.3
type V = String
type N = Int
data E = Var V | Val N | Plus E E | Mult E E 
instance Show E where
	show (Var x) = x
	show (Val x) = show x
	show (Plus x y) = "(" ++ show x ++ " + " ++ show y ++ ")"
	show (Mult x y) = "(" ++ show x ++ " * " ++ show y ++ ")"

hello :: E
hello = (Mult (Val 2) (Plus (Val 20) (Var "y")))

evaluate :: E->Int
evaluate (Var x) = error ("Var: " ++ x)
evaluate (Val x) = x
evaluate (x `Plus` y) = (evaluate x) + (evaluate y)
evaluate (x `Mult` y) = (evaluate x) * (evaluate y)

simplify :: E->E
simplify (e `Mult` (Val 1)) = simplify e
simplify ((Val 1) `Mult` e) = simplify e
simplify (e `Plus` (Val 0)) = simplify e
simplify ((Val 0) `Plus` e) = simplify e
simplify (e0 `Mult` e1) = simplify((simplify e0) `Mult` (simplify e1))
simplify (e0 `Plus` e1) = simplify((simplify e0) `Plus` (simplify e1))
simplify e = e
--3.4
type Assoc a = [(String, a)]

test :: Assoc Int
test = [("x", 4), ("y", 2), ("z", 0)]

names :: Assoc a -> [String]
names [] = []
names xs = map (\x-> (fst x)) xs

inAssoc :: String->Assoc a -> Bool
inAssoc _ [] = False
inAssoc [] _ = False
inAssoc n xs = any (\x->(fst x)==n) xs
--inAssoc n xs = foldl (\p c->(((fst c) == n) || p)) False xs --elem s (names xs)

fetch :: String->Assoc a->a
fetch [] _ = error "Empty name"
fetch _ [] = error "Empty association list/not in list."
fetch n xs 	| (fst (head xs)) == n = (snd (head xs))
			| otherwise = fetch n (tail xs)

update :: String -> a -> Assoc a -> Assoc a
update [] _ _ = error "Empty name"
update n v xs 	| inAssoc n xs = map (\c-> if n == (fst c) then (n, v) else c) xs
				| otherwise = xs ++ [(n, v)]
--3.5
evaluate2 :: Assoc Int -> E -> Int
evaluate2 d (Var x) = fetch x d
evaluate2 d (Val x) = x
evaluate2 d (x `Plus` y) = (evaluate2 d x) + (evaluate2 d y)
evaluate2 d (x `Mult` y) = (evaluate2 d x) * (evaluate2 d y)
--More to do if you want...
--3.6
headT :: [a] -> Maybe a
headT [] = Nothing
headT xs = Just(head xs)

tailT :: [a] -> Maybe [a]
tailT (x:[]) = Nothing
tailT [] = Nothing
tailT xs = Just(tail xs)

lastT :: [a] -> Maybe a
lastT [] = Nothing
lastT xs = Just(last xs)

