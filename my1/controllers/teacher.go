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

type TeacherController struct{
	beego.Controller
}

//implement the get way
func (c *TeacherController) Get() {
	fmt.Println("enter tea's get")

	username = c.GetString("username")
	if len(username) == 0 {
		c.Redirect("/", 302)
		return
	}
	fmt.Println("username  is" + username)
	//here username means stu id
	c.Data["UserName"] = username
	c.TplName = "teacher.tpl"

	return
}

//handle the websocket request
func (c *TeacherController) TeaEnter() {
	fmt.Println("Tea enter, websocket is established!")

	ws, err := upgrader.Upgrade(c.Ctx.ResponseWriter, c.Ctx.Request, nil)
	if err != nil {
		log.Fatal(err)
	}

	clients[ws] = true

	//老师进入
	msg := models.Message{
		Type: models.TeaJoin,    //0
		Message: username +"log in at " + time.Now().Format("01-02 15:04"),
		From:"go host",
		To:"web"}

	fmt.Println("entered!	")
	tmsg <- msg
	//实现老师的Show 功能
	var ShowInfo models.TakeLessonsT
	fmt.Println(ShowInfo)
	tid, _ := strconv.Atoi(username)
	models.ShowTea(tid, &ShowInfo)
	fmt.Println(ShowInfo)
	msgShowInfo := models.TeaData{
		Type:    models.TeaShow, //1
		LTake: ShowInfo,
		TeaL: models.Lessons{},
		}
	tChan <- msgShowInfo


	for {
		//目前存在问题 定时效果不好 需要在业务代码替换时改为beego toolbox中的定时器
		//fmt.Println("ctr is",ctr)

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
		if webData.Type == "show" { //
			fmt.Println("server's show stus triggered");
			msg := models.Message{
				Type:    models.TeaLogMessage,     //4
				Message: "from host:"+webData.Type+" operation success!"  + time.Now().Format("2006-01-02 15:04:05"),
				From:    "web",
				To:      "web"}

			//发送执行操作
			tmsg <- msg
			//实现老师的Show 功能
			var ShowInfo models.TakeLessonsT
			tid, _ := strconv.Atoi(username)
			models.ShowTea(tid, &ShowInfo)

			fmt.Println("show's content:",tid,"is",ShowInfo.TakeL)

			msgShowInfo := models.TeaData{
				Type:    models.TeaShow, //1
				LTake: ShowInfo,
				TeaL: models.Lessons{},
			}
			tChan <- msgShowInfo

		}else if webData.Type == "loadMyL" { //deal the chooseL action from the client
			fmt.Println("server's loadMyL triggered");

			//发送老师要编辑的课程的信息
			msg := models.Message{
				Type:    models.TeaLogMessage, //4
				Message: "from host: operation success!" + "@" + time.Now().Format("2006-01-02 15:04:05"),
				From:    "web",
				To:      "web"}
			tmsg<-msg

			//发送老师已有的课程，便于他为这些考试创建
			var LessonsInfo models.Lessons
			tid, _ := strconv.Atoi(username)
			models.GetLessonsT(tid,&LessonsInfo)

			fmt.Println(LessonsInfo)

			msgLessonsInfo := models.TeaData{
				Type: models.TeaLoadMyL, //1
				LTake: models.TakeLessonsT{},
				TeaL: LessonsInfo,

				}
			tChan <- msgLessonsInfo
		}else if webData.Type == "writeL" { //deal the chooseL action from the client
			fmt.Println("server's writeL triggered");

			//解析前端发来写入课程考试的信息
			js, _ := simplejson.NewJson(p)
			tmp1,_ := js.Get("Data").Get("LID").String()
			lid, _ :=  strconv.Atoi(tmp1)
			tmp2,_ := js.Get("Data").Get("TEID").String()
			teid, _ :=  strconv.Atoi(tmp2)
			tmp3,_ := js.Get("Data").Get("TEW").String()
			teW, _ :=  strconv.ParseFloat(tmp3, 32)

			teName, _ := js.Get("Data").Get("TENAME").String()

			//将该考试插入考试表：
			models.InsertTest(lid, teid, float32(teW), teName)


			//发送给前端告诉已经执行
			msg := models.Message{
				Type:    models.TeaLogMessage, //4
				Message: "from host: operation success!" + "@" + time.Now().Format("2006-01-02 15:04:05"),
				From:    "web",
				To:      "web"}
			tmsg<-msg


			tid, _ := strconv.Atoi(username)
			var ts models.Tests
			//获得该老师的考试
			models.GetTestsT(tid, &ts)

			//发送老师已经插入的所有考试
			msgLessonsInfo := models.TeaData{
				Type: models.TeaWriteL, //3
				TeaT: ts,
			}
			fmt.Println(ts)

			tChan <- msgLessonsInfo
		}else if webData.Type == "loadWriteS" { //deal the chooseL action from the client
			fmt.Println("server's loadWriteS triggered");

			//发送老师要编辑的课程的信息
			msg := models.Message{
				Type:    models.TeaLogMessage, //4
				Message: "from host: loadWriteS operation success!" + "@" + time.Now().Format("2006-01-02 15:04:05"),
				From:    "web",
				To:      "web"}
			tmsg<-msg

			//发送老师选了老师的课程的学生和他们的成绩表
			tid, _ := strconv.Atoi(username)
			//获得参考表
			var TakeTInfo models.TakeTs
			models.GetTakeTs(tid, &TakeTInfo)

			//获得学生表
			var ShowInfo models.TakeLessonsT
			models.ShowTea(tid, &ShowInfo)

			msgShowInfo := models.TeaData{
				Type:    models.TeaLoadWriteS, //6
				LTake: ShowInfo,
				TeaL: models.Lessons{},
				TeaTakeT:TakeTInfo,
			}
			tChan <- msgShowInfo



		}else if webData.Type == "writeS" { //deal the chooseL action from the client
			fmt.Println("server's writeS triggered");
			//
			//解析前端发来的登入成绩的信息
			js, _ := simplejson.NewJson(p)
			tmp1,_ := js.Get("Data").Get("LIDws").String()
			lidws, _ :=  strconv.Atoi(tmp1)
			tmp2,_ := js.Get("Data").Get("TEIDws").String()
			teidws, _ :=  strconv.Atoi(tmp2)
			tmp3,_ := js.Get("Data").Get("SIDws").String()
			sidws, _ :=  strconv.Atoi(tmp3)
			tmp4, _ := js.Get("Data").Get("PSCOREws").String()
			fmt.Println("tmp4 is",tmp4)
			pscorews, _ :=  strconv.ParseFloat(tmp4, 32)

			//获得老师的tid
			tid, _ := strconv.Atoi(username)

			//将该参考记录插入考试表：
            models.UpdatePSCORE(lidws,teidws,sidws, float32(pscorews))
            fmt.Println("记录writeS是",lidws,teidws,sidws, float32(pscorews))

			//于此同时更新该人的总成绩
            models.UpdateScore(lidws, sidws, tid)


			//发送给前端告诉已经执行
			msg := models.Message{
				Type:    models.TeaWriteS, //4
				Message: "from host: operation success!" + "@" + time.Now().Format("2006-01-02 15:04:05"),
				From:    "web",
				To:      "web"}
			tmsg<-msg

			//获得学生表
			var ShowInfo models.TakeLessonsT
			models.ShowTea(tid, &ShowInfo)

			//获得参考表
			var TakeTInfo models.TakeTs
			models.GetTakeTs(tid, &TakeTInfo)
            fmt.Println(TakeTInfo)
			//发送学生表和参考表
			msgShowInfo := models.TeaData{
				Type:    models.TeaLoadWriteS, //6
				LTake: ShowInfo,
				TeaL: models.Lessons{},
				TeaTakeT:TakeTInfo,
			}
			tChan <- msgShowInfo
		}else if webData.Type == "loadShowLevels" {
			fmt.Println("server's loadShowLevels triggered");

			msg := models.Message{
				Type:    models.TeaLogMessage,
				Message: "from host:"+webData.Type+" operation success!"  + time.Now().Format("2006-01-02 15:04:05"),
				From:    "web",
				To:      "web"}

			//发送执行操作
			tmsg <- msg
			//实现老师的Show 功能
			var ShowInfo models.TakeLessonsT
			tid, _ := strconv.Atoi(username)
			models.ShowTea(tid, &ShowInfo)

			fmt.Println("show's content:",tid,"is",ShowInfo.TakeL)

			msgShowInfo := models.TeaData{
				Type:    models.TeaLoadShowLevels, //7
				LTake: ShowInfo,
				TeaL: models.Lessons{},
			}
			tChan <- msgShowInfo
		}


	}


	return
}