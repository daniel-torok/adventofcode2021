<?php
function sum_if($coll, $fn) {
  $sum = 0;
  foreach ($coll as $value) {
    $res = $fn($value);
    if ($res !== NULL) {
      $sum += $res;
    }
  }
  return $sum;
}

function alter_display(&$display, array $expected_segments, array $actual_segments) {
  $skip_segments = array_diff(range('a', 'g'), $expected_segments);
  foreach ($skip_segments as $skip) {
    $display[$skip] = array_diff($display[$skip], $actual_segments);
  }
  foreach ($expected_segments as $expected) {
    $display[$expected] = array_intersect($display[$expected], $actual_segments);
  }
}

function find_matching(array $compare_to, int $num, array ...$others) {
  foreach ($others as $other) {
    if (count(array_intersect($compare_to, $other)) == $num) {
      return $other;
    }
  }
}
?>
