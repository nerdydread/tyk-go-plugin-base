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

	//testExample3()
}

// Example3
// Tyk Plugin Entrypoint
func Example3(responseWriter http.ResponseWriter, request *http.Request) {
	doExample3(request)
}

// doExample3
// Handles the main plugin logic
func doExample3(request *http.Request) *http.Request {
	request.Header.Add("Example-Header-3", "1")

	return request
}

/**
DEBUG
*/

func testExample3() {
	// Given
	requestURL := fmt.Sprintf("http://localhost:%d/api/example3?foo=1&bar=2&baz=3", ServerPort)
	bodyReader := bytes.NewReader([]byte(``))
	req, _ := http.NewRequest(http.MethodPost, requestURL, bodyReader)
	reqBody, _ := ioutil.ReadAll(req.Body)

	fmt.Println("Original Headers: ", req.Header)
	fmt.Println("Original Query: ", req.URL.Query().Encode())
	fmt.Println("Original Body: ", string(reqBody))

	newReq := doExample3(req)
	newReqBody, _ := ioutil.ReadAll(newReq.Body)
	fmt.Println("New Headers: ", newReq.Header)
	fmt.Println("New Query: ", newReq.URL.Query().Encode())
	fmt.Println("New Body: ", string(newReqBody))
}
