#!/bin/bash

counter_matrix_part_one=()
counter_matrix_part_two=()
max=$(cat input.data | sed -r 's/([0-9]+),([0-9]+) -> ([0-9]+),([0-9]+)(.*)/\1\n\2\n\3\n\4/' | sort | tail -n 1)
lines=$(cat input.data | sed -r 's/([0-9]+),([0-9]+) -> ([0-9]+),([0-9]+)(.*)/\1,\2,\3,\4/')
number_of_lines=$(wc -l input.data | awk '{print $1}')

progress=0
for line in ${lines}; do
  IFS=',' read -ra coords <<< "$line"
  x1=${coords[0]}
  y1=${coords[1]}
  x2=${coords[2]}
  y2=${coords[3]}
  
  if [ ${x1} -eq ${x2} ]
  then
    for pair in $(seq ${y1} ${y2}); do
      idx=$((pair * max + x1))
      ((counter_matrix_part_one[${idx}]++))
      ((counter_matrix_part_two[${idx}]++))
    done
  elif [ ${y1} -eq ${y2} ]
  then
    for pair in $(seq ${x1} ${x2}); do
      idx=$((y1 * max + pair))
      ((counter_matrix_part_one[${idx}]++))
      ((counter_matrix_part_two[${idx}]++))
    done
  else
    [[ $((x2 - x1)) -gt 0 ]] && x_slope=1 || x_slope=-1
    [[ $((y2 - y1)) -gt 0 ]] && y_slope=1 || y_slope=-1
    length=$((x2 - x1))
    length=${length#-}
    for delta in $(seq 0 ${length}); do
      x=$((x1 + delta * x_slope))
      y=$((y1 + delta * y_slope))
      idx=$((y * max + x))
      ((counter_matrix_part_two[${idx}]++))
    done
  fi

  ((progress++))
  echo "Progress: ${progress}/${number_of_lines}"
done

counter_part_one=0
for num in ${counter_matrix_part_one[@]}; do
  if [ ${num} -gt 1 ]
  then
    ((counter_part_one++))
  fi
done

counter_part_two=0
for num in ${counter_matrix_part_two[@]}; do
  if [ ${num} -gt 1 ]
  then
    ((counter_part_two++))
  fi
done

echo "First part result: ${counter_part_one}"
echo "Second part result: ${counter_part_two}"
