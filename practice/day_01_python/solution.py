def read(src):
  import os, sys
  with open(os.path.join(sys.path[0], src), "r") as f:
    return f.read().splitlines()


def procedural_solution(lines):
  counter = 0
  for idx in range(len(lines) - 1):
    prev_value = lines[idx]
    curr_value = lines[idx + 1]
    if curr_value > prev_value:
      counter += 1

  return counter


def functional_solution(lines):
  from functools import reduce
  def reducer(acc, curr_value):
    counter, prev_value = acc
    if curr_value > prev_value:
      return (counter + 1, curr_value)
    else:
      return (counter, curr_value)

  counter, _ = reduce(reducer, lines, (0, lines[0]))
  return counter


def sum_using_sliding_window(lines):
  result = []
  for idx in range(len(lines) - 2):
    next = sum(lines[idx : idx + 3])
    result.append(next)
  
  return result


def main():
  import timeit

  lines = read("input.data")
  lines = list(map(int, lines))
  
  functional_result = functional_solution(lines)
  time = timeit.timeit(lambda: functional_solution(lines), number=1_0000)
  print(f"Result via 'functional' way: { functional_result }, took: { time } ms.")

  procedural_result = procedural_solution(lines)
  time = timeit.timeit(lambda: procedural_solution(lines), number=1_0000)
  print(f"Result via 'procedural' way: { procedural_result }, took: { time } ms.")

  # part two
  lines = sum_using_sliding_window(lines)
  time = timeit.timeit(lambda: sum_using_sliding_window(lines), number=1_0000)
  print(f"Transforming input took: { time } ms.")

  functional_result = functional_solution(lines)
  print(f"Result via 'functional' way: { functional_result }.")
  procedural_result = procedural_solution(lines)
  print(f"Result via 'procedural' way: { procedural_result }.")


if __name__ == "__main__":
  main()
