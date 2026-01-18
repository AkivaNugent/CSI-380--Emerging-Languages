# Clojure Sub-anagram Finder
Tool for finding all the sub-anagrams that can be made from given words.

A sub-anagram is an anagram of a substring of word.

## Layout
You will need to add code to `src/subanagram_finder/core.clj`, 
Do not change the function `-main` nor any of the unit tests. Please use all of our existing function signatures, but feel free to add your own as well.

## Running
Once your program is implemented, you can run it by executing `lein run -- word [word ...]` from the current directory.
You should get the same output as running `python subanagram_finder.py [-h] word [word ...]`

For example 
```
$ python subanagram_finder.py test
E Es S Se Set St T Tet e es s set t test ts
```

## Testing
Test the program by executing `lein test` from this directory. 
It will test each of the functions you are supposed to implement.

## Note on Repository Access

This repository should stay private. If you make it public, you are possibly providing your solution to other students taking the class. Generally the projects in this class are not great portfolio projects because they are too small, or for the later projects, contain a significant portion of code that is not your own and therefore does not demonstrate your skill. Please keep your repository private so other students can't use your solution.
