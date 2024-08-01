package main

import (
	"ccrayz/go_opentelemetry/internal/configs"
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/gin-gonic/gin"
	"go.opentelemetry.io/otel"
	"go.opentelemetry.io/otel/propagation"
	// "go.opentelemetry.io/contrib/instrumentation/github.com/gin-gonic/gin/otelgin"
)

type ResponseData struct {
	Message string `json:"message"`
}

var (
	server_name = os.Getenv("SERVER_NAME")
	server_port = os.Getenv("SERVER_PORT")
	server_type = os.Getenv("SERVER_TYPE")
	tracer      = otel.Tracer(server_name)
)

func main() {

	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt)
	defer stop()

	otelShutdown, err := configs.SetupOTelSDK(ctx, server_name)
	if err != nil {
		return
	}
	defer func() {
		err = errors.Join(err, otelShutdown(ctx))
	}()

	router := gin.New()
	router.Use(
		gin.Logger(),
		gin.Recovery(),
	)

	addServerHandler(server_type, router.Group("/api"))

	srv := &http.Server{
		Addr:    ":" + server_port,
		Handler: router.Handler(),
	}

	go func() {
		if err := srv.ListenAndServe(); err != nil && err != http.ErrServerClosed {
			log.Fatalf("listen: %s\n", err)
		}
	}()

	quit := make(chan os.Signal, 1)
	signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
	<-quit
	log.Println("Shutdown Server ...")

	ctx, cancel := context.WithTimeout(context.Background(), time.Duration(2)*time.Second)
	defer cancel()
	if err := srv.Shutdown(ctx); err != nil {
		log.Fatal("Server Shutdown:", err)
	}

	<-ctx.Done()
	log.Println("Server exiting")
}

func addServerHandler(server_type string, router *gin.RouterGroup) {
	switch server_type {
	case "A":
		addAHandler(router)
	case "B":
		addBHandler(router)
	}
}

func addAHandler(router *gin.RouterGroup) {
	router.GET("/A", func(c *gin.Context) {
		_, span := tracer.Start(c.Request.Context(), server_name+"-span")
		defer span.End()
		c.JSON(200, gin.H{
			"message": "This is server A",
		})
	})

	router.GET("/A/hello", func(c *gin.Context) {
		_, span := tracer.Start(c.Request.Context(), server_name+"-hello")
		defer span.End()
		c.JSON(200, gin.H{
			"message": "hello",
		})
	})

	router.GET("/A/target/B", func(c *gin.Context) {
		ctx, span := tracer.Start(c.Request.Context(), server_name+"-target-B")
		defer span.End()
		message := calledByB(ctx, "http://localhost:9090/api/B")
		doWorkTemplate(ctx, "doWork4", doWork4)
		doWorkTemplate(ctx, "doWork5", doWork5)

		c.JSON(200, gin.H{
			"message": message,
		})
	})
}

func addBHandler(router *gin.RouterGroup) {
	router.GET("/B", func(c *gin.Context) {
		ctx := otel.GetTextMapPropagator().Extract(c.Request.Context(), propagation.HeaderCarrier(c.Request.Header))
		ctx, span := tracer.Start(ctx, server_name+"-span")
		defer span.End()
		doWorkTemplate(ctx, "doWork1", doWork1)
		doWorkTemplate(ctx, "doWork2", doWork2)
		doWorkTemplate(ctx, "doWork3", doWork3)

		c.JSON(http.StatusOK, gin.H{
			"message": "This is server B",
		})
	})
}

func calledByB(ctx context.Context, endpoint string) string {
	_, span := tracer.Start(ctx, server_name+"-calledByB")
	defer span.End()
	req, _ := http.NewRequestWithContext(ctx, "GET", endpoint, nil)
	req.Header.Set("Content-Type", "application/json")
	otel.GetTextMapPropagator().Inject(ctx, propagation.HeaderCarrier(req.Header))

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		log.Println("Error making request:", err)
		return err.Error()
	}
	defer resp.Body.Close()

	var body []byte
	body, err = io.ReadAll(resp.Body)
	if err != nil {
		fmt.Println("Error reading body:", err)
		return err.Error()
	}
	var responseData ResponseData
	err = json.Unmarshal(body, &responseData)
	if err != nil {
		fmt.Println("Error unmarshaling body:", err)
		return err.Error()
	}
	return responseData.Message
}

func doWorkTemplate(ctx context.Context, workName string, workFunc WorkFunc) {
	_, span := tracer.Start(ctx, server_name+"-"+workName)
	defer span.End()
	log.Printf("%s %s", workName, span.SpanContext().TraceID())
	workFunc(ctx)
}

type WorkFunc func(ctx context.Context)

func doWork1(ctx context.Context) {
	time.Sleep(1000 * time.Millisecond)
}

func doWork2(ctx context.Context) {
	time.Sleep(2000 * time.Millisecond)
}

func doWork3(ctx context.Context) {
	time.Sleep(3000 * time.Millisecond)
}

func doWork4(ctx context.Context) {
	time.Sleep(4000 * time.Millisecond)
}

func doWork5(ctx context.Context) {
	time.Sleep(5000 * time.Millisecond)
}
