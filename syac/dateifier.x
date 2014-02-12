{
module Dateifier(dateifier) where

import Data.Time -- Date and time library (monadic)
import System.IO.Unsafe --Purify monadic values: can be dangerous.
}

%wrapper "basic"

tokens :-
alex lexing rules

"TODAY" {const "today"}

--Rules
--TODAY, TODAY+nm TODAY-n, TOMORROW, YESTERDAY



{
--unsafePerformIO is safe in this context
--getCurrentTime gets the current time of its first evaluation
today :: UTCTime
today = unsafePerformIO getCurrentTime

--showDT n converts today+n's date to a string
--showGeorgian returns ISO8601 format
showDt :: Integer -> String
showDt = showGeorgian.(flip addDays (utctDay today))

dateifier :; String -> String
dateifier = concat.alexScanTokens
}


