use std::fs;
use std::str;

mod data;
pub use self::data::*;

fn execute_instruction(state: SubmarineState, instruction: Instruction) -> SubmarineState {
  match instruction {
    Instruction { direction: Direction::Forward, amount } => {
      return SubmarineState { horizontal: state.horizontal + amount, depth: state.depth, aim: 0 };
    }
    Instruction { direction: Direction::Up, amount } => {
      return SubmarineState { horizontal: state.horizontal, depth: state.depth - amount, aim: 0 };
    }
    Instruction { direction: Direction::Down, amount } => {
      return SubmarineState { horizontal: state.horizontal, depth: state.depth + amount, aim: 0 };
    }
  }
}

fn execute_instruction_part_two(state: SubmarineState, instruction: Instruction) -> SubmarineState {
  let SubmarineState { horizontal, depth, aim } = state;
  let Instruction { direction, amount } = instruction;
  match direction {
    Direction::Forward => SubmarineState {
      horizontal: horizontal + amount,
      depth: depth + amount * aim,
      aim
    },
    Direction::Up => SubmarineState {
      horizontal,
      depth,
      aim: aim - amount
    },
    Direction::Down => SubmarineState {
      horizontal,
      depth,
      aim: aim + amount
    }
  }
}

fn main() {
  let contents = fs::read_to_string("input.data")
    .expect("could not read file");

  let initial_state = SubmarineState { horizontal: 0, depth: 0, aim: 0 };

  let final_state = contents
    .lines()
    .map(&str::parse)
    .map(Result::unwrap)
    .fold(initial_state, execute_instruction);

  println!("First part result: {}", final_state.horizontal * final_state.depth);

  let SubmarineState { horizontal, depth, aim: _ } = contents
    .lines()
    .map(&str::parse)
    .map(Result::unwrap)
    .fold(initial_state, execute_instruction_part_two);

  println!("Second part result: {}", horizontal * depth);

}
