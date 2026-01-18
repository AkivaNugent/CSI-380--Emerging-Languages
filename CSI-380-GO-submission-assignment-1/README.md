# simple-blackjack
Starter code and unit tests for Assignment 1

## Running the Tests

Note that to run the tests, you will need to move the `.cpp` file out of the directory, otherwise the `go test` command will complain. After you have removed that file, with your working directory set to the one containing your Go sources, you can simply run on Windows:
```
go test
```
On macOS, you can run:
```
go test *.go
```
And four unit tests against your `calculateScore()` function will be run. 

## Running the Game

You can run with:
```
go run simple-blackjack.go
```

## Note on Repository Access

This repository should stay private. If you make it public, you are possibly providing your solution to other students taking the class. Generally the projects in this class are not great portfolio projects because they are too small, or for the later projects, contain a significant portion of code that is not your own and therefore does not demonstrate your skill. Please keep your repository private so other students can't use your solution.
