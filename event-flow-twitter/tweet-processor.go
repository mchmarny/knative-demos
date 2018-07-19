/*
Copyright 2018 The Knative Authors

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    https://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package main

import (
	"encoding/base64"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
)

func tweetHandler(rw http.ResponseWriter, req *http.Request) {

	body, err := ioutil.ReadAll(req.Body)
	if err != nil {
		panic(err)
	}
	//log.Println(string(body))

	// decode the pubsub message
	//	var event map[string]string
	var event Event
	if err := json.Unmarshal(body, &event); err != nil {
		log.Printf("Failed to unmarshal event: %s", err)
		return
	}

	// decode pubsub payload
	rawEvent, _ := base64.StdEncoding.DecodeString(event.Data)

	// decode iot data
	data, _ := base64.StdEncoding.DecodeString(string(rawEvent))

	// decode the pubsub message payload
	var payload MonitoredItem
	if err := json.Unmarshal(data, &payload); err != nil {
		log.Printf("Failed to unmarshal payload: %s", err)
		return
	}

	log.Printf("\nContent:%s Score:%s\n",
		payload.Content.String(), payload.Sentiment.String())
}

func main() {
	http.HandleFunc("/", tweetHandler)
	log.Fatal(http.ListenAndServe(":8080", nil))
}

// Event represents PubSub payload
type Event struct {
	ID         string            `json:"ID"`
	Data       string            `json:"Data"`
	Attributes map[string]string `json:"Attributes"`
}

// MonitoredItem is the outer envelope of the monitored item
type MonitoredItem struct {
	ID        string         `json:"id"`
	Query     string         `json:"query"`
	Content   TweetContent   `json:"content"`
	Sentiment SentimentScore `json:"sentiment"`
}

// TweetContent represents simple tweet content
type TweetContent struct {
	ID   string `json:"id"`
	On   string `json:"on"`
	By   string `json:"by"`
	Text string `json:"Text"`
}

// toString returns readable string representation of the MiniTweet struct
func (m *TweetContent) String() string {
	return fmt.Sprintf("ID:%v, On:%v, By:%v, Text:%v", m.ID, m.On, m.By, m.Text)
}

// SentimentScore represents processed Message and it's content
type SentimentScore struct {
	Score     float32 `json:"score"`
	Magnitude float32 `json:"Magnitude"`
}

// toString returns readable string representation of the SentimentScore struct
func (s *SentimentScore) String() string {
	return fmt.Sprintf("Score:%v, Magnitude:%v", s.Score, s.Magnitude)
}
