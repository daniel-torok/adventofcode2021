package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"
)

func initialCounter(line string) []int {
	rawNumbers := strings.Split(line, ",")
	counter := make([]int, 9)
	for _, rawNum := range rawNumbers {
		num, _ := strconv.Atoi(rawNum)
		counter[num] += 1
	}
	return counter
}

func iterateDay(counter []int) []int {
	newCounter := counter[1:]
	newCounter = append(newCounter, counter[0])
	newCounter[6] += counter[0]
	return newCounter
}

func calculateSolution(counter []int, days int) int {
	acc := counter
	for i := 0; i < days; i++ {
		acc = iterateDay(acc)
	}

	sum := 0
	for _, num := range acc {
		sum += num
	}
	return sum
}

func main() {
	data, error := os.ReadFile("input.data")
	if error != nil {
		panic(error)
	}

	counter := initialCounter(strings.TrimSpace(string(data)))
	fmt.Printf("First day esult: %d\n", calculateSolution(counter, 80))
	fmt.Printf("Second day esult: %d\n", calculateSolution(counter, 256))
}
