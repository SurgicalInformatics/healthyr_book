# Tests for categorical variables

## Data
We are now changing to a new dataset: melanoma. Click on mydata in your Environment and have a look at the values - you'll see that categorical variables are coded as numbers, rather than text. You will need to recode these numbers into proper factors. 


```r
library(tidyverse)
library(summarizer)
library(broom)
mydata = boot::melanoma
```

### Recap on factors

Press F1 on `boot::melanoma` to see its description. Use the information from help to change the numbers (e.g. 0 - female, 1 - male) into proper factors.


```r
mydata$status %>% 
  factor() %>% 
  fct_recode("Died"  = "1",
             "Alive" = "2",
             "Died - other causes" = "3") %>% 
  fct_relevel("Alive") -> # move Alive to front (first factor level) 
  mydata$status.factor    # so odds ratio will be relative to that

mydata$sex %>% 
  factor() %>% 
  fct_recode("Female" = "0",
             "Male" = "1") ->
  mydata$sex.factor
  
mydata$ulcer %>% 
  factor() %>% 
  fct_recode("Present" = "1",
             "Absent"  = "0") -> 
  mydata$ulcer.factor

#the cut() function makes a continuous variable into a categorical variable
mydata$age %>% 
  cut(breaks = c(4,20,40,60,95), include.lowest=TRUE) ->
  mydata$age.factor
```


## Chi-squared test / Fisher's exact test

### Plotting
Always plot new data first!


```r
mydata %>% 
	ggplot(aes(x = ulcer.factor, fill=status.factor)) + 
	  geom_bar(position = "fill") +
	  theme_bw() +
	  scale_fill_brewer(palette = "Paired")
```

![](08_tests_categorical_files/figure-epub3/unnamed-chunk-3-1.png)<!-- -->


```r
mydata %>% 
  ggplot(aes(x = age.factor, fill = status.factor)) +
    geom_bar() +
    theme_bw() +
    scale_fill_brewer(palette = "Paired")
```

![](08_tests_categorical_files/figure-epub3/unnamed-chunk-4-1.png)<!-- -->


```r
mydata %>% 
  ggplot(aes(x = ulcer.factor, fill=status.factor)) + 
    geom_bar() +
    theme_bw() +
    scale_fill_brewer(palette = "Paired") +
    facet_grid(sex.factor~age.factor)
```

![](08_tests_categorical_files/figure-epub3/unnamed-chunk-5-1.png)<!-- -->

## Analysis

### Using base R

First lets group together those that 'died of another cause' with those 'alive', to give a disease-specific mortality variable (`fct_collapse` will help us) . 

```r
mydata$status.factor %>%  
	fct_collapse("Alive" = c("Alive", "Died - other causes")) ->
  mydata$status.factor
```

Let's test mortality against sex.


```r
table(mydata$status.factor, mydata$sex.factor)
```

```
##        
##         Female Male
##   Alive     98   50
##   Died      28   29
```

```r
chisq.test(mydata$status.factor, mydata$sex.factor)
```

```
## 
## 	Pearson's Chi-squared test with Yates' continuity correction
## 
## data:  mydata$status.factor and mydata$sex.factor
## X-squared = 4.3803, df = 1, p-value = 0.03636
```

Note that `chisq.test()` defaults to the Yates continuity correction. It is fine to use this, but if you have a particular need not to, turn if off with `chisq.test(mydata$status.factor, mydata$sex.factor, correct=FALSE)`.

### Using `CrossTable`
This gives lots of useful information. It is readable in R and has lots of options, including Fisher's exact test. It is not that easy to extract results. 
\newpage

```r
library(gmodels)

# F1 CrossTable to see options
CrossTable(mydata$status.factor, mydata$sex.factor, chisq=TRUE)
```

```
## 
##  
##    Cell Contents
## |-------------------------|
## |                       N |
## | Chi-square contribution |
## |           N / Row Total |
## |           N / Col Total |
## |         N / Table Total |
## |-------------------------|
## 
##  
## Total Observations in Table:  205 
## 
##  
##                      | mydata$sex.factor 
## mydata$status.factor |    Female |      Male | Row Total | 
## ---------------------|-----------|-----------|-----------|
##                Alive |        98 |        50 |       148 | 
##                      |     0.544 |     0.868 |           | 
##                      |     0.662 |     0.338 |     0.722 | 
##                      |     0.778 |     0.633 |           | 
##                      |     0.478 |     0.244 |           | 
## ---------------------|-----------|-----------|-----------|
##                 Died |        28 |        29 |        57 | 
##                      |     1.412 |     2.253 |           | 
##                      |     0.491 |     0.509 |     0.278 | 
##                      |     0.222 |     0.367 |           | 
##                      |     0.137 |     0.141 |           | 
## ---------------------|-----------|-----------|-----------|
##         Column Total |       126 |        79 |       205 | 
##                      |     0.615 |     0.385 |           | 
## ---------------------|-----------|-----------|-----------|
## 
##  
## Statistics for All Table Factors
## 
## 
## Pearson's Chi-squared test 
## ------------------------------------------------------------
## Chi^2 =  5.076334     d.f. =  1     p =  0.0242546 
## 
## Pearson's Chi-squared test with Yates' continuity correction 
## ------------------------------------------------------------
## Chi^2 =  4.380312     d.f. =  1     p =  0.03635633 
## 
## 
```

### Exercise
Use the 3 methods (`table`, `chisq.test`, `CrossTable`) to test `status.factor` against `ulcer.factor`. 


```r
str(mydata)
table(mydata$status.factor, mydata$ulcer.factor)
chisq.test(mydata$status.factor, mydata$ulcer.factor)
```

Using `CrossTable`

```r
CrossTable(mydata$status.factor, mydata$ulcer.factor, chisq=TRUE)
```

### Fisher's exact test

An assumption of the chi-squared test is that the 'expected cell count' is greater than 5. If it is less than 5 the test becomes unreliable and the Fisher's exact test is recommended. 

Run the following code. 


```r
library(gmodels)
CrossTable(mydata$status.factor, mydata$age.factor, expected=TRUE, chisq=TRUE)
```

```
## Warning in chisq.test(t, correct = FALSE, ...): Chi-squared approximation
## may be incorrect
```

```
## 
##  
##    Cell Contents
## |-------------------------|
## |                       N |
## |              Expected N |
## | Chi-square contribution |
## |           N / Row Total |
## |           N / Col Total |
## |         N / Table Total |
## |-------------------------|
## 
##  
## Total Observations in Table:  205 
## 
##  
##                      | mydata$age.factor 
## mydata$status.factor |    [4,20] |   (20,40] |   (40,60] |   (60,95] | Row Total | 
## ---------------------|-----------|-----------|-----------|-----------|-----------|
##                Alive |         6 |        30 |        66 |        46 |       148 | 
##                      |     6.498 |    26.712 |    66.420 |    48.371 |           | 
##                      |     0.038 |     0.405 |     0.003 |     0.116 |           | 
##                      |     0.041 |     0.203 |     0.446 |     0.311 |     0.722 | 
##                      |     0.667 |     0.811 |     0.717 |     0.687 |           | 
##                      |     0.029 |     0.146 |     0.322 |     0.224 |           | 
## ---------------------|-----------|-----------|-----------|-----------|-----------|
##                 Died |         3 |         7 |        26 |        21 |        57 | 
##                      |     2.502 |    10.288 |    25.580 |    18.629 |           | 
##                      |     0.099 |     1.051 |     0.007 |     0.302 |           | 
##                      |     0.053 |     0.123 |     0.456 |     0.368 |     0.278 | 
##                      |     0.333 |     0.189 |     0.283 |     0.313 |           | 
##                      |     0.015 |     0.034 |     0.127 |     0.102 |           | 
## ---------------------|-----------|-----------|-----------|-----------|-----------|
##         Column Total |         9 |        37 |        92 |        67 |       205 | 
##                      |     0.044 |     0.180 |     0.449 |     0.327 |           | 
## ---------------------|-----------|-----------|-----------|-----------|-----------|
## 
##  
## Statistics for All Table Factors
## 
## 
## Pearson's Chi-squared test 
## ------------------------------------------------------------
## Chi^2 =  2.019848     d.f. =  3     p =  0.5682975 
## 
## 
## 
```

Why does it give a warning? Run it a second time including `fisher=TRUE`. 



```r
library(gmodels)
CrossTable(mydata$status.factor, mydata$age.factor, expected=TRUE, chisq=TRUE)
```

```
## Warning in chisq.test(t, correct = FALSE, ...): Chi-squared approximation
## may be incorrect
```

```
## 
##  
##    Cell Contents
## |-------------------------|
## |                       N |
## |              Expected N |
## | Chi-square contribution |
## |           N / Row Total |
## |           N / Col Total |
## |         N / Table Total |
## |-------------------------|
## 
##  
## Total Observations in Table:  205 
## 
##  
##                      | mydata$age.factor 
## mydata$status.factor |    [4,20] |   (20,40] |   (40,60] |   (60,95] | Row Total | 
## ---------------------|-----------|-----------|-----------|-----------|-----------|
##                Alive |         6 |        30 |        66 |        46 |       148 | 
##                      |     6.498 |    26.712 |    66.420 |    48.371 |           | 
##                      |     0.038 |     0.405 |     0.003 |     0.116 |           | 
##                      |     0.041 |     0.203 |     0.446 |     0.311 |     0.722 | 
##                      |     0.667 |     0.811 |     0.717 |     0.687 |           | 
##                      |     0.029 |     0.146 |     0.322 |     0.224 |           | 
## ---------------------|-----------|-----------|-----------|-----------|-----------|
##                 Died |         3 |         7 |        26 |        21 |        57 | 
##                      |     2.502 |    10.288 |    25.580 |    18.629 |           | 
##                      |     0.099 |     1.051 |     0.007 |     0.302 |           | 
##                      |     0.053 |     0.123 |     0.456 |     0.368 |     0.278 | 
##                      |     0.333 |     0.189 |     0.283 |     0.313 |           | 
##                      |     0.015 |     0.034 |     0.127 |     0.102 |           | 
## ---------------------|-----------|-----------|-----------|-----------|-----------|
##         Column Total |         9 |        37 |        92 |        67 |       205 | 
##                      |     0.044 |     0.180 |     0.449 |     0.327 |           | 
## ---------------------|-----------|-----------|-----------|-----------|-----------|
## 
##  
## Statistics for All Table Factors
## 
## 
## Pearson's Chi-squared test 
## ------------------------------------------------------------
## Chi^2 =  2.019848     d.f. =  3     p =  0.5682975 
## 
## 
## 
```


## Summarising multiple factors (optional)
`CrossTable` is useful for summarising single variables. We often want to summarise more than one factor or continuous variable against our `dependent` variable of interest. Think of Table 1 in a journal article. 

## Summarising factors with `library(summarizer)`

This is our own package which we have written and maintain. It contains functions to summarise data for publication tables and figures, and to easily run regression analyses. We specify a `dependent` or outcome variable, and a set of `explanatory` or predictor varaibles. 


```r
library(summarizer)
mydata %>% 
  summary.factorlist(dependent = "status.factor", 
                     explanatory = c("sex.factor", "ulcer.factor", "age.factor"),
                     p = TRUE,
                     column = TRUE)
```

```
## Warning in chisq.test(tab, correct = FALSE): Chi-squared approximation may
## be incorrect
```

```
##          label  levels     Alive      Died pvalue
## 5   sex.factor  Female 98 (66.2) 28 (49.1)  0.024
## 6                 Male 50 (33.8) 29 (50.9)       
## 7 ulcer.factor  Absent 99 (66.9) 16 (28.1) <0.001
## 8              Present 49 (33.1) 41 (71.9)       
## 1   age.factor  [4,20]   6 (4.1)   3 (5.3)  0.568
## 2              (20,40] 30 (20.3)  7 (12.3)       
## 3              (40,60] 66 (44.6) 26 (45.6)       
## 4              (60,95] 46 (31.1) 21 (36.8)
```


### Summarising factors with `library(tidyverse)`

### Example
`Tidyverse` gives the flexibility and power to examine millions of rows of your data any way you wish. The following are intended as an extension to what you have already done. These demonstrate some more advanced approaches to combining `tidy` functions. 



```r
# Calculate number of patients in each group
mydata %>%
  count(ulcer.factor, status.factor) ->
  counted_data

# Add the total number of people in each status group
counted_data %>%
  group_by(status.factor) %>%
  mutate(total = sum(n)) ->
  counted_data2   
```


```r
# Calculate the percentage of n to total
counted_data2 %>%
  mutate(percentage = round(100*n/total, 1)) ->
  counted_data3
```


```r
# Create a combined columns of both n and percentage,
# using paste to add brackets around the percentage
counted_data3 %>% 
  mutate(count_perc = paste0(n, " (", percentage, ")")) -> 
  counted_data4
```


Or combine everything together without the intermediate `counted_data` breaks.

```r
mydata %>%
  count(ulcer.factor, status.factor) %>%
  group_by(status.factor) %>%
  mutate(total = sum(n)) %>%
  mutate(percentage = round(100*n/total, 1)) %>% 
  mutate(count_perc = paste0(n, " (", percentage, ")")) %>% 
  select(-total, -n, -percentage) %>% 
  spread(status.factor, count_perc)
```

```
## # A tibble: 2 x 3
##   ulcer.factor Alive     Died     
## * <fct>        <chr>     <chr>    
## 1 Absent       99 (66.9) 16 (28.1)
## 2 Present      49 (33.1) 41 (71.9)
```



### Exercise
By changing one and only one word at a time in the above block (the "Combine everything together" section)

Reproduce this:

```
##   age.factor     Alive      Died
## 1     [4,20]   6 (4.1)   3 (5.3)
## 2    (20,40] 30 (20.3)  7 (12.3)
## 3    (40,60] 66 (44.6) 26 (45.6)
## 4    (60,95] 46 (31.1) 21 (36.8)
```

And then this:

```
##   sex.factor     Alive      Died
## 1     Female 98 (66.2) 28 (49.1)
## 2       Male 50 (33.8) 29 (50.9)
```

Solution: The only thing you need to change is the first variable in `count()`, e.g., `count(age.factor, ...`.


