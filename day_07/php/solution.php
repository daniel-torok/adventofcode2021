<?php

$file = file_get_contents('input.data', true);
$nums = array_map('intval', explode(',', $file));

$differences = array_map(
  fn($compare_to): array =>
    array_map(fn($value): int => abs($compare_to - $value), $nums),
  range(0, max($nums))
);

$result_part_one = min(array_map('array_sum', $differences));
print "Part one: $result_part_one\n";

/* // too much memory usage
$differences_incremental = array_map(
  fn($differences_in_iteration): array =>
    array_map(fn($difference): int => ($difference * ($difference + 1) / 2), $differences_in_iteration),
  $differences
);

$result_part_two = min(array_map('array_sum', $differences_incremental));
print "Part two: $result_part_two\n";
*/

$max_value = max($nums);
$min_sum = PHP_INT_MAX;
for ($compare_to = 0; $compare_to <= $max_value; $compare_to++) {
  $sum = 0;
  foreach ($nums as $num) {
    $delta = abs($compare_to - $num);
    $cost = ($delta * ($delta + 1) / 2);
    $sum += $cost;
  }
  $min_sum = min($min_sum, $sum);
}
print "Part two: $min_sum\n";

?>
