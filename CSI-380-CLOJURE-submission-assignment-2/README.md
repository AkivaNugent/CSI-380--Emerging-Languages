# Six Degrees of Kevin Bacon

Your job is to implement the game, [Six Degrees of Kevin Bacon](https://en.wikipedia.org/wiki/Six_Degrees_of_Kevin_Bacon).

The repository has a subset of IMDB's movie database (ironically missing Kevin Bacon) in two files in the `resources` folder. `data.clj` already has functions for importing them into Clojure hashmaps. Note that since the database is incomplete, the results of your program will not always match [other versions of the game that you can find online](https://www.oracleofbacon.org).

You need to implement a single function `find-path` in `core.clj`, which finds the shortest path (in terms of number of hops) between any two actors. This includes movies and co-stars. For example, one of the shortest paths between Tom Cruise and Michael Keaton is via Jon Hamm. Tom Cruise was in *Top Gun: Maverick* with Jon Hamm. Jon Hamm was in *Minions* with Michael Keaton. So, the path is:

Tom Cruise -> Top Gun: Maverick -> Jon Hamm -> Minions -> Michael Keaton

Since this was a shortest path found in the database between Tom Cruise and Michael Keaton it implies that Tom Cruise and Michael Keaton never starred in a film together (at least not one in the database).

The easiest way to find the shortest path is to perform a breadth-first search, alternating between searching across actors and movies. The database `people-movies` has actors as keys and lists of the movies they were in as values. The database `movies-people` has movies as keys and lists of the actors in them as values.

You can write as many helper functions as you would like. `-main`, which loads the database, and the helper `print-path` are already implemented, as well as the aforementioned loading of the database files.

Your assignment will be graded based on its ability to pass the tests for `find-path` that are in the testing file.

## Running

From within the directory:

```bash
lein run "Tom Cruise" "Michael Keaton"
Tom Cruise -> Top Gun: Maverick -> Jon Hamm -> Minions -> Michael Keaton
```

## Testing

```bash
lein test
```

## Instructions

1. Use the contents of the repository https://github.com/CSI380/six-degrees as a template, copying it into a private repository of your own that you create using "Use this template."

2. Add your instructor (@davecom) as a collaborator on the repository on GitHub.

3. Fill in the functions with the missing code and add any additional utility functions that you see fit. Do not change any of the existing function signatures, nor any of the unit tests.

4. Test your program on its own and also test the included unit tests.

5. Submit the URL of your repository on Canvas as your submission for this assignment.

## Database License

Information courtesy of
[IMDb](https://www.imdb.com).
Used with permission. [Here is their license.](https://www.imdb.com/conditions?ref_=helpms_ih_gi_usedata)

## Note on Repository Access

This repository should stay private. If you make it public, you are possibly providing your solution to other students taking the class. Generally the projects in this class are not great portfolio projects because they are too small, or for the later projects, contain a significant portion of code that is not your own and therefore does not demonstrate your skill. Please keep your repository private so other students can't use your solution.
