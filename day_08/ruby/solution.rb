$LOAD_PATH.unshift(File.expand_path('../', __FILE__))
require 'functions.rb'
require 'set'

DIGITS = ["abcefg", "cf", "acdeg", "acdfg", "bcdf", "abdfg", "abdefg", "acf", "abcdefg", "abcdfg"]
contents = File.read(File.expand_path("input.data", __dir__)).split("\n")

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
    alter_display(display, DIGITS[1], one)
    alter_display(display, DIGITS[7], seven)
    alter_display(display, DIGITS[4], four)
    alter_display(display, DIGITS[3], three)
    alter_display(display, DIGITS[5], five)
    display = display.map { |k,v| [k, v.to_a[0]] }.to_h.invert()
  
    visible_digits.split(" ").each_with_object([]) { |encoded, arr|
      decoded = encoded.chars.map { |d| display[d] }.sort(&:casecmp).join
      arr.append(DIGITS.find_index(decoded).to_s)
    }.join.to_i
  }.sum.to_s
end

puts "First: " + first(contents)
puts "Second: " + second(contents)
