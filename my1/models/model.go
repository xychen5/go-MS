package models

import (
	"fmt"
	"github.com/astaxie/beego/orm"
	_ "github.com/go-sql-driver/mysql"
	"reflect"
	"strconv"
)


type StuEventType int

const (
	StuJoin = iota   //0
	StuLoadLessons   //1
	StuChooseL       //2
	StuShow          //3
	StuLogMessage       //4

)

type Lesson struct{
	TID     int
	TNAME   string
	LID     int
	LNAME   string

}

//有哪些课程，这会被学生选课用
type Lessons struct{
	HaveL   []Lesson
}

type TakeLesson struct{
	SID int
	TID int
	TNAME string
	LID int
	LNAME string
	SCORE int
}

type TakeLessons struct{
	TakeL   []TakeLesson
}

//传递给客户端的信息，不一定所有的都初始化了，得看类型
type StuData struct{
	Type    StuEventType  //join, chooseL, Show, exit
	LChoice Lessons       //lessons to choosen
	LTake   TakeLessons
}


type Message struct{
	Type    int
	Message string
    From    string
	To      string
}

var (
	con orm.Ormer
)

func init(){

	////
	////	参数一：数据库别名
	////	参数二：驱动名称
	////	参数三：数据库连接字符串:username:password@tcp(127.0.0.1:3306)/databasename?charset=utf8
	////	参数四：设置数据库的最大空闲连接
	////
	_ = orm.RegisterDataBase("default",
		"mysql",
		"root:cxy0321@tcp(127.0.0.1:3306)/CXY?charset=utf8",
		5)

    fmt.Println("models is inited!");

	con = orm.NewOrm()


	var maps []orm.Params
	ok := 1
	num,_ := con.Raw("SELECT * FROM TEACHER where TID>?",ok).Values(&maps)

	for _,term := range maps{
		fmt.Println(term["TID"],":",term["TNAME"],num)
	}

	var maps2 []orm.Params
	num2,_ := con.Raw("SELECT TEACHER.TID, TEACHER.TNAME, LESSON.LID, LESSON.LNAME "+
		"from CXY.TEACHER left join CXY.TEACH on " +
	   "CXY.TEACHER.TID = CXY.TEACH.TID " +
		"left join CXY.LESSON on CXY.TEACH.LID = CXY.LESSON.LID;").Values(&maps2)
	var tmp = Lesson{0,"",0,""}

	for _,term := range maps2{
		fmt.Println(term["TID"]," ",term["TNAME"]," ",term["LID"],
			" ",term["LNAME"]," ",num2)
		fmt.Println(reflect.TypeOf(term))
		fmt.Println(reflect.TypeOf(term["TNAME"]))

		tmp.TID, _ = strconv.Atoi(reflect.ValueOf(term["TID"]).String())
		tmp.TNAME = reflect.ValueOf(term["TNAME"]).String()
		tmp.LID,_ = strconv.Atoi(reflect.ValueOf(term["LID"]).String())
		tmp.LNAME = reflect.ValueOf(term["LNAME"]).String()
	}
	//db, err := sql.Open("mysql", "root:cxy0321@tcp(127.0.0.1:3306)/CXY?charset=utf8")
    //var L Lessons
	//GetLessons(&L)
}

func GetLessons(p *Lessons ) *Lessons{
	var maps2 []orm.Params
	num2,_ := con.Raw("SELECT TEACHER.TID, TEACHER.TNAME, LESSON.LID, LESSON.LNAME "+
		"from CXY.TEACHER left join CXY.TEACH on " +
		"CXY.TEACHER.TID = CXY.TEACH.TID " +
		"left join CXY.LESSON on CXY.TEACH.LID = CXY.LESSON.LID;").Values(&maps2)
	if num2 == 0{
		fmt.Println("cannot get the lessons for stu to choose")
		return nil
	}

	var tmp = Lesson{0,"",0,""}
	for _,term := range(maps2){
		tmp.TID, _ = strconv.Atoi(reflect.ValueOf(term["TID"]).String())
		tmp.TNAME = reflect.ValueOf(term["TNAME"]).String()
		tmp.LID,_ = strconv.Atoi(reflect.ValueOf(term["LID"]).String())
		tmp.LNAME = reflect.ValueOf(term["LNAME"]).String()

		p.HaveL = append(p.HaveL,tmp)
		//fmt.Println("test Get Lessons"+p.HaveL[0].TNAME+p.HaveL[0].LNAME)
	}
	return p
}
