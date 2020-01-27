---
output:
  pdf_document: default
  html_document: default
---



# Summarising data
\index{summarising data@\textbf{summarising data}}

>“The Answer to the Great Question ... Of Life, the Universe and Everything ... Is ... Forty-two," said Deep Thought, with infinite majesty and calm.  
>Douglas Adams, The Hitchhiker's Guide to the Galaxy

In this chapter you will find out how to:

* summarise data using: `group_by()`, `summarise()`, and `mutate()`
* reshape data between the wide and long formats: `spread()` and `gather()`
* `select()` columns and `arrange()` (sort) rows

The exercises at the end of this chapter combine all of the above to give context and show you more worked examples.

## Get the data



Dataset: Global Burden of Disease (year, cause, sex, income, deaths)

The Global Burden of Disease dataset used in this chapter is more detailed than the one we used previously. 
For each year, the total number of deaths from the three broad disease categories are also separated into sex and World Bank income categories. 
This means that we have 24 rows for each year, and that the total number of deaths per year is the sum of these 24 rows:


```r
library(tidyverse)
gbd_full = read_csv("data/global_burden_disease_cause-year-sex-income.csv")

# Creating a single-year tibble for printing and simple examples:
gbd2017 = gbd_full %>% 
  filter(year == 2017)
```

\begin{table}[!h]

\caption{(\#tab:chap3-tab-gbd2017)Deaths per year (2017) from three broad disease categories, sex, and World Bank county-level income groups.}
\centering
\fontsize{10}{12}\selectfont
\begin{tabular}[t]{lcrlc}
\toprule
cause & year & sex & income & deaths\_millions\\
\midrule
Communicable diseases & 2017 & Female & High & 0.26\\
Communicable diseases & 2017 & Female & Upper-Middle & 0.55\\
Communicable diseases & 2017 & Female & Lower-Middle & 2.92\\
Communicable diseases & 2017 & Female & Low & 1.18\\
\addlinespace
Communicable diseases & 2017 & Male & High & 0.29\\
Communicable diseases & 2017 & Male & Upper-Middle & 0.73\\
Communicable diseases & 2017 & Male & Lower-Middle & 3.10\\
Communicable diseases & 2017 & Male & Low & 1.35\\
\addlinespace
Injuries & 2017 & Female & High & 0.21\\
Injuries & 2017 & Female & Upper-Middle & 0.43\\
Injuries & 2017 & Female & Lower-Middle & 0.66\\
Injuries & 2017 & Female & Low & 0.12\\
\addlinespace
Injuries & 2017 & Male & High & 0.40\\
Injuries & 2017 & Male & Upper-Middle & 1.16\\
Injuries & 2017 & Male & Lower-Middle & 1.23\\
Injuries & 2017 & Male & Low & 0.26\\
\addlinespace
Non-communicable diseases & 2017 & Female & High & 4.68\\
Non-communicable diseases & 2017 & Female & Upper-Middle & 7.28\\
Non-communicable diseases & 2017 & Female & Lower-Middle & 6.27\\
Non-communicable diseases & 2017 & Female & Low & 0.92\\
\addlinespace
Non-communicable diseases & 2017 & Male & High & 4.65\\
Non-communicable diseases & 2017 & Male & Upper-Middle & 8.79\\
Non-communicable diseases & 2017 & Male & Lower-Middle & 7.30\\
Non-communicable diseases & 2017 & Male & Low & 1.00\\
\bottomrule
\end{tabular}
\end{table}

\clearpage

## Plot the data

The best way to investigate a dataset is of course to plot it. 
We have added a couple of notes as comments (the lines starting with a `#`) for those who can't wait to get to the next chapter where the code for plotting will be introduced and explained in detail. 
Overall, you shouldn't waste time trying to understand this code here but to look at the different groups within this new dataset.


```r
gbd2017 %>% 
  # without the mutate(... = fct_relevel()) 
  # the panels get ordered alphabetically
  mutate(income = fct_relevel(income,
                              "Low",
                              "Lower-Middle",
                              "Upper-Middle",
                              "High")) %>% 
  # defining the variables using ggplot(aes(...)):
  ggplot(aes(x = sex, y = deaths_millions, fill = cause)) +
  # type of geom to be used: column (that's a type of barplot):
  geom_col(position = "dodge") +
  # facets for the income groups:
  facet_wrap(~income, ncol = 4) +
  # move the legend to the top of the plot (default is "right"):
  theme(legend.position = "top")
```

![(\#fig:chap03-fig-gbd)Global Burden of Disease data with subgroups: cause, sex, World Bank income group.](03_summarising_files/figure-latex/chap03-fig-gbd-1.pdf) 

## Aggregating: `group_by()`, `summarise()`
\index{summarising data@\textbf{summarising data}!aggregation}
\index{functions@\textbf{functions}!group\_by}
\index{functions@\textbf{functions}!summarise}

Health data analysis is frequently concerned with making comparisons between groups. 
Groups of genes, or diseases, or patients, or populations etc.
An easy approach to the comparison of data by a categorical grouping is therefore essential. 

We will introduce very flexible functions from **tidyverse** that you can apply in any setting. 
The examples intentionally get quite involved to demonstrate the different approaches that can be used. 
<!-- We finish by showing how to quickly and easily create summary tables that can be used in your work.  -->

To quickly calculate the total number of deaths in 2017, we can select the column and send it into the `sum()` function:


```r
gbd2017$deaths_millions %>% sum()
```

```
## [1] 55.74
```

But a much cleverer way of summarising data is using the `summarise()` function:


```r
gbd2017 %>% 
  summarise(sum(deaths_millions))
```

```
## # A tibble: 1 x 1
##   `sum(deaths_millions)`
##                    <dbl>
## 1                  55.74
```

This is indeed equal to the number of deaths per year we saw in the previous chapter using the shorter version of this data (Deaths from the three causes were 10.38, 4.47, 40.89 which adds to 55.74).

`sum()` is a function that adds numbers together, whereas `summarise()` is a clever and efficient way of creating summarised tibbles. 
The main strength of `summarise()` is how it works with the `group_by()` function. 
`group_by()` and `summarise()` are like cheese and wine, a perfect complement for each other, seldom seen apart. 

We use `group_by()` to tell `summarise()` which subgroups to apply the calculations on. 
In the above example, without `group_by()`, summarise just works on the whole dataset, yielding the same result as just sending a single column into the `sum()` function. 

We can subset on the cause variable using `group_by()`:


```r
gbd2017 %>% 
  group_by(cause) %>% 
  summarise(sum(deaths_millions))
```

```
## # A tibble: 3 x 2
##   cause                     `sum(deaths_millions)`
##   <chr>                                      <dbl>
## 1 Communicable diseases                      10.38
## 2 Injuries                                    4.47
## 3 Non-communicable diseases                  40.89
```

Furthermore, `group_by()` is happy accept multiple grouping variables. 
So by just copying and editing the above code, we can quickly get summarised totals across multiple grouping variables (by just adding `sex` inside the `group_by()` after `cause`):


```r
gbd2017 %>% 
  group_by(cause, sex) %>% 
  summarise(sum(deaths_millions))
```

```
## # A tibble: 6 x 3
## # Groups:   cause [3]
##   cause                     sex    `sum(deaths_millions)`
##   <chr>                     <chr>                   <dbl>
## 1 Communicable diseases     Female                   4.91
## 2 Communicable diseases     Male                     5.47
## 3 Injuries                  Female                   1.42
## 4 Injuries                  Male                     3.05
## 5 Non-communicable diseases Female                  19.15
## 6 Non-communicable diseases Male                    21.74
```

## Add new columns: `mutate()`
\index{summarising data@\textbf{summarising data}!create columns}
\index{functions@\textbf{functions}!mutate}

We met `mutate()` in the last chapter. 
Let's first give the summarised column a better name, e.g. `deaths_pergroup`. 
We can remove groupings by using `ungroup()`. 
This is important to remember if you want to manipulate the dataset in its original format.
We can combine `ungroup()` with `mutate()` to add a total deaths column, which will be used below to calculate a percentage:


```r
gbd2017 %>% 
  group_by(cause, sex) %>% 
  summarise(deaths_pergroups = sum(deaths_millions)) %>% 
  ungroup() %>% 
  mutate(deaths_total = sum(deaths_pergroups))
```

```
## # A tibble: 6 x 4
##   cause                     sex    deaths_pergroups deaths_total
##   <chr>                     <chr>             <dbl>        <dbl>
## 1 Communicable diseases     Female             4.91        55.74
## 2 Communicable diseases     Male               5.47        55.74
## 3 Injuries                  Female             1.42        55.74
## 4 Injuries                  Male               3.05        55.74
## 5 Non-communicable diseases Female            19.15        55.74
## 6 Non-communicable diseases Male              21.74        55.74
```

### Percentages formatting: `percent()`
\index{functions@\textbf{functions}!percent}

So `summarise()` condenses a tibble, whereas `mutate()` retains it's current size and adds columns. 
We can also further lines to `mutate()` to calculate the percentage of each group:


```r
# percent() function for formatting percentages come from library(scales)
library(scales)
gbd2017 %>% 
  group_by(cause, sex) %>% 
  summarise(deaths_pergroups = sum(deaths_millions)) %>% 
  ungroup() %>% 
  mutate(deaths_total    = sum(deaths_pergroups),
         deaths_relative = percent(deaths_pergroups/deaths_total))
```

```
## # A tibble: 6 x 5
##   cause                     sex    deaths_pergroups deaths_total deaths_relative
##   <chr>                     <chr>             <dbl>        <dbl> <chr>          
## 1 Communicable diseases     Female             4.91        55.74 8.8%           
## 2 Communicable diseases     Male               5.47        55.74 9.8%           
## 3 Injuries                  Female             1.42        55.74 2.5%           
## 4 Injuries                  Male               3.05        55.74 5.5%           
## 5 Non-communicable diseases Female            19.15        55.74 34.4%          
## 6 Non-communicable diseases Male              21.74        55.74 39.0%
```

The `percent()` function comes from `library(scales)` and is a very handy way of formatting percentages
You must keep in mind that it changes the column from a number (denoted `<dbl>`) to a character (`<chr>`). 
The `percent()` function is equivalent to:


```r
# using values from the first row as an example:
round(100*4.91/55.74, 1) %>% paste0("%")
```

```
## [1] "8.8%"
```

This is very convenient for final presentation of number, but if you intend to do further calculations/plot/sort the percentages just calculate them as fractions with:


```r
mydata %>% 
  mutate(deaths_relative = deaths_pergroups/deaths_total)
```

and convert to nicely formatted percentages later:


```r
mydata %>% 
  mutate(deaths_percentage = percent(deaths_relative))
```

## `summarise()` vs `mutate()`

So far we've shown you examples of using `summarise()` on grouped data (so following `group_by()`) and `mutate()` on the whole dataset (either without using `group_by()` at all, or resetting the grouping information with `ungroup()`).

But here's the thing: `mutate()` is also happy to work on grouped data.

Let's save the aggregated example from above in a new tibble.
We will then sort the rows using `arrange()` based on `sex`, just for easier viewing (it was previously sorted by `cause`).

The `arrange()` function sorts the rows within a tibble:


```r
gbd_summarised = gbd2017 %>% 
  group_by(cause, sex) %>% 
  summarise(deaths_pergroups = sum(deaths_millions)) %>% 
  arrange(sex)

gbd_summarised
```

```
## # A tibble: 6 x 3
## # Groups:   cause [3]
##   cause                     sex    deaths_pergroups
##   <chr>                     <chr>             <dbl>
## 1 Communicable diseases     Female             4.91
## 2 Injuries                  Female             1.42
## 3 Non-communicable diseases Female            19.15
## 4 Communicable diseases     Male               5.47
## 5 Injuries                  Male               3.05
## 6 Non-communicable diseases Male              21.74
```

You should also notice that `summarise()` drops all variables that are not listed in `group_by()` or created inside it. 
So `year`, `income`, and `deaths_millions` exist in `gbd2017`, but they do not exist in `gbd_summarised`.

We now want to calculate the percentage of deaths from each cause for each gender. 
We could use `summarise()` to calculate the totals:


```r
gbd_summarised_sex =
  gbd_summarised %>% 
  group_by(sex) %>% 
  summarise(deaths_persex = sum(deaths_pergroups))

gbd_summarised_sex
```

```
## # A tibble: 2 x 2
##   sex    deaths_persex
##   <chr>          <dbl>
## 1 Female         25.48
## 2 Male           30.26
```

But that drops the `cause` and `deaths_pergroups` columns. 
One way would be to now use a join on `gbd_summarised` and `gbd_summarised_sex`:


```r
full_join(gbd_summarised, gbd_summarised_sex)
```

```
## Joining, by = "sex"
```

```
## # A tibble: 6 x 4
## # Groups:   cause [3]
##   cause                     sex    deaths_pergroups deaths_persex
##   <chr>                     <chr>             <dbl>         <dbl>
## 1 Communicable diseases     Female             4.91         25.48
## 2 Injuries                  Female             1.42         25.48
## 3 Non-communicable diseases Female            19.15         25.48
## 4 Communicable diseases     Male               5.47         30.26
## 5 Injuries                  Male               3.05         30.26
## 6 Non-communicable diseases Male              21.74         30.26
```

Joining different summaries together can be useful, especially if the individual pipelines are quite long (e.g., over 5 lines of `%>%`).
However, it does increase the chance of mistakes creeping in and is best avoided if possible. 

An alternative is to use `mutate()` with `group_by()` to achieve the same result as the `full_join()` above:


```r
gbd_summarised %>% 
  group_by(sex) %>% 
  mutate(deaths_persex = sum(deaths_pergroups))
```

```
## # A tibble: 6 x 4
## # Groups:   sex [2]
##   cause                     sex    deaths_pergroups deaths_persex
##   <chr>                     <chr>             <dbl>         <dbl>
## 1 Communicable diseases     Female             4.91         25.48
## 2 Injuries                  Female             1.42         25.48
## 3 Non-communicable diseases Female            19.15         25.48
## 4 Communicable diseases     Male               5.47         30.26
## 5 Injuries                  Male               3.05         30.26
## 6 Non-communicable diseases Male              21.74         30.26
```

So `mutate()` calculates the sums within each grouping variable (in this example just `group_by(sex)`) and puts the results in a new column without condensing the tibble down or removing any of the existing columns.

Let's combine all of this together into a single pipeline and calculate the percentages per cause for each gender:


```r
gbd2017 %>% 
  group_by(cause, sex) %>% 
  summarise(deaths_pergroups = sum(deaths_millions)) %>% 
  group_by(sex) %>% 
  mutate(deaths_persex  = sum(deaths_pergroups),
         sex_cause_perc = percent(deaths_pergroups/deaths_persex)) %>% 
  arrange(sex, deaths_pergroups)
```

```
## # A tibble: 6 x 5
## # Groups:   sex [2]
##   cause                     sex    deaths_pergroups deaths_persex sex_cause_perc
##   <chr>                     <chr>             <dbl>         <dbl> <chr>         
## 1 Injuries                  Female             1.42         25.48 6%            
## 2 Communicable diseases     Female             4.91         25.48 19%           
## 3 Non-communicable diseases Female            19.15         25.48 75%           
## 4 Injuries                  Male               3.05         30.26 10.1%         
## 5 Communicable diseases     Male               5.47         30.26 18.1%         
## 6 Non-communicable diseases Male              21.74         30.26 71.8%
```

## Common arithmetic functions - `sum()`, `mean()`, `median()`, etc.
\index{functions@\textbf{functions}!arithmetic}
\index{summarising data@\textbf{summarising data}!arithmetic functions}

Statistics is what R does, so if there is a statistical function you can think of, it will exist in R.

The most common ones are:

* `sum()`
* `mean()`
* `median()`
* `min()`, `max()`
* `sd()` - standard deviation
* `IQR()` - inter-quartile range


The import thing to remember about all of these is that if any of the values is NA (not applicable/not available), these functions will return an NA. 
Either deal with your missing values beforehand (recommended) or add the `na.rm = TRUE` argument into any of the above functions to ask R to ignore missing values. 
More discussion and examples around missing data can be found in Chapters \@ref(r-basics) and \@ref(chap14-h1).


```r
mynumbers = c(1, 2, NA)
sum(mynumbers)
```

```
## [1] NA
```

```r
sum(mynumbers, na.rm = TRUE)
```

```
## [1] 3
```

Overall, R's unwillingness to implicitly average over observations with missing values should be considered helpful, not an unnecessary pain. 
If you don't know exactly where your missing values are/how many, you might end up comparing the averages of very different groups (if the values are not missing and random or the sample size is small). 
So the `na.rm = TRUE` is fine to use if quickly exploring and cleaning data, or you've already investigated missing values and are convinced the existing ones are representative.
But it is rightfully not a default so get used to typing `na.rm = TRUE` when using these functions.

## Reshaping data - long vs wide format
\index{summarising data@\textbf{summarising data}!long vs wide data}

So far, all of the example we've shown you have been using 'tidy' data. 
Data is 'long' when *each variable is in its own column*, and *each observation is in its own row*. 
This long format is efficient to use in data analysis and visualisation and can also be considered "computer readable".

But sometimes when presenting data in tables for humans to read, or when collecting data directly into a spreadsheet, it can be convenient to have data in a wide format. 
Data is 'wide' when *some or all of columns are levels of a factor*.
An example makes this easier to see. 


```r
gbd_wide = read_csv("data/global_burden_disease_wide-format.csv")
gbd_long = read_csv("data/global_burden_disease_cause-year-sex.csv")
```


\begin{table}[!h]

\caption{(\#tab:chap3-tab-gbd-wide)Global Burden of Disease data in human-readable wide format. This is not tidy data.}
\centering
\resizebox{\linewidth}{!}{
\begin{tabular}[t]{lcccc}
\toprule
cause & Female-1990 & Female-2017 & Male-1990 & Male-2017\\
\midrule
Communicable diseases & 7.30 & 4.91 & 8.06 & 5.47\\
Injuries & 1.41 & 1.42 & 2.84 & 3.05\\
Non-communicable diseases & 12.80 & 19.15 & 13.91 & 21.74\\
\bottomrule
\end{tabular}}
\end{table}

\begin{table}[!h]

\caption{(\#tab:chap3-tab-gbd-long)Global Burden of Disease data in analysis-friendly long format. This is tidy data.}
\centering
\fontsize{10}{12}\selectfont
\begin{tabular}[t]{lccc}
\toprule
cause & year & sex & deaths\_millions\\
\midrule
Communicable diseases & 1990 & Female & 7.30\\
Communicable diseases & 2017 & Female & 4.91\\
Communicable diseases & 1990 & Male & 8.06\\
Communicable diseases & 2017 & Male & 5.47\\
\addlinespace
Injuries & 1990 & Female & 1.41\\
Injuries & 2017 & Female & 1.42\\
Injuries & 1990 & Male & 2.84\\
Injuries & 2017 & Male & 3.05\\
\addlinespace
Non-communicable diseases & 1990 & Female & 12.80\\
Non-communicable diseases & 2017 & Female & 19.15\\
Non-communicable diseases & 1990 & Male & 13.91\\
Non-communicable diseases & 2017 & Male & 21.74\\
\bottomrule
\end{tabular}
\end{table}

Tables \@ref(tab:chap3-tab-gbd-long) and \@ref(tab:chap3-tab-gbd-wide) contain the exact same information, but in long (tidy) and wide formats, respectively.


\begin{figure}
\includegraphics[width=40.46in]{images/wide_long} \caption{Same data in the long ('tidy', necessary for efficient analysis) and wide (easier for human-readability/presentation/manual data entry) formats. TODO: replace with updated data.}(\#fig:unnamed-chunk-20)
\end{figure}

\clearpage 

### `spread()` values from rows into columns
\index{summarising data@\textbf{summarising data}!convert long to wide}
\index{functions@\textbf{functions}!spread}

If we want to take the long data from \@ref(tab:chap3-tab-gbd-long) and put some of the numbers next to each other for easier visualisation, then `spread()` is the function to do it. 
It means we want to spread a variable into columns, and it needs just two arguments: the column we want to spread, and the column where the values are.



```r
gbd_long %>% 
  spread(year, deaths_millions)
```

```
## # A tibble: 6 x 4
##   cause                     sex    `1990` `2017`
##   <chr>                     <chr>   <dbl>  <dbl>
## 1 Communicable diseases     Female   7.3    4.91
## 2 Communicable diseases     Male     8.06   5.47
## 3 Injuries                  Female   1.41   1.42
## 4 Injuries                  Male     2.84   3.05
## 5 Non-communicable diseases Female  12.8   19.15
## 6 Non-communicable diseases Male    13.91  21.74
```


In this example, we are sending `gbd_long` into the `spread(year, deaths_millions)` to put the year variable into different columns. The values to fill the new columns with are `deaths_millions`.

This means we can quickly eyeball how the number of deaths have changed from 1990 to 2017 for each cause category and sex.
Whereas if we wanted to quickly look at the difference in the number of deaths for Females and Males, we can just the `sex` variable instead, so `spread(sex, deaths_millions)`. Furthermore, we can now add a `mutate()` to show this difference in a new column:



```r
gbd_long %>% 
  spread(sex, deaths_millions) %>% 
  mutate(Male - Female)
```

```
## # A tibble: 6 x 5
##   cause                      year Female  Male `Male - Female`
##   <chr>                     <dbl>  <dbl> <dbl>           <dbl>
## 1 Communicable diseases      1990   7.3   8.06          0.76  
## 2 Communicable diseases      2017   4.91  5.47          0.5600
## 3 Injuries                   1990   1.41  2.84          1.430 
## 4 Injuries                   2017   1.42  3.05          1.63  
## 5 Non-communicable diseases  1990  12.8  13.91          1.110 
## 6 Non-communicable diseases  2017  19.15 21.74          2.59
```

All of these differences are positive which means every year, more men die than women.
Which make sense, as more boys are born than girls.

And what if we want to spread both `year` and `sex` at the same time, so to create table \@ref(tab:chap3-tab-gbd-wide) from  Table \@ref(tab:chap3-tab-gbd-long)?
`spread()` can only accept two arguments. 
First is the variable to be spread to columns. 
Second is the values to used. 
Therefore, to spread by two columns we need to combine them beforehand.
This is what the `unite()` function is for:


```r
gbd_long %>% 
  unite(sex_year, c(sex, year)) %>% 
  slice(1:2)
```

```
## # A tibble: 2 x 3
##   cause                 sex_year    deaths_millions
##   <chr>                 <chr>                 <dbl>
## 1 Communicable diseases Female_1990            7.3 
## 2 Communicable diseases Female_2017            4.91
```

We are using the `slice(1:2)` to select the first two rows - just for efficient printing (`:` in R is a shorthand for creating sequential numbers, e.g. `1:4` is 1, 2, 3, 4).


We can then `spread()` the united column:

```r
gbd_long %>% 
  unite(sex_year, c(sex, year)) %>% 
  spread(sex_year, deaths_millions)
```

```
## # A tibble: 3 x 5
##   cause                     Female_1990 Female_2017 Male_1990 Male_2017
##   <chr>                           <dbl>       <dbl>     <dbl>     <dbl>
## 1 Communicable diseases            7.3         4.91      8.06      5.47
## 2 Injuries                         1.41        1.42      2.84      3.05
## 3 Non-communicable diseases       12.8        19.15     13.91     21.74
```

Both `spread()` and `unite()` have a few optional arguments that you may be useful for you. 
For example, `spread(..., fill = 0)` is used to fill empty cells (default is `fill = NA`).
Or `unite(..., sep = " ")` can be used to change the separator that gets put between the values (e.g. you may want "Female-1990" or "Female: 1990" instead of the default "_").
Remember that pressing F1 when your cursor is on a function opens it up in the Help tab where these extra options are listed.

The `unite()` is a very convenient function for pasting values from multiple columns together, but if you want to do something more special (e.g. also round numbers or add different separators between multiple different columns), then the `paste()` function inside `mutate()` will give you that extra flexibility and control.

For example, this:

```r
gbd_long %>% 
  unite(sex_year, c(sex, year)) %>% 
  slice(1)
```

```
## # A tibble: 1 x 3
##   cause                 sex_year    deaths_millions
##   <chr>                 <chr>                 <dbl>
## 1 Communicable diseases Female_1990             7.3
```

is similar to:

```r
gbd_long %>% 
  mutate(sex_year = paste(sex, year, sep = "_")) %>% 
  slice(1)
```

```
## # A tibble: 1 x 5
##   cause                  year sex    deaths_millions sex_year   
##   <chr>                 <dbl> <chr>            <dbl> <chr>      
## 1 Communicable diseases  1990 Female             7.3 Female_1990
```

They're similar but not exactly the same as `unite()` drops the original columns (and only keeps the new united one), whereas `mutate()` creates a new column and keeps all existing ones as well. 

To make them equivalent, you could either add `drop = FALSE` inside `unite()` (keeping all columns) or `%>% select(-sex, -year)` after the `mutate()` (to drop/deselect these).

### `gather()` values from columns to rows
\index{summarising data@\textbf{summarising data}!convert wide to long}
\index{functions@\textbf{functions}!gather}

The opposite of `spread()` is `gather()`. 
If you're lucky enough, your data comes from a proper database and is already in the long and tidy format. 
But if you do get landed with something that looks like the Table \@ref(tab:chap3-tab-gbd-wide), you'll need to know how to gather and separate the variables currently spread across different columns into the tidy format (each column is a variable, each row is an observation).

We could try and run `gather()` without any extra arguments (again, using slice(1:6) just for shorter printing, the first 6 lines this time):

```r
gbd_wide %>% 
  gather() %>% 
  slice(1:6)
```

```
## # A tibble: 6 x 2
##   key         value                    
##   <chr>       <chr>                    
## 1 cause       Communicable diseases    
## 2 cause       Injuries                 
## 3 cause       Non-communicable diseases
## 4 Female-1990 7.3                      
## 5 Female-1990 1.41                     
## 6 Female-1990 12.8
```

So it gathers all column names into a new variable called `key`, and puts everything in the rows into a column called `value`.
However, the `cause` variable already was how we wanted it - in a column of its own, so we don't want this gathered together the `deaths_millions` values.
So we can tell `gather()` to leave it where it is:



```r
gbd_wide %>% 
  gather(sex_year, deaths_millions, -cause) %>% 
  slice(1:6)
```

```
## # A tibble: 6 x 3
##   cause                     sex_year    deaths_millions
##   <chr>                     <chr>                 <dbl>
## 1 Communicable diseases     Female-1990            7.3 
## 2 Injuries                  Female-1990            1.41
## 3 Non-communicable diseases Female-1990           12.8 
## 4 Communicable diseases     Female-2017            4.91
## 5 Injuries                  Female-2017            1.42
## 6 Non-communicable diseases Female-2017           19.15
```

Now there, because selection (or deselection) of columns needs to be the fourth argument to `gather()` (first on is the data that gets piped - %>% in, second and third the names of the new columns), we also need to include the names of the new columns before we can specify that we want `-cause` to stay where it is. 

And finally, we need to use `separate()` to put `sex` and `year` into their own columns:

```r
gbd_wide %>% 
  gather(sex_year, deaths_millions, -cause) %>% 
  separate(sex_year, into = c("sex", "year"), convert = TRUE) %>% 
  slice(1:6)
```

```
## # A tibble: 6 x 4
##   cause                     sex     year deaths_millions
##   <chr>                     <chr>  <int>           <dbl>
## 1 Communicable diseases     Female  1990            7.3 
## 2 Injuries                  Female  1990            1.41
## 3 Non-communicable diseases Female  1990           12.8 
## 4 Communicable diseases     Female  2017            4.91
## 5 Injuries                  Female  2017            1.42
## 6 Non-communicable diseases Female  2017           19.15
```

It is important to notice the quotes around the new column names: `into = c("sex", "year")`. Most tidyverse functions don't want to use use quotes around column names, so this can be confusing.

We've also added `convert = TRUE` to `separate()` so `year` would get converted into a numeric variable.
The combination of, e.g., "Female-1990" is a character variable, so after separating them both `sex` and `year` would still be classified as characters. 
But the `convert = TRUE` recognises that `year` is a number and will appropriately convert it into an integer.

When working with large datasets with a lot of columns that need gathering, then the `select()` helpers are extremely useful.

## `select()` columns
\index{summarising data@\textbf{summarising data}!select columns}
\index{functions@\textbf{functions}!select}

The `select()` function can be used to choose, rename or reorder columns of a tibble.

For the following `select()` examples, let's create a new tibble called `gbd_2rows` by taking the first 2 rows of `gbd_full` (just for shorter printing):


```r
gbd_2rows = gbd_full %>% 
  slice(1:2)

gbd_2rows
```

```
## # A tibble: 2 x 5
##   cause                  year sex    income       deaths_millions
##   <chr>                 <dbl> <chr>  <chr>                  <dbl>
## 1 Communicable diseases  1990 Female High                   0.21 
## 2 Communicable diseases  1990 Female Upper-Middle           1.150
```

Let's `select()` two of these columns:


```r
gbd_2rows %>% 
  select(cause, deaths_millions)
```

```
## # A tibble: 2 x 2
##   cause                 deaths_millions
##   <chr>                           <dbl>
## 1 Communicable diseases           0.21 
## 2 Communicable diseases           1.150
```

We can also use `select()` to rename the columns we are choosing:


```r
gbd_2rows %>% 
  select(cause, deaths = deaths_millions)
```

```
## # A tibble: 2 x 2
##   cause                 deaths
##   <chr>                  <dbl>
## 1 Communicable diseases  0.21 
## 2 Communicable diseases  1.150
```

There function `rename()` is similar to `select()`, but it keeps all variables whereas `select()` only kept the ones we mentioned:


```r
gbd_2rows %>% 
  rename(deaths = deaths_millions)
```

```
## # A tibble: 2 x 5
##   cause                  year sex    income       deaths
##   <chr>                 <dbl> <chr>  <chr>         <dbl>
## 1 Communicable diseases  1990 Female High          0.21 
## 2 Communicable diseases  1990 Female Upper-Middle  1.150
```

`select()` can also be used to reorder the columns in your tibble. Moving columns around is not relevant in data analysis (as any of the functions we showed you above, as well as plotting, only look at the column names, and not their positions in the tibble), but it is useful for organising your tibble for easier viewing.

So if we use select like this:


```r
gbd_2rows %>% 
  select(year, sex, income, cause, deaths_millions)
```

```
## # A tibble: 2 x 5
##    year sex    income       cause                 deaths_millions
##   <dbl> <chr>  <chr>        <chr>                           <dbl>
## 1  1990 Female High         Communicable diseases           0.21 
## 2  1990 Female Upper-Middle Communicable diseases           1.150
```

The columns are reordered.

If you want to move specific column(s) to the front to the tibble, do:


```r
gbd_2rows %>% 
  select(year, sex, everything())
```

```
## # A tibble: 2 x 5
##    year sex    cause                 income       deaths_millions
##   <dbl> <chr>  <chr>                 <chr>                  <dbl>
## 1  1990 Female Communicable diseases High                   0.21 
## 2  1990 Female Communicable diseases Upper-Middle           1.150
```

And this is where the true power of `select()` starts to come out.
In addition to listing the columns explicitly (e.g., `mydata %>% select(year, cause...)`) there are several special functions that can be used inside `select()`.
These special functions are called select helpers, and the first select helper we used is `everything()`.

The most common select helpers are `starts_with()`/`ends_with()` and `matches()` (but there are several others that may be useful to you, so press F1 on `select()` for a full list, or search the web for more examples).

<!-- ADD contains() above? -->

Let's say you can remember, whether the deaths column was called `deaths_millions` or just `deaths` or `deaths_mil`, or maybe there are other columns that include the word "deaths" that you want to `select()`:


```r
gbd_2rows %>% 
  select(starts_with("deaths"))
```

```
## # A tibble: 2 x 1
##   deaths_millions
##             <dbl>
## 1           0.21 
## 2           1.150
```

Note how "deaths" needs to be quoted inside `starts_with()` - as it's a word to look for, not the real name of a column/variable.

### Using select helpers in other functions
\index{summarising data@\textbf{summarising data}!select helpers}

The select helpers may seem a bit extra in the simple example above, but they become invaluable when working with, for example, biobank data - as you'll be landed with hundreds of columns, often named something like hosp_ep_01, hosp_ep_02, hosp_ep_03, hosp_ep_04, hosp_ep_05, hosp_ep_06..., so `starts_with("hosp_ep")` can really become your new best friend.

Furthermore, the select helpers can be used in some of the other tidyverse functions as well, namely `mutate_at()`, `summarise_at()`, and especially `gather()`:


```r
# made-up biobank-like tibble:
gather_helperdata  = tibble(id = "ID-1",
                            already = "Yes",
                            tidy = TRUE,
                            hosp_ep_01 = "Y92.241",
                            hosp_ep_02 = "W61.43",
                            hosp_ep_03 = "V91.07",
                            hosp_ep_04 = "V95.43")

gather_helperdata
```

```
## # A tibble: 1 x 7
##   id    already tidy  hosp_ep_01 hosp_ep_02 hosp_ep_03 hosp_ep_04
##   <chr> <chr>   <lgl> <chr>      <chr>      <chr>      <chr>     
## 1 ID-1  Yes     TRUE  Y92.241    W61.43     V91.07     V95.43
```

```r
gather_helperdata %>%
  gather(episode, diagnosis, starts_with("hosp_ep"))
```

```
## # A tibble: 4 x 5
##   id    already tidy  episode    diagnosis
##   <chr> <chr>   <lgl> <chr>      <chr>    
## 1 ID-1  Yes     TRUE  hosp_ep_01 Y92.241  
## 2 ID-1  Yes     TRUE  hosp_ep_02 W61.43   
## 3 ID-1  Yes     TRUE  hosp_ep_03 V91.07   
## 4 ID-1  Yes     TRUE  hosp_ep_04 V95.43
```

## `arrange()` rows
\index{summarising data@\textbf{summarising data}!arrange / order rows}
\index{functions@\textbf{functions}!arrange}

The `arrange()` functions sorts rows based on the column(s) you want. By default, it arranges the tibble ascending order:


```r
gbd_long %>% 
  arrange(deaths_millions) %>% 
  # first 3 rows just for printing:
  slice(1:3)
```

```
## # A tibble: 3 x 4
##   cause     year sex    deaths_millions
##   <chr>    <dbl> <chr>            <dbl>
## 1 Injuries  1990 Female            1.41
## 2 Injuries  2017 Female            1.42
## 3 Injuries  1990 Male              2.84
```

For numeric variables, we can just use a `-` to sort in descending order:


```r
gbd_long %>% 
  arrange(-deaths_millions) %>% 
  slice(1:3)
```

```
## # A tibble: 3 x 4
##   cause                      year sex    deaths_millions
##   <chr>                     <dbl> <chr>            <dbl>
## 1 Non-communicable diseases  2017 Male             21.74
## 2 Non-communicable diseases  2017 Female           19.15
## 3 Non-communicable diseases  1990 Male             13.91
```

Whereas the `-` doesn't work for categorical variables, they need to be put in `desc()` for arranging in descending order:


```r
gbd_long %>% 
  arrange(desc(sex)) %>% 
  # printing rows 1, 2, 11, and 12
  slice(1,2, 11, 12)
```

```
## # A tibble: 4 x 4
##   cause                      year sex    deaths_millions
##   <chr>                     <dbl> <chr>            <dbl>
## 1 Communicable diseases      1990 Male              8.06
## 2 Communicable diseases      2017 Male              5.47
## 3 Non-communicable diseases  1990 Female           12.8 
## 4 Non-communicable diseases  2017 Female           19.15
```

### factor levels
\index{summarising data@\textbf{summarising data}!factor levels}
\index{functions@\textbf{functions}!fct\_relevel}
\index{functions@\textbf{functions}!levels}

`arrange()` sorts characters alphabetically, whereas factors will be sorted by the order of their levels. 
Let's make the cause column into a factor:



```r
gbd_factored = gbd_long %>% 
  mutate(cause = factor(cause))
```

When we first create a factor, its levels will be ordered alphabetically:


```r
gbd_factored$cause %>% levels()
```

```
## [1] "Communicable diseases"     "Injuries"                 
## [3] "Non-communicable diseases"
```

But we can now use `fct_relevel()` inside `mutate()` to change the order of these levels:


```r
gbd_factored = gbd_factored %>% 
  mutate(cause = cause %>% 
           fct_relevel("Injuries"))

gbd_factored$cause %>% levels()
```

```
## [1] "Injuries"                  "Communicable diseases"    
## [3] "Non-communicable diseases"
```

`fct_relevel()` brings the level(s) listed in it to the front.

So if we use `arrange()` on `gbd_factored`, the `cause` column will be sorted based on the order of its levels, not alphabetically.
This is especially useful in two places:

* plotting - categorical variables that are characters will be ordered alphabetically (e.g., think barplots), regardless of whether the rows are arranged or not;
* statistical tests - the reference level of categorical variables that are characters is the alphabetically first (e.g., what the odds ratio is relative to).

However, making a character column into a factor gives us power to give its levels a non-alphabetical order, giving us control over plotting order or defining our reference levels for use in statistical tests.

## Exercise - `spread()`

Using the GBD dataset with variables `cause`, `year` (1990 and 2017 only), `sex` (as shown in Table \@ref(tab:chap3-tab-gbd-long)):


```r
gbd_long = read_csv("data/global_burden_disease_cause-year-sex.csv")
```

Spread the `cause` variable into columns using the `deaths_millions` as values:

\begin{table}[!h]

\caption{(\#tab:unnamed-chunk-45)Exercise: putting the cause variable into the wide format using spread.}
\centering
\resizebox{\linewidth}{!}{
\begin{tabular}[t]{lcccc}
\toprule
year & sex & Communicable diseases & Injuries & Non-communicable diseases\\
\midrule
1990 & Female & 7.30 & 1.41 & 12.80\\
1990 & Male & 8.06 & 2.84 & 13.91\\
2017 & Female & 4.91 & 1.42 & 19.15\\
2017 & Male & 5.47 & 3.05 & 21.74\\
\bottomrule
\end{tabular}}
\end{table}

**Solution**


```r
gbd_long = read_csv("data/global_burden_disease_cause-year-sex.csv")
gbd_long %>% 
  spread(cause, deaths_millions) 
```

## Exercise - `group_by()`, `summarise()`

Read in the full GBD dataset with variables `cause`, `year`, `sex`, `income`, `deaths_millions`.


```r
gbd_full = read_csv("data/global_burden_disease_cause-year-sex-income.csv")

glimpse(gbd_full)
```

```
## Observations: 168
## Variables: 5
## $ cause           <chr> "Communicable diseases", "Communicable diseases", "...
## $ year            <dbl> 1990, 1990, 1990, 1990, 1990, 1990, 1990, 1990, 199...
## $ sex             <chr> "Female", "Female", "Female", "Female", "Male", "Ma...
## $ income          <chr> "High", "Upper-Middle", "Lower-Middle", "Low", "Hig...
## $ deaths_millions <dbl> 0.21, 1.15, 4.43, 1.51, 0.26, 1.35, 4.73, 1.72, 0.2...
```

Year 2017 of this dataset was shown in Table \@ref(tab:chap3-tab-gbd2017), the full dataset has seven times as many observations as Table \@ref(tab:chap3-tab-gbd2017) since it includes information about multiple years: 1990, 1995, 2000, 2005, 2010, 2015, 2017.

Investigate these code examples:


```r
summary_data1 = 
  gbd_full %>% 
  group_by(year) %>% 
  summarise(total_per_year = sum(deaths_millions))

summary_data1
```

```
## # A tibble: 7 x 2
##    year total_per_year
##   <dbl>          <dbl>
## 1  1990          46.32
## 2  1995          48.91
## 3  2000          50.38
## 4  2005          51.25
## 5  2010          52.63
## 6  2015          54.62
## 7  2017          55.74
```

```r
summary_data2 = 
  gbd_full %>% 
  group_by(year, cause) %>% 
  summarise(total_per_cause = sum(deaths_millions))

summary_data2
```

```
## # A tibble: 21 x 3
## # Groups:   year [7]
##     year cause                     total_per_cause
##    <dbl> <chr>                               <dbl>
##  1  1990 Communicable diseases               15.36
##  2  1990 Injuries                             4.25
##  3  1990 Non-communicable diseases           26.71
##  4  1995 Communicable diseases               15.11
##  5  1995 Injuries                             4.53
##  6  1995 Non-communicable diseases           29.27
##  7  2000 Communicable diseases               14.81
##  8  2000 Injuries                             4.56
##  9  2000 Non-communicable diseases           31.01
## 10  2005 Communicable diseases               13.89
## # ... with 11 more rows
```

You should recognise that:

* `summary_data1` includes the total number of deaths per year.
* `summary_data2` includes the number of deaths per cause per year.
* `summary_data1 =` means we are creating a new tibble called `summary_data1` and saving (=) results into it. If `summary_data1` was a tibble that already existed, it would get overwritten.
* `gbd_full` is the data being sent to the `group_by()` and then `summarise()` functions.
* `group_by()` tells `summarise()` that we want aggregated results for each year.
* `summarise()` then creates a new variable called `total_per_year` that sums the deaths from each different observation (subcategory) together.
* Calling `summary_data1` on a separate line gets it printed.
* We then do something very similar in `summary_data2`.

Compare the number of rows (observations) and number of columns (variables) of `gbd_full`, `summary_data1`, and `summary_data2`.

You should notice that:
* `summary_data2` has exactly 3 times as many rows (observations) as `summary_data1`. Why?
* `gbd_full` has 5 variables, whereas the summarised tibbles have 2 and 3. Which variables got dropped? How?

**Answers**

* `gbd_full` has 168 observations (rows), 
* `summary_data1` has 7,
* `summary_data2` has 21.

`summary_data1` was grouped by year, therefore it includes a (summarised) value for each year in the original dataset.
`summary_data2` was grouped by year and cause (Communicable diseases, Injuries, Non-communicable diseases), so it has 3 values for each year.

The columns a `summarise()` function returns are: variables listed in `group_by()` + variables created inside `summarise()` (e.g., in this case `deaths_peryear`). All others get aggregated.

## Exercise - `full_join()`, `percent()`

For each cause, calculate its percentage to total deaths in each year.

Hint: Use `full_join()` on `summary_data1` and `summary_data2`, and then use `mutate()` to add a new column called `percentage`.

Example result for a single year:


```
## Joining, by = "year"
```

```
## # A tibble: 3 x 5
##    year total_per_year cause                     total_per_cause percentage
##   <dbl>          <dbl> <chr>                               <dbl> <chr>     
## 1  1990          46.32 Communicable diseases               15.36 33.161%   
## 2  1990          46.32 Injuries                             4.25 9.175%    
## 3  1990          46.32 Non-communicable diseases           26.71 57.664%
```

**Solution**


```
## Joining, by = "year"
```

```
## # A tibble: 21 x 5
##     year total_per_year cause                     total_per_cause percentage
##    <dbl>          <dbl> <chr>                               <dbl> <chr>     
##  1  1990          46.32 Communicable diseases               15.36 33.161%   
##  2  1990          46.32 Injuries                             4.25 9.175%    
##  3  1990          46.32 Non-communicable diseases           26.71 57.664%   
##  4  1995          48.91 Communicable diseases               15.11 30.893%   
##  5  1995          48.91 Injuries                             4.53 9.262%    
##  6  1995          48.91 Non-communicable diseases           29.27 59.845%   
##  7  2000          50.38 Communicable diseases               14.81 29.397%   
##  8  2000          50.38 Injuries                             4.56 9.051%    
##  9  2000          50.38 Non-communicable diseases           31.01 61.552%   
## 10  2005          51.25 Communicable diseases               13.89 27.102%   
## # ... with 11 more rows
```

## Exercise - `mutate()`, `summarise()`

Instead of creating the two summarised tibbles and using a `full_join()`, achieve the same result as in the previous Exercise by with a single pipeline using `summarise()` and then `mutate()`.

Hint: you have to do it the either way round, so `group_by(year, cause) %>% summarise(...)` first, then `group_by(year) %>% mutate()`.

Bonus: `select()` columns `year`, `cause`, `percentage`, then `spread()` the `cause` variable using `percentage` as values.

**Solution**


```r
gbd_full %>% 
  # aggregate to deaths per cause per year using summarise()
  group_by(year, cause) %>% 
  summarise(total_per_cause = sum(deaths_millions)) %>% 
  # then add a column of yearly totals using mutate()
  group_by(year) %>% 
  mutate(total_per_year = sum(total_per_cause)) %>% 
  # add the percentage column
  mutate(percentage = percent(total_per_cause/total_per_year)) %>% 
  # select the final variables and spread for better vieweing
  select(year, cause, percentage) %>% 
  spread(cause, percentage)
```

```
## # A tibble: 7 x 4
## # Groups:   year [7]
##    year `Communicable diseases` Injuries `Non-communicable diseases`
##   <dbl> <chr>                   <chr>    <chr>                      
## 1  1990 33%                     9%       58%                        
## 2  1995 31%                     9%       60%                        
## 3  2000 29%                     9%       62%                        
## 4  2005 27%                     9%       64%                        
## 5  2010 24%                     9%       67%                        
## 6  2015 20%                     8%       72%                        
## 7  2017 19%                     8%       73%
```


Note that your pipelines shouldn't be much longer than this, and we often save interim results into separate tibbles for checking (like we did with `summary_data1` and `summary_data2`, making sure the number of rows are what we expect and spot checking that the calculation worked as expected).

> R doesn't do what you want it to do, it does what you ask it to do. Testing and spot checking is essential as you will make mistakes. We sure do.

Do not feel like you should be able to just bash out these clever pipelines without a lot of trial and error first.


## Exercise - `filter()`, `summarise()`, `spread()`

Still working with `gbd_full`:

* Filter for 1990.
* Calculate the total number of deaths in the different income groups (High, Upper-Middle, Lower-Middle, Low). Hint: use `group_by(income)` and `summarise(new_column_name = sum(variable))`.
* Calculate the total number of deaths within each income group for males and females. Hint: this is as easy as adding `, sex` to `group_by(income)`.

* `spread()` the `income` column.

**Solution**


```r
gbd_full %>% 
  filter(year == 1990) %>% 
  group_by(income, sex) %>% 
  summarise(total_deaths = sum(deaths_millions)) %>% 
  spread(income, total_deaths)
```

```
## # A tibble: 2 x 5
##   sex     High   Low `Lower-Middle` `Upper-Middle`
##   <chr>  <dbl> <dbl>          <dbl>          <dbl>
## 1 Female 4.140  2.22           8.47          6.68 
## 2 Male   4.46   2.57           9.83          7.950
```
