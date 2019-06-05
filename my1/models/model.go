package models

import (
	"database/sql"
	"fmt"
	_ "github.com/go-sql-driver/mysql"
)


type StuEventType int
type TeaEventType int

const (
	StuJoin = iota  //0
	StuLoadLessons    //1
	StuChooseL       //2
	StuShowChooseL          //3
	StuLogMessage       //4
    //------------------------
)

const (
    TeaJoin = iota  //0
    TeaShow          //1
    TeaWriteS         //2
    TeaWriteL           //3
    TeaLogMessage     //4
    TeaLoadMyL        //5
    TeaLoadWriteS   //6
    TeaLoadShowLevels //7
)

const (
	D0 = iota
	D1
	D2
	D3
	D4
	D5
	D6
	D7
	D8
	D9
	D10
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
	SCORE float32
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

type WebData struct{
    Type    string
    Data    interface{}
}

type WebStuChooseL struct{
	Type    string `josn:"Type"`
	STL     struct{
		SID int
		TID int
		LID int
	}               `josn:"Data"`
}

//----------------------below structurs for teacher
type TakeLessonT struct{
	TID int
	SID int
	SNAME string
	LID int
	LNAME string
	SCORE float32
}

type TakeLessonsT struct{
	TakeL   []TakeLessonT
}

type Test struct {
	TEID   int
	LID    int
	TEW    float32
	TENAME string
}

type Tests struct {
    HaveT   []Test
}

//考一次考试
type TakeT struct{
    SID     int
	LID     int
    TEID    int
    PSCORE  float32
}

//多个学生参加的考试
type TakeTs struct{
	HaveTakeTs []TakeT
}

type TeaData struct{
	Type  TeaEventType
	LTake TakeLessonsT  //所有参加该老师的学生信息
    TeaL  Lessons    //该老师教的所有课程
	TeaT  Tests    //该老师制定的所有考试
    TeaTakeT TakeTs
}

var (
	Con *sql.DB
)


func init(){

	////
	////	参数一：数据库别名
	////	参数二：驱动名称
	////	参数三：数据库连接字符串:username:password@tcp(127.0.0.1:3306)/databasename?charset=utf8
	////	参数四：设置数据库的最大空闲连接
	////
	//_ = orm.RegisterDataBase("default",
	//	"mysql",
	//	"root:cxy0321@tcp(127.0.0.1:3306)/CXY?charset=utf8",
	//	5)
	//orm.RegisterModel(new(TL))
	//
    //fmt.Println("models is inited!");
	//
	//con = orm.NewOrm()
	//
	//
	//var maps []orm.Params
	//ok := 1
	//num,_ := con.Raw("SELECT * FROM TEACHER where TID>?",ok).Values(&maps)
	//
	//for _,term := range maps{
	//	fmt.Println(term["TID"],":",term["TNAME"],num)
	//}
	//
	//var maps2 []orm.Params
	//num2,_ := con.Raw("SELECT TEACHER.TID, TEACHER.TNAME, LESSON.LID, LESSON.LNAME "+
	//	"from CXY.TEACHER left join CXY.TEACH on " +
	//   "CXY.TEACHER.TID = CXY.TEACH.TID " +
	//	"left join CXY.LESSON on CXY.TEACH.LID = CXY.LESSON.LID;").Values(&maps2)
	//var tmp = Lesson{0,"",0,""}
	//
	//for _,term := range maps2{
	//	fmt.Println(term["TID"]," ",term["TNAME"]," ",term["LID"],
	//		" ",term["LNAME"]," ",num2)
	//	fmt.Println(reflect.TypeOf(term))
	//	fmt.Println(reflect.TypeOf(term["TNAME"]))
	//
	//	tmp.TID, _ = strconv.Atoi(reflect.ValueOf(term["TID"]).String())
	//	tmp.TNAME = reflect.ValueOf(term["TNAME"]).String()
	//	tmp.LID,_ = strconv.Atoi(reflect.ValueOf(term["LID"]).String())
	//	tmp.LNAME = reflect.ValueOf(term["LNAME"]).String()
	//}
	//
	//
	//
	//tmp1 := TL{1,1,3,0}
	//
	//err, _ := con.Insert(&tmp1);
	//if err < 0  {
	//	fmt.Println("hello")
	//}
	//fmt.Println("done")
	db, err := sql.Open("mysql", "root:cxy0321@tcp(127.0.0.1:3306)/CXY?charset=utf8")
    Con = db
	check(err)
	rows, err := Con.Query("SELECT TEACHER.TID, TEACHER.TNAME, LESSON.LID, LESSON.LNAME "+
		"from CXY.TEACHER left join CXY.TEACH on " +
		"CXY.TEACHER.TID = CXY.TEACH.TID " +
		"left join CXY.LESSON on CXY.TEACH.LID = CXY.LESSON.LID;")
	check(err)
	var tmp = Lesson{0,"",0,""}
	for rows.Next(){
		err=rows.Scan(&tmp.TID, &tmp.TNAME, &tmp.LID, &tmp.LNAME)
		check(err)
		fmt.Println(tmp)
	}

	//测试函数 GetTakeLessons
	//tmp2 := TakeLessons{}
	//GetTakeLessons(&tmp2, 1)
	//fmt.Println(tmp2)

	//测试函数 InsertTakeT
    //InsertTakeT(3,1)

    //测试函数
    //var p TakeLessonsT
	//ShowTea(1 ,&p)
	//fmt.Println(p)

	//测试函数
	//InsertTest(1,1,0.5,"DB1")

	//测试函数
	//var p TakeTs
	//GetTakeTs(1, &p)
	//fmt.Println(p)

	//测试函数
	//UpdatePSCORE(3, 1,1,90)

	//测试函数
	//UpdateScore(3, 1,1)

	//测试函数
	//InsertStu(4,"s4","1")

	//测试函数
	//DeleteStu(4)

	//测试函数
	//UpdateStu(1,"2")

	//测试函数
	//UpdateStu(1,"1")

	//测试函数
	//InsertTea(4,"s4","1")
	//DeleteTea(4)
	//UpdateTea(1,"2")
	//UpdateTea(1,"1")
}

func check(err error){     //因为要多次检查错误，所以干脆自己建立一个函数。
	if err!=nil{
		fmt.Println(err)
	}
}

func GetLessons(p *Lessons ) *Lessons{
	rows, err := Con.Query("SELECT TEACHER.TID, TEACHER.TNAME, LESSON.LID, LESSON.LNAME "+
		"from CXY.TEACHER left join CXY.TEACH on " +
		"CXY.TEACHER.TID = CXY.TEACH.TID " +
		"left join CXY.LESSON on CXY.TEACH.LID = CXY.LESSON.LID;")
	check(err)
	var tmp = Lesson{0,"",0,""}
	for rows.Next(){
		err=rows.Scan(&tmp.TID, &tmp.TNAME, &tmp.LID, &tmp.LNAME)
		check(err)
		p.HaveL = append(p.HaveL,tmp)
	}

	return p
}

func GetTakeLessons(p *TakeLessons, sid int ) *TakeLessons{
	rows, err := Con.Query("select STU.SID, TEACHER.TID, TEACHER.TNAME, LESSON.LID, LESSON.LNAME, TAKEL.SCORE"+
	" from CXY.TEACHER left join CXY.TAKEL on CXY.TEACHER.TID = CXY.TAKEL.TID"+
	" left join CXY.STU on CXY.STU.SID = CXY.TAKEL.SID"+
	" left join CXY.LESSON on CXY.LESSON.LID = CXY.TAKEL.LID"+
	" where STU.SID = ?;",sid)

	check(err)
	var tmp = TakeLesson{0,0,"",0,"",0}
	for rows.Next(){
		err=rows.Scan(&tmp.SID, &tmp.TID, &tmp.TNAME,&tmp.LID, &tmp.LNAME, &tmp.SCORE)
		check(err)
		p.TakeL = append(p.TakeL,tmp)
	}

	return p
}

func InsertTakeL(SID int, TID int, LID int) int {
    _, err := Con.Exec("insert into TAKEL (SID, TID, LID, SCORE) values (?,?,?,0);",SID, TID, LID)
    check(err)
    return 0
}


//选课的时候，选完就执行这个动作，来参加考试
func InsertTakeT(LID int, SID int){
	type TL struct{
		TEID int
		LID  int
	}
	//获得LID课程的所有考试
	rowsTL, err := Con.Query("select TEST.TEID, TEST.LID " +
		" from CXY.TEST where TEST.LID = ?;",LID)
	check(err)

	var tmp = TL{0,0}
	var tls []TL
	for rowsTL.Next(){
		err := rowsTL.Scan(&tmp.TEID, &tmp.LID)
		//fmt.Println(tmp)
		check(err)
		tls = append(tls, tmp)
	}
	//fmt.Println(tls)
	//将该学生加入该课堂对应的所有考试
	for _, tl := range(tls){
		Con.Exec("insert into CXY.TAKET(SID, LID, TEID, PSCORE) values "+
			" (?,?,?,0)",SID, tl.LID, tl.TEID);
	}

}

//--------------------below for teacher
//username is the id of tea
func ShowTea(tid int ,p *TakeLessonsT) *TakeLessonsT{
	rows, err := Con.Query("select TEACHER.TID, STU.SID, STU.SNAME, LESSON.LID, LESSON.LNAME, TAKEL.SCORE"+
		" from CXY.TEACHER left join CXY.TAKEL on CXY.TEACHER.TID = CXY.TAKEL.TID"+
		" left join CXY.STU on CXY.STU.SID = CXY.TAKEL.SID"+
		" left join CXY.LESSON on CXY.LESSON.LID = CXY.TAKEL.LID"+
		" where TEACHER.TID = ?;",tid)

	check(err)
	var tmp = TakeLessonT{}
	for rows.Next(){

		err=rows.Scan(&tmp.TID, &tmp.SID, &tmp.SNAME,&tmp.LID, &tmp.LNAME, &tmp.SCORE)
		check(err)
		//sql会把读到的nil转为0
        if tmp.SID == 0{
        	return p
		}

		p.TakeL = append(p.TakeL,tmp)
	}

	return p
}


func GetLessonsT(tid int,p *Lessons ) *Lessons{
	//选出为tid的老师的所有课程
	rows, err := Con.Query("SELECT TEACHER.TID, TEACHER.TNAME, LESSON.LID, LESSON.LNAME "+
		"from CXY.TEACHER left join CXY.TEACH on " +
		"CXY.TEACHER.TID = CXY.TEACH.TID " +
		"left join CXY.LESSON on CXY.TEACH.LID = CXY.LESSON.LID "+
		"where TEACHER.TID = ?", tid)
	check(err)
	var tmp = Lesson{0,"",0,""}
	for rows.Next(){
		err=rows.Scan(&tmp.TID, &tmp.TNAME, &tmp.LID, &tmp.LNAME)
		check(err)
		p.HaveL = append(p.HaveL,tmp)
	}

	return p
}

func GetTestsT(tid int,p *Tests ) *Tests{
	//选出为tid的老师的所有课程
	rows, err := Con.Query("select TEST.TEID, TEST.LID, TEST.TEW, TEST.TENAME " +
		" from CXY.TEST left join CXY.TEACH on CXY.TEST.LID = CXY.TEACH.LID "+
		" left join CXY.TEACHER on CXY.TEACH.TID = CXY.TEACHER.TID " +
		" where TEACHER.TID = ? ;", tid)
	check(err)
	var tmp = Test{0,0,0.0,""}
	for rows.Next(){
		err=rows.Scan(&tmp.TEID, &tmp.LID, &tmp.TEW,  &tmp.TENAME)
		check(err)
		p.HaveT = append(p.HaveT,tmp)
	}

	return p
}

func InsertTest(LID int, TEID int, TEW float32, TENAME string) int {
	_, err := Con.Exec("insert into TEST (TEID, LID, TEW, TENAME) " +
		"values (?,?,?,?);",TEID, LID, TEW, TENAME)
	check(err)
	return 0
}

////为录入成绩的老师提供参加了这个老师的和考试所有的学生名单
////在这个名单基础上进行筛选
//func Screen(TID int, LID int, TEID int,p *TakeLessonsT) *TakeLessonsT{
//	_, err := con.Exec("select STU.SID, STU.SNAME, TAKET.TEID, TAKET.LID, TAKET.PSCORE "+
//	"from CXY.TAKET ,CXY.STU , CXY.TAKEL "+
//	"where STU.SID = TAKET.SID and CXY.TAKEL.TID = ? AND CXY.STU.SID = TAKEL.SID; ")
//	check(err)
//
//	return p
//}

//rows, err := con.Query("select STU.SID, TAKET.LID, TAKET.TEID, TAKET.PSCORE from CXY.TAKEL, CXY.STU, CXY.TAKET "+
//" where STU.SID = TAKEL.SID and TAKEL.TID = 1 and TAKET.SID = STU.SID;", tid)
//找出所有参见tid老师的所有参考记录
func GetTakeTs(tid int,p *TakeTs ) *TakeTs{

	rows, err := Con.Query("select STU.SID, TAKET.LID, TAKET.TEID, TAKET.PSCORE from CXY.TAKEL, CXY.STU, CXY.TAKET "+
		" where STU.SID = TAKEL.SID and TAKEL.TID = ? and TAKET.SID = STU.SID group by STU.SID, TAKET.LID, TAKET.TEID;", tid)
	check(err)
	var tmp = TakeT{0,0,0,0.0}
	for rows.Next(){
		err=rows.Scan(&tmp.SID, &tmp.LID, &tmp.TEID,  &tmp.PSCORE)
		check(err)
		p.HaveTakeTs = append(p.HaveTakeTs,tmp)
	}
	return p
}

//_, err := con.Exec("update CXY.TAKET set TAKET.PSCORE = ? "+
//" where TAKET.LID = ? ADN TAKET.TEID = ? AND TAKE.SID = ?;", pscoresws, lidws , teidws , sidws)


//将登分记录更新到参考试表
func UpdatePSCORE(lidws int, teidws int, sidws int, pscoresws float32){
	_, err := Con.Exec("update CXY.TAKET set TAKET.PSCORE = ? "+
	" where TAKET.LID = ? AND TAKET.TEID = ? AND TAKET.SID = ?;", pscoresws, lidws , teidws , sidws)
	check(err)
}



//于此同时，每次真的录入成绩的时候，就update 相应的总分
func UpdateScore(lidws int, sidws int, tid int){
	//首先计算出其总分
    type PSCORE struct{
    	S     float32
    	W     float32
	}
    type Score struct{
    	SUM  []PSCORE
	}
    var res Score
	rows, err := Con.Query("select  TAKET.PSCORE, TEST.TEW from CXY.TAKET left join CXY.TEST on TEST.LID = TAKET.LID"+
	" where TAKET.SID = ? AND TAKET.LID = ? group by TAKET.PSCORE, TEST.TEW;",sidws, lidws )
	check(err)
	var tmp = PSCORE{0.0,0.0}
	for rows.Next(){
		err=rows.Scan(&tmp.S, &tmp.W)
		check(err)
		res.SUM = append(res.SUM,tmp)
	}

	fmt.Println("每个考试：",res.SUM)
	//计算总分
	var score float32
	score = 0
	for _,item := range res.SUM {
		score += item.S * item.W
	}

	fmt.Println("总分：",score)
	//将总分update到takeL表中
	_, _ = Con.Exec("update CXY.TAKEL set TAKEL.SCORE = ?"+
	" where TAKEL.SID = ? AND TAKEL.LID = ?	and TAKEL.TID = ?;",score, sidws, lidws, tid)
	check(err)
    fmt.Println("总分right！")
}






//--------------------below for dba--------
func InsertStu(sid int, sname string, spass string){
	_, err := Con.Exec("insert into CXY.STU (SID, SNAME, SPASS) " +
		"values (?, ?, ?);",sid,sname,spass )
	check(err)
}

func DeleteStu(sid int){
	_, err := Con.Exec("delete from CXY.STU where STU.SID = ?;", sid )
	check(err)
}

func UpdateStu(sid int, spass string){
	_, err := Con.Exec("update CXY.STU set STU.SPASS = ? where STU.SID = ?;",spass,sid)
	check(err)
}
//select * from CXY.STU;
//insert into CXY.STU (SID, SNAME, SPASS) values (4, "s4", "1");
//delete from CXY.STU where STU.SID = 4;
//update CXY.STU set STU.SPASS = 1 where STU.SID = 1;

func InsertTea(tid int, tname string, tpass string){
	_, err := Con.Exec("insert into CXY.TEACHER (TID, TNAME, TPASS) " +
		"values (?, ?, ?)",tid,tname,tpass )
	check(err)
}

func DeleteTea(tid int){
	_, err := Con.Exec("delete from CXY.TEACHER where TEACHER.TID = ?;",tid )
	check(err)
}

func UpdateTea(tid int, tpass string){
	_, err := Con.Exec("update CXY.TEACHER set TEACHER.TPASS = ? " +
		"where TEACHER.TID = ?;",tpass, tid)
	check(err)
}
//select * from CXY.TEACHER;
//insert into CXY.TEACHER (TID, TNAME, TPASS) values (4, "chen4", "1");
//delete from CXY.TEACHER where TEACHER.TID = 4;
//update CXY.TEACHER set TEACHER.TPASS = 1 where TEACHER.TID = 1;

func InsertLes(lid int, lname string){
	_, err := Con.Exec("insert into CXY.LESSON (LID, LNAME) values (?,?);",lid,lname)
	check(err)
}

func DeleteLes(lid int){
	_, err := Con.Exec("delete from CXY.LESSON where LESSON.LID = ?;",lid )
	check(err)
}

//select * from CXY.LESSON;
//insert into CXY.LESSON (LID, LNAME) values (4,"sb");
//delete from CXY.LESSON where LESSON.LID = 4;

