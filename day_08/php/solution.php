<?php
require_once 'functions.php';

$DIGITS = array_flip(array(
  0 => 'abcefg',
  1 => 'cf',
  2 => 'acdeg',
  3 => 'acdfg',
  4 => 'bcdf',
  5 => 'abdfg',
  6 => 'abdefg',
  7 => 'acf',
  8 => 'abcdefg',
  9 => 'abcdfg'
));

function part_one($contents) {
  function sum_if_part_one_fn($val) {
    $length = strlen($val);
    return (($length >= 2 && $length <= 4) || $length == 7) ? 1 : NULL;
  }

  $sum = 0;
  foreach ($contents as $line) {
    list(0 => $_, 1 => $nums) = explode(" | ", $line);
    $sum += sum_if(explode(" ", trim($nums)), 'sum_if_part_one_fn');
  }
  return $sum;
}

function part_two($contents) {
  global $DIGITS;
  $sum = 0;
  foreach($contents as $line) {
    $display = array(
      'a' => range('a', 'g'),
      'b' => range('a', 'g'),
      'c' => range('a', 'g'),
      'd' => range('a', 'g'),
      'e' => range('a', 'g'),
      'f' => range('a', 'g'),
      'g' => range('a', 'g')
    );

    list(0 => $all_digits, 1 => $visible_digits) = explode(" | ", $line);
    $all_digits = explode(" ", $all_digits);
    $visible_digits = explode(" ", trim($visible_digits));
    usort($all_digits, fn($a, $b) => strlen($a) - strlen($b));

    list(
      0 => $one,
      1 => $seven,
      2 => $four,
      3 => $_3_possible_1,
      4 => $_3_possible_2,
      5 => $_3_possible_3,
      6 => $_6_possible_1,
      7 => $_6_possible_2,
      8 => $_6_possible_3
    ) = array_map('str_split', $all_digits);
    $three = find_matching($one, 2, $_3_possible_1, $_3_possible_2, $_3_possible_3);
    $six = find_matching($one, 1, $_6_possible_1, $_6_possible_2, $_6_possible_3);

    alter_display($display, ['c', 'f'], $one);
    alter_display($display, ['a', 'c', 'f'], $seven);
    alter_display($display, ['b', 'c', 'd', 'f'], $four);
    alter_display($display, ['a', 'c', 'd', 'f', 'g'], $three);
    alter_display($display, ['a', 'b', 'd', 'e', 'f', 'g'], $six);

    $display = array_flip(array_map(fn($v) => reset($v), $display));

    $decoded_number = '';
    foreach ($visible_digits as $digit) {
      $decoded_digit = array_map(fn($v) => $display[$v] ,str_split($digit));
      sort($decoded_digit);
      $decoded_number .= $DIGITS[implode('', $decoded_digit)];
    }
    $sum += intval($decoded_number);
  }

  return $sum;
}

$contents = explode(PHP_EOL, trim(file_get_contents('input.data', true)));
printf("First: %d\n", part_one($contents));
printf("Second: %d\n", part_two($contents));

?>
