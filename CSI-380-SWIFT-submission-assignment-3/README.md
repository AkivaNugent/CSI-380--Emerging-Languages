# NanoBASIC
A Swift interpreter for a stripped down version of Tiny BASIC.

## Language Guide
Please start by reading [the language guide](language_guide.md).

## Building NanoBASIC and Running Programs
You can run a source file through the NanoBASIC interpreter by first building NanoBASIC:
```
swift build
```
and then from the repository's main directory running
```
swift run NanoBASIC Examples/print1.bas
```
Where `Examples/print1.bas` is replaced by the filename of your program. Some sample programs are included in the Examples directory of the repository. The examples that come with the repository should be left unchanged for the unit tests to work.

## Testing NanoBASIC
Before you try running the tests, you should first build NanoBASIC. From the main repository directory run:
```
swift build
```
Tests should be run from the command-line (they depend on the build directory), not Xcode and you can run NanoBASIC's unit tests by running
```
swift test
```
from the main directory of this repository.

## Note on Repository Access

This repository should stay private. If you make it public, you are possibly providing your solution to other students taking the class. Generally the projects in this class are not great portfolio projects because they are too small, or for the later projects, contain a significant portion of code that is not your own and therefore does not demonstrate your skill. Please keep your repository private so other students can't use your solution.
