package routers

import (
	"github.com/astaxie/beego"
	"my1/controllers"
)

func init() {
	//indicate that when at "/", find controllers.MainController{}
    beego.Router("/", &controllers.MainController{})
    beego.Router("/MyPost", &controllers.MainController{},"post:MyPost")

    beego.Router("/teacher", &controllers.TeacherController{}, "get:Get")
    beego.Router("/teacher/TeaEnter", &controllers.TeacherController{}, "get:TeaEnter")

    //handle get
	beego.Router("/stu", &controllers.StuController{},"get:Get")
	//hadle websocket request
    beego.Router("/stu/StuEnter", &controllers.StuController{},"get:StuEnter")

    //dba
    beego.Router("/dba", &controllers.DbaController{},"get:Get")
    //handle websocket
    beego.Router("/dba/DbaEnter", &controllers.DbaController{},"get:DbaEnter")

}




