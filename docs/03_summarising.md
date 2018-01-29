# Summarising data

In this session we will get to know our three best friends for summarising data: `group_by()`, `summarise()`, and `mutate()`.

## Data
In Session 2, we used a very condensed version of the Global Burden of Disease data. In this module we are going back to a longer one and we will learn how to summarise it ourselves.


```r
source("1_source_theme.R")
load("global_burden_disease_long.rda")
```

We were already using this longer dataset in Session1, but with `colour=cause` to hide the fact that the total deaths in each year was made up of 12 lines groups of data (as the black lines on the bars indicate):


```r
mydata %>% 
	ggplot(aes(x=year, y=deaths_millions, fill=cause))+ 
	geom_col(colour = "black")
```

![](03_summarising_files/figure-epub3/unnamed-chunk-2-1.png)<!-- -->

```r
mydata %>% 
	filter(year == 1990)
```

```
##      location                     cause    sex year deaths_millions
## 1  Developing Non-communicable diseases   Male 1990       9.2277141
## 2  Developing Non-communicable diseases Female 1990       8.0242455
## 3   Developed Non-communicable diseases   Male 1990       4.7692902
## 4   Developed Non-communicable diseases Female 1990       4.9722431
## 5  Developing                  Injuries   Male 1990       2.2039625
## 6  Developing                  Injuries Female 1990       1.2698308
## 7   Developed                  Injuries   Male 1990       0.5941184
## 8   Developed                  Injuries Female 1990       0.2578759
## 9  Developing     Communicable diseases   Male 1990       7.9819728
## 10 Developing     Communicable diseases Female 1990       7.5416376
## 11  Developed     Communicable diseases   Male 1990       0.3387820
## 12  Developed     Communicable diseases Female 1990       0.2870169
```

## Tidyverse packages: ggplot2, dplyr, tidyr, etc.

Most of the functions introduced in this session come from the tidyverse family (http://tidyverse.org/), rather than Base R. Including `library(tidyverse)` in your script loads a list of packages: ggplot2, dplyr, tidry, forcats, etc.

<img src="images/library_vs_package.png" width="1491" />


```r
library(tidyverse)
```


## Basic functions for summarising data

You can always pick a column and ask R to give you the `sum()`, `mean()`, `min()`, `max()`, etc. for it:


```r
mydata$deaths_millions %>% sum()
```

```
## [1] 309.4174
```

```r
mydata$deaths_millions %>% mean()
```

```
## [1] 4.297463
```

But if you want to get the total number of deaths for each `year` (or `cause`, or `sex`, whichever grouping variables you have in your dataset) you can use `group_by()` and `summarise()` that make subgroup analysis very convenient and efficient.


## Subgroup analysis: `group_by()` and `summarise()`

The `group_by()` function tells R that you are about to perform subgroup analysis on your data. It retains information about your groupings and calculations are applied on each group separately. To go back to summarising the whole dataset again use `ungroup()`. Note that `summarise()` is different to the `summary()` function we used in Session 2.

With `summarise()`, we can calculate the total number of deaths per year:


```r
mydata %>% 
	group_by(year) %>% 
	summarise(total_per_year = sum(deaths_millions)) ->
	summary_data1


mydata %>% 
	group_by(year, cause) %>% 
	summarise(total_per_cause = sum(deaths_millions)) ->
	summary_data2
```

* `summary_data1` includes the total number of deaths per year.
* `summary_data2` includes the number of deaths per cause per year.

### Exercise

Compare the sizes - number of rows (observations) and number of columns (variables) - of `mydata`, `summary_data1`, and `summary_data2` (in the Environment tab).

* `summary_data2` has exactly 3 times as many rows as `summary_data1`. Why?
* `mydata` has 5 variables, whereas the summarised dataframes have 2 and 3. Which variables got dropped? Why?


### Exercise

For each cause, calculate its percentage to total deaths in each year.

Hint: Use `full_join()` on `summary_data1` and `summary_data2`.

Solution:

```r
alldata = full_join(summary_data1, summary_data2)
```

```
## Joining, by = "year"
```

```r
alldata$percentage = round(100*alldata$total_per_cause/alldata$total_per_year, 0)
```


## `mutate()`

Mutate works similarly to `summarise()` (as in it respects groupings set with `group_by()`), but it adds a new column into the original data. `summarise()`, on the other hand, condenses the data into a minimal table that only includes the variables specifically asked for.

### Exercise

Investigate these examples to learn how `summarise()` and `mutate()` differ.


```r
summarise_example = mydata %>% 
	summarise(total_deaths = sum(deaths_millions)) 

mutate_example = mydata %>% 
	mutate(total_deaths = sum(deaths_millions))
```

You should see that `mutate()` adds the same number total number (309.4174) to every line in the dataframe. 

### Optional advanced exercise

Based on what we just observed on how `mutate()` adds a value to each row, can you think of a way to redo **Exercise 3.4.2** without using a join? Hint: instead of creating `summary_data1` (total deaths per year) as a separate dataframe which we then merge with `summary_data2` (total deaths for all causes per year), we can use `mutate()` to add total death per year to each row.


```r
mydata %>% 
	group_by(year, cause) %>% 
	summarise(total_per_cause = sum(deaths_millions)) %>% 
	group_by(year) %>% 
	mutate(total_per_year = sum(total_per_cause)) %>% 
	mutate(percentage = 100*total_per_cause/total_per_year) -> alldata
```





## Wide vs long: `spread()` and `gather()`


### Wide format
Although having data in the long format is very convenient for R, for publication tables, it makes sense to spread some of the values out into columns:


```r
alldata %>%
	mutate(percentage = paste0(round(percentage, 2), "%")) %>% #add a % label and round to 2 decimals
	select(year, cause, percentage) %>% #only select the variables you want in your final table
	spread(cause, percentage)
```

```
## # A tibble: 6 x 4
## # Groups:   year [6]
##    year `Communicable diseases` Injuries `Non-communicable diseases`
## * <int>                   <chr>    <chr>                       <chr>
## 1  1990                  34.02%    9.11%                      56.87%
## 2  1995                  30.91%    9.28%                      59.81%
## 3  2000                  28.93%    9.35%                      61.72%
## 4  2005                  26.53%    9.23%                      64.24%
## 5  2010                  23.17%    9.26%                      67.57%
## 6  2013                  21.53%    8.73%                      69.75%
```

### Exercise
Calculate the percentage of male and female deaths for each year. Spread it to a human readable form:

Hints:

* create `summary_data3` that includes a variable called `total_per_sex`
* merge `summary_data1` and `summary_data3` into a new data frame
* calculate the percentage of `total_per_sex` to `total_per_year`
* round, add % labels
* spread


Solution: 

```r
mydata %>% 
	group_by(year) %>% 
	summarise(total_per_year = sum(deaths_millions)) ->
	summary_data1

mydata %>% 
	group_by(year, sex) %>% 
	summarise(total_per_sex = sum(deaths_millions)) ->
	summary_data3

alldata = full_join(summary_data1, summary_data3)
```

```
## Joining, by = "year"
```

```r
result_spread = alldata %>% 
  mutate(percentage = round(100*total_per_sex/total_per_year, 0)) %>%
  mutate(percentage = paste0(percentage, "%")) %>% 
  select(year, sex, percentage) %>% 
  spread(sex, percentage)

result_spread
```

```
## # A tibble: 6 x 3
##    year Female  Male
## * <int>  <chr> <chr>
## 1  1990    47%   53%
## 2  1995    47%   53%
## 3  2000    46%   54%
## 4  2005    46%   54%
## 5  2010    46%   54%
## 6  2013    45%   55%
```

And save it into a csv file using `write_csv()`:


```r
write_csv(result_spread, "gbd_genders_summarised.csv")
```

You can open a csv file with Excel and copy the table into Word or PowerPoint for presenting.


### Long format

The opposite of `spread()` is `gather()`:

* The first argument is a name for the column that will include columns gathered from the wide columns (in this example, `Male` and `Female` are gathered into `sex`).
* The second argument is a name for the column that will include the values from the wide-format columns (the values from `Male` and `Female` are gathered into `percentage`).
* Any columns that already are condensed (e.g. year was in one column, not spread out like in the pre-course example) must be included with a negative (i.e. -year).


```r
result_spread %>% 
  gather(sex, percentage, -year)
```

```
## # A tibble: 12 x 3
##     year    sex percentage
##    <int>  <chr>      <chr>
##  1  1990 Female        47%
##  2  1995 Female        47%
##  3  2000 Female        46%
##  4  2005 Female        46%
##  5  2010 Female        46%
##  6  2013 Female        45%
##  7  1990   Male        53%
##  8  1995   Male        53%
##  9  2000   Male        54%
## 10  2005   Male        54%
## 11  2010   Male        54%
## 12  2013   Male        55%
```



### Exercise

Test what happens when you

* Change the order of sex and percentage:


```r
result_spread %>% 
  gather(percentage, sex, -year)
```

Turns out in the above example, `percentage` and `sex` were just label you assigned to the gathered columns. It could be anything, e.g.:


```r
result_spread %>% 
  gather(look-I-gathered-sex, values-Are-Here, -year)
```

* What happens if we omit `-year`:


```r
result_spread %>% 
  gather(sex, percentage)
```

`-year` was telling R we don't want the year column to be gathered together with Male and Female, we want to keep it as it is.


## Sorting: `arrange()`

To reorder data ascendingly or descendingly, `use arrange()`:


```r
mydata %>% 
	group_by(year) %>% 
	summarise(total = sum(deaths_millions))  %>%
	arrange(-year) # reorder after summarise()
```


\newpage 

## Factor handling

We talked about the pros and cons of working with factors in Session 2. Overall, they are very useful for the type of analyses involved in medical research. 

### Exercise
Explain how and why these two plots are different.


```r
mydata %>%                                   
	ggplot(aes(x=year, y=deaths_millions, fill=cause))+  
	geom_col()
```

![](03_summarising_files/figure-epub3/unnamed-chunk-17-1.png)<!-- -->

```r
mydata %>% 
	ggplot(aes(x=factor(year), y=deaths_millions, fill=cause, colour=cause))+ 
	geom_col()
```

![](03_summarising_files/figure-epub3/unnamed-chunk-17-2.png)<!-- -->

What about these?

![](03_summarising_files/figure-epub3/unnamed-chunk-18-1.png)![](03_summarising_files/figure-epub3/unnamed-chunk-18-2.png)

These illustrate why it might sometimes be useful to use numbers as factors - on the second one we have used `fill=factor(year)` as the fill, so each year gets a distinct colour, rather than a gradual palette.

### `fct_collapse()` - grouping levels together



```r
mydata$cause  %>% 
	fct_collapse("Non-communicable and injuries" = c("Non-communicable diseases", "Injuries")) ->
	mydata$cause2

mydata$cause %>% levels()
```

```
## [1] "Communicable diseases"     "Injuries"                 
## [3] "Non-communicable diseases"
```

```r
mydata$cause2 %>% levels()
```

```
## [1] "Communicable diseases"         "Non-communicable and injuries"
```

### `fct_relevel()` - change the order of levels

Another reason to sometimes make a numeric variable into a factor is that we can then reorder it for the plot:


```r
mydata$year %>% 
  factor() %>% 
	fct_relevel("2013") -> #brings 2013 to the front
	mydata$year.factor

source("1_source_theme.R")

mydata %>% 
	ggplot(aes(x=year.factor, y=deaths_millions, fill=cause))+ 
	geom_col()
```

![](03_summarising_files/figure-epub3/unnamed-chunk-20-1.png)<!-- -->

### `fct_recode()` - rename levels

```r
mydata$cause %>% 
	levels()  # levels() lists the factor levels of a column
```

```
## [1] "Communicable diseases"     "Injuries"                 
## [3] "Non-communicable diseases"
```

```r
mydata$cause %>% 
	fct_recode("Deaths from injury" = "Injuries") %>% 
	levels()
```

```
## [1] "Communicable diseases"     "Deaths from injury"       
## [3] "Non-communicable diseases"
```

### Converting factors to numbers

MUST REMEMBER: factor needs to become `as.character()` before converting to numeric or date!
(Factors are actually stored as labelled integers (so like number codes), only the function `as.character()` will turn a factor back into a collated format which can then be converted into a number or date.)

### Exercise

Investigate the two examples converting the `year.factor` variable back to a number.


```r
mydata$year.factor
```

```
##  [1] 1990 1990 1990 1990 1995 1995 1995 1995 2000 2000 2000 2000 2005 2005
## [15] 2005 2005 2010 2010 2010 2010 2013 2013 2013 2013 1990 1990 1990 1990
## [29] 1995 1995 1995 1995 2000 2000 2000 2000 2005 2005 2005 2005 2010 2010
## [43] 2010 2010 2013 2013 2013 2013 1990 1990 1990 1990 1995 1995 1995 1995
## [57] 2000 2000 2000 2000 2005 2005 2005 2005 2010 2010 2010 2010 2013 2013
## [71] 2013 2013
## Levels: 2013 1990 1995 2000 2005 2010
```

```r
mydata$year.factor %>%
	as.numeric()
```

```
##  [1] 2 2 2 2 3 3 3 3 4 4 4 4 5 5 5 5 6 6 6 6 1 1 1 1 2 2 2 2 3 3 3 3 4 4 4
## [36] 4 5 5 5 5 6 6 6 6 1 1 1 1 2 2 2 2 3 3 3 3 4 4 4 4 5 5 5 5 6 6 6 6 1 1
## [71] 1 1
```

```r
mydata$year.factor %>%
	as.character() %>% 
	as.numeric()
```

```
##  [1] 1990 1990 1990 1990 1995 1995 1995 1995 2000 2000 2000 2000 2005 2005
## [15] 2005 2005 2010 2010 2010 2010 2013 2013 2013 2013 1990 1990 1990 1990
## [29] 1995 1995 1995 1995 2000 2000 2000 2000 2005 2005 2005 2005 2010 2010
## [43] 2010 2010 2013 2013 2013 2013 1990 1990 1990 1990 1995 1995 1995 1995
## [57] 2000 2000 2000 2000 2005 2005 2005 2005 2010 2010 2010 2010 2013 2013
## [71] 2013 2013
```

\newpage 
## Long Exercise

This exercise includes multiple steps, combining all of the above.

First, create a new script called "2_long_exercise.R". Then Restart your R session, add `library(tidyverse)` and load `"global_burden_disease_long.rda"` again.

* Calculate the total number of deaths in Developed and Developing countries. Hint: use `group_by(location)` and `summarise( Include new column name = sum() here)`.
* Calculate the total number of deaths in Developed and Developing countries and for men and women. Hint: this is as easy as adding `, sex` to `group_by()`.
* Filter for 1990.
* `spread()` the the `location` column.


```
## # A tibble: 2 x 3
##      sex Developed Developing
## * <fctr>     <dbl>      <dbl>
## 1 Female  5.517136   16.83571
## 2   Male  5.702191   19.41365
```



## Extra: formatting a table for publication

Creating a publication table with both the total numbers and percentages (in brackets) + using `formatC()` to retain trailing zeros:


```r
# Let's use alldata from Exercise 5.2:

mydata %>% 
	group_by(year, cause) %>% 
	summarise(total_per_cause = sum(deaths_millions)) %>% 
	group_by(year) %>% 
	mutate(total_per_year = sum(total_per_cause)) %>% 
	mutate(percentage = 100*total_per_cause/total_per_year) -> alldata

alldata %>%
	mutate(total_percentage =	
				 	paste0(round(total_per_cause, 1)  %>% formatC(1, format = "f"),
				 	       " (", round(percentage, 1) %>% formatC(1, format = "f"),
				 	       "%)"
				 	       )
				 	) %>%
	select(year, cause, total_percentage) %>%
	spread(cause, total_percentage)
```

```
## # A tibble: 6 x 4
## # Groups:   year [6]
##    year `Communicable diseases`   Injuries `Non-communicable diseases`
## * <int>                   <chr>      <chr>                       <chr>
## 1  1990            16.1 (34.0%) 4.3 (9.1%)                27.0 (56.9%)
## 2  1995            15.4 (30.9%) 4.6 (9.3%)                29.9 (59.8%)
## 3  2000            14.8 (28.9%) 4.8 (9.4%)                31.5 (61.7%)
## 4  2005            13.9 (26.5%) 4.8 (9.2%)                33.6 (64.2%)
## 5  2010            12.4 (23.2%) 5.0 (9.3%)                36.3 (67.6%)
## 6  2013            11.8 (21.5%) 4.8 (8.7%)                38.3 (69.7%)
```


## Solution: Long Exercise


```r
mydata %>% 
  filter(year == 1990) %>% 
  group_by(location, sex) %>% 
  summarise(total_deaths = sum(deaths_millions)) %>% 
  spread(location, total_deaths)
```

