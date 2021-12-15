contents = File.read(File.expand_path("input.data", __dir__)).split("\n")

TABLE = {
  ')' => ['(', 3],
  ']' => ['[', 57],
  '}' => ['{', 1197],
  '>' => ['<', 25137]
}

COMPLETION_TABLE = {
  '(' => 1,
  '[' => 2,
  '{' => 3,
  '<' => 4
}

def solution(contents)
  sum_syntax_error = 0
  sum_completions = []
  for line in contents do
    stack = []
    syntax_error = false
    for char in line.chars do
      if TABLE.include? char then
        expected, score = TABLE[char]
        if stack[-1] == expected then
          stack.pop()
        else
          sum_syntax_error += score
          syntax_error = true
          break
        end
      else
        stack << char
      end
    end
    
    if !syntax_error then  
      tmp_sum_completion = 0
      while stack.length() > 0 do
        char = stack.pop()
        tmp_sum_completion = tmp_sum_completion * 5 + COMPLETION_TABLE[char]
      end
      sum_completions.append(tmp_sum_completion)
    end

  end
  sum_completions = sum_completions.sort
  return [sum_syntax_error, sum_completions[sum_completions.length()/2]]
end

first, second = solution(contents)
puts "First: " + first.to_s
puts "Second: " + second.to_s
