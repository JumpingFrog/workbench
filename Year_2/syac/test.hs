mylen :: [a] -> Int
mylen [] = 0
mylen (x:[]) = 1
mylen (x:y) = 1 + mylen y

mlast :: [a] -> a
mlast [] = error "This is null!"
mlast (xs) = xs!!((length xs) - 1)

ab :: Int
ab = a `div` (length xs)
	where
		a = 10
		xs = [1, 2, 3, 4, 5]
--4.11 Exc functions
second xs :: a
