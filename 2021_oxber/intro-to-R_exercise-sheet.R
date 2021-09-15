## R script for workshop "Introduction to R --- Oxford" as part of the
## Ox|Ber Summer School 2001 programme. Workshop by Adam Kenny, Matt
## Jaquiery, and Olly Robertson. This script is based on the initial
## lessons of the Carpentries' Programming with R material
## (http://swcarpentry.github.io/r-novice-inflammation/), which is
## Copyright (c) Software Carpentry (http://software-carpentry.org/)
## available under CC BY 4.0
## (http://swcarpentry.github.io/r-novice-inflammation/LICENSE.html).

##################################################
## Setup
##################################################

## If you haven't been able to download the files, follow instructions
## here: http://swcarpentry.github.io/r-novice-inflammation/setup.html

##################################################
## Lesson 01
##################################################

##### Loading Data

## The data file should be located in the directory data inside the
## working directory. Load the data into R using read.csv:



##### Assigning Variables

## 'read.csv' reads the file, but we can't use the data unless we
## assign it to a variable. We can create a new variable and assign a
## value to it using '<-'. Practice by creating a new variable
## 'weight_kg' with a value e.g. 55:

## We can treat our variable like a regular number, and do arithmetic
## with it (multiply variable by a 2.2 to get weight in pounds):

## We can also change a variable's value by assigning it a new value
## e.g. 57.5:

## Now, we'll convert 'weight_kg' into pounds, and store the new value
## in the variable 'weight_lb':

## Now that we know how to assign things to variables, let's re-run
## 'read.csv' and save its result into a variable called 'dat':

## Use the function 'head' to display only the first few rows of data:



##### Manipulating Data

## What type of thing is 'dat'? Use 'class' to find out:

## We can see the shape, or dimensions, of the data frame with the
## function 'dim':

## Get a single value from the data frame, by providing an index in
## square brackets. The first number specifies the row and the second
## the column.

## First value in dat, row 1, column 1:

## Middle value in dat, row 30, column 20:

## If we want to select more than one row or column, we can use the
## function 'c', which stands for combine. For example, to pick columns
## 10 and 20 from rows 1, 3, and 5, we can do this:

## If we want to select contiguous rows and columns, it's more
## convienent to use ':' operator. This special function generates
## sequesnces of numbers. For example, select the first ten columns of
## values for the first four rows:

## If you want to select all rows or all columns, leave that index
## value empty. Try selecting all columns from row 5:



##### Analyzing Data

## Now let's perform some common mathematical operations to learn more
## about our data. We often want to look at partial statistics, such
## as the maximum value per patient. One way to do this is to select
## the data we want to create a new temporary data frame, and then
## perform the calculation on this subset. Do so by first selecting
## the first row and all of the columns, and assigning it to a
## variable called 'patient_1':

## We don't actually need to store the row in a variable of its
## own. Instead, we can combine the selection and the function call:

## R also has functions for other common calculations. Find the
## minimum inflation on day 7:

## Find the mean inflation on day 7:

## Find the standard deviation of inflation on day 7:

## R also has a function that summaries the previous common
## calculations, try 'summary' on a columns 1 to 4:


## What if we need the maximum inflammation for all patients, or the
## average for each day? For this, we want to perform the operation
## across rows or across columns. To support this, we can use the
## 'apply' function.

## To learn about this or any function, run 'help(function)' or '?
## function'. Try this will 'apply':

## To obtain the average inflammation of each patient we will need to
## calculate the mean of all of the rows (MARGIN = 1) of the data
## frame:

## And to obtain the average inflammation of each day we will need to
## calculate the mean of all of the columns (MARGIN = 2) of the data
## frame:

##################################################
##### Extension: Lesson 01
##################################################

## If you have done all of the above and there is time left, try to
## answer the questions in 'Subsetting More Data', 'Subsetting and
## Re-Assignment', and 'Using the Apply Function on Patient Data'
## towards the end of this webpage:
## http://swcarpentry.github.io/r-novice-inflammation/01-starting-with-data/index.html.

## And if you've done that, try the section on 'Plotting', using the
## 'help' function to e.g. change x axis label.

##################################################
##### Lesson 02
##################################################

##### Defining a Function

## Let's start by defining a function 'fahrenheit_to_celsius' that
## converts temperatures from Fahrenheit to Celsius:

## Let's try running our function. Calling our own function is no
## different from calling any other function. Try with today's
## temperature (likely freezing here in Oxford):

## Try freezing point of water (32 degrees Fahrenheit):



##### Composing Functions

## Now that we've seen how to turn Fahrenheit into Celsius, it's easy
## to turn Celsius into Kelvin:

## Try freezing point of water from Celsius to Kelvin:

## What about converting Fahrenheit to Kelvin? We could write out the
## formula, but we don't need to. Instead, we can compose the two
## functions we have already created:

## Instead of combining two functions in the previous step, you
## could've perfomed the calculation in one line of code, by “nesting”
## one function call inside another. Try it! Although convienient, too
## many nested functions can become difficult to read:

##### Exercise: Create a Function

## Try at least one of the exercises in Create a Function.

## 1) Write a function called 'highlight' that takes two vectors as
## arguments, called 'content' and 'wrapper', and returns a new vector
## that has the wrapper vector at the beginning and end of the
## content:

## 2) Write a function called 'edges' that returns a vector made up of
## just the first and last elements of its input:



##### Testing, Error Handling, and Documenting

## Once we start putting things in functions so that we can re-use
## them, we need to start testing that those functions are working
## correctly. To see how to do this, let’s write a function to center
## a dataset around a particular midpoint:

## We could test this on our actual data, but since we don't know what
## the values ought to be, it will be hard to tell if the result was
## correct. Instead, let's create a vector of 0s and then center that
## around 3. This will make it simple to see if our function is
## working as expected:


## That looks right, so let's try center on our real data. We'll
## center the inflammation data from day 4 around 0:

## It's hard to tell from the default output whether the result is
## correct, but let's compare the original mean on day 4, with the
## centered mean:

## We can do a whole host of checks, such as comparing the standard
## deviations (they should be the same in the original and centred
## data):

## There are two important tasks to consider: 1) we should ensure our
## function can provide informative errors when needed, and 2) we
## should write some documentation for our function to remind
## ourselves later what it’s for and how to use it.

##### Error Handling

## What happens if we have missing data (NA values) in the data
## argument we provide to center? Let's create a new data object
## ('datNA') and set one value in column 4 to NA:

## Use 'center' on new data frame:

## This is likely not the behavior we want, and is caused by the mean
## function returning NA when the 'na.rm = TRUE' is not provided. We
## may wish to not consider NA values in our 'center' function. We can
## provide the 'na.rm = TRUE' argument and solve this issue:

## However, what happens if the user were to accidentally hand this
## function a factor or character vector?

## Both of these attempts result in errors. Luckily, the errors are
## quite informative. In other cases, we may need to add in error
## handling using the 'warning' and 'stop' functions (which we won't
## do today!).

##### Documentation

## A common way to put documentation in software is to add comments as
## you do with '#':


##### Defining Defaults

## If we put arguments that are not named in positions the function
## can't understand, you'll get an error:

## To make our own functions easier to use, let's re-define our center
## function to include a default midpoint of 0:


##### Exercise

## Try the example that shows how R matches values to arguments.


##################################################
## Lesson 03
##################################################

## For Loops

## Suppose we want to print each word in a sentence. One way is to use
## six print statements:

## This is a bad approach because it doesn't scale and it's
## fragile. So let's create a 'for loop':
