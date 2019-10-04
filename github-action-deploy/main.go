package main

import (
	"log"
	"net"
	"net/http"
	"os"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

const (
	defaultPort         = "8080"
	portVariableName    = "PORT"
	releaseVariableName = "RELEASE"
)

var (
	logger = log.New(os.Stdout, "", 0)
)

func main() {

	gin.SetMode(gin.ReleaseMode)
	r := gin.Default()
	r.NoRoute(defaultHandler)
	r.GET("/", defaultHandler)

	v1 := r.Group("/v1")
	{
		v1.GET("/greeting/", statusHandler)
		v1.GET("/greeting/:msg", statusHandler)
	}

	// port
	port := os.Getenv(portVariableName)
	if port == "" {
		port = defaultPort
	}

	hostPort := net.JoinHostPort("0.0.0.0", port)
	logger.Printf("Starting server: %v", hostPort)
	if err := r.Run(hostPort); err != nil {
		logger.Fatal(err)
	}

}

func defaultHandler(c *gin.Context) {
	c.String(http.StatusOK, "OK")
}

func statusHandler(c *gin.Context) {
	id, err := uuid.NewUUID()
	if err != nil {
		logger.Printf("Error while getting id: %v", err)
		c.JSON(http.StatusInternalServerError,
			"Internal Server Error: see logs for details")
		return
	}

	releaseVersion := os.Getenv(releaseVariableName)
	if releaseVersion == "" {
		releaseVersion = "v0.0.0"
	}

	c.JSON(http.StatusOK, &Status{
		ID:        id.String(),
		Message:   c.Param("msg"),
		RequestOn: time.Now(),
		Release:   releaseVersion,
	})
}

// Status represents simple status
type Status struct {
	ID        string    `json:"id"`
	Message   string    `json:"msg,omitempty"`
	RequestOn time.Time `json:"on"`
	Release   string    `json:"rel"`
}
