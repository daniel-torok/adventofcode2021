package functions

func Sum(coll []int) int {
  sum := 0
  for _, val := range coll {
    sum += val
  }
  return sum
}

func Rotate(coll []int) []int {
  tmp := coll[0]
  coll = coll[1:]
  coll = append(coll, tmp)
  return coll
}
