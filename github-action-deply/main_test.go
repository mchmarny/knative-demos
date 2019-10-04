package main

import (
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
)

func TestStatusHandler(t *testing.T) {
	r := gin.Default()
	r.GET("/v1/greeting/:msg", statusHandler)

	w := httptest.NewRecorder()
	req, _ := http.NewRequest(http.MethodGet, "/v1/greeting/test", nil)
	r.ServeHTTP(w, req)
	assert.Equal(t, 200, w.Code)

	decoder := json.NewDecoder(w.Body)
	var s Status
	err := decoder.Decode(&s)
	assert.Nil(t, err)
	assert.Equal(t, "test", s.Message)
}
