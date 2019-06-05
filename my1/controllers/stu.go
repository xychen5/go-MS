package controllers

import (
	"encoding/json"
	"fmt"
	"github.com/astaxie/beego"
	"github.com/bitly/go-simplejson"
	"github.com/gorilla/websocket"
	"log"
	"my1/models"
	"reflect"
	"strconv"
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
	//here username means stu id
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
		//fmt.Println("ctr is",ctr)

		time.Sleep(time.Second * 3)

		if ctr < 0 {

		} else {
			//从前端读取json字符串
			_, p, err := ws.ReadMessage()

			if err != nil {
				return
			}
			fmt.Println("have received msg from client" + string(p) + "type is")
			fmt.Println(reflect.TypeOf(p))
			fmt.Println(string(p))

			//将前端的字符串解析到struct中
			var webData models.WebData
			_ = json.Unmarshal(p, &webData)


			//判断前端数据的类型，然后作相应处理
			if webData.Type == "refresh"{       //
				msg := models.Message{
					Type: models.StuShowChooseL,    //4
					Message: "from host: operation success!" +"@"+ time.Now().Format("2006-01-02 15:04:05"),
					From:"web",
					To:"web"}
				msgShowChooseL := msgLessonsInfo
				msgShowChooseL.Type = models.StuShowChooseL
				var ChooseLInfo models.TakeLessons
				sid, _ := strconv.Atoi(username)
				fmt.Println("sid is", sid)
				models.GetTakeLessons(&ChooseLInfo, sid)
				fmt.Println(ChooseLInfo)
				msgShowChooseL.LTake = ChooseLInfo
				//发送已经选了的课程
				broadcast <- msg
				stuChan <- msgShowChooseL

			}else if webData.Type == "chooseL"{  //deal the chooseL action from the client
				fmt.Println("server's chooseL triggered");

				msg := models.Message{
					Type: models.StuLogMessage,    //4
					Message: "from host: operation success!" +"@"+ time.Now().Format("2006-01-02 15:04:05"),
					From:"web",
					To:"web"}
				////将数据装到已知的结构
				//var data models.WebStuChooseL
				//_ = json.Unmarshal(p, &data)
                //fmt.Println(data)
				//models.InsertTakeL(data.STL.SID, data.STL.TID, data.STL.LID)
                //t := []byte(strJ)
				js, _ := simplejson.NewJson(p)
                tmp1,_ := js.Get("Data").Get("LID").String()
				lid, _ :=  strconv.Atoi(tmp1)

				tmp2,_ := js.Get("Data").Get("SID").String()
				sid, _ :=  strconv.Atoi(tmp2)
				tmp3,_ := js.Get("Data").Get("TID").String()
				tid, _ :=  strconv.Atoi(tmp3)
				//将学生插入选课表
				models.InsertTakeL(sid,tid,lid)
                //将学生插入参加考试表
                models.InsertTakeT(lid,sid)

				//a, _ := js.Get("Data").Get("LID").String()
				//fmt.Println("a is", a, reflect.TypeOf(p), string(p))
				broadcast <- msg
				//msgLessonsInfo.LTake.
				tmp := msgLessonsInfo
				tmp.Type = models.StuChooseL
				stuChan <- tmp
				//fmt.Println("send log msg from stu",data.STL.SID,data.STL.TID,data.STL.LID)
				//msgLTake := models.StuData{
				//	Type:    models.StuLoadLessons, //1
				//	LChoice: LessonsInfo,
				//	LTake: models.TakeLessons{
				//		[]models.TakeLesson{models.TakeLesson{0, 0, "", 0, "", 0}}},
				//}
			}
		}
		ctr += 1
	}
	return
}

func (c *StuController) StuPost() {

	fmt.Println("stu's Post is called");

	return
}