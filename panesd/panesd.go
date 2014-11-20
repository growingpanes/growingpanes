package main

import (
	"bufio"
	"bytes"
	"encoding/json"
	"fmt"
	"github.com/gorilla/http"
	// jsonrpc "github.com/gorilla/rpc/json"
	"github.com/gorilla/websocket"
	"log"
	"math/rand"
	"net"
	"net/url"
	"os"
	"runtime"
	"strconv"
)

type Tab struct {
	Description          string
	DevtoolsFrontendUrl  string
	FaviconUrl           string
	Id                   string
	Title                string
	Type                 string
	Url                  string
	WebSocketDebuggerUrl string
}

type ChromeError struct {
	Code    int      `json:"code,omitempty"`
	Message string   `json:"message,omitempty"`
	Data    []string `json:"data,omitempty"`
}

// We don't know if an incoming message from Chrome is going to be a request or
// a response. This will handle both.
type ChromeMessage struct {
	// Response Fields

	// Result map[string]interface{} `json:"result"`
	Result interface{} `json:"result,omitempty"`
	Error  interface{} `json:"error,omitempty"`

	// Request Fields

	// A String containing the name of the method to be invoked.
	Method string `json:"method"`
	// Object to pass as request parameter to the method.
	Params map[string]interface{} `json:"params"`
	// The request id. This can be of any type. It is used to match the
	// response with the request that it is replying to.
	Id interface{} `json:"id"`
}

var logger *log.Logger

var host = "127.0.0.1"
var port = 2345

func main() {
	// Set up logging
	logger = log.New(os.Stdout, "PanesD ", log.Lshortfile)

	// get available tabs and websocket urls from Chrome
	tabsJson := getTabs()
	var tabs []Tab
	err := json.Unmarshal(tabsJson.Bytes(), &tabs)
	errCheck(err)

	// Set up websockets connection to Chrome tab
	netConn, err := net.Dial("tcp", host+":"+strconv.Itoa(port))
	// netConn, err := net.Dial("tcp", "echo.websocket.org:80")
	errCheck(err)
	wsUrl := tabs[0].WebSocketDebuggerUrl
	// wsUrl = "ws://echo.websocket.org/?encoding=text"
	logger.Println("Connecting to " + wsUrl)
	url, err := url.Parse(wsUrl)
	errCheck(err)
	chrome, _, err := websocket.NewClient(netConn, url, nil, 2048, 2048)
	errCheck(err)

	// turn console on
	// request, err := jsonrpc.EncodeClientRequest("Console.enable", nil)
	// errCheck(err)
	// err = chrome.WriteMessage(
	// 	websocket.TextMessage,
	// 	request,
	// )
	// errCheck(err)

	// loop read console messages
	go func() {
		for {
			var consoleMessage ChromeMessage
			err := chrome.ReadJSON(&consoleMessage)
			if err != nil {
				logger.Println(err)
			} else {
				// logger.Println(consoleMessage)
				if len(consoleMessage.Method) != 0 {
					logger.Println("Message is a request")
					logger.Println(consoleMessage.Method)
					logger.Println(consoleMessage.Params)
				}
				if consoleMessage.Result != nil {
					logger.Println("Message is a response")
					logger.Println(consoleMessage.Result)
				}
				if consoleMessage.Error != nil {
					chromeError := consoleMessage.Error.(map[string]interface{})
					logger.Println("Message is an error")
					logger.Println(chromeError["code"])
					logger.Println(chromeError["message"])
					logger.Println(chromeError["data"])
				}
			}
		}
	}()

	scanner := bufio.NewScanner(os.Stdin)
	for scanner.Scan() {
		fmt.Print("Enter Url: ")
		input := scanner.Text()

		if err := scanner.Err(); err != nil {
			fmt.Fprintln(os.Stderr, "reading standard input:", err)
		}

		// params := map[string]string{
		// 	"url": input,
		// }
		// request, err := jsonrpc.EncodeClientRequest("Page.navigate", params)
		// logger.Println("Sending request: " + bytes.NewBuffer(request).String())
		// errCheck(err)
		// err = chrome.WriteMessage(
		// 	websocket.TextMessage,
		// 	request,
		// )
		// errCheck(err)

		params := map[string]interface{}{
			"url": input,
		}

		urlChangeMsg := ChromeMessage{
			Method: "Page.navigate",
			Params: params,
			Id:     int(rand.Int31()),
		}

		// logger.Println("Sending request: " + bytes.NewBuffer(json).String())
		err = chrome.WriteJSON(urlChangeMsg)
		// m := "{\"method\":\"Page.navigate\",\"params\":{\"url\":\"http://aol.com\"},\"id\":6129484611666145821}"
		// m  = "{\"jsonrpc\":\"2.0\",\"id\":0,\"method\":\"Page.navigate\",\"params\":{\"url\":\"http://aol.com\"}}"
		// err = chrome.WriteMessage(websocket.TextMessage, bytes.NewBufferString(m).Bytes())
		// errCheck(err)
	}

}

func getTabs() *bytes.Buffer {
	url := "http://" + host + ":" + strconv.Itoa(port) + "/json"
	logger.Println("dialing " + url)

	var response bytes.Buffer
	if _, err := http.Get(&response, url); err != nil {
		log.Fatalf("could not fetch: %v", err)
	}

	return &response
}

func errCheck(err error) {
	if err != nil {
		trace := make([]byte, 1024)
		count := runtime.Stack(trace, true)
		logger.Fatalf("%s\nStack of %d bytes: %s", trace, count, err)
	}
}
