# Working with categorical outcome variables {#chap08-h1}
\index{categorical data@\textbf{categorical data}}

> Suddenly Christopher Robin began to tell Pooh about some of the things: People called Kings and Queens and something called Factors ... and Pooh said "Oh!" and thought how wonderful it would be to have a Real Brain which could tell you things.  
> A.A. Milne, *The House at Pooh Corner* (1928)

## Factors
\index{factors}



We said earlier that continuous data can be measured and categorical data can be counted, which is useful to remember. 
Categorical data can be a:

* Factor
  + a fixed set of names/strings or numbers
  + these may have an inherent order (1st, 2nd 3rd) - ordinal factor
  + or may not (female, male) 
* Character
  + sequences of letters, numbers, and symbols
* Logical
  + containing only TRUE or FALSE

Health data is awash with factors. 
Whether it is outcomes like death, recurrence, or readmission. 
Or predictors like cancer stage, deprivation quintile, smoker yes/no.
It is essential therefore to be comfortable manipulating factors and dealing with outcomes which are categorical.

## The Question

We will use the classic “Survival from Malignant Melanoma” dataset which is included in the `boot` package. 
The data consist of measurements made on patients with malignant melanoma, a type of skin cancer. 
Each patient had their tumour removed by surgery at the Department of Plastic Surgery, University Hospital of Odense, Denmark between 1962 and 1977.

We are interested in the association between tumour ulceration and death from melanoma. 

## Get the data

The Help page (F1 on `boot::melanoma`) gives us its data dictionary including the definition of each variable and the coding used.


```r
mydata = boot::melanoma
```

## Check the data
As always, check any new dataset carefully before you start analysis.  


```r
library(tidyverse)
library(finalfit)
theme_set(theme_bw())
mydata %>% glimpse()
```

```
## Observations: 205
## Variables: 7
## $ time      <dbl> 10, 30, 35, 99, 185, 204, 210, 232, 232, 279, 295, 355, 386…
## $ status    <dbl> 3, 3, 2, 3, 1, 1, 1, 3, 1, 1, 1, 3, 1, 1, 1, 3, 1, 1, 1, 1,…
## $ sex       <dbl> 1, 1, 1, 0, 1, 1, 1, 0, 1, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1, 1,…
## $ age       <dbl> 76, 56, 41, 71, 52, 28, 77, 60, 49, 68, 53, 64, 68, 63, 14,…
## $ year      <dbl> 1972, 1968, 1977, 1968, 1965, 1971, 1972, 1974, 1968, 1971,…
## $ thickness <dbl> 6.76, 0.65, 1.34, 2.90, 12.08, 4.84, 5.16, 3.22, 12.88, 7.4…
## $ ulcer     <dbl> 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
```

```r
mydata %>% ff_glimpse()
```

```
## Continuous
##               label var_type   n missing_n missing_percent   mean     sd    min
## time           time    <dbl> 205         0             0.0 2152.8 1122.1   10.0
## status       status    <dbl> 205         0             0.0    1.8    0.6    1.0
## sex             sex    <dbl> 205         0             0.0    0.4    0.5    0.0
## age             age    <dbl> 205         0             0.0   52.5   16.7    4.0
## year           year    <dbl> 205         0             0.0 1969.9    2.6 1962.0
## thickness thickness    <dbl> 205         0             0.0    2.9    3.0    0.1
## ulcer         ulcer    <dbl> 205         0             0.0    0.4    0.5    0.0
##           quartile_25 median quartile_75    max
## time           1525.0 2005.0      3042.0 5565.0
## status            1.0    2.0         2.0    3.0
## sex               0.0    0.0         1.0    1.0
## age              42.0   54.0        65.0   95.0
## year           1968.0 1970.0      1972.0 1977.0
## thickness         1.0    1.9         3.6   17.4
## ulcer             0.0    0.0         1.0    1.0
## 
## Categorical
## data frame with 0 columns and 205 rows
```

As can be seen, all of the variables are currently coded as continuous/numeric.
The `<dbl>` stands for 'double', meaning numeric which comes from 'double-precision floating point', an awkward computer science term. 

## Recode the data {#chap08-recode}
It is really important that variables are correctly coded for all plotting and analysis functions. 
Using the data dictionary, we will convert the categorical variables to factors. 

In the section below, we convert the continuous variables to `factors` (e.g., `sex %>% factor() %>% `), then use the `forcats` package to recode the factor levels. 
Modern databases (such as REDCap for example) can give you an R script to recode your specific dataset.
This means you don't always have to recode your factors from numbers to names manually.
But you will always be recoding variables during the exploration and analysis stages too, so it is important to follow what is happening here.


```r
mydata = mydata %>% 
  mutate(sex.factor =             # Make new variable  
           sex %>%                # from existing variable
           factor() %>%           # convert to factor
           fct_recode(            # forcats function
             "Female" = "0",      # new on left, old on right
             "Male"   = "1") %>% 
           ff_label("Sex"),       # Optional label for finalfit
         
         # same thing but more condensed code:
         ulcer.factor = factor(ulcer) %>% 
           fct_recode("Present" = "1",
                      "Absent"  = "0") %>% 
           ff_label("Ulcerated tumour"),
         
         status.factor = factor(status) %>% 
           fct_recode("Died melanoma"       = "1",
                      "Alive"               = "2",
                      "Died - other causes" = "3") %>% 
           ff_label("Status"))
```

We have formatted the recode of the `sex` variables to be on multiple lines - to make it easier for you to see the exact steps included.
We have condensed for the other recodes (e.g., `ulcer.factor = factor(ulcer) %>%`), but it does the exact same thing as the first one.


\index{functions@\textbf{functions}!factor}
\index{functions@\textbf{functions}!fct\_recode}
\index{functions@\textbf{functions}!ff\_label}



## Should I convert a continuous variable to a categorical variable?
\index{categorical data@\textbf{categorical data}!convert from continuous}

This is a common question and something which is frequently done. 
Take for instance the variable age. 
Is it better to leave it as a continuous variable, or to chop it into categories, e.g. 30 to 39 etc.?

The clear disadvantage in doing this is that information is being thrown away. 
Which feels like a bad thing to be doing. 
This is particularly important if categories being created are large. 
For instance, if age was dichotomised to "young" and "old" at say 42 years (the current median age in Europe), then it is likely that relevant information to a number of analyses has been discarded. 
Secondly, it is unforgivable practice to repeatedly try different cuts of continuous variable in order to obtain a statistically significant result. 
This is most commonly done in tests of diagnostic accuracy, where a threshold for considering a continuous test result positive is chosen *post hoc* to maximise sensitivity/specificity, but not then validated in an independent cohort.

But there are also advantages. 
Say the relationship between age and an outcome is not linear, but rather u-shaped, then fitting a regression line is more difficult. 
While if the age has been cut into 10 year bands and entered into a regression as a factor, then the non-linearity is already accounted for. 
Secondly, sometimes when communicating the results of an analysis to a lay audience, then using a rhetorical representation can make this easier. 
For instance, an odds of death 1.8 times greater in 70 year-olds compared with 40 year-olds may be easier to grasp than 1.02 times extra per year. 

So the answer. 
Do not do it unless you have to. 
Plot and understand the continuous variable first. 
If you do it, try not to throw away too much information. 


```r
# Summary of age
mydata$age %>% 
  summary()
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##    4.00   42.00   54.00   52.46   65.00   95.00
```

```r
mydata %>% 
  ggplot(aes(x = age)) + 
  geom_histogram()
```

```
## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
```

<img src="08_working_categorical_files/figure-html/unnamed-chunk-5-1.png" width="384" />

There are different ways in which a continuous variable can be converted to a factor. 
You may wish to create a number of intervals of equal length. 
The `cut()` function can be used for this. 

Figure \@ref(fig:chap08-fig-cut) illustrates different options for this. 
We suggest not using the `label` option of the `cut()` function, to avoid errors should the underlying data change or when the code is copied and reused. 
A better practice is to recode the levels using `fct_recode` as above. 

The intervals in the output are standard mathematical notation. 
A square bracket indicates the value is included in the interval and a round bracket that the value is excluded.

Note the requirement for `include.lowest = TRUE` when you specify breaks yourself and the the lowest cut-point is also the lowest data value. 
This should be clear in Figure \@ref(fig:chap08-fig-cut).

<div class="figure">
<img src="images/chapter08/1_cut.pdf" alt="`Cut` a continuous variable into a categorical variable."  />
<p class="caption">(\#fig:chap08-fig-cut)`Cut` a continuous variable into a categorical variable.</p>
</div>

### Equal intervals vs quantiles
\index{categorical data@\textbf{categorical data}!quantiles}

Be clear in your head whether you wish to cut the data so the intervals are of equal length. 
Or whether you wish to cut the data so there are equal proportions of cases (patients) in each level. 

Equal intervals:

```r
mydata = mydata %>% 
  mutate(
    age.factor = 
      age %>%
      cut(4)
  )
mydata$age.factor %>%
  summary()
```

```
## (3.91,26.8] (26.8,49.5] (49.5,72.2] (72.2,95.1] 
##          16          68         102          19
```

\index{functions@\textbf{functions}!cut}

Quantiles:

```r
mydata = mydata %>% 
  mutate(
    age.factor = 
      age %>%
      Hmisc::cut2(g=4)
  )
mydata$age.factor %>% 
  summary()
```

```
## [ 4,43) [43,55) [55,66) [66,95] 
##      55      49      53      48
```

```r
# Or?
# mydata$age.factor %>% 
#  fct_count()
```

\index{functions@\textbf{functions}!quantile}

Using the cut function, a continuous variable can be converted to a categorical one:


```r
mydata = mydata %>% 
  mutate(
    age.factor = 
      age %>%
      cut(breaks = c(4,20,40,60,95), include.lowest = TRUE) %>% 
      fct_recode(
        "≤20"      =  "[4,20]",
        "21 to 40" = "(20,40]",
        "41 to 60" = "(40,60]",
        ">60"      = "(60,95]"
      ) %>% 
      ff_label("Age (years)")
  )
head(mydata$age.factor)
```

```
## [1] >60      41 to 60 41 to 60 >60      41 to 60 21 to 40
## Levels: ≤20 21 to 40 41 to 60 >60
```

## Plot the data

We are interested in the association between tumour ulceration and death from melanoma. 
To start then, we simply count the number of patients with ulcerated tumours who died. 
It is useful to plot this as counts but also as proportions. 
It is proportions you are comparing, but you really want to know the absolute numbers as well. 


```r
p1 = mydata %>% 
  ggplot(aes(x = ulcer.factor, fill = status.factor)) + 
  geom_bar() + 
  theme(legend.position = "none")

p2 = mydata %>% 
  ggplot(aes(x = ulcer.factor, fill = status.factor)) + 
  geom_bar(position = "fill") + 
  ylab("proportion")

library(patchwork)
p1 + p2
```

<div class="figure">
<img src="08_working_categorical_files/figure-html/unnamed-chunk-9-1.png" alt="Bar chart: outcome after surgery for patients with ulcerated melanoma." width="672" />
<p class="caption">(\#fig:unnamed-chunk-9)Bar chart: outcome after surgery for patients with ulcerated melanoma.</p>
</div>

It should be obvious that more died from melanoma in the ulcerated tumour group compared with the non-ulcerated tumour group.
The stacking is orders from top to bottom by default. 
This can be easily adjusted by changing the order of the levels within the factor (see re-levelling below).
This default order works well for binary variables - the "yes" or "1" is lowest and can be easily compared. 
This ordering of this particular variable is unusual - it would be more common to have for instance `alive = 0`, `died = 1`. 
One quick option is to just reverse the order of the levels in the plot. 


```r
p1 = mydata %>% 
  ggplot(aes(x = ulcer.factor, fill = status.factor)) + 
  geom_bar(position = position_stack(reverse = TRUE)) + 
  theme(legend.position = "none")

p2 = mydata %>% 
  ggplot(aes(x = ulcer.factor, fill = status.factor)) + 
  geom_bar(position = position_fill(reverse = TRUE)) + 
  ylab("proportion")

library(patchwork)
p1 + p2
```

<div class="figure">
<img src="08_working_categorical_files/figure-html/unnamed-chunk-10-1.png" alt="Bar chart: outcome after surgery for patients with ulcerated melanoma, reversed levels." width="672" />
<p class="caption">(\#fig:unnamed-chunk-10)Bar chart: outcome after surgery for patients with ulcerated melanoma, reversed levels.</p>
</div>

Just from the plot then, death from melanoma in the ulcerated tumour group is around 40% and in the non-ulcerated group around 13%. 
The number of patients included in the study is not huge, however, this still looks like a real difference given its effect size.

We may also be interested in exploring potential effect modification, interactions and confounders.
Again, we urge you to first visualise these, rather than going straight to a model. 


```r
p1 = mydata %>% 
  ggplot(aes(x = ulcer.factor, fill=status.factor)) + 
  geom_bar(position = position_stack(reverse = TRUE)) +
  facet_grid(sex.factor ~ age.factor) + 
  theme(legend.position = "none")

p2 = mydata %>% 
  ggplot(aes(x = ulcer.factor, fill=status.factor)) + 
  geom_bar(position = position_fill(reverse = TRUE)) +
  facet_grid(sex.factor ~ age.factor)+ 
  theme(legend.position = "bottom")

p1 / p2
```

<div class="figure">
<img src="08_working_categorical_files/figure-html/unnamed-chunk-11-1.png" alt="Facetted bar plot: outcome after surgery for patients with ulcerated melanoma aggregated by sex and age." width="576" />
<p class="caption">(\#fig:unnamed-chunk-11)Facetted bar plot: outcome after surgery for patients with ulcerated melanoma aggregated by sex and age.</p>
</div>

## Group factor levels together - `fct_collapse()`
\index{functions@\textbf{functions}!fct\_collapse}

Our question relates to the association between tumour ulceration and death from melanoma. 
The outcome measure has three levels as can be seen. 
For our purposes here, we will generate a disease-specific mortality variable (`status_dss`), by combining "Died - other causes" and "Alive". 


```r
mydata = mydata %>%
  mutate(
    status_dss = fct_collapse(
      status.factor,
      "Alive" = c("Alive", "Died - other causes"))
  )
```

## Change the order of values within a factor - `fct_relevel()` {#chap08-h2-fct-relevel}
\index{functions@\textbf{functions}!fct\_relevel}

The default order for levels with `factor()` is alphabetical. 
We often want to reorder the levels in a factor when plotting, or when performing an regression analysis and we want to specify the reference level.  

The order can be checked using `levels()`.


```r
# dss - disease specific survival
mydata$status_dss %>% levels()
```

```
## [1] "Died melanoma" "Alive"
```

The reason "Alive" is second, rather than alphabetical, is it was recoded from "2" and that order was retained.
If, however, we want to make comparisons relative to "Alive", we need to move it to the front by using `fct_relevel()`.


```r
mydata = mydata %>% 
  mutate(status_dss = status_dss %>%
           fct_relevel("Alive")
         )
```

Any number of factor levels can be specified in `fct_relevel()`. 

## Summarising factors with **finalfit**
\index{categorical data@\textbf{categorical data}!finalfit}
\index{categorical data@\textbf{categorical data}!summarising}

Our own **finalfit** package provides convenient functions to summarise and compare factors, producing final tables for publication. 


```r
library(finalfit)
mydata %>% 
  summary_factorlist(dependent   = "status_dss", 
                     explanatory = "ulcer.factor")
```

<table class="table" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:chap08-tab-2x2)Two-by-two table with finalfit: Died with melanoma by tumour ulceration status.</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> label </th>
   <th style="text-align:left;"> levels </th>
   <th style="text-align:right;"> Alive </th>
   <th style="text-align:right;"> Died melanoma </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Ulcerated tumour </td>
   <td style="text-align:left;"> Absent </td>
   <td style="text-align:right;"> 99 (66.9) </td>
   <td style="text-align:right;"> 16 (28.1) </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> Present </td>
   <td style="text-align:right;"> 49 (33.1) </td>
   <td style="text-align:right;"> 41 (71.9) </td>
  </tr>
</tbody>
</table>


**finalfit** is useful for summarising multiple variables. 
We often want to summarise more than one factor or continuous variable against our `dependent` variable of interest. 
Think of Table 1 in a journal article. 

Any number of continuous or categorical explanatory variables can be added. 


```r
library(finalfit)
mydata %>% 
  summary_factorlist(dependent = "status_dss", 
                     explanatory = 
                       c("ulcer.factor", "age.factor", 
                         "sex.factor", "thickness")
  )
```

<table class="table" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:unnamed-chunk-17)Multiple variables by outcome: Outcome after surgery for melanoma by patient and disease factors.</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> label </th>
   <th style="text-align:left;"> levels </th>
   <th style="text-align:right;"> Alive </th>
   <th style="text-align:right;"> Died melanoma </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Ulcerated tumour </td>
   <td style="text-align:left;"> Absent </td>
   <td style="text-align:right;"> 99 (66.9) </td>
   <td style="text-align:right;"> 16 (28.1) </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> Present </td>
   <td style="text-align:right;"> 49 (33.1) </td>
   <td style="text-align:right;"> 41 (71.9) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Age (years) </td>
   <td style="text-align:left;"> ≤20 </td>
   <td style="text-align:right;"> 6 (4.1) </td>
   <td style="text-align:right;"> 3 (5.3) </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> 21 to 40 </td>
   <td style="text-align:right;"> 30 (20.3) </td>
   <td style="text-align:right;"> 7 (12.3) </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> 41 to 60 </td>
   <td style="text-align:right;"> 66 (44.6) </td>
   <td style="text-align:right;"> 26 (45.6) </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> &gt;60 </td>
   <td style="text-align:right;"> 46 (31.1) </td>
   <td style="text-align:right;"> 21 (36.8) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Sex </td>
   <td style="text-align:left;"> Female </td>
   <td style="text-align:right;"> 98 (66.2) </td>
   <td style="text-align:right;"> 28 (49.1) </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> Male </td>
   <td style="text-align:right;"> 50 (33.8) </td>
   <td style="text-align:right;"> 29 (50.9) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> thickness </td>
   <td style="text-align:left;"> Mean (SD) </td>
   <td style="text-align:right;"> 2.4 (2.5) </td>
   <td style="text-align:right;"> 4.3 (3.6) </td>
  </tr>
</tbody>
</table>

## Pearson's chi-squared and Fisher's exact tests
\index{categorical data@\textbf{categorical data}!chi-squared test}
\index{categorical data@\textbf{categorical data}!Fisher's exact test}
\index{chi-squared test}
\index{Fisher's exact test}

Pearson's chi-squared ($\chi^2$) test of independence is used to determine whether two categorical variables are independent in a given population.
Independence here means that the relative frequencies of one variable are the same over all levels of another variable.

A common setting for this is the classic 2x2 table. 
This refers to two categorical variables with exactly two levels each, such as is show in Table \@ref(tab:chap08-tab-2x2) above. 
The null hypothesis of independence for this particular question is no difference in the proportion of patients with ulcerated tumours who die (45.6%) compared with non-ulcerated tumours (13.9%).
From the raw frequencies, there seems to be a large difference, as we noted in the plot we made above. 

### Base R

Base R has reliable functions for all common statistical tests, but they are sometimes a little inconvenient to extract results from. 

A table of counts can be constructed, either using the `$` to identify columns, or using the `with()` function. 

```r
table(mydata$ulcer.factor, mydata$status_dss) # both give same result
with(mydata, table(ulcer.factor, status_dss))
```


```
##          
##           Alive Died melanoma
##   Absent     99            16
##   Present    49            41
```

When working with older R functions, a useful shortcut is the `exposition pipe-operator` (`%$%`) from the `magrittr` package, home of the standard forward pipe-operator (`%>%`). 
The exposition pipe-operator exposes data frame/tibble columns on the left to the function which follows on the right.
It's easier to see in action by making a table of counts. 


```r
library(magrittr)
mydata %$%        # note $ sign here
  table(ulcer.factor, status_dss) # No dollar, no data = .
```

```
##             status_dss
## ulcer.factor Alive Died melanoma
##      Absent     99            16
##      Present    49            41
```

The counts table can be passed to `prop.table()` for a proportions. 


```r
mydata %$%
  table(ulcer.factor, status_dss) %>% 
  prop.table(margin = 1)     # 1: row, 2: column etc.
```

```
##             status_dss
## ulcer.factor     Alive Died melanoma
##      Absent  0.8608696     0.1391304
##      Present 0.5444444     0.4555556
```

Similarly, the counts table can be passed to `chisq.test()` to perform the chi-squared test. 

```r
mydata %$%        # note $ sign here
  table(ulcer.factor, status_dss) %>% 
  chisq.test()
```

```
## 
## 	Pearson's Chi-squared test with Yates' continuity correction
## 
## data:  .
## X-squared = 23.631, df = 1, p-value = 1.167e-06
```

\index{functions@\textbf{functions}!chisq.test}

The result can be extracted into a tibble using the `tidy()` function from the `broom` package. 

```r
library(broom)
mydata %$%        # note $ sign here
  table(ulcer.factor, status_dss) %>% 
  chisq.test() %>% 
  tidy()
```

```
## # A tibble: 1 x 4
##   statistic    p.value parameter method                                         
##       <dbl>      <dbl>     <int> <chr>                                          
## 1      23.6 0.00000117         1 Pearson's Chi-squared test with Yates' continu…
```

The `chisq.test()` function applies the Yates' continuity correction by default. 
The standard interpretation assumes that the discrete probability of observed counts in the table can be approximated by the continuous chi-squared distribution. 
This introduces some error. 
The correction involves subtracting 0.5 from the absolute difference between each observed and expected value. 
This is particularly helpful when counts are low, but can be removed if desired by `chisq.test(..., correct = FALSE)`.

## Fisher's exact test

A commonly stated assumption of the chi-squared test is the requirement to have an expected count of at least 5 in each cell of the 2x2 table. 
For larger tables, all expected counts should be $>1$ and no more than 20% of all cells should have expected counts $<5$.
If this assumption is not fulfilled, an alternative test is Fisher's exact test. 
For instance, if were are testing across a 2x4 table created from our `age.factor` variable and `status_dss`, then we receive a warning.  


```r
mydata %$%        # note $ sign here
  table(age.factor, status_dss) %>% 
  chisq.test()
```

```
## Warning in chisq.test(.): Chi-squared approximation may be incorrect
```

```
## 
## 	Pearson's Chi-squared test
## 
## data:  .
## X-squared = 2.0198, df = 3, p-value = 0.5683
```

Switch to Fisher's exact test

```r
mydata %$%        # note $ sign here
  table(age.factor, status_dss) %>% 
  fisher.test()
```

```
## 
## 	Fisher's Exact Test for Count Data
## 
## data:  .
## p-value = 0.5437
## alternative hypothesis: two.sided
```

\index{functions@\textbf{functions}!fisher.test}

## Chi-squared / Fisher's exact test using Finalfit

It is easier using the `summary_factorlist()` function from the **finalfit** package. 
Including `p = TRUE` in `summary_factorlist()` adds a hypothesis test to each included comparison. 
This defaults to chi-squared tests with no continuity correction for categorical variables and a Kruskal-Wallis non-parametric test for continuous variables. 


```r
library(finalfit)
mydata %>% 
  summary_factorlist(dependent   = "status_dss", 
                     explanatory = "ulcer.factor",
                     p = TRUE)
```

\index{functions@\textbf{functions}!summary\_factorlist}

<table class="table" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:unnamed-chunk-27)Two-by-two table with chi-squared test using final fit: Outcome after surgery for melanoma by tumour ulceration status.</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> label </th>
   <th style="text-align:left;"> levels </th>
   <th style="text-align:right;"> Alive </th>
   <th style="text-align:right;"> Died melanoma </th>
   <th style="text-align:right;"> p </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Ulcerated tumour </td>
   <td style="text-align:left;"> Absent </td>
   <td style="text-align:right;"> 99 (66.9) </td>
   <td style="text-align:right;"> 16 (28.1) </td>
   <td style="text-align:right;"> &lt;0.001 </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> Present </td>
   <td style="text-align:right;"> 49 (33.1) </td>
   <td style="text-align:right;"> 41 (71.9) </td>
   <td style="text-align:right;">  </td>
  </tr>
</tbody>
</table>

Adding further variables:


```r
mydata %>% 
  summary_factorlist(dependent = "status_dss", 
                     explanatory = 
                       c("ulcer.factor", "age.factor", 
                         "sex.factor", "thickness"),
                     p = TRUE)
```


```
## Warning in chisq.test(age.factor, status_dss): Chi-squared approximation may be
## incorrect
```

<table class="table" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:unnamed-chunk-29)Multiple variables by outcome with hypothesis tests: Outcome after surgery for melanoma by patient and disease factors (chi-squared test).</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> label </th>
   <th style="text-align:left;"> levels </th>
   <th style="text-align:right;"> Alive </th>
   <th style="text-align:right;"> Died melanoma </th>
   <th style="text-align:right;"> p </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Ulcerated tumour </td>
   <td style="text-align:left;"> Absent </td>
   <td style="text-align:right;"> 99 (66.9) </td>
   <td style="text-align:right;"> 16 (28.1) </td>
   <td style="text-align:right;"> &lt;0.001 </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> Present </td>
   <td style="text-align:right;"> 49 (33.1) </td>
   <td style="text-align:right;"> 41 (71.9) </td>
   <td style="text-align:right;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Age (years) </td>
   <td style="text-align:left;"> ≤20 </td>
   <td style="text-align:right;"> 6 (4.1) </td>
   <td style="text-align:right;"> 3 (5.3) </td>
   <td style="text-align:right;"> 0.568 </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> 21 to 40 </td>
   <td style="text-align:right;"> 30 (20.3) </td>
   <td style="text-align:right;"> 7 (12.3) </td>
   <td style="text-align:right;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> 41 to 60 </td>
   <td style="text-align:right;"> 66 (44.6) </td>
   <td style="text-align:right;"> 26 (45.6) </td>
   <td style="text-align:right;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> &gt;60 </td>
   <td style="text-align:right;"> 46 (31.1) </td>
   <td style="text-align:right;"> 21 (36.8) </td>
   <td style="text-align:right;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Sex </td>
   <td style="text-align:left;"> Female </td>
   <td style="text-align:right;"> 98 (66.2) </td>
   <td style="text-align:right;"> 28 (49.1) </td>
   <td style="text-align:right;"> 0.036 </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> Male </td>
   <td style="text-align:right;"> 50 (33.8) </td>
   <td style="text-align:right;"> 29 (50.9) </td>
   <td style="text-align:right;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;"> thickness </td>
   <td style="text-align:left;"> Mean (SD) </td>
   <td style="text-align:right;"> 2.4 (2.5) </td>
   <td style="text-align:right;"> 4.3 (3.6) </td>
   <td style="text-align:right;"> &lt;0.001 </td>
  </tr>
</tbody>
</table>

Switch to Fisher's exact test:


```r
mydata %>% 
  summary_factorlist(dependent = "status_dss", 
                     explanatory = 
                       c("ulcer.factor", "age.factor", 
                         "sex.factor", "thickness"),
                     p = TRUE,
                     catTest = catTestfisher)
```









