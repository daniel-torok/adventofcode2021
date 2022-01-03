def read(src):
  import os, sys
  with open(os.path.join(sys.path[0], src), "r") as f:
    return f.read().splitlines()

def main():
  digits = dict()
  stack = list()

  dig = 0
  for i, line in enumerate(read("input.data")):
    _, *operands = line.rstrip().split(' ')
    if i % 18 == 4: push = operands[1] == '1'
    if i % 18 == 5: sub = int(operands[1])
    if i % 18 == 15:
      if push:
        stack.append((dig, int(operands[1])))
      else:
        sibling, add = stack.pop()
        diff = add + sub
        if diff < 0:
          digits[sibling] = (-diff + 1, 9)
          digits[dig] = (1, 9 + diff)
        else:
          digits[sibling] = (1, 9 - diff)
          digits[dig] = (1 + diff, 9)
      dig += 1

  print('Part one: ' + ''.join(str(digits[d][1]) for d in sorted(digits.keys())))
  print('Part two: ' + ''.join(str(digits[d][0]) for d in sorted(digits.keys())))

if __name__ == "__main__":
  main()
