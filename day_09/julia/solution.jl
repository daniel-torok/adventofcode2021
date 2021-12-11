using DelimitedFiles

function find_mins(matrix)
  mins = []
  rows, cols = size(matrix)
  for (x, y) in [(x, y) for x in 1:rows for y in 1:cols]
    neighbours = matrix[max(1, x-1):min(rows, x+1), (max(1, y-1):min(cols, y+1))]
    if sum(neighbours .< matrix[x, y]) == 0
      push!(mins, (x, y, matrix[x, y]))
    end
  end
  return mins
end

matrix = readdlm(dirname(@__FILE__) * "/input.data", ' ', Int)
mins = find_mins(matrix)

println("First part: ", sum(last.(mins)) + length(mins))
println()
