// minimax.go for CSI 380 Assignment 3
// This file contains a working implementation of Minimax
// You will need to implement the FindBestMove() methods to
// actually evaluate a position by running MiniMax on each of the legal
// moves in a starting position and finding the move associated with the best outcome

//the file was edited by Akiva Nugent
//I referenced https://www.youtube.com/watch?v=MMLtza3CZFM a couple times,
//but no code was specifically taken

package main

import "math"

// Find the best possible outcome evaluation for originalPlayer
// depth is initially the maximum depth
func MiniMax(board Board, maximizing bool, originalPlayer Piece, depth uint) float32 {
	// Base case — terminal position or maximum depth reached
	if board.IsWin() || board.IsDraw() || depth == 0 {
		return board.Evaluate(originalPlayer)
	}

	// Recursive case - maximize your gains or minimize the opponent's gains
	if maximizing {
		var bestEval float32 = -math.MaxFloat32 // arbitrarily low starting point
		for _, move := range board.LegalMoves() {
			result := MiniMax(board.MakeMove(move), false, originalPlayer, depth-1)
			if result > bestEval {
				bestEval = result
			}
		}
		return bestEval
	} else { // minimizing
		var worstEval float32 = math.MaxFloat32
		for _, move := range board.LegalMoves() {
			result := MiniMax(board.MakeMove(move), true, originalPlayer, depth-1)
			if result < worstEval {
				worstEval = result
			}
		}
		return worstEval
	}
}

// Find the best possible move in the current position
// looking up to depth ahead
// This version looks at each legal move from the starting position
// concurrently (runs minimax on each legal move concurrently)
func ConcurrentFindBestMove(board Board, depth uint) Move {
	//same as the non-concurrent version but with a channel for the results
	//go over results and pick the best evaluated

	moves := board.LegalMoves()
	bestMove := Move(0)
	bestEval := float32(-math.MaxFloat32)
	results := make(chan struct {
		move Move
		eval float32
	}, len(moves))

	for _, move := range moves {
		go func(m Move) {
			results <- struct {
				move Move
				eval float32
			}{m, MiniMax(board.MakeMove(m), false, board.Turn(), depth-1)}
		}(move)
	}

	for range moves {
		result := <-results
		if result.eval > bestEval {
			bestEval = result.eval
			bestMove = result.move
		}
	}

	return bestMove
}

// Find the best possible move in the current position
// looking up to depth ahead
// This is a non-concurrent version that you may want to test first
func FindBestMove(board Board, depth uint) Move {
	//Get all moves with legalmoves()
	//minnax each one
	//pick the best evaluted

	moves := board.LegalMoves()
	bestMove := Move(0)
	bestEval := float32(-math.MaxFloat32)

	for _, move := range moves {
		result := MiniMax(board.MakeMove(move), false, board.Turn(), depth-1)
		if result > bestEval {
			bestEval = result
			bestMove = move
		}
	}
	return bestMove
}
