A_SERVER_PORT ?= 8080
A_SERVER_NAME ?= server-a
A_SERVER_TYPE ?= A

B_SERVER_PORT ?= 9090
B_SERVER_NAME ?= server-b
B_SERVER_TYPE ?= B

# build:
# 	go build -o server main.go

run-a:
	SERVER_NAME=$(A_SERVER_NAME) SERVER_PORT=$(A_SERVER_PORT) SERVER_TYPE=$(A_SERVER_TYPE) go run ./cmd/main.go

run-b:
	SERVER_NAME=$(B_SERVER_NAME) SERVER_PORT=$(B_SERVER_PORT) SERVER_TYPE=$(B_SERVER_TYPE) go run ./cmd/main.go