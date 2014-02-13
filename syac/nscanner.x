{
module Nscanner(nscanner) where
}

%wrapper "basic"

:-
$white  ;
true	{const TRUE}
false	{const FALSE}
=		{const EQUALS}
\<		{const LESS}
\+		{const PLUS}
\-		{const MINUS}
\*		{const TIMES}
:=		{const ASSIGN}
\;		{const SEQ}
skip	{const SKIP}
if		{const IF}
then	{const THEN}
else	{const ELSE}
while	{const WHILE}
\(		{const LEFT}
\)		{const RIGHT}
(a-z)+	{VAR}
(0-9)+	{(NUM).read}
0b(0-1)+ {parseBinary}
\-\-.*$ ;

-- catch all
.      {error.("Lexical error: "++)}

{
parseBinary :: String -> Token
parseBinary (_:_:xs) = NUM (foldl1 (\p n->(p*2)+n) (map (\c-> if (c=='1') then 1 else 0) xs))

data Token = 	TRUE | FALSE | EQUALS | LESS | PLUS | 
				MINUS | TIMES | ASSIGN | SEQ | SKIP |
				IF | THEN | ELSE | WHILE | LEFT | RIGHT |
				VAR String | NUM Int

instance Show Token where
	show (TRUE)		= "TRUE"
	show (FALSE)	= "FALSE"
	show (EQUALS)	= "EQUALS"
	show (LESS)		= "LESS"
	show (PLUS)		= "PLUS"
	show (MINUS)	= "MINUS"
	show (TIMES)	= "TIMES"
	show (ASSIGN)	= "ASSIGN"
	show (SEQ)		= "SEQ"
	show (SKIP)		= "SKIP"
	show (IF)		= "IF"
	show (THEN)		= "THEN"
	show (ELSE)		= "ELSE"
	show (WHILE)	= "WHILE"
	show (LEFT)		= "LEFT"
	show (RIGHT)	= "RIGHT"
	show (VAR x)	= "VAR: " ++ x
	show (NUM x)	= "NUM: " ++ (show x)


nscanner :: String -> [Token]
nscanner = alexScanTokens

}
