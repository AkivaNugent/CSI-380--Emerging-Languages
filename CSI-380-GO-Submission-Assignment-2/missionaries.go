// Missionaries and Cannibals for CSI 380
// This program solves the classic Missionaries and Cannibals problem
//This file was edited by Akiva Nugent

package main

import "fmt"

// A representation of the state of the game
type position struct {
	boatOnWestBank   bool // true is west bank, false is east bank
	westMissionaries int  // west bank missionaries
	westCannibals    int  // west bank cannibals
	eastMissionaries int  // east bank missionaries
	eastCannibals    int  // east bank cannibals
}

// Is this a legal position? In particular, does it have
// more cannibals than missionaries on either bank? Because that is illegal.
func valid(pos position) bool {

	//No more than 3, no less than 0
	if pos.westMissionaries < 0 || pos.westMissionaries > 3 {
		return false
	}
	if pos.eastMissionaries < 0 || pos.eastMissionaries > 3 {
		return false
	}
	if pos.westCannibals < 0 || pos.westCannibals > 3 {
		return false
	}
	if pos.eastCannibals < 0 || pos.eastCannibals > 3 {
		return false
	}

	//Checking total cannibals and missionaries
	if (pos.westMissionaries + pos.eastMissionaries) != 3 {
		return false
	}
	if (pos.westCannibals + pos.eastCannibals) != 3 {
		return false
	}

	//Missionaries must be mt/eq Canibals (assuming theyre there at all)
	if pos.westMissionaries > 0 && pos.westMissionaries < pos.westCannibals {
		return false
	}
	if pos.eastMissionaries > 0 && pos.eastMissionaries < pos.eastCannibals {
		return false
	}

	return true
}

// Added this function because its what you showed in class, plus its nicer to read
func filterPositions(positions []position) []position {
	validPos := []position{}
	for _, pos := range positions {
		if valid(pos) {
			validPos = append(validPos, pos)
		}
	}
	return validPos
}

// What are all of the next positions we can go to legally from the current position
// Returns nil if there are no valid positions
func (pos position) successors() []position {
	testPos := []position{}

	if pos.boatOnWestBank {
		testPos = append(testPos, position{boatOnWestBank: false, westMissionaries: pos.westMissionaries - 2, westCannibals: pos.westCannibals, eastMissionaries: pos.eastMissionaries + 2, eastCannibals: pos.eastCannibals})
		testPos = append(testPos, position{boatOnWestBank: false, westMissionaries: pos.westMissionaries - 1, westCannibals: pos.westCannibals, eastMissionaries: pos.eastMissionaries + 1, eastCannibals: pos.eastCannibals})
		testPos = append(testPos, position{boatOnWestBank: false, westMissionaries: pos.westMissionaries, westCannibals: pos.westCannibals - 2, eastMissionaries: pos.eastMissionaries, eastCannibals: pos.eastCannibals + 2})
		testPos = append(testPos, position{boatOnWestBank: false, westMissionaries: pos.westMissionaries, westCannibals: pos.westCannibals - 1, eastMissionaries: pos.eastMissionaries, eastCannibals: pos.eastCannibals + 1})
		testPos = append(testPos, position{boatOnWestBank: false, westMissionaries: pos.westMissionaries - 1, westCannibals: pos.westCannibals - 1, eastMissionaries: pos.eastMissionaries + 1, eastCannibals: pos.eastCannibals + 1})
	}
	if !pos.boatOnWestBank {
		testPos = append(testPos, position{boatOnWestBank: true, westMissionaries: pos.westMissionaries + 2, westCannibals: pos.westCannibals, eastMissionaries: pos.eastMissionaries - 2, eastCannibals: pos.eastCannibals})
		testPos = append(testPos, position{boatOnWestBank: true, westMissionaries: pos.westMissionaries + 1, westCannibals: pos.westCannibals, eastMissionaries: pos.eastMissionaries - 1, eastCannibals: pos.eastCannibals})
		testPos = append(testPos, position{boatOnWestBank: true, westMissionaries: pos.westMissionaries, westCannibals: pos.westCannibals + 2, eastMissionaries: pos.eastMissionaries, eastCannibals: pos.eastCannibals - 2})
		testPos = append(testPos, position{boatOnWestBank: true, westMissionaries: pos.westMissionaries, westCannibals: pos.westCannibals + 1, eastMissionaries: pos.eastMissionaries, eastCannibals: pos.eastCannibals - 1})
		testPos = append(testPos, position{boatOnWestBank: true, westMissionaries: pos.westMissionaries + 1, westCannibals: pos.westCannibals + 1, eastMissionaries: pos.eastMissionaries - 1, eastCannibals: pos.eastCannibals - 1})
	}

	return filterPositions(testPos)
}

// A itterative depth-first search that goes through to find the goal and returns the path to get there
// Returns nil if no solution found
func dfs(start position, goal position, solution []position, visited map[position]bool) []position {
	frontier := []position{start}
	parent := make(map[position]position)
	visited[start] = true

	for len(frontier) > 0 {
		current := frontier[len(frontier)-1]
		frontier = frontier[:len(frontier)-1]

		//exit condition / reconstruct path
		if current == goal {
			path := []position{}
			for current != start {
				path = append([]position{current}, path...)
				current = parent[current]
			}
			return append([]position{start}, path...)
		}

		successors := current.successors()
		for _, next := range successors {
			if !visited[next] {
				visited[next] = true
				parent[next] = current
				frontier = append(frontier, next)
			}
		}
	}

	return nil
}

func main() {
	start := position{boatOnWestBank: true, westMissionaries: 3, westCannibals: 3, eastMissionaries: 0, eastCannibals: 0}
	goal := position{boatOnWestBank: false, westMissionaries: 0, westCannibals: 0, eastMissionaries: 3, eastCannibals: 3}
	solution := dfs(start, goal, []position{start}, make(map[position]bool))
	fmt.Println(solution)
}
