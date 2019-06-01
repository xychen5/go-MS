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
)

func init() {
	go handleMessages()
}

//广播发送至页面
func handleMessages() {
	for {
		msg := <-broadcast
		stuMsg := <-stuChan
		fmt.Println("clients len ", len(clients))
		for client := range clients {
			err := client.WriteJSON(msg)
			err2 := client.WriteJSON(stuMsg)
			if err != nil || err2 != nil{
				log.Printf("msg:    client.WriteJSON error: %v", err)
				log.Printf("stuMsg: client.WriteJSON error: %v", err2)

				client.Close()
				delete(clients, client)
			}
		}
	}
}
