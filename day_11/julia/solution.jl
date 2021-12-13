using DelimitedFiles

deltas = vec([(x, y) for x = -1:1, y = -1:1 if x != 0 || y != 0 ])
function get_adjacent(matrix, x, y)
  return [((d_x + x, d_y + y)) for (d_x, d_y) in deltas if checkbounds(Bool, matrix, d_x + x, d_y + y)]
end

function do_iteration(matrix)
  flashes = Set(Tuple.(findall(==(10), matrix)))
  while !isempty(flashes)
    for (x, y) in get_adjacent(matrix, pop!(flashes)...)
      if matrix[x, y] < 10 && (matrix[x, y] += 1) == 10
        push!(flashes, (x, y))
      end
    end
  end
end

function count_flashes(matrix, iteration)
  sum_of_flashes = 0
  for _ in 1:iteration
    matrix .+= 1
    do_iteration(matrix)
    sum_of_flashes += sum(matrix .== 10)
    matrix .%= 10
  end
  return sum_of_flashes
end

function find_synced_flashes(matrix)
  iteration = 0
  while any(>(0), matrix)
    matrix .+= 1
    do_iteration(matrix)
    matrix .%= 10
    iteration += 1
  end
  return iteration
end

matrix = readdlm(dirname(@__FILE__) * "/input.data", ' ', Int)
println("First part: ", count_flashes(copy(matrix), 100))
println("Second part: ", find_synced_flashes(copy(matrix)))

#println("\u1b[11F") # moves cursor 11 lines up
