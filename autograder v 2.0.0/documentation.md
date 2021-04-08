#### Peter Gruber & Paolo Montemurro 26/11/2020

## Autograder V2.0.0 



#### Philosofy

Re-start from 0 the grader and aim to obtain an elegant version which is not dependent on testthat package, built with separate functions and code objectives. The 2.0.0 will run both on the Gradescope platform or on the internally developed one.



#### New principles

+ 2 additional environments: ``SUBMISSION`` and ``SOLUTION``
+ Code organized in processes, each defined by a specific function
+ Independence from ``testthat``package and Gradescope platform
+ Shortcuts on test creation
+ Multiple formats for feedback
+ Tests can have preparatory lines
+ 



#### Functions

##### Main

DONE ``run_code``: runs a code. First, try to source the code. If the operation is not successful, runs the code line by line (replay). Returns the environment that the code generated and eventual error messages from replay

DONE ``categorize_error``: analyze the errors encountered in execution and return a message 

DONE ``load_text``: Load a text file (.R or .txt)

DONE ``parse_config`` parse the config (test names, test, points, feedbacks)

PARTIALLY DONE``do_assessment`` Check the test conditions on the student submission. Store the results internally

PARTIALLY DONE``create_feedback`` From the ``do_assessment`` output, create human or platform readable output (json, yml, txt)

PARTIALLY DONE ``shortcuts`` assessment shortcuts, including parsing



##### Assessments

DONE ``keyword_count`` counts the occurrences of a given comand. Must be used in an inequality. Ex: ``keyword_count("pippo")==2``

They output a R code standard test. Mapping from R function to R code. Alternatively, already give result. However, a true statement or a number IS  a test.

``code_properties``  returns the lines and characters of code, and the line and characters of comments

DONE ``obj_exist`` returns T, F, NA based on the existence of an object in the specified environment

DONE ``obj_condition`` returns T, F, NA based on the condition to verify

``...`` shortcuts for standardized tests (ex: ``obj_equal`` done)



#### Syntax of config.txt

``#`` is a comment

``£`` indicates preparatory line (before each code line. will be executed in the global environment if not differently specified).

``---`` separates each test



First line must be exercise name





#### Submission environment objects

``code_text``: text of the submission code

``code_text_stats`` data-frame of statistics of the code text

``...`` variables, functions and objects created by the submission code.



#### Parameters

``text_params`` text strings to format autograder output



#### config.txt tests examples

3 white spaces separate first element, operator and second element 

``SUBMISSION["a"]   <   5``

``SUBMISSION["a(b)"]   ==   5``

``SUBMISSION["a"]   ==   SOLUTION["a"]``

``Obj_equal("a")`` (shortcut for previous example)





#### Run





