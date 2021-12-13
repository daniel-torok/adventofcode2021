<?php

$file = file_get_contents('input.data', true);
$nums = array_map('intval', explode(',', $file));

$differences = array_map(fn($compare_to): array => array_map(fn($num): int => abs($compare_to - $num), $nums), range(0, max($nums)));
$differences2 = array_map(fn($arr): int => array_reduce($arr, fn($acc, $num): int => $acc + $num * ($num + 1) / 2, 0), $differences);

printf("Part one: %d\n", min(array_map('array_sum', $differences)));
printf("Part one: %d\n", min($differences2));

?>
