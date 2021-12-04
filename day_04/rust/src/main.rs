use std::fs;

mod data;
pub use self::data::*;

fn main() {
  let numbers = fs::read_to_string("input/numbers.data")
    .expect("could not read file")
    .split(",")
    .map(str::parse::<u32>)
    .map(Result::unwrap)
    .collect::<Vec<u32>>();
  
  let mut boards = fs::read_to_string("input/boards.data")
    .expect("could not read file")
    .split("\n\n")
    .map(Board::new)
    .collect::<Vec<Board>>();

  let mut win_counts = 0;
  let board_count = boards.len();

  'outer: for num in numbers {
    for board in &mut boards {
      if board.win {
        continue;
      }

      if let Some(board_score) = board.process_num(num) {
        win_counts += 1;
        if win_counts == 1 {
          println!("First part result: {}", board_score);
        }
        if win_counts == board_count {
          println!("Second part result: {}", board_score);
          break 'outer;
        }
      }
    }
  }
}
