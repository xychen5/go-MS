package main

import (
	"github.com/astaxie/beego"
	_ "my1/models"
	_ "my1/routers"

)

func main() {
	beego.Run()
	//fmt.Println("hello")
}

func test(num1 int, num2 int) int {

	return 0
}


