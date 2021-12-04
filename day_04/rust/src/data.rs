use std::collections::HashMap;
use std::fmt;

pub struct Pos {
  pub x: usize,
  pub y: usize
}

impl fmt::Debug for Pos {
  fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
    write!(f, "({}, {})", self.x, self.y)
  }
}

pub struct Board {
  size: u16,
  nums: HashMap<u32, Pos>,
  row_counts: Vec<u16>,
  col_counts: Vec<u16>,
  pub win: bool
}

impl fmt::Debug for Board {
  fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
    f.debug_map().entries(&self.nums).finish()
  }
}

impl Board {
  // raw_board is in the following format:
  // "10 5 2\n4 2 6\n" etc.
  pub fn new(raw_board: &str) -> Board {
    let mut nums = HashMap::new();
    for (y, row) in raw_board.lines().enumerate() {
      for (x, col) in row.split_whitespace().enumerate() {
        let num = col.parse::<u32>().unwrap();
        nums.insert(num, Pos { x, y });
      }
    }

    Board {
      size: 5,
      nums,
      row_counts: vec![0; 5],
      col_counts: vec![0; 5],
      win: false
    }
  }

  pub fn process_num(&mut self, num: u32) -> Option<u32> {
    if let Some(Pos { x, y }) = self.nums.remove(&num) {
      self.row_counts[y] += 1;
      self.col_counts[x] += 1;
      if self.row_counts[y] == self.size || self.col_counts[x] == self.size {
        self.win = true;
        return Some(self.nums.keys().sum::<u32>() * num)
      }
    }
    return None
  }
}
