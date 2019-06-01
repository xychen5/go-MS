package controllers

import (
	"fmt"
	"github.com/astaxie/beego"
)

type TeacherController struct{
	beego.Controller
}

//implement the get way
func (c *TeacherController) Enter() {

	//// Safe check.
	//uname := c.GetString("uname")
	//if uname == "false" {
	//	//back to welcom view
	//	c.Redirect("/", 302)
	//	return
	//}
	//
	//fmt.Println("teacher's Enter for get is called");
    ////change to teacher view
	c.Data["Website"] = "beego.me"
	c.Data["Email"] = "astaxie@gmail.com"
	c.TplName = "teacher.tpl"

	return
}

func (c *TeacherController) Post() {

	// Safe check.
	uname := c.GetString("uname")
	if uname == "false" {
		//back to welcom view
		c.Redirect("/", 302)
		return
	}

	fmt.Println("teacher's Post is called");

	//change to teacher view
	c.TplName = "teacher.tpl"

	return
}