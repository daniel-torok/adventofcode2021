module Solution where

import System.IO ()  
import Control.Monad ()

data Direction = Forward | Down | Up deriving Show
type Instruction = (Direction, Int)
type SubmarineState = (Int, Int)
type SubmarineState2 = (Int, Int, Int)

readInt :: String -> Int
readInt = read

parseInstruction :: String -> Instruction
parseInstruction = fn . words
  where
    fn :: [String] -> Instruction
    fn ("forward":num:_) = (Forward, readInt num)
    fn ("down":num:_) = (Down, readInt num)
    fn ("up":num:_) = (Up, readInt num)
    fn invalid = error ("invalid instruction: " ++ unwords invalid)

executeInstruction :: SubmarineState -> Instruction -> SubmarineState
executeInstruction (x, y) (Forward, amount) = (x + amount, y)
executeInstruction (x, y) (Down, amount) = (x, y + amount)
executeInstruction (x, y) (Up, amount) = (x, y - amount)

executeInstruction2 :: SubmarineState2 -> Instruction -> SubmarineState2
executeInstruction2 (x, y, aim) (Forward, amount) = (x + amount, y + aim * amount, aim)
executeInstruction2 (x, y, aim) (Down, amount) = (x, y, aim + amount)
executeInstruction2 (x, y, aim) (Up, amount) = (x, y, aim - amount)

main :: IO ()
main = do
  contents <- readFile "input.data"
  let instructions = map parseInstruction $ lines contents
  let (x, y) = foldl executeInstruction (0, 0) instructions
  print ("first part result: " ++ show (x * y))
  let (x2, y2, _) = foldl executeInstruction2 (0, 0, 0) instructions
  print ("second part result: " ++ show (x2 * y2))
