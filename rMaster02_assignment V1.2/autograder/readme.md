## Documentation - Gradescope Auto-Grader
Authors: Peter Gruber and Paolo Montemurro - montep@usi.ch, started
2020-10-09, this version 2002-10-14

## Folder structure
```
gradescope_assignment/
├── autograder/
|	├── config.txt
|	├── grader.R
|	├── parse_txt.R
|	├── readme.md
|	├── run_autograder
|	├── setup.sh
|	├── solution.R
|	├── functions.R
|	└── tests.R
├── incorrect_solutions
|	├── assignment01.R
|	└── foo.R
├── results
|	└── results.json
├── submission
|	└──  assignmentXX.R
└── text
```
### Content of autograder
- `config.txt` **(required)**: file that contains the tests
- `grader.R` **(required)**: format the test results according to Gradescope
- `parse_txt.R` **(required)**: read `config.txt`
- `run_autograder`**(required)**: load the student submission in the grader
- `setup.sh` **(required)**: install the required packages in the installation
- `solution.R` **(optional)**: solution of the assignment. **Must** have different variable naming than submission. Use "\_sol" after each variable/function to distinguish.
- `functions.R` **(required)**: functions called by the different scripts
- `readme.md` **(optional)**: this guide. 
- `tests.R` **(required)**: run the tests with testthat package

### Content of incorrect_solutions
- **(optional)**: Any incorrect solution for testing

### Content of results
- **(optional)**: This folder can be emtpy , **(required)** if you want to test locally. If testing the grader locally, the `resuts.json` file will end up here.

### Content of submission
- `assignmentXX.R` **(optional)**: test assignment submission (this is where gradescope puts the student's solution), **(required)** if you want to test locally.

### Content of text
- **(optional)**: assignment text (=problem description) for students.


## File conventions
### config.txt conventions
- First line shall be ""# name_assignment.R".
- Each line that starts with "#" or with spaces and "#" will NOT be considered
- Empty lines will not be considered

### How to write a test in config.txt
- Enclose tests with `---`
- No need to type 2 times `---` between tests
- Row [1] **required**: title of the test (no "" needed). Same naming between tests is permitted.
	- Use `@` sign before name for testing code content. 
		- With this option, the first argument in the   (`expect_equal(...)`,...) function will be replaced by the number of its occurences. 
		- *Example* `expect_equal("return",3)` is `TRUE`, if the student code contains exactly three times the keyword `return`.
		- *Note* keywords in comments do not count, in the above example `# Do not forget the return()` would (correctly) not count.
- Row [2] **required** Test
	- Type the testthat function (`expect_equal(...)`, ...) # put testthat doc
		- Type the student variable name 
		- Type the solution. Could be both R code, or variable name contained in `solution.R`. In the same solution it is possible to use both code and `solution.R` variables. 
		- Type additional parameters for the function (precision)
		- Example: `expect_equal(vec, vec_sol, tolerance = 1e-8, scale = vec_sol)`
- Row [3] **required** score of the test. Will be normalized to have a sum of weights of 100.
- Row [4] **optional** negative (error) feedback. If no feedback is provided, R error message will be shown.
- Row [5] **optional** positive (correct) feedback. If no feedback is provided, the message *Congratulations, the answer is correct!* will be displayed. 
	- Individual positive feedback currently only works if also individual negative feedback has been provided. 
	- Individual positive feedback is especially useful if you run two or more tests against one task.

### Checklist
- Set correct submission filename in `grader.R`
- Configure all tests in `config.txt`

### How to upload to Gradescope
- Zip all files inside `autograder` (do not zip the whole folder!)
- Upload