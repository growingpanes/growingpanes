package main

import (
	"bufio"
	"bytes"
	"encoding/json"
	"errors"
	"fmt"
	ghttp "github.com/gorilla/http"
	"github.com/gorilla/mux"
	"github.com/gorilla/websocket"
	"log"
	"math/rand"
	"net"
	"net/http"
	"net/url"
	"os"
	"runtime"
	"strconv"
	"time"
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

	chrome, err := getChrome()
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
				logger.Println("Trying to reconnect to Chrome")
				chrome, err = getChrome()
				errCheck(err)
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

	r := mux.NewRouter()
	r.HandleFunc("/navigate/{url:.+}", func(response http.ResponseWriter, request *http.Request) {
		vars := mux.Vars(request)
		url := vars["url"]
		errCheck(navigate(chrome, url))
		fmt.Fprint(response, "Navigated to "+url)
	})
	http.Handle("/", r)
	log.Fatal(http.ListenAndServe(":3001", nil))

	scanner := bufio.NewScanner(os.Stdin)
	for scanner.Scan() {
		fmt.Print("Enter Url: ")
		input := scanner.Text()

		if err := scanner.Err(); err != nil {
			fmt.Fprintln(os.Stderr, "reading standard input:", err)
		}

		err = navigate(chrome, input)
		errCheck(err)
	}

}

func getChrome() (*websocket.Conn, error) {
	var tab Tab

	for tab.WebSocketDebuggerUrl == "" {
		// get available tabs and websocket urls from Chrome
		tabs := getTabs()

		if len(tabs) < 1 {
			time.Sleep(100 * time.Millisecond)
			continue
		}
		tab = tabs[0]
		wsUrl := tab.WebSocketDebuggerUrl
		// wsUrl = "ws://echo.websocket.org/?encoding=text"
		logger.Println("Connecting to " + wsUrl)
		url, err := url.Parse(wsUrl)
		errCheck(err)

		// Set up websockets connection to Chrome tab
		netConn, err := net.Dial("tcp", host+":"+strconv.Itoa(port))
		errCheck(err)
		chrome, _, err := websocket.NewClient(netConn, url, nil, 2048, 2048)
		return chrome, err
	}

	return nil, errors.New("Shouldn't have gotten here.")
}

func navigate(chrome *websocket.Conn, url string) error {
	params := map[string]interface{}{
		"url": url,
	}

	urlChangeMsg := ChromeMessage{
		Method: "Page.navigate",
		Params: params,
		Id:     int(rand.Int31()),
	}

	return chrome.WriteJSON(urlChangeMsg)
}

func getTabs() []Tab {
	url := "http://" + host + ":" + strconv.Itoa(port) + "/json"
	logger.Println("dialing " + url)

	var response bytes.Buffer
	if _, err := ghttp.Get(&response, url); err != nil {
		log.Printf("could not fetch: %v", err)
		return nil
	}

	var tabs []Tab
	err := json.Unmarshal(response.Bytes(), &tabs)
	errCheck(err)

	return tabs
}

func errCheck(err error) {
	if err != nil {
		trace := make([]byte, 1024)
		count := runtime.Stack(trace, true)
		logger.Fatalf("%s\nStack of %d bytes: %s", trace, count, err)
	}
}
