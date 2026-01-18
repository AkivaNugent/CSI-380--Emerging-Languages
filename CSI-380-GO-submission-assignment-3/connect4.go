// connect4.go for CSI 380 Assignment 3
// The struct C4Board should implement the Board
// interface specified in Board.go
// Note: you will almost certainly need to add additional
// utility functions/methods to this file.

//the file was edited by Akiva Nugent
//I referenced https://www.youtube.com/watch?v=MMLtza3CZFM a couple times,
//but no code was specifically taken
//I did ask Gemini about the Evaluating Scores because I was lost as to why it
//wasn't working and it came up with the idea of doing pow10 instead
// of *100 like I was going to do :)

package main

import "math"

// size of the board
const numCols uint = 7
const numRows uint = 6

// size of a winning segment in Connect 4
const segmentLength uint = 4

// represents a place on the board
type location struct {
	col uint
	row uint
}

// Represents a segment of 4 locations on the board.
type segment [segmentLength]location

// Returns a slice containing all of the possible segments
// on the board.
func generateSegments() []segment {
	var segments []segment
	// generate vertical segments
	for c := uint(0); c < numCols; c++ {
		for r := uint(0); r < numRows-segmentLength+1; r++ {
			s := segment{{c, r}, {c, r + 1}, {c, r + 2}, {c, r + 3}}
			segments = append(segments, s)
		}
	}
	// generate horizontal segments
	for c := uint(0); c < numCols-segmentLength+1; c++ {
		for r := uint(0); r < numRows; r++ {
			s := segment{{c, r}, {c + 1, r}, {c + 2, r}, {c + 3, r}}
			segments = append(segments, s)
		}
	}
	// generate the bottom left to top right diagonal segments
	for c := uint(0); c < numCols-segmentLength+1; c++ {
		for r := uint(0); r < numRows-segmentLength+1; r++ {
			s := segment{{c, r}, {c + 1, r + 1}, {c + 2, r + 2}, {c + 3, r + 3}}
			segments = append(segments, s)
		}
	}
	// generate the top left to bottom right diagonal segments
	for c := uint(0); c < numCols-segmentLength+1; c++ {
		for r := segmentLength - 1; r < numRows; r++ {
			s := segment{{c, r}, {c + 1, r - 1}, {c + 2, r - 2}, {c + 3, r - 3}}
			segments = append(segments, s)
		}
	}
	return segments
}

var allSegments []segment = generateSegments()

// The main struct that should implement the Board interface
// It maintains the position of a game
// You should not need to add any additional properties to this struct, but
// you may add additional methods
type C4Board struct {
	position [numCols][numRows]Piece // the grid in Connect 4
	colCount [numCols]uint           // how many pieces are in a given column (or how many are "non-empty")
	turn     Piece                   // who's turn it is to play
}

// Who's turn is it?
func (board C4Board) Turn() Piece {
	return board.turn
}

// Put a piece in column col.
// Returns a copy of the board with the move made.
// Does not check if the column is full (assumes legal move).
func (board C4Board) MakeMove(col Move) Board {
	//Make a temp board
	//check the height of the column
	//put turns piece im
	//make column 1 higher
	//flip turn

	newBoard := board
	row := board.colCount[col]
	newBoard.position[col][row] = board.turn
	newBoard.colCount[col]++
	newBoard.turn = board.turn.Opponent()
	return newBoard
}

// All of the current legal moves.
// Remember, a move is just the column you can play.
func (board C4Board) LegalMoves() []Move {
	//Make a list of possible moves
	//put a piece in every column that isnt full

	var moves []Move
	for col := uint(0); col < numCols; col++ {
		if board.colCount[col] < numRows {
			moves = append(moves, Move(col))
		}
	}
	return moves
}

// Is it a win?
func (board C4Board) IsWin() bool {
	//checks each winning segment
	//if there isnt a piece: Skip
	//If there isnt a matching piece in the remaining segments: Skip
	//if there is a piece in all 4 spots: True
	//if we get to the end without any wins: False

	for _, segment := range allSegments {
		playersPiece := board.position[segment[0].col][segment[0].row]
		if playersPiece == 0 {
			continue
		}
		win := true
		for i := 0; i < int(segmentLength); i++ {
			if board.position[segment[i].col][segment[i].row] != playersPiece {
				win = false
				break
			}
		}
		if win {
			return true
		}
	}
	return false
}

// Is it a draw?
func (board C4Board) IsDraw() bool {
	//Check if someone one
	//If someone one: False
	//If the board has space: False
	//Else: True

	if board.IsWin() {
		return false
	}
	for col := uint(0); col < numCols; col++ {
		if board.colCount[col] < numRows {
			return false
		}
	}
	return true
}

// Who is winning in this position?
// This function scores the position for player
// and returns a numerical score
// When player is doing well, the score should be higher
// When player is doing worse, player's returned score should be lower
// Scores mean nothing except in relation to one another; so you can
// use any scale that makes sense to you
// The more accurately Evaluate() scores a position, the better that minimax will work
// There may be more than one way to evaluate a position but an obvious route
// is to count how many 1 filled, 2 filled, and 3 filled segments of the board
// that the player has (that don't include any of the opponents pieces) and give
// a higher score for 3 filleds than 2 filleds, 1 filleds, etc.
// You may also need to score wins (4 filleds) as very high scores and losses (4 filleds
// for the opponent) as very low scores
// You may want to make helper functions/methods like evaluateSegment() and countSegment(),
// but it's up to you
func (board C4Board) Evaluate(player Piece) float32 {
	//go over every segment
	//count how many piece for each person are in the each segment
	//gives points if the segment is winnable still
	//takes points away if its unwinnable

	score := float32(0)
	for _, segment := range allSegments {
		playerPieces := 0
		opponentPieces := 0
		for _, pos := range segment {
			if board.position[pos.col][pos.row] == player {
				playerPieces++
			} else if board.position[pos.col][pos.row] == player.Opponent() {
				opponentPieces++
			}
		}
		if opponentPieces == 0 {
			score += float32(math.Pow(10, float64(playerPieces)))
		} else if playerPieces == 0 {
			score -= float32(math.Pow(10, float64(opponentPieces)))
		}
	}
	return score
}

// Nice to print board representation
// This will be used in play.go to print out the state of the position
// to the user
func (board C4Board) String() string {
	boardStr := ""

	for r := int(numRows - 1); r >= 0; r-- {
		for c := 0; c < int(numCols); c++ {
			boardStr += board.position[c][r].String() + " "
		}
		boardStr += "\n"
	}

	return boardStr
}

func (piece Piece) Opponent() Piece {
	//swap the player
	if piece == 1 {
		return 2
	}
	return 1
}
