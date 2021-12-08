require 'set'

local_dir = File.expand_path('../', __FILE__)
$LOAD_PATH.unshift(local_dir)
require 'functions.rb'

DIGITS = [
  [0, "abcefg"],
  [1, "cf"],
  [2, "acdeg"],
  [3, "acdfg"],
  [4, "bcdf"],
  [5, "abdfg"],
  [6, "abdefg"],
  [7, "acf"],
  [8, "abcdefg"],
  [9, "abcdfg"]
]

contents = File.read("input.data").split("\n")

def first(contents)
  numbers = contents.map { |row|
    _, visible_digits = row.split(" | ")
    visible_digits.split(" ").select { |digit| [2, 3, 4, 7].include? digit.length }.count
  }.sum.to_s
end

def second(contents)
  numbers = contents.map { |row|
    all_digits, visible_digits = row.split(" | ")
    one, seven, four, three_five_1, three_five_2, three_five_3 = all_digits.split(" ").sort_by(&:length)
    three = get_matching(2, one, three_five_1, three_five_2, three_five_3)[0]
    five = get_matching(1, one, *get_matching(3, four, three_five_1, three_five_2, three_five_3))[0]
    
    display = ('a'..'g').map { |digit| [digit, Set[*('a'..'g')]] }
    alter_display(display, DIGITS.assoc(1)[1], one)
    alter_display(display, DIGITS.assoc(7)[1], seven)
    alter_display(display, DIGITS.assoc(4)[1], four)
    alter_display(display, DIGITS.assoc(3)[1], three)
    alter_display(display, DIGITS.assoc(5)[1], five)
    display = display.map { |k,v| [k, v.to_a[0]] }
  
    visible_digits.split(" ").each_with_object([]) { |encoded, arr|
      decoded = encoded.chars.map { |d| display.rassoc(d)[0] }.sort(&:casecmp).join
      arr.append(DIGITS.rassoc(decoded)[0].to_s)
    }.join.to_i
  }.sum.to_s
end

puts "First: " + first(contents)
puts "Second: " + second(contents)
