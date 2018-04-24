# R Basics

The aim of this module is to familiarise you with how R works and how to read in and apply basic manipulations on your data. Here, we will be working with similar but slightly shorter version of the Global Burden of Disease dataset than we did for the bar plots.

Throughout this course, don't copy or type code directly into the Console. We will only be using the Console for viewing output, warnings, and errors. All code should be in a script and executed (=run) using Control+Enter (line or section) or Control+Shift+Enter (whole script). Make sure you are always working in a project (the right-top corner of your RStudio interface should say "HealthyR").

## Getting help

RStudio has a built in Help tab. To use the Help tab, move your cursor to something in your code (e.g. `read_csv()`) and press F1 - this will show you the definition and some examples. However, the Help tab is only useful if you already know what you are looking for but can't remember how it worked exactly. For finding help on things you have not used before, it is best to Google it. R has about 2 million users so someone somewhere has had the same question or problem.


##Starting with a blank canvas

In the first session we loaded some data that we then plotted. When we import data, R remembers the data and stores it in the Environment tab.

It's good practice to Restart R before starting new work, as it's best to use fresh up to date data - otherwise we could accidentally use data which has nothing to do with our work. Restarting R only takes a second!

* Restart R (Control+Shift+F10 or select it from Session -> Restart R).

RStudio has a default option that is not best practise any more, you should do this (once only):

* Go to Tools -> Global Options -> General and set "Save .RData on exit" to Never. This does not mean you can't or shouldn't save your work in .RData files. But it is best to do it consciously and load exactly what you need to load, rather than letting R always save and load everything for you, as this could also include broken data or objects.



##Working with Objects

It's sometimes difficult to appreciate how coding works without trying it first.

These exercises will show you how R works.

We'll first create an object and call it `a`, we will give the object `a` a value of 1.

In R the equals `=` sign tells R to give the object on the left of the sign the value of whatever is on the right of the sign.


```r
a = 1
```

In your environment panel, you should see `a` appear under the `Values` section.

Now, lets create `b` and give it a value of 2.


```r
b = 2
```

Lets now add `a` and `b` together to create the object `c`


```r
c = a + b 

#Print the value of c to the Console

c # should return the number 3
```

```
## [1] 3
```

All of R is just an extension of this: applying more complex functions (calculations) across more complex objects.

It's important to appreciate that objects can be more than just single numbers too. They can be entire spreadsheets, which in R are known as `data frames`.


Note that many people use `<-` instead of `=`. They mean the same thing in R. `=` and `<-` save what is on the right into the name on the left. There is also a left-to-right operator: `->`.

### Exercise

Create 3 new variables, `d`, `e`, `f` with values 6, 7, 8 using the different assignment operators.

```r
d  = 6
e <- 7
8 -> f
```


##Loading data

Before we load a new dataset, we should clear or experiments from the previous section: Restart R by pressing Control+Shift+F10 or Select Section -> Restart R from the menu above.

Now the environment is clear, lets load in the data:


```r
library(tidyverse) #Tidyverse is the package which contains some of the code we want to use

mydata = read_csv("global_burden_disease_short.csv")
```

But how can we look at the data we just loaded? How do we know which variables it contains? Hint: the Environment tab.

###Excercise

Answer these question about your data:

1. At present, how many variables are there?

2. How many deaths were there from communicable diseases in 1990? Hint: clicking on columns when Viewing a dataframe orders it.



### Other ways to investigate objects

In most cases, you can rely on the Environment tab to see how many variables you have. If, however, the dataset you are using is too big to easily navigate within, you might need to use `names(mydata)`, `head(mydata)`, or `str(mydata)`.

Furthermore, we can select a single column using the dollar sign: `$`.

So if we type:


```r
mydata$deaths
```

```
##  [1] 16149409 26993493  4325788 15449045 29897069  4639869 14775502
##  [8] 31521934  4776852 13890709 33637815  4833919 12431802 36259550
## [15]  4970846 11809640 38267197  4786929
```

R will give us all the data for that variable.

### Exercise


![](images/magittr.png)

*Image source: https://cran.r-project.org/web/packages/magrittr/vignettes/magrittr.html*

Re-write `names(mydata)` and `head(mydata)` using the pipe (`%>%`). Use the keyboard shortcut `Control+Shift+M` to insert it.


### Exercise

How many unique values does the `cause` variable have? Hint: `mydata$cause` piped into `unique()` piped into `length()`.

##Operators

Operators are symbols in R Code that tell R how to handle different pieces of data or objects.

Here are the main operators:

`=, <-, ==, <, >, <=, >=`

Some of these perform a test on data. A good example of this is the '==' operator.

This tells R to compare two things and ask if they are equal. If they are equal R will return 'TRUE', if not R will return 'FALSE'.

On your R cheat sheet, you can see what the others do. Here is a reminder:

| Symbol  | What does  | Example  | Example result|
|-------- | ---------  | -------- |-------|
| `=` or `<-` |  assigns   |`x = 2`   | the value of x is now 2 |
| `==`      | Equal?     | `x == 2` | TRUE  |
| `!=`      | Not equal? | `x != 1` | TRUE |
| `<`       | Less than  | `x < 2`    | FALSE |
| `>`       | Greater than | `x > 1`   | TRUE |
| `<=`      | Less than or equal to | `x <= 2` | TRUE|
| `>=`      | Greater than or equal to | `x >= 1` | TRUE |
| `%>% `   | sends data into a function | `x %>% print()` | 2 |
| `::`     | indicates package | `dplyr::count()` | `count()` fn. from the `dplyr` package|
| `->`            | assigns | `2 -> x` | the value of x is now 2 |
| `&`             | AND | `x > 1 & x < 3` | TRUE |
| `|`             | OR | `x > 3 | x == 3` | TRUE |
| `%in%`          | is value in list | `x %in% c(1,2,3)` | TRUE |
| `$`             | select a column | `mydata$year` | 1990,1996,...|
| `c()`           | combines values | `c(1, 2)`     | 1, 2 |
| `#`               | comment| `#Riinu changed this` | ignored by R   |


For example, if we wanted to select the years in the Global Burden of disease study after 2000 (and including 2000) we could type the following:


```r
mydata %>% 
  filter(year >= 2000)
```


To save this as a new object we would then write:



```r
mydata_out = mydata %>% 
  filter(year >= 2000)

#Or we could write

mydata %>% 
  filter(year >= 2000) -> mydata_out
```

How would you change the above code to only include years greater than 2000 (so not including 2000 itself too)? Hint: look at the table of operators above (also in your HealthyR QuickStart Sheet).

###Exercise

Modify the above example to filter for only year 2000, not all years greater than 2000. Save it into a variable called `mydata_year2000`.





###Exercise

Let's practice this and combine multiple selections together.

This '|' means OR and '&' means AND.

From `mydata`, select the lines where year is either 1990 or 2013 and cause is "Communicable diseases":


```r
new_data_selection = mydata %>% 
  filter( (year == 1990 | year == 2013) & cause == "Communicable diseases")

# or we can get rid of the extra brackets around the years
# by moving cause into a new filter on a new line:

new_data_selection = mydata %>% 
  filter(year == 1990 | year == 2013) %>% 
  filter(cause == "Communicable diseases")
```



##Types of variables

Like many other types of statistical software, R needs to know the variable type of each column. The main types are:

### Characters

**Characters** (sometimes referred to as *strings* or *character strings*) in R are letters, words, or even whole sentences (an example of this may be free text comments). We can specify these using the `as.character()` function. Characters are displayed in-between `""` (or `''`).

### Factors

**Factors** are fussy characters. Factors are fussy because they have something called levels. Levels are all the unique values this variable could take - e.g. like when we looked at `mydata$cause %>% unique()`.
Using factors rather than just characters can be useful because:


* The values factor levels can take is fixed. For example, if the levels of your column called `sex` are "Male" and "Female" and you try to add a new patient where sex is called just "F" you will get a warning from R. If `sex` was a character column rather than a factor R would have no problem with this and you would end up with "Male", "Female", and "F" in your column.
* Levels have an order. When we plotted the different causes of death in the last session, R ordered them alphabetically (because `cause` was a character rather than a factor). But if you want to use a non-alphabetical order, e.g. "Communicable diseases"-"Non-communicable diseases"-"Injuries", we need make `cause` into a factor. Making a character column into a factor enables us to define and change the order of the levels. Furthermore, there are useful tools such as `fct_inorder` or `fct_infreq` that can order factor levels for us.


These can be huge benefits, especially as a lot of medical data analyses include comparing different risks to a reference level. Nevertheless, the fussiness of factors can sometimes be unhelpful or even frustrating. For example, if you really did want to add a new level to your `gender` column (e.g., "Prefer not to say") you will either have to convert the column to a character, add it, and convert it back to a factor, or use `fct_expand` to add the level and then add your new line.

#### Exercise

Temporarily type `fct_inorder` anywhere in your script, then press F1. Read the **Description** in the Help tab and discuss with your neighbour how `fct_inorder` and `fct_infreq` would order your factor levels.


### Numbers

Self-explanatory! These are numbers. In R, we specify these using the `as.numeric()` function. Numbers without decimal places are sometimes called integers. Click on the blue arrow in front of `mydata` in the Environment tab and see that `year` is an `int` (integer) whereas `deaths` is a `num` (numeric).




### Specifying variable types


```r
as.character(mydata$cause)

as.numeric(mydata$year)

factor(mydata$year)

#Lets save the cause as a factor

mydata$cause = factor(mydata$cause)

#Now lets print it out

mydata$cause
```

### Exercise

Change the order of the levels in `mydata$cause` so that "Non-communicable diseases" come before "Injuries". Hint: use F1 to investigate examples of how `fct_relevel()` works.

## Importing data

For historical reasons, R's default functions (e.g. `read.csv()` or `data.frame()`) convert all characters to factors automatically (for more on this see [forcats.tidyverse.org](http://forcats.tidyverse.org). But it is usually more convenient to deal with characters and convert some of the columns to factors when necessary.

Base R:


```r
mydata = read.csv("global_burden_disease_short.csv", stringsAsFactors = FALSE)
```

The tidyverse version, `read_csv()`, has `stringsAsFactors` set to FALSE by default (and it is a lot faster than `read.csv()` when reading in large datasets).

Tidyverse:


```r
mydata = read_csv("global_burden_disease_short.csv")
```

```
## Parsed with column specification:
## cols(
##   cause = col_character(),
##   year = col_integer(),
##   deaths = col_double()
## )
```

You can use the "Import Dataset" button in the Environment tab to get the code for importing data from Excel, SPSS, SAS, or Stata.

##Adding columns to dataframes

If we wanted to add in a new column or variable to our data, we can simply use the dollar sign '$' to create a new variable inside a pre-existing piece of data:


```r
mydata$new = 1

mydata$new2 = 1:18
```

Run these lines and click on `mydata` in the Environment tab to check this worked as expected.

Conversely, if we want to delete a specific variable or column we can use the 'NULL' function, or alternatively ask R to `select()` the data without the new variable included.


```r
mydata$new = NULL

mydata = mydata %>% 
  select(-new2)
```

We can make new variables using calculations based on variables in the data too.

The mutate function is useful here. All you have to specify within the mutate function is the name of the variable (this can be new or pre-existing) and where the new data should come from.

There are two equivalent ways of defining new columns based on a calculation with a previous column:


```r
#First option

mydata$years_from_1990 = mydata$year - 1990 
mydata$deaths_millions = mydata$deaths/1000000

#Second option (mutate() function)

mydata = mydata %>% 
  mutate(years_from_1990 = year-1990,
         deaths_millions = deaths/1000000) 
```

Throughout this course we will be using both of these ways to create or modify columns. The first option (using the `$`) can look neater when changing a single variable, but when combining multiple ones you will end up repeating `mydata$`. `mutate()` removes the duplication, but it does add a new line and brackets. 


## Rounding numbers

We can use `round()` to round the new variables to create integers.

### Exercise

Round the new column `deaths_millions` to no decimals:


```
##  [1] 16 27  4 15 30  5 15 32  5 14 34  5 12 36  5 12 38  5
```

* How would you round it to 2 decimals? Hint: use F1 to investigate `round()`. 

* What do `ceiling()` and `floor()` do? Hint: sometimes you want to round a number up or down.

##The combine function: c()

The combine function combines several values: `c()`

The combine function can be used with numbers or characters (like words or letters):


```r
examplelist = c("Red", "Yellow", "Green", "Blue")

# Ask R to print it by executing it on its own line

examplelist
```

```
## [1] "Red"    "Yellow" "Green"  "Blue"
```

### Exercise

There are 18 lines (observations) in mydata. Create a new variable using `c()` with 18 values (numbers, words, whichever you like, e.g. like we created `examplelist`). Then add it as new column to `mydata$newlist`. Advanced version: do this using a combination of `rep()` and `c()`.

\newpage
##The `paste()` function

The `paste()` function is used to paste several words or numbers into one character variable/sentence.

In the paste function we need to specify what we would like to combine, and what should separate the components. By default, the separation is a space, but we can change this using the `sep =` option within the paste function.

So, for example if we wanted to make a sentence:


```r
paste("Edinburgh", "is", "Great")
```

```
## [1] "Edinburgh is Great"
```

```r
#Lets add in full stops

paste("Edinburgh", "is", "Great", sep = ".")
```

```
## [1] "Edinburgh.is.Great"
```

```r
#separator needs to go in "" as it is a character

#If we really like Edinburgh

paste("Edinburgh", "is", "Great", sep = "!")
```

```
## [1] "Edinburgh!is!Great"
```

```r
#If we want to make it one word

paste("Edinburgh", "is", "Great", sep = "") # no separator (still need the brackets)
```

```
## [1] "EdinburghisGreat"
```

We can also join two different variables together using `paste()`: 



```r
paste("Year is", mydata$year)
```

```
##  [1] "Year is 1990" "Year is 1990" "Year is 1990" "Year is 1995"
##  [5] "Year is 1995" "Year is 1995" "Year is 2000" "Year is 2000"
##  [9] "Year is 2000" "Year is 2005" "Year is 2005" "Year is 2005"
## [13] "Year is 2010" "Year is 2010" "Year is 2010" "Year is 2013"
## [17] "Year is 2013" "Year is 2013"
```


###Exercise

Fix this code:

Hint: Think about characters and quotes!


```r
paste(Today is, Sys.Date() )
```


##Combining two dataframes

For combining dataframes based on shared variables we use the Joins: `left_join()`, `right_join()`, `inner_join()`, or `full_join()`. Let's split some of the variables in `mydata` between two new dataframes: `first_data` and `second_data`. For demonstrating the difference between the different joins, we will only include a subset (first 6 rows) of the dataset in `second_data`:


```r
first_data  = select(mydata, year, cause, deaths_millions)
second_data = select(mydata, year, cause, deaths_millions) %>% slice(1:6)

#change the order of rows in first_data to demosntrate the join does not rely on the ordering of rows:
first_data = arrange(first_data, deaths_millions)

combined_left  =  left_join(first_data, second_data)
combined_right = right_join(first_data, second_data)
combined_inner = inner_join(first_data, second_data)
combined_full  =  full_join(first_data, second_data)
```

Those who have used R before, or those who come across older scripts will have seen `merge()` instead of the joins. `merge()` works similarly to joins, but instead of having the four options defined clearly at the front, you would have had to use the `all = FALSE, all.x = all, all.y = all` arguments.

![](images/databasejoke.jpg)

### Exercise

Investigate the four new dataframes called `combined_` using the Environment tab and discuss how the different joins (left, right, inner, full) work.


##The `summary()` Function

In R, the `summary()` function provides a quick way of summarising both data or the results of statistical tests.

Lets get a quick summary of all the variables inside the Global Burden of Disease dataset. It will work for whole datasets and single variables too.


```r
mydata %>% summary()
```

```
##     cause                year          deaths         years_from_1990
##  Length:18          Min.   :1990   Min.   : 4325788   Min.   : 0.00  
##  Class :character   1st Qu.:1995   1st Qu.: 4868151   1st Qu.: 5.00  
##  Mode  :character   Median :2002   Median :14333106   Median :12.50  
##                     Mean   :2002   Mean   :17189854   Mean   :12.17  
##                     3rd Qu.:2010   3rd Qu.:29171175   3rd Qu.:20.00  
##                     Max.   :2013   Max.   :38267197   Max.   :23.00  
##  deaths_millions
##  Min.   : 4.00  
##  1st Qu.: 5.00  
##  Median :14.50  
##  Mean   :17.22  
##  3rd Qu.:29.25  
##  Max.   :38.00
```

This even works on statistical tests (we will learn more about these later):


```r
# lm stands for linear model
lm(deaths ~ year, data = mydata) %>% summary()
```

```
## 
## Call:
## lm(formula = deaths ~ year, data = mydata)
## 
## Residuals:
##       Min        1Q    Median        3Q       Max 
## -13480641 -11791203  -2889909  12818624  19999627 
## 
## Coefficients:
##               Estimate Std. Error t value Pr(>|t|)
## (Intercept) -181988644  736014812  -0.247    0.808
## year             99482     367606   0.271    0.790
## 
## Residual standard error: 12590000 on 16 degrees of freedom
## Multiple R-squared:  0.004556,	Adjusted R-squared:  -0.05766 
## F-statistic: 0.07324 on 1 and 16 DF,  p-value: 0.7901
```

### When pipe sends data to the wrong place

Note that our usual way of doing things with the pipe would not work here:



```r
mydata %>% 
  lm(deaths ~ year) %>%
  summary()
```

This is because the pipe tries to send data into the first place of the function (first argument), but `lm()` wants the formula (`deaths ~ year`) first, then the dataframe. We can bypass this using `data = .` to tell the pipe where to put mydata:


```r
mydata %>% 
  lm(deaths ~ year, data = .) %>%
  summary()
```


###Exercise

Try adding a new variable called `death_over_10m` which indicates whether there were more than 10 million deaths for a cause. The new variable should take the form 'Yes' or 'No'. 

Then make it into a factor.

Then use `summary()` to find out about it!

```r
mydata = mydata %>% 
  mutate(death_over_10m = ifelse(deaths >= 10000000, "Yes", "No")) #Using ifelse

mydata$death_over_10m = as.factor(mydata$death_over_10m)

mydata$death_over_10m %>% summary()
```

```
##  No Yes 
##   6  12
```

##Extra: Creating a dataframe from scratch

It is rare that you will need to create a dataframe by hand as most of the time you will be reading in a data from a .csv or similar. But in some cases (e.g., when creating special labels for a plot) it might be useful, so this is how to create one:



```r
patient_id = paste0("ID", 1:10)
sex        = rep(c("Female", "Male"), 5)
age        = 18:27

newdata = data_frame(patient_id, sex, age)

#same as

newdata      = data_frame(
  patient_id = paste0("ID", 1:10), #note the commas
  sex        = rep(c("Female", "Male"), 5),
  age        = 18:27
)
```


If we used `data.frame()` instead of `data_frame()`, all our character variables (`patient_id`, `sex`) would become factors automatically. This might make sense for `sex`, but it doesn't for `patient_id`.

###Exercise

Create a new dataframe called `my_dataframe` that looks like this:

Hint: Use the functions `paste0()`, `seq()` and `rep()`



```
## # A tibble: 10 x 3
##    patient_id   age sex   
##    <chr>      <dbl> <chr> 
##  1 ID11        15.0 Male  
##  2 ID12        20.0 Male  
##  3 ID13        25.0 Male  
##  4 ID14        30.0 Male  
##  5 ID15        35.0 Male  
##  6 ID16        40.0 Female
##  7 ID17        45.0 Female
##  8 ID18        50.0 Female
##  9 ID19        55.0 Female
## 10 ID20        60.0 Female
```


## Solutions

**2.5.3**


```r
mydata %>% names()
mydata %>% head()
mydata %>% str()
```

**2.5.4**


```r
mydata$cause %>% unique() %>% length()
```

```
## [1] 3
```

**2.6.2**


```r
mydata_year2000 = mydata %>% 
  filter(year == 2000)
```

**2.7.5** 


```r
mydata$cause %>% fct_relevel("Injuries", after = 1)
```

**2.10.1**


```r
mydata$deaths_millions = round(mydata$deaths_millions)

# or
mydata$deaths_millions = mydata$deaths_millions %>% round()
```

**2.11.1**


```r
examplelist = c("Red", "Yellow", "Green", "Blue",
                "Red", "Yellow", "Green", "Blue",
                "Red", "Yellow", "Green", "Blue",
                "Red", "Yellow", "Green", "Blue",
                "Green", "Blue")

#Let's see what we've made by using print

mydata$newlist = examplelist


# using rep()

examplelist2 = rep(c("Green", "Red"), 9)
```


**2.12.1**


```r
paste("Today is", Sys.Date())
```

**2.15.1**


```r
my_dataframe = data_frame(
  patient_id = paste0("ID", 11:20),
  age        = seq(15, 60, 5),
  sex        = c( rep("Male", 5), rep("Female", 5))
)
```
