package controllers

import (
	"fmt"
	"github.com/astaxie/beego"
	"github.com/gorilla/websocket"
	"log"
	"my1/models"
	"reflect"
	"time"
)

type StuController struct{
	beego.Controller
}

var upgrader = websocket.Upgrader{}

var (
	username string
)

//implement the get way
func (c *StuController) Get() {
	fmt.Println("enter stu's get")

	//fmt.Println(c.TplName)
	username = c.GetString("username")
	if len(username) == 0 {
		c.Redirect("/", 302)
		return
	}
	fmt.Println("username  is" + username)
	c.Data["UserName"] = username
	c.TplName = "stu.tpl"
	return
}


//handle websocket req
func (c *StuController) StuEnter() {
	fmt.Println("Stu enter, websocket is established!")

	ws, err := upgrader.Upgrade(c.Ctx.ResponseWriter, c.Ctx.Request, nil)
	if err != nil {
		log.Fatal(err)
	}
	//  defer ws.Close()
	fmt.Println("upgrader is ok")
	clients[ws] = true

    //学生进入
	msg := models.Message{
		Type: models.StuJoin,    //0
		Message: username +"log in at " + time.Now().Format("01-02 15:04"),
		From:"go host",
		To:"web"}
	broadcast <- msg

	//发送可选课程信息
	var LessonsInfo models.Lessons
	models.GetLessons(&LessonsInfo)
	msgLessonsInfo := models.StuData{
		Type:    models.StuLoadLessons, //1
		LChoice: LessonsInfo,
		LTake: models.TakeLessons{
			[]models.TakeLesson{models.TakeLesson{0, 0, "", 0, "", 0}}},
	}
	stuChan <- msgLessonsInfo

	//将消息广播发送到页面上
	ctr := 0
	for {
		//目前存在问题 定时效果不好 需要在业务代码替换时改为beego toolbox中的定时器
		fmt.Println("ctr is",ctr)
		time.Sleep(time.Second * 3)
		_, p, err := ws.ReadMessage()
		if err != nil {
			return
		}
		fmt.Println("have received msg from client" + string(p) + "type is")
		fmt.Println(reflect.TypeOf(p))
		fmt.Println(string(p))
		//if ctr % 2 == 0 {
		if ctr < 0 {
			msg := models.Message{
				Type: models.StuLogMessage,
				Message: "这是向页面发送的数据 " + time.Now().Format("2006-01-02 15:04:05"),
				From:"go host",
				To:"web",
			}
			broadcast <- msg

		}else {

			_, p, err := ws.ReadMessage()
			if err != nil {
				return
			}
			fmt.Println("have received msg from client" + string(p) + "type is")
			fmt.Println(reflect.TypeOf(p))
			fmt.Println(string(p))
			msg := models.Message{
				Type: models.StuLogMessage,
				Message: "自页面发送的数据 " + string(p) + time.Now().Format("2006-01-02 15:04:05"),
				From:"web",
				To:"web"}
			broadcast <- msg
		}
		ctr += 1

	}

	return
}

func (c *StuController) StuPost() {

	// Safe check.
	uname := c.GetString("uname")
	if uname == "false" {
		//back to welcom view
		c.Redirect("/", 302)
		return
	}

	fmt.Println("stu's Post is called");

	//change to teacher view
	c.TplName = "stu.tpl"

	return
}