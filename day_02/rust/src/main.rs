use std::fs;
use std::str;

mod data;
pub use self::data::*;

fn execute_instruction(state: SubmarineState, instruction: Instruction) -> SubmarineState {
  match instruction {
    Instruction { direction: Direction::Forward, amount } => {
      return SubmarineState { horizontal: state.horizontal + amount, depth: state.depth };
    }
    Instruction { direction: Direction::Up, amount } => {
      return SubmarineState { horizontal: state.horizontal, depth: state.depth - amount };
    }
    Instruction { direction: Direction::Down, amount } => {
      return SubmarineState { horizontal: state.horizontal, depth: state.depth + amount };
    }
  }
}

fn main() {
  let contents = fs::read_to_string("input.data")
    .expect("could not read file");

  let final_state = contents
    .lines()
    .map(&str::parse)
    .map(Result::unwrap)
    .fold(SubmarineState { horizontal: 0, depth: 0 }, execute_instruction);

  println!("First part result: {}", final_state.horizontal * final_state.depth);
}
