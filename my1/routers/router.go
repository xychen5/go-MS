package routers

import (
	"github.com/astaxie/beego"
	"my1/controllers"
)

func init() {
	//indicate that when at "/", find controllers.MainController{}
    beego.Router("/", &controllers.MainController{})
    beego.Router("/MyPost", &controllers.MainController{},"post:MyPost")

    beego.Router("/teacher", &controllers.TeacherController{}, "get:Enter")
    beego.Router("/teacher", &controllers.TeacherController{}, "post:Post")

    //handle get
	beego.Router("/stu", &controllers.StuController{},"get:Get")
	//hadle websocket request
    beego.Router("/stu/StuEnter", &controllers.StuController{},"get:StuEnter")
	beego.Router("/stu", &controllers.StuController{}, "post:StuPost")


}




