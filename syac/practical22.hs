module Main(main) where
import Dateifier
main :: IO()
main = do
	s <- getContents
	print(dateifier s)
