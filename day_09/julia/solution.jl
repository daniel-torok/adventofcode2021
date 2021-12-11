using DelimitedFiles

deltas = vec([(-1, 0), (0, 1), (1, 0), (0, -1)])
function get_adjacent(matrix, x, y)
  return [((d_x + x, d_y + y)) for (d_x, d_y) in deltas if checkbounds(Bool, matrix, d_x + x, d_y + y)]
end

function _lookup(matrix, idx)
  x, y = idx
  return matrix[x, y]
end

function find_mins(matrix)
  mins = []
  rows, cols = size(matrix)
  for (x, y) in [(x, y) for x in 1:rows for y in 1:cols]
    neighbours = matrix[max(1, x-1):min(rows, x+1), (max(1, y-1):min(cols, y+1))]
    if sum(neighbours .< matrix[x, y]) == 0
      push!(mins, (x, y))
    end
  end
  return mins
end

function get_basins(matrix, mins)
  function _basin(min)
    unvisited = Set([min])
    visited = Set([])
    while !isempty(unvisited)
      current = pop!(unvisited)
      push!(visited, current)
      for (x, y) in get_adjacent(matrix, current...)
        if matrix[x, y] != 9 && !((x, y) in visited)
          push!(unvisited, (x, y))
        end
      end
    end
    return length(visited)
  end

  return sort(_basin.(mins), rev=true)
end

matrix = readdlm(dirname(@__FILE__) * "/input.data", ' ', Int)
lookup = Base.Fix1(_lookup, matrix)
mins = find_mins(matrix)

println("First part: ", sum(lookup.(mins)) + length(mins))
println("Second part: ", prod(get_basins(matrix, mins)[1:3]))
