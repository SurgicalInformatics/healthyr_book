# Linear regression

## Data

We will be using the same gapminder dataset as in the last two sessions.


```r
library(tidyverse)
library(gapminder) # dataset
library(lubridate) # handles dates
library(broom)     # transforms statistical output to data frame

mydata = gapminder
```

## Plotting

Let's plot the life expectancies of European countries over the past 60 years:



```r
mydata %>% 
  filter(continent == "Europe") %>% 
  ggplot(aes(x = year, y = lifeExp)) +
  geom_point() +
  facet_wrap(~country) +
  theme_bw() +
  scale_x_continuous(breaks = c(1960, 1980, 2000))
```

![](07_linear_regression_files/figure-epub3/unnamed-chunk-2-1.png)<!-- -->

### Exercise

Save the above filter into a new variable called `eurodata`:


```r
mydata %>% 
  filter(continent == "Europe") -> eurodata
```



### Exercise

Create the same plot as above (life expectancy over time), but for just Turkey and the United Kingdom, and add linear regression lines. 
Hint: use `+ geom_smooth(method = "lm")` for the lines. `lm()` stands for linear model.

![](07_linear_regression_files/figure-epub3/unnamed-chunk-4-1.png)<!-- -->

## Simple linear regression

As you can see, `ggplot()` is very happy to run and plot linear regression for us. 
To access the results, however, we should save the full results of the linear regression models into variables in our Environment. 
We can then investigate the intercepts and the slope coefficients (linear increase per year):


```r
fit_uk = mydata %>%
  filter(country == "United Kingdom") %>% 
  lm(lifeExp~year, data=.)  # the data=. argument is necessary


fit_turkey = mydata %>%
  filter(country == "Turkey") %>% 
  lm(lifeExp~year, data=.)


fit_uk$coefficients

fit_turkey$coefficients
```

```
##  (Intercept)         year 
## -294.1965876    0.1859657 
##  (Intercept)         year 
## -924.5898865    0.4972399
```


### Exercise

To make the intercepts more meaningful, add a new column called `year_from1952` and redo `fit_turkey` and `fit_uk` using `year_from1952` instead of `year`.


```r
mydata$year_from1952 = mydata$year - 1952

fit_uk = mydata %>%
  filter(country == "United Kingdom") %>% 
  lm(lifeExp~year_from1952, data=.)


fit_turkey = mydata %>%
  filter(country == "Turkey") %>% 
  lm(lifeExp~year_from1952, data=.)


fit_uk$coefficients

fit_turkey$coefficients
```

```
##   (Intercept) year_from1952 
##    68.8085256     0.1859657 
##   (Intercept) year_from1952 
##    46.0223205     0.4972399
```


### Model information: `summary()`, `tidy()` ,`glance()`

Accessing all other information about our regression model:


```r
fit_uk %>% summary()
```

```
## 
## Call:
## lm(formula = lifeExp ~ year_from1952, data = .)
## 
## Residuals:
##      Min       1Q   Median       3Q      Max 
## -0.69767 -0.31962  0.06642  0.36601  0.68165 
## 
## Coefficients:
##                Estimate Std. Error t value Pr(>|t|)    
## (Intercept)   68.808526   0.240079  286.61  < 2e-16 ***
## year_from1952  0.185966   0.007394   25.15 2.26e-10 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.4421 on 10 degrees of freedom
## Multiple R-squared:  0.9844,	Adjusted R-squared:  0.9829 
## F-statistic: 632.5 on 1 and 10 DF,  p-value: 2.262e-10
```

```r
fit_uk %>% tidy()
```

```
## # A tibble: 2 x 5
##   term          estimate std.error statistic  p.value
##   <chr>            <dbl>     <dbl>     <dbl>    <dbl>
## 1 (Intercept)     68.8     0.240       287.  6.58e-21
## 2 year_from1952    0.186   0.00739      25.1 2.26e-10
```

```r
fit_uk %>% glance()
```

```
## # A tibble: 1 x 11
##   r.squared adj.r.squared sigma statistic  p.value    df logLik   AIC   BIC
##       <dbl>         <dbl> <dbl>     <dbl>    <dbl> <int>  <dbl> <dbl> <dbl>
## 1     0.984         0.983 0.442      633. 2.26e-10     2  -6.14  18.3  19.7
## # … with 2 more variables: deviance <dbl>, df.residual <int>
```


## If you are new to linear regression

See these interactive Shiny apps provided by RStudio:

https://gallery.shinyapps.io/simple_regression/

https://gallery.shinyapps.io/multi_regression/

(`library(shiny)` is an R package for making your output interactive)

### Exercise - Residuals

Open the first Shiny app ("Simple regression"). 
Move the sliders until the red lines (residuals*) turn green - this means you've made the line fit the points as well as possible. 
Look at the intercept and slope - discuss with your neighbour or a tutor what these numbers mean/how they affect the straight line on the plot.

*Residual is how far away each point (observation) is from the linear regression line. 
(In this example it's the linear regression line, but residuals are relevant in many other contexts as well.)

## Multiple linear regression

Multiple linear regression includes more than one predictor variable. 
There are a few ways to include more variables, depending on whether they should share the intercept and how they interact:

Simple linear regression (exactly one predictor variable):

`myfit = lm(lifeExp~year, data=eurodata)`

Multiple linear regression (additive):

`myfit = lm(lifeExp~year+country, data=eurodata)`

Multiple linear regression (all interactions):

`myfit = lm(lifeExp~year*country, data=eurodata)`

Multiple linear regression (some interactions):

`myfit = lm(lifeExp~year:country, data=eurodata)`

These examples of multiple regression include two variables: `year` and `country`, but we could include more by just adding them with `+`.

### Exercise

Open the second Shiny app ("Multiple regression") and see how:

* In simple regression, there is only one intercept and slope for the whole dataset.
* Using the additive model (`lm(formula = y ~ x + group`) the two lines (one for each group) have different intercepts but the same slope. However, the `lm()` summary seems to only include one line called "(Intercept)", how to find the intercept for the second group of points?
* Using the interactive model (`lm(formula = y ~ x*group`)) the two lines have different intercepts and different slopes.

### Exercise

Convince yourself that using an fully interactive multivariable model is the same as running several separate simple linear regression models. 
Remember that we calculate the life expectancy in 1952 (intercept) and improvement per year (slope) for Turkey and the United Kingdom:


```r
fit_uk %>%
  tidy() %>%
  mutate(estimate = round(estimate, 2)) %>% 
  select(term, estimate)
```

```
## # A tibble: 2 x 2
##   term          estimate
##   <chr>            <dbl>
## 1 (Intercept)      68.8 
## 2 year_from1952     0.19
```

```r
fit_turkey %>%
  tidy() %>%
  mutate(estimate = round(estimate, 2)) %>% 
  select(term, estimate)
```

```
## # A tibble: 2 x 2
##   term          estimate
##   <chr>            <dbl>
## 1 (Intercept)       46.0
## 2 year_from1952      0.5
```

(The lines `tidy()`, `mutate()`, and `select()` are only included for neater presentation here, you can use `summary()` instead.)

We can do this together using `year_from1952*country` in the `lm()`:


```r
mydata %>% 
  filter(country %in% c("Turkey", "United Kingdom")) %>% 
  lm(lifeExp ~ year_from1952*country, data = .)   %>% 
  tidy() %>%
  mutate(estimate = round(estimate, 2)) %>% 
  select(term, estimate)
```

```
## # A tibble: 4 x 2
##   term                                estimate
##   <chr>                                  <dbl>
## 1 (Intercept)                            46.0 
## 2 year_from1952                           0.5 
## 3 countryUnited Kingdom                  22.8 
## 4 year_from1952:countryUnited Kingdom    -0.31
```

Now. It may seem like R has omitted Turkey but the values for Turkey are actually in the Intercept = 46.02 and in year_from1952 = 0.50. 
Can you make out the intercept and slope for the UK? Are they the same as in the simple linear regression model?

### Exercise

Add a third country (e.g. "Portugal") to `filter(country %in% c("Turkey", "United Kingdom"))` in the above example. Do the results change?


### Optional (Advanced) Exercise

Run separate linear regression models for every country in the dataset at the same time and putting it all in two neat dataframes (one for the coefficients, one for the summary statistics):


```r
linfit_coefficients = mydata %>% 
  group_by(country) %>% 
  do(
    tidy(
      lm(lifeExp~year, data=.)
    )
  )


linfit_overall = mydata %>% 
  group_by(country) %>% 
  do(
    glance(
      lm(lifeExp~year, data=.)
    )
  )
```


Plot the linear regression estimate (improvement per year between 1952 -- 2007), size the points by their r-squared values, and colour the points by continent (hint: you will have to join `mydata`, `linfit_coefficients %>% filter(term == "year")`, and `linfit_overall`):


```r
mydata %>% 
  filter(year == 1952) %>% 
  full_join(linfit_coefficients %>% filter(term == "year"), by = "country") %>% 
  full_join(linfit_overall, by = "country") %>% 
  ggplot(aes(x = lifeExp, y = estimate, colour = continent, size = r.squared)) +
  geom_point(alpha = 0.6) +
  theme_bw() +
  scale_colour_brewer(palette = "Set1") +
  ylab("Increase in life expectancy per year") +
  xlab("Life expectancy in 1952")
```

![](07_linear_regression_files/figure-epub3/unnamed-chunk-11-1.png)<!-- -->


## Very advanced example

Or you can do the above in a nested dataframe (dataframes nested in dataframes):


```r
nested_linreg = mydata %>% 
  group_by(country) %>% 
  nest() %>% 
  mutate(model = purrr::map(data, ~ lm(lifeExp ~ year, data = .)))
```



## Solutions

**6.2.2**


```r
mydata %>% 
  filter(country %in% c("United Kingdom", "Turkey") ) %>% 
  ggplot(aes(x = year.formatted, y = lifeExp)) +
  geom_point() +
  facet_wrap(~country) +
  theme_bw() +
  geom_smooth(method = "lm")
```


**6.5.3**



```r
mydata %>% 
  filter(country %in% c("Turkey", "United Kingdom", "Portugal")) %>% 
  lm(lifeExp ~ year_from1952*country, data = .)   %>% 
  tidy() %>%
  mutate(estimate = round(estimate, 2)) %>% 
  select(term, estimate)
```

Overall, the estimates for Turkey and the UK do not change, but Portugal becomes the reference (alphabetically first) and you need to subtract or add the relevant lines for Turkey and the UK.




