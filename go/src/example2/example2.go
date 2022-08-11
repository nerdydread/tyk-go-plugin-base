package main

import (
	"bytes"
	"fmt"
	"io/ioutil"
	"net/http"
)

const ServerPort = 8080

func main() {
	// TODO: DEBUG FUNCTIONS -- uncomment to run

	//testExample2()
}

// Example2
// Tyk Plugin Entrypoint
func Example2(responseWriter http.ResponseWriter, request *http.Request) {
	doExample2(request)
}

// doExample2
// Handles the main plugin logic
func doExample2(request *http.Request) *http.Request {
	request.Header.Add("Example-Header-2", "1")

	return request
}

/**
DEBUG
*/

func testExample2() {
	// Given
	requestURL := fmt.Sprintf("http://localhost:%d/api/example2?foo=1&bar=2&baz=3", ServerPort)
	bodyReader := bytes.NewReader([]byte(``))
	req, _ := http.NewRequest(http.MethodPost, requestURL, bodyReader)
	reqBody, _ := ioutil.ReadAll(req.Body)

	fmt.Println("Original Headers: ", req.Header)
	fmt.Println("Original Query: ", req.URL.Query().Encode())
	fmt.Println("Original Body: ", string(reqBody))

	newReq := doExample2(req)
	newReqBody, _ := ioutil.ReadAll(newReq.Body)
	fmt.Println("New Headers: ", newReq.Header)
	fmt.Println("New Query: ", newReq.URL.Query().Encode())
	fmt.Println("New Body: ", string(newReqBody))
}
