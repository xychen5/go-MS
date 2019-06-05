package controllers

import (
	"fmt"
	"github.com/gorilla/websocket"
	"log"
	"my1/models"
)

var (
	clients   = make(map[*websocket.Conn] bool)
	broadcast = make(chan models.Message)
	stuChan   = make(chan models.StuData)
	tmsg      = make(chan models.Message)
    tChan     = make(chan models.TeaData)
    dChan     = make(chan models.Message)
)

func init() {
	go handleMessages()
	go handleTMessages()
	go handleDMessages()
}

//广播发送至页面
func handleMessages() {
	for {
		msg := <-broadcast
		stuMsg := <-stuChan
		//webData := <- webChan
		fmt.Println("clients len ", len(clients))
		for client := range clients {
			err := client.WriteJSON(msg)
			err2 := client.WriteJSON(stuMsg)
			if err != nil || err2 != nil{
				log.Printf("msg:    client.WriteJSON error: %v", err)
				log.Printf("stuMsg: client.WriteJSON error: %v", err2)
				_ = client.Close()
				delete(clients, client)
			}
		}
	}
}


//tea广播发送至页面
func handleTMessages() {
	for {
		msg := <-tmsg
		tdata := <- tChan
		//webData := <- webChan
		fmt.Println("clients len ", len(clients))
		for client := range clients {
			err := client.WriteJSON(msg)
			err2 := client.WriteJSON(tdata)

			if err != nil || err2 != nil{
				log.Printf("msg:    client.WriteJSON error: %v", err)
				log.Printf("tdata: client.WriteJSON error: %v", err2)
				_ = client.Close()
				delete(clients, client)
			}
		}
	}
}

//dba广播发送至页面
func handleDMessages() {
	for {
		msg := <-dChan
		//webData := <- webChan
		fmt.Println("clients len ", len(clients))
		for client := range clients {
			err := client.WriteJSON(msg)

			if err != nil {
				log.Printf("msg:    client.WriteJSON error: %v", err)
				_ = client.Close()
				delete(clients, client)
			}
		}
	}
}
