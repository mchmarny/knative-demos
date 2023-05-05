module github.com/mchmarny/knative-demos/github-action-deply

go 1.13

require (
	github.com/gin-gonic/gin v1.9.0
	github.com/google/uuid v1.1.1
	github.com/modern-go/concurrent v0.0.0-20180306012644-bacd9c7ef1dd // indirect
	github.com/stretchr/testify v1.8.1
)

replace github.com/ugorji/go v1.1.4 => github.com/ugorji/go/codec v0.0.0-20190204201341-e444a5086c43
