package main

import (
	"fmt"
	"strings"
)

type MultiError struct {
	errs []string
}

func (m *MultiError) Add(err error) {
	m.errs = append(m.errs, err.Error())
}

func (m *MultiError) Error() string {
	return strings.Join(m.errs, ";")
}

type Customer struct {
	Name string
	Age  int
}

func (c *Customer) Validate() error {
	var m *MultiError

	if c.Age < 21 {
		m = &MultiError{}
		m.Add(fmt.Errorf("Age is less than 21"))
	}

	if c.Name == "" {
		if m == nil {
			m = &MultiError{}
		}
		m.Add(fmt.Errorf("Name is empty"))
	}

	if m != nil {
		return m
	}

	return nil
}

func main() {
	// mistake with nil reciever
	customer := &Customer{Age: 22, Name: "test"}
	err := customer.Validate()
	if err != nil {
		fmt.Println("Validation failed: ", err)
		return
	}
	fmt.Println("Validation passed")

	defer func() {
		if r := recover(); r != nil {
			fmt.Println("Recovered from panic: ", r)
		}
	}()

	f()
}

func f() {
	fmt.Println("f")
	panic("Panic in f")
	// fmt.Println("ff")
}
