use std::fs;

fn solution(mut counter: [u64; 9], iterations: usize) -> u64 {
  for _ in 0..iterations {
    let tmp = counter[0];
    counter.rotate_left(1);
    counter[6] += tmp;
  }
  counter.iter().sum()
}

fn main() {
  let contents = fs::read_to_string("input.data")
    .expect("could not open file");
  let numbers = contents
    .trim_end()
    .split(",")
    .map(|n| n.parse::<usize>().unwrap());

  let mut counter = [0_u64; 9];
  for value in numbers {
    counter[value] += 1
  }

  println!("Part one: {}", solution(counter, 80));
  println!("Part two: {}", solution(counter, 256));
}
