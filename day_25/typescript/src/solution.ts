import fs from 'fs'
import path from 'path'

const data = fs.readFileSync(path.join(__dirname, 'input.data'), 'utf8')
const grid = data.split('\n').map(line => line.split(''))
const [height, width] = [grid.length, grid[0].length]

let numberOfMoves = 0
let couldMove = true
while (couldMove) {

  const movesRight = []
  for (let i = 0; i < height; i++) {
    for (let j = 0; j < width; j++) {
      if (grid[i][j] === '.') continue;
      if (grid[i][j] === '>' && grid[i][(j + 1) % width] === '.') {
        movesRight.push([i, j, i, (j + 1) % width])
      }
    }
  }

  movesRight.forEach(([i1, j1, i2, j2]) => {
    grid[i2][j2] = grid[i1][j1]
    grid[i1][j1] = '.'
  })

  const movesDown = []
  for (let i = 0; i < height; i++) {
    for (let j = 0; j < width; j++) {
      if (grid[i][j] === '.') continue;
      if (grid[i][j] === 'v' && grid[(i + 1) % height][j] === '.') {
        movesDown.push([i, j, (i + 1) % height, j])
      }
    }
  }

  movesDown.forEach(([i1, j1, i2, j2]) => {
    grid[i2][j2] = grid[i1][j1]
    grid[i1][j1] = '.'
  })

  couldMove = movesRight.length > 0 || movesDown.length > 0
  numberOfMoves++
}

console.log("Part one: " + numberOfMoves)
