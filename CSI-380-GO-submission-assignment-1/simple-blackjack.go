// Simple Blackjack for CSI 380
// This program play's a simple, single suit game of Blackjack
// against a computer dealer.
//Editied by Akiva Nugent

//SOURCING
//used a Stackoverflow to explain the rand.Seed deprecation: https://stackoverflow.com/questions/75597325/rand-seedseed-is-deprecated-how-to-use-newrandnewseed

package main

import (
	"fmt"
	"math/rand"
	"strconv"
	"strings"
	"time"
)

// Move a card from deck to hand
func drawCard(hand *[]string, deck *[]string) {
	if len(*deck) == 0 { //This should never happen, but good practice to add.
		fmt.Println("The deck is already empty. Not sure how that happened.")
		return
	}

	*hand = append(*hand, (*deck)[len(*deck)-1])
	*deck = (*deck)[:len(*deck)-1]
}

// Calculate the score of the hand
func calculateScore(hand []string) int {
	score := 0
	hasAce := false

	for _, card := range hand {
		cardValue, err := strconv.Atoi(card)

		if err == nil {
			score += cardValue
		} else {
			if card == "A" {
				hasAce = true
			} else {
				score += 10
			}
		}
	}

	if hasAce {
		if score+11 > 21 {
			score += 1
		} else {
			score += 11
		}
	}

	return score
}

// Print everyone's scores and hands
func printStatus(playerCards, dealerCards []string) {
	fmt.Println("Players's Total is ", calculateScore(playerCards), ":")
	fmt.Println(strings.Join(playerCards, ", "))

	fmt.Println("Dealer's Total is ", calculateScore(dealerCards), ":")
	fmt.Println(strings.Join(dealerCards, ", "))
	fmt.Println()
}

// Entry point and main game loop
func main() {
	deck := []string{"2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"}
	playerCards := []string{}
	dealerCards := []string{}

	rng := rand.New(rand.NewSource(time.Now().UnixNano())) //used a Stackoverflow to explain the rand.Seed deprecation (link above)
	rng.Shuffle(len(deck), func(i int, j int) { deck[i], deck[j] = deck[j], deck[i] })

	fmt.Println("Dealer draws first:")
	drawCard(&dealerCards, &deck)

	fmt.Println("Player gets 2 cards:")
	drawCard(&playerCards, &deck)
	drawCard(&playerCards, &deck)

	fmt.Println()

	printStatus(playerCards, dealerCards)

	for {
		fmt.Println("Do you want to (H)it, (S)tay, or (Q)uit?")
		selection := ""
		fmt.Scanln(&selection)
		selection = strings.ToUpper(selection)

		if selection == "H" {
			drawCard(&playerCards, &deck)

			printStatus(playerCards, dealerCards)

			if calculateScore(playerCards) > 21 {
				fmt.Println("You busted! You Lose! :(")
				return
			}

		} else if selection == "S" {
			break
		} else if selection == "Q" {
			return
		}
	}

	fmt.Println("The Dealer will now draw the rest of its cards:")

	for calculateScore(dealerCards) < 17 {
		drawCard(&dealerCards, &deck)
	}
	printStatus(playerCards, dealerCards)

	if calculateScore(dealerCards) > 21 {
		fmt.Println("Dealer Busts! You Win!")
	} else if calculateScore(playerCards) < calculateScore(dealerCards) {
		fmt.Println("Dealer Wins :(  ")
	} else if calculateScore(playerCards) > calculateScore(dealerCards) {
		fmt.Println("Player Wins! :) ")
	} else if calculateScore(playerCards) == calculateScore(dealerCards) {
		fmt.Println("Its a Tie! :/  ")
	}
}
