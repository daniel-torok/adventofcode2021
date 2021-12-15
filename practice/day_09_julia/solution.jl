using DelimitedFiles

deltas = vec([(-1, 0), (0, 1), (1, 0), (0, -1)])
function get_adjacent(matrix, x, y)
  return [((d_x + x, d_y + y)) for (d_x, d_y) in deltas if checkbounds(Bool, matrix, d_x + x, d_y + y)]
end

function _lookup(matrix, idx)
  return matrix[idx...]
end

function find_mins(matrix, rows, cols)
  function neighbour_indices(x, y)
    return (max(1, x-1):min(rows, x+1), (max(1, y-1):min(cols, y+1)))
  end

  return filter(
    ((x, y),) -> !any(matrix[neighbour_indices(x, y)...] .< matrix[x, y]),
    [(x, y) for x in 1:rows for y in 1:cols]
  )
end

function _get_basins(matrix, min)
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

matrix = readdlm(dirname(@__FILE__) * "/input.data", ' ', Int)
lookup = Base.Fix1(_lookup, matrix)
get_basins = Base.Fix1(_get_basins, matrix)

mins = find_mins(matrix, size(matrix)...)
basins = sort(get_basins.(mins), rev=true)

println("First part: ", sum(lookup.(mins)) + length(mins))
println("Second part: ", prod(basins[1:3]))
