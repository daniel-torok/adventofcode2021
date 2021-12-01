module Solution where

import System.IO ()  
import Control.Monad ()

slidingWindow :: Num a => [a] -> [a]
slidingWindow (x:y:z:rest) = (x+y+z) : slidingWindow (y:z:rest)
slidingWindow rest = []

numberOfDecreases :: (Num a, Ord a) => [a] -> Int
numberOfDecreases (x:xs) = fst $ foldl fn (0, x) xs
  where
    fn :: (Num a, Ord a) => (Int, a) -> a -> (Int, a)
    fn (counter, prev) curr
      | curr > prev = (counter + 1, curr)
      | otherwise = (counter, curr)
numberOfDecreases _ = error "empty list"

readInt :: String -> Int
readInt = read

main :: IO ()
main = do
  contents <- readFile "input.data"
  let numbers = map readInt $words contents
  let resultPartOne = numberOfDecreases numbers
  print resultPartOne
  let alteredNumbers = slidingWindow numbers
  let resultPartTwo = numberOfDecreases alteredNumbers
  print resultPartTwo
