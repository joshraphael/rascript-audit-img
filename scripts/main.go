package main

import (
	"encoding/json"
	"fmt"
	"os"
	"strconv"

	"github.com/joshraphael/go-retroachievements"
	"github.com/joshraphael/go-retroachievements/models"
)

func main() {
	envGameId := os.Getenv("GAME_ID")
	gameId, err := strconv.Atoi(envGameId)
	if err != nil {
		fmt.Println("invalid game id")
		os.Exit(1)
		return
	}
	client := retroachievements.NewClient("")
	notes, err := client.GetCodeNotes(models.GetCodeNotesParameters{
		GameID: gameId,
	})
	if err != nil {
		fmt.Println("error getting code notes")
		os.Exit(1)
		return
	}

	jsonNotes, err := json.Marshal(notes.CodeNotes)
	if err != nil {
		fmt.Println("error converting code notes to json")
		os.Exit(1)
		return
	}

	fmt.Println(string(jsonNotes))
}
