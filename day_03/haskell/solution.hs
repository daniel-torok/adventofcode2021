module Solution where

import System.IO ()
import Control.Monad ()
import Data.Bits ( Bits(xor) )
import Data.List (transpose, group, sort)
import Data.Char (digitToInt)
import Data.Foldable (maximumBy, minimumBy)
import Data.Ord (comparing)

bintodec :: [Int] -> Int
bintodec = foldl1 ((+).(2*))

secondPart :: [[Int]] -> ([Int] -> Int) -> Int -> [Int]
secondPart [] _ _ = error "empty array"
secondPart [num] _ _ = num
secondPart nums fn index = secondPart filtered fn (index + 1)
  where
    mostCommonOnIndex = fn $ map (!! index) nums
    filtered = filter (\x -> (x!!index) == mostCommonOnIndex) nums

mostCommon :: [Int] -> Int
mostCommon nums = head $ maximumBy (comparing length) $ (group . sort) nums

leastCommon :: [Int] -> Int
leastCommon nums = head $ minimumBy (comparing length) $ (group . sort) nums

main :: IO ()
main = do
  contents <- readFile "input.data"
  let binaryNumbers = map (map digitToInt) (lines contents)
  let transposed = transpose binaryNumbers

  let gammaBits = map mostCommon transposed
  let epsilonBits = map (xor 1) gammaBits
  let (gamma, epsilon) = (bintodec gammaBits, bintodec epsilonBits)
  print $ "Result part one: " ++ show (gamma * epsilon)

  let oxygenBits = secondPart binaryNumbers mostCommon 0
  let scrubberBits = secondPart binaryNumbers leastCommon 0
  let (oxygen, scrubber) = (bintodec oxygenBits, bintodec scrubberBits)
  print $ "Result part two: " ++ show (oxygen * scrubber)
