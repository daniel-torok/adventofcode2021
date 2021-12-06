package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"
)

func repeat(val int, times int) []int {
	slice := make([]int, times)
	for i := range slice {
		slice[i] = val
	}
	return slice
}

func main() {
	data, error := os.ReadFile("input.data")
	if error != nil {
		panic(error)
	}

	line := strings.TrimSpace(string(data))
	split := strings.Split(line, ",")
	numbers := make([]int, 0, 500000000)
	numbers_2 := make([]int, 0, 300)
	for _, rawNum := range split {
		num, _ := strconv.Atoi(rawNum)
		numbers = append(numbers, num)
		numbers_2 = append(numbers_2, num)
	}

	/* part one
		for i := 0; i < 80; i++ {
			counter := 0
			for idx, num := range numbers {
				newNum := num - 1
				if newNum == -1 {
					newNum = 6
					counter += 1
				}

				numbers[idx] = newNum
			}
			numbers = append(numbers, repeat(8, counter)...)
		}
	  fmt.Printf("Result: %d\n", len(numbers))
	*/

	// Part two
	dict := []int{-1, 6206821033, 5617089148, 5217223242, 4726100874, 4368232009}
	sum := 0
	for _, num := range numbers_2 {
		sum += dict[num]
	}
	fmt.Printf("Result: %d\n", sum)

}
