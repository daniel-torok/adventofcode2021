require 'set'

def get_matching(match_count, compare_to, *candidates)
  candidates.select { |candidate| candidate.count(compare_to) == match_count }
end

def alter_display(display, expected_digits, actual_digits)
  actual_digits = Set[*actual_digits.chars]
  expected_digits = Set[*expected_digits.chars]

  expected_digits.each do |digit|
    entry = display.assoc(digit)
    entry[1] = entry[1].intersection(actual_digits)
  end

  skip_digits = Set[*('a'..'g')].subtract(expected_digits)
  skip_digits.each do |digit|
    _, set = display.assoc(digit)
    set.subtract(actual_digits)
  end
end
