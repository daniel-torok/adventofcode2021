module Main where

import System.IO ()
import Control.Monad ()
import Data.List (group, sort)
import Data.List.Split (splitOn)

type Coord = (Int, Int)

readInt :: String -> Int
readInt = read

parse :: String -> (Coord, Coord)
parse line = (parseCoord $ head splitted, parseCoord $ last splitted)
  where
    splitted :: [String]
    splitted = splitOn " -> " line
    parseCoord :: String -> Coord
    parseCoord num = (head parsed, last parsed)
      where
        parsed :: [Int]
        parsed = map readInt $ splitOn "," num

gen :: Bool -> (Coord, Coord) -> [Coord]
gen skipDiagonal ((x1, y1), (x2, y2))
  | x1 == x2 = [(x1, y) | y <- [(min y1 y2)..(max y1 y2)]]
  | y1 == y2 = [(x, y1) | x <- [(min x1 x2)..(max x1 x2)]]
  | skipDiagonal = []
  | otherwise = [(x1+i*xSlope, y1+i*ySlope) | i <- [0..abs (x1 - x2)] ]
    where
      xSlope = signum (x2 - x1)
      ySlope = signum (y2 - y1)

main :: IO ()
main = do
  contents <- readFile "input.data"
  let coords = map parse $ lines contents

  let firstExpanded = sort $ concatMap (gen True) coords
  let firstMatrix = map length $ group firstExpanded
  let firstResult = sum $ map (fromEnum . (>1)) firstMatrix
  print $ "First part result: " ++ show firstResult

  let secondExpanded = sort $ concatMap (gen False) coords
  let secondMatrix = map length $ group secondExpanded
  let secondResult = sum $ map (fromEnum . (>1)) secondMatrix
  print $ "Second part result: " ++ show secondResult
