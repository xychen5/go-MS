package controllers

import (
	"fmt"
	"github.com/astaxie/beego"
)

type MainController struct {
	beego.Controller
}

func (c *MainController) Get() {
	c.TplName = "index.tpl"
	return
}

func (c *MainController) MyPost() {
	fmt.Println("of course, main Post is called")

	idType := c.GetString("idChooser")
    
	// Check valid, 这是不必要的，在js中有检测名称的合法性；
	//if len(idType) == 0 {
	//	c.Redirect("/", 302)
	//	return
	//}
	username := c.GetString("username")
	fmt.Println("mypost show :" + username + "idtype is"+idType)
	if idType == "i am teacher" {
		c.Redirect("/teacher?username="+username, 302)
	}else if idType == "i am student"{
		c.Redirect("/stu?username="+ username,302)
	}else {
		c.Redirect("/dba?username="+ username,302)
	}
	return
}

