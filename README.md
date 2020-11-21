## Gradescope Auto-Grader
Authors: Peter Gruber (peter.gruber@usi.ch) and Paolo Montemurro (montep@usi.ch) started 2020-10-09.

## Versions:
#### V 1.6
- **Improved output for different errors**:
	- SYNTAX: The grader outputs a message, the line of the first syntax error and the R error message.
	- COMPILING: The grader outputs the code of the line that contains the error, and the R message
	- NAMING: not changed
	- EVALUATION: not changed
- Improved output message format

#### V 1.5
- **Different output for different errors**:
	- COMPILING: The grader outputs the error message of the code that produced an error.
	- NAMING: The grader recognizes if the variable requested is not present and outputs a standardized message 
	- EVALUATION: The grader provides user-generated or R-generated feedback.
- Created the function return_0_grade
- 7 tests made. Stored in folder test submissions

#### V 1.2
Handling of lines that produces error on submission code. in V1.1 it was stopping the tests and giving 0 points, now it ignores the errors and proceeds with the tests.

#### V 1.1
-	You can start a line with a space (or more) and then a comment
-	In the config.txt file, you can comment directly on the code line, and the first row is the assignment file name (assignment02.R)
-	Created the Parser function used both for config.txt and the submission
-	Created standard variables for submissions: code_length and first_row

#### V1.0
Autograder with config.txt file

## Folder structure
```
gradescope_assignment/
├── autograder/
|	├── config.txt
|	├── grader.R
|	├── parse_txt.R
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
- First line shall be "# name_assignment.R", which is equal to the student submission naming.
- Each line that starts with "#" or with spaces and "#", except from the first line, will NOT be considered.
- You can comment on the same line of the instructions.
- Empty lines will not be considered.

### How to write a test in config.txt
- Enclose tests with `---`, no need to type 2 times `---` between tests.
- Row [1] **required**: title of the test (no "" needed). Same naming between tests is permitted.
	- Use `@` sign before name for testing code content (parsing) 
		- With this option, the first argument in the   (`expect_equal(...)`,...) function will be replaced by the number of its occurences. 
		- *Example* `expect_equal("return",3)` is `TRUE`, if the student code contains exactly three times the keyword `return`.
		- *Note* keywords in comments do not count, in the above example `# Do not forget the return()` would (correctly) not count.
- Row [2] **required** Test
	- Type the testthat function (`expect_equal(...)`, ...). for reference, see https://testthat.r-lib.org/reference/index.html
		- First argument: the student variable name 
		- Second argument: the solution. Could be both R code, or variable name contained in `solution.R`. In the same solution it is possible to use both code and `solution.R` variables. 
		- Type additional parameters for the testthat function (precision, etc)
		- Example: `expect_equal(vec, vec_sol, tolerance = 1e-8, scale = vec_sol)`
- Row [3] **required** score of the test. Will be normalized to have a sum of weights of 100. If the answer is correct, maximum score is given. 0 otherwise.
- Row [4] **optional** negative (error) feedback. If no feedback is provided, R error message will be shown.
- Row [5] **optional** positive (correct) feedback. If no feedback is provided, the message *Congratulations, the answer is correct!* will be displayed. 
	- Individual positive feedback currently only works if also individual negative feedback has been provided. 
	- Individual positive feedback is especially useful if you run two or more tests against one task.

### Handling different errors
- COMPILING: The grader outputs the code of the line that contains an error, and the R message.
- NAMING: The grader recognizes if the variable or function is not present and outputs a standardized message.
- EVALUATION: The grader provides user-generated or R-generated feedback.


### Checklist
- Set correct submission filename in `grader.R`
- Configure all tests in `config.txt`

### How to upload to Gradescope
- Zip all files inside `autograder` (do not zip the whole folder!)
- Upload
