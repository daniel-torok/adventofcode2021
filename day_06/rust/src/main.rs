use std::fs;

fn initialize_counter(line: &str) -> [u64; 9] {
  let mut counter = [0_u64; 9];
  for raw_num in line.split(",") {
    let num = raw_num.parse::<usize>().unwrap();
    counter[num] += 1
  }
  return counter
}

fn calculate_solution(mut counter: [u64; 9], iterations: usize) -> u64 {
  for _ in 0..iterations {
    counter[7] += counter[0];
    counter.rotate_left(1);
  }
  counter.iter().sum()
}

fn main() {
  let contents = fs::read_to_string("input.data")
    .expect("could not open file");

  let counter = initialize_counter(contents.trim_end());
  println!("Part one: {}", calculate_solution(counter, 80));
  println!("Part two: {}", calculate_solution(counter, 256));
}
