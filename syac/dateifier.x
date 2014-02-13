{
module Dateifier(dateifier) where

import Data.Time -- Date & time library (monadic)
import System.IO.Unsafe -- To purify monadic values: can be dangerous!
}

%wrapper "basic"

:-

-- YOUR RULES GO HERE

TODAY	      {showDt.const 0}
TODAY\+(0-9)+ {showDt.read.(drop 6)} -- remove "TODAY+" from start of string
TODAY\-(0-9)+ {showDt.negate.read.(drop 6)} -- ditto, "TODAY-"
TOMORROW      {showDt.const 1}
YESTERDAY     {showDt.negate.const 1}
[.  \n]	      {id}

{
-- unsafePerformIO is safe in this context!
-- getCurrentTime gets the current time of its first evaluation.
today :: UTCTime
today = unsafePerformIO getCurrentTime

-- showDt n converts today+n's date to a String
-- showGregorian produces ISO 8601 format
showDt :: Integer -> String
showDt = showGregorian.(flip addDays (utctDay today))

dateifier :: String -> String
dateifier = concat.alexScanTokens
}

