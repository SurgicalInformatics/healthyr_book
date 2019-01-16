# (PART) Medical Statistics {-}

# Tests for continuous outcome variables

## Load data

This session we will be using the gapminder dataset as in Session 4.


```r
library(tidyverse) 
library(gapminder)
library(broom)

mydata = gapminder
```

The first step of choosing the right statistical test is determining the type of variable you have.

Lets first have a look at some of our avalible data:


```r
mydata$continent %>% unique() # categorical
```

```
## [1] Asia     Europe   Africa   Americas Oceania 
## Levels: Africa Americas Asia Europe Oceania
```

```r
mydata$year %>% unique() # categorical
```

```
##  [1] 1952 1957 1962 1967 1972 1977 1982 1987 1992 1997 2002 2007
```

```r
mydata$lifeExp %>% head() # continuous
```

```
## [1] 28.801 30.332 31.997 34.020 36.088 38.438
```

## T-test
A t-test is used to compare the means of two groups of continuous variables.

### Plotting
Before you perform any statistical tests, you should always plot your data first to determine whether these have a "normal" distribution.
 
 - Histograms should form a symmetrical "bell-shaped curve".

 - Q-Q plots should fall along the 45 degree line.
 
 - Box-plots should be symmetrical and have few outliers.

### Histogram for each continent

```r
theme_set(theme_bw())

mydata %>% 
	filter(year %in% c(2002, 2007)) %>%
	ggplot(aes(x = lifeExp)) +
	geom_histogram(bins = 10) +
	facet_grid(year~continent, scales = "free")
```

![](06_tests_continuous_files/figure-epub3/unnamed-chunk-3-1.png)<!-- -->

### Q-Q plot for each continent

With `ggplot()`, we can drawa Q-Q plot for each subgroup very efficiently:


```r
mydata %>% 
  filter(year %in% c(2002, 2007)) %>% 
  ggplot(aes(sample = lifeExp)) + 
  geom_point(stat = "qq") +
  facet_grid(year~continent)
```

![](06_tests_continuous_files/figure-epub3/unnamed-chunk-4-1.png)<!-- -->

Or we could save a subset of the data (e.g., "Americas" and year 2007 only) into a new variable (`subdata`) and use base R to draw a single Q-Q plot with less code:


```r
mydata %>% 
  filter(year == 2007) %>% 
  filter(continent == "Americas") -> subdata

qqnorm(subdata$lifeExp)
qqline(subdata$lifeExp)
```

![](06_tests_continuous_files/figure-epub3/unnamed-chunk-5-1.png)<!-- -->

### Boxplot of 2 years

```r
mydata %>% 
	filter(year %in% c(2002, 2007)) %>% 
	ggplot(aes(x = factor(year), y=lifeExp)) + #show that x = year errors: 
	geom_boxplot()                           #needs to be factor(year) or group=year
```

![](06_tests_continuous_files/figure-epub3/unnamed-chunk-6-1.png)<!-- -->

### Exercise
Make a histogram, Q-Q plot, and a box-plot for the life expectancy for a continent (you choose!) but for all years - does the data appear normally distributed?

## Two-sample t-tests

Lets perform a t-test on the "Americas" data as it appears normally distributed. We are savings the results of our t.test into a variable called t.result, but you can call it whatever you like (e.g. `myttest`).



```r
mydata %>% 
  filter(year %in% c(2002, 2007)) %>%
  filter(continent == "Americas") -> test.data

t.test(lifeExp~year, data=test.data)
```

```
## 
## 	Welch Two Sample t-test
## 
## data:  lifeExp by year
## t = -0.90692, df = 47.713, p-value = 0.369
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  -3.816017  1.443857
## sample estimates:
## mean in group 2002 mean in group 2007 
##           72.42204           73.60812
```

```r
mydata %>% 
  filter(year %in% c(2002, 2007)) %>%
  filter(continent == "Americas") %>% 
  t.test(lifeExp~year, data = .) -> t.result

t.result
```

```
## 
## 	Welch Two Sample t-test
## 
## data:  lifeExp by year
## t = -0.90692, df = 47.713, p-value = 0.369
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  -3.816017  1.443857
## sample estimates:
## mean in group 2002 mean in group 2007 
##           72.42204           73.60812
```

### T-Test output
However, that output isn't in a useful format, let's investigate the output of the function `t.test()`. 

```r
names(t.result)
```

```
## [1] "statistic"   "parameter"   "p.value"     "conf.int"    "estimate"   
## [6] "null.value"  "alternative" "method"      "data.name"
```

```r
str(t.result) # or click on the blue button in the Environment tab
```

```
## List of 9
##  $ statistic  : Named num -0.907
##   ..- attr(*, "names")= chr "t"
##  $ parameter  : Named num 47.7
##   ..- attr(*, "names")= chr "df"
##  $ p.value    : num 0.369
##  $ conf.int   : atomic [1:2] -3.82 1.44
##   ..- attr(*, "conf.level")= num 0.95
##  $ estimate   : Named num [1:2] 72.4 73.6
##   ..- attr(*, "names")= chr [1:2] "mean in group 2002" "mean in group 2007"
##  $ null.value : Named num 0
##   ..- attr(*, "names")= chr "difference in means"
##  $ alternative: chr "two.sided"
##  $ method     : chr "Welch Two Sample t-test"
##  $ data.name  : chr "lifeExp by year"
##  - attr(*, "class")= chr "htest"
```

The structure of R's `t.test()` result looks a bit overwhelming. Fortunately, the `tidy()` function from `library(broom)` puts it into a neat dataframe for us:


```r
t.result <- tidy(t.result) # broom package puts it all in a data frame
```

try clicking on it in the Environment tab now.

Thus, now we understand the output structure we can extract any result.

```r
t.result$p.value
```

```
## [1] 0.3690064
```


### Exercise

1. Select any 2 years in any continent and perform a t-test to determine whether the life expectancy is signficantly different. Remember to plot your data first.

2. Extract only the p-value from your `t.test()` output.


## One sample t-tests
However, we don't always want to compare 2 groups or sometimes we don't have the data to be able to.

Let's investigate whether the mean life expectancy in each continent significant different to 77 years in 2007.


```r
mydata %>% 
  filter(year==2007, continent=='Europe') -> subdata

# Standard one-sample t-test
t.test(subdata$lifeExp, mu=77)
```

```
## 
## 	One Sample t-test
## 
## data:  subdata$lifeExp
## t = 1.1922, df = 29, p-value = 0.2428
## alternative hypothesis: true mean is not equal to 77
## 95 percent confidence interval:
##  76.53592 78.76128
## sample estimates:
## mean of x 
##   77.6486
```

### Exercise
1. Select a different year, different continent, and different age to compare the mean life expectancy to.

2. Replace mu=77 with mu=0 (the default value). How does this affect your result?


## ANOVA
In some cases, we may also want to test more than two groups to see if they are signficantly different.

### Plotting
For example, lets plot the life expectancy in 2007 accross 3 continents.

```r
mydata %>% 
	filter(year == 2007) %>% 
	filter(continent %in% c("Americas", "Europe", "Asia")) %>% 
	ggplot(aes(x = continent, y=lifeExp)) +
	geom_boxplot()
```

![](06_tests_continuous_files/figure-epub3/unnamed-chunk-12-1.png)<!-- -->

### Analysis
ANOVA tests are useful for testing for the presence of signficant differences between more than two groups or variables.

```r
mydata %>% 
  filter(year == 2007) %>% 
  filter(continent %in% c("Americas", "Europe", "Asia")) -> subdata

fit = aov(lifeExp~continent, data = subdata) 

summary(fit)
```

```
##             Df Sum Sq Mean Sq F value   Pr(>F)    
## continent    2  755.6   377.8   11.63 3.42e-05 ***
## Residuals   85 2760.3    32.5                     
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

```r
mydata %>% 
  filter(year == 2007) %>% 
  filter(continent %in% c("Americas", "Europe", "Asia")) %>% 
  aov(lifeExp~continent, data = .) %>% 
	tidy()
```

```
## # A tibble: 2 x 6
##   term         df sumsq meansq statistic    p.value
##   <chr>     <dbl> <dbl>  <dbl>     <dbl>      <dbl>
## 1 continent     2  756.  378.       11.6  0.0000342
## 2 Residuals    85 2760.   32.5      NA   NA
```

### Check assumptions

```r
# Check ANOVA assumptions 
par(mfrow=c(2, 2)) # 4 plots in 2 x 2 grid
plot(fit)
```

![](06_tests_continuous_files/figure-epub3/unnamed-chunk-14-1.png)<!-- -->

### Perform pairwise tests
The ANOVA test was significant, indicating that there is a signficant difference in the mean life expectancy across those continents.

But which continents are significantly different, and can we quantify this difference as a p-value?


```r
mydata %>% 
  filter(year == 2007) %>% 
  filter(continent %in% c("Americas", "Europe", "Asia")) -> subdata

pairwise.t.test(subdata$lifeExp, subdata$continent)
```

```
## 
## 	Pairwise comparisons using t tests with pooled SD 
## 
## data:  subdata$lifeExp and subdata$continent 
## 
##        Americas Asia   
## Asia   0.060    -      
## Europe 0.021    1.9e-05
## 
## P value adjustment method: holm
```

```r
# or equivalently, without saving the subset in a separate variable:
# sending it into the test using pipes only
mydata %>% 
  filter(year == 2007) %>% 
  filter(continent %in% c("Americas", "Europe", "Asia")) %>% 
  pairwise.t.test(.$lifeExp, .$continent, data=.) %>% 
  tidy()
```

```
## # A tibble: 3 x 3
##   group1 group2     p.value
##   <chr>  <chr>        <dbl>
## 1 Asia   Americas 0.0601   
## 2 Europe Americas 0.0209   
## 3 Europe Asia     0.0000191
```

F1 for help to see options for `pairwise.t.test()`.

### Top tip: the cut() function

A great way of easily converting a continuous variable to a categorical variable is to use the cut() function

```r
pop_quantiles = quantile(mydata$pop)

mydata %>% 
	mutate(pop.factor = cut(pop, breaks=pop_quantiles)) -> mydata
```

### Exercise

When we used `cut()` to divide country populations into quantiles, the labels it assigned are not very neat:


```r
mydata$pop.factor %>% levels()
```

```
## [1] "(6e+04,2.79e+06]"    "(2.79e+06,7.02e+06]" "(7.02e+06,1.96e+07]"
## [4] "(1.96e+07,1.32e+09]"
```

Use `fct_recode()` to change them to something nicer, e.g., "Tiny", "Small", "Medium", "Large":


```r
mydata$pop.factor %>% 
  fct_recode("Tiny"   = "(6e+04,2.79e+06]",
             "Small"  = "(2.79e+06,7.02e+06]",
             "Medium" = "(7.02e+06,1.96e+07]",
             "Large"  = "(1.96e+07,1.32e+09]") -> mydata$pop.factor 
```


### Exercise
Perform ANOVA to test for a difference in mean life expectancy by country population factor (`mydata$pop.factor`). Remember to plot data first


```r
mydata %>% 
	filter(year == 2007) %>% 
	ggplot(aes(x=pop.factor, y=lifeExp))+
	geom_boxplot()
```

![](06_tests_continuous_files/figure-epub3/unnamed-chunk-19-1.png)<!-- -->

```r
mydata %>% 
	filter(year == 2007) %>% 
	aov(.$lifeExp ~ .$pop.factor, data=.) %>% 
	summary()
```

```
##               Df Sum Sq Mean Sq F value Pr(>F)  
## .$pop.factor   3   1160   386.6   2.751 0.0451 *
## Residuals    138  19392   140.5                 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```



## Non-parametric data
If your data is not parametric (e.g. not normally distributed) then the usual t-test is invalid. In this case there are 2 options:

1. Non-parametric statistical tests.

2. "Transform" the data to fit a normal distribution (*not covered here*) so that a t-test can be used.

### Plotting
Lets plot the life expectancy within Africa in 1997, 2002, and 2007.

```r
# African data is not normally distributed
mydata %>% 
  filter(year %in% c(1997, 2002, 2007)) %>%
  filter(continent == "Africa") %>% 
  ggplot(aes(x = lifeExp)) +
  geom_histogram(bins = 10, fill=NA, colour='black') +
  facet_grid(year~continent)
```

![](06_tests_continuous_files/figure-epub3/unnamed-chunk-20-1.png)<!-- -->

```r
mydata %>% 
  filter(year %in% c(1997, 2002, 2007)) %>%
  filter(continent == "Africa") %>% 
  group_by(year) %>% 
  summarise(avg = mean(lifeExp), med = median(lifeExp))
```

```
## # A tibble: 3 x 3
##    year   avg   med
##   <int> <dbl> <dbl>
## 1  1997  53.6  52.8
## 2  2002  53.3  51.2
## 3  2007  54.8  52.9
```


### Exercise: Non-parametric testing
Mann-Whitney U test is also called the Wilcoxon rank sum test (note the Wilcoxon signed rank test is for paried data).

Is there a significant increase in the life expectencies for African countries between 1992 and 2007? How about 1982 and 2007?


```r
mydata$year %>%  unique()
```

```
##  [1] 1952 1957 1962 1967 1972 1977 1982 1987 1992 1997 2002 2007
```

```r
mydata %>% 
  filter(continent == "Africa") %>% 
  group_by(year) %>% 
  summarise(mean = mean(lifeExp), median = median(lifeExp)) %>% 
  ggplot(aes(x = year, y = median)) +
	  geom_line()
```

![](06_tests_continuous_files/figure-epub3/unnamed-chunk-21-1.png)<!-- -->



```r
mydata %>% 
  filter(continent == "Africa") %>% 
  ggplot(aes(x = factor(year), y=lifeExp)) + #demonstrate that needs to be factor(year), not year
  geom_boxplot()
```

![](06_tests_continuous_files/figure-epub3/unnamed-chunk-22-1.png)<!-- -->

```r
mydata %>% 
  filter(year %in% c(1992, 2007)) %>%
  filter(continent == "Africa") %>% 
  wilcox.test(lifeExp~year, data=.)
```

```
## 
## 	Wilcoxon rank sum test with continuity correction
## 
## data:  lifeExp by year
## W = 1314, p-value = 0.8074
## alternative hypothesis: true location shift is not equal to 0
```

## Solutions

**5.2.2**


```r
mydata %>% 
  filter(continent == "Europe") %>% 
  ggplot(aes(x = lifeExp)) + 
  geom_histogram() +
  facet_wrap(~year)

mydata %>% 
  filter(continent == "Europe") %>% 
  ggplot(aes(sample = lifeExp)) + 
  geom_point(stat = "qq") +
  facet_wrap(~year)

mydata %>% 
  filter(continent == "Europe") %>% 
  ggplot(aes(y = lifeExp, x = factor(year))) + 
  geom_boxplot()
```




## Advanced example
This is a complex but useful example which shows you the power of the syntax. Here multiple t-tests are performed and reported with just a few lines of code. 

Performing t-tests across all continents at once:


```r
mydata %>% 
  filter(year %in% c(1997, 2007)) %>% 
  group_by(continent) %>%
	do(
		tidy(
			t.test(lifeExp~year, data=.)
		)
	)
```

```
## # A tibble: 5 x 11
## # Groups:   continent [5]
##   continent estimate estimate1 estimate2 statistic p.value parameter
##   <fct>        <dbl>     <dbl>     <dbl>     <dbl>   <dbl>     <dbl>
## 1 Africa       -1.21      53.6      54.8    -0.657 0.513      102.  
## 2 Americas     -2.46      71.2      73.6    -1.86  0.0690      47.6 
## 3 Asia         -2.71      68.0      70.7    -1.37  0.175       64.0 
## 4 Europe       -2.14      75.5      77.6    -2.73  0.00842     57.9 
## 5 Oceania      -2.53      78.2      80.7    -3.08  0.0965       1.91
## # … with 4 more variables: conf.low <dbl>, conf.high <dbl>, method <chr>,
## #   alternative <chr>
```
