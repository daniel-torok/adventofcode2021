package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"

	"go/solution/functions"
)

func initializeCounter(line string) []int {
	counter := make([]int, 9)
	for _, rawNum := range strings.Split(line, ",") {
		num, _ := strconv.Atoi(rawNum)
		counter[num] += 1
	}
	return counter
}

func calculateSolution(counter []int, days int) int {
	for i := 0; i < days; i++ {
		counter[7] += counter[0]
		counter = functions.Rotate(counter)
	}
	return functions.Sum(counter)
}

func main() {
	data, error := os.ReadFile("input.data")
	if error != nil {
		panic(error)
	}

	counter := initializeCounter(strings.TrimSpace(string(data)))
	fmt.Printf("First day result: %d\n", calculateSolution(counter, 80))
	fmt.Printf("Second day result: %d\n", calculateSolution(counter, 256))
}
