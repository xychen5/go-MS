package routers

import (
	"github.com/astaxie/beego"
	"my1/controllers"
)

func init() {
    beego.Router("/", &controllers.MainController{})
}
