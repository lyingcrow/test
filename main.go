package main

import (
	"log"

	"github.com/gin-gonic/gin"
)

func main() {
	r := gin.Default()
	r.GET("/test", v1)
	err := r.Run(":12001")
	if err != nil {
		log.Fatal("启动失败")
	}
}

func v1(c *gin.Context) {
	c.String(200, "%v", "hello jenkins")
}
