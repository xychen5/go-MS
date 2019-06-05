package controllers

import (
	"encoding/json"
	"fmt"
	"github.com/astaxie/beego"
	"github.com/bitly/go-simplejson"
	"log"
	"my1/models"
	"reflect"
	"strconv"
	"time"
)

type DbaController struct{
	beego.Controller
}


//implement the get way
func (c *DbaController) Get() {
	fmt.Println("enter stu's get")

	//fmt.Println(c.TplName)
	username = c.GetString("username")
	if len(username) == 0 {
		c.Redirect("/", 302)
		return
	}
	fmt.Println("username  is" + username)
	//here username means dba
	c.Data["UserName"] = username
	c.TplName = "dba.tpl"
	return
}


//handle websocket req
func (c *DbaController) DbaEnter() {
	fmt.Println("Dba enter, websocket is established!")

	ws, err := upgrader.Upgrade(c.Ctx.ResponseWriter, c.Ctx.Request, nil)
	if err != nil {
		log.Fatal(err)
	}
	//  defer ws.Close()
	fmt.Println("upgrader is ok")

	clients[ws] = true

	//dba in
	msg := models.Message{
		Type: models.D0, //0
		Message: username +"log in at " + time.Now().Format("01-02 15:04"),
		From:"go host",
		To:"web"}
	dChan <- msg

	for {
		time.Sleep(time.Second * 3)

		//从前端读取json字符串
		_, p, err := ws.ReadMessage()

		if err != nil {
			return
		}
		fmt.Println("have received msg from client" + string(p) + "type is")
		fmt.Println(reflect.TypeOf(p))
		fmt.Println(string(p))

		//将前端的字符串解析到struct中，主要利用webData的Type
		var webData models.WebData
		_ = json.Unmarshal(p, &webData)

		//判断前端数据的类型，然后作相应处理
		if webData.Type == "createStu" { //
			fmt.Println("server's createStu triggered");

			//解析前端发来修改学生的
			js, _ := simplejson.NewJson(p)
			tmp1,_ := js.Get("Data").Get("SID").String()
			sid, _ :=  strconv.Atoi(tmp1)
			sname,_ := js.Get("Data").Get("SNAME").String()

			spass,_ := js.Get("Data").Get("SPASS").String()

			//向学生表插入一个人
            models.InsertStu(sid,sname,spass)

			msg := models.Message{
				Type: models.D1, //0
				Message: username +"createStu" + time.Now().Format("01-02 15:04"),
				From:"go host",
				To:"web"}
			dChan <- msg

		}else if webData.Type == "deleteStu" { //deal the chooseL action from the client
			fmt.Println("server's deleteStu triggered");

			//解析前端发来修改学生的
			js, _ := simplejson.NewJson(p)
			tmp1,_ := js.Get("Data").Get("SID").String()
			sid, _ :=  strconv.Atoi(tmp1)

			//向学生表删除一个人
			models.DeleteStu(sid)

			msg := models.Message{
				Type: models.D2, //0
				Message: username +"deleteStu" + time.Now().Format("01-02 15:04"),
				From:"go host",
				To:"web"}
			dChan <- msg

		}else if webData.Type == "modifyStu" { //deal the chooseL action from the client
			fmt.Println("server's modifyTea triggered");
			//解析前端发来修改学生的
			js, _ := simplejson.NewJson(p)
			tmp1,_ := js.Get("Data").Get("SID").String()
			sid, _ :=  strconv.Atoi(tmp1)
			spass,_ := js.Get("Data").Get("SPASS").String()

			//向学生表修改一个人
			models.UpdateStu(sid,spass)

			msg := models.Message{
				Type: models.D3, //0
				Message: username +"createStu" + time.Now().Format("01-02 15:04"),
				From:"go host",
				To:"web"}
			dChan <- msg

		}else if webData.Type == "createTea" { //
			fmt.Println("server's createTea triggered");

			//解析前端发来修改学生的
			js, _ := simplejson.NewJson(p)
			tmp1,_ := js.Get("Data").Get("TID").String()
			sid, _ :=  strconv.Atoi(tmp1)
			sname,_ := js.Get("Data").Get("TNAME").String()

			spass,_ := js.Get("Data").Get("TPASS").String()

			//向tea表插入一个人
			models.InsertTea(sid,sname,spass)

			msg := models.Message{
				Type: models.D4, //0
				Message: username +"createTea" + time.Now().Format("01-02 15:04"),
				From:"go host",
				To:"web"}
			dChan <- msg

		}else if webData.Type == "deleteTea" { //deal the chooseL action from the client
			fmt.Println("server's deleteTea triggered");

			//解析前端发来修改tea的
			js, _ := simplejson.NewJson(p)
			tmp1,_ := js.Get("Data").Get("TID").String()
			sid, _ :=  strconv.Atoi(tmp1)

			//向tea表删除一个人
			models.DeleteTea(sid)

			msg := models.Message{
				Type: models.D5, //0
				Message: username +"deleteTea" + time.Now().Format("01-02 15:04"),
				From:"go host",
				To:"web"}
			dChan <- msg

		}else if webData.Type == "modifyTea" { //deal the chooseL action from the client
			fmt.Println("server's modifyTea triggered");
			//解析前端发来修改tea的
			js, _ := simplejson.NewJson(p)
			tmp1,_ := js.Get("Data").Get("TID").String()
			sid, _ :=  strconv.Atoi(tmp1)
			spass,_ := js.Get("Data").Get("TPASS").String()

			//向tea表修改一个人
			models.UpdateTea(sid,spass)

			msg := models.Message{
				Type: models.D6, //0
				Message: username +"createStu" + time.Now().Format("01-02 15:04"),
				From:"go host",
				To:"web"}
			dChan <- msg
		}else if webData.Type == "createLes" { //
			fmt.Println("server's createLes triggered");

			//解析前端发来修改les的
			js, _ := simplejson.NewJson(p)
			tmp1,_ := js.Get("Data").Get("LID").String()
			sid, _ :=  strconv.Atoi(tmp1)
			sname,_ := js.Get("Data").Get("LNAME").String()

			//向tea表插入一个人
			models.InsertLes(sid,sname)

			msg := models.Message{
				Type: models.D7, //0
				Message: username +"createTea" + time.Now().Format("01-02 15:04"),
				From:"go host",
				To:"web"}
			dChan <- msg

		}else if webData.Type == "deleteLes" { //deal the chooseL action from the client
			fmt.Println("server's deleteLes triggered");

			//解析前端发来修改les的
			js, _ := simplejson.NewJson(p)
			tmp1,_ := js.Get("Data").Get("LID").String()
			sid, _ :=  strconv.Atoi(tmp1)

			//向tea表删除一个人
			models.DeleteLes(sid)

			msg := models.Message{
				Type: models.D8, //0
				Message: username +"deleteTea" + time.Now().Format("01-02 15:04"),
				From:"go host",
				To:"web"}
			dChan <- msg

		}else if webData.Type == "anyDo" { //deal the chooseL action from the client
			fmt.Println("server's deleteLes triggered");

			//解析前端发来修改les的
			js, _ := simplejson.NewJson(p)
			sql,_ := js.Get("Data").Get("Sql").String()


			//执行该sql
			_,err := models.Con.Exec(sql)
			if err!=nil{
				msg := models.Message{
					Type: models.D9, //0
					Message: "sql wrong:" + time.Now().Format("01-02 15:04"),
					From:"go host",
					To:"web"}
				dChan <- msg
			}else {
				msg := models.Message{
					Type: models.D9, //0
					Message: "sql right:" + time.Now().Format("01-02 15:04"),
					From:"go host",
					To:"web"}
				dChan <- msg
			}
		}else{
			//do nothing
			fmt.Println("wrong request type!")
		}
	}
	return
}

