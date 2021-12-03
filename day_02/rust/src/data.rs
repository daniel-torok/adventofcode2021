use std::fmt;
use std::str;
pub enum Direction {
  Forward,
  Up,
  Down
}

pub struct Instruction {
  pub direction: Direction,
  pub amount: u32
}

#[derive(Copy, Clone)]
pub struct SubmarineState {
  pub horizontal: u32,
  pub depth: u32,
  pub aim: u32
}

impl fmt::Display for SubmarineState {
  fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
    write!(f, "horizontal: {}, depth: {}", self.horizontal, self.depth)
  }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct ParseInstructionError {

}

impl str::FromStr for Instruction {
  type Err = ParseInstructionError;

  fn from_str(line: &str) -> Result<Self, Self::Err> {
    let mut split = line.split_whitespace();
    let direction = split.next().expect("invalid instruction");
    let amount = split.next().expect("invalid instruction").parse::<u32>().unwrap();

    match direction {
      "forward" => Ok(Instruction { direction: Direction::Forward, amount }),
      "up" => Ok(Instruction { direction: Direction::Up, amount }),
      "down" => Ok(Instruction { direction: Direction::Down, amount }),
      _ => Err(ParseInstructionError {})
    }
  }
}
