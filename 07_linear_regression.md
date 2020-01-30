# Linear regression {#chap07-h1}
\index{linear regression@\textbf{linear regression}}

> Smoking is one of the leading causes of statistics.  
> Fletcher Knebel

## Regression

Regression is a method by which we can determine the existence and strength of the relationship between two or more variables. 
This can be thought of as drawing lines, ideally straight lines, through data points. 

Linear regression is our method of choice for examining continuous outcome variables. 
Broadly, there are often two separate goals in regression:

* Prediction: fitting a predictive model to an observed dataset. Using that model to make predictions about an outcome from a new set of explanatory variables;
* Explanation: fit a model to explain the inter-relationships between a set of variables.

Figure \@ref(fig:chap07-fig-regression) unifies the terms we will use throughout. 
A clear scientific question should define our `explanatory variable of interest` $(x)$, which sometimes gets called an exposure, predictor, or independent variable. 
Our outcome of interest will be referred to as the `dependent` variable or outcome $(y)$; it is sometimes referred to as the response. 
In simple linear regression, there is a single explanatory variable and a single dependent variable, and we will sometimes refer to this as *univariable linear regression*. 
When there is more than one explanatory variable, we will call this *multivariable regression*. 
Avoid the term *multivariate regression*, which means more than one dependent variable. 
We don't use this method and we suggest you don't either!

Note that in linear regression, the dependent variable is always continuous, it cannot be a categorical variable. 
The explanatory variables can be either continuous or categorical. 

### The Question (1)

We will illustrate our examples of linear regression using a classical question which is important to many of us!
This is the relationship between coffee consumption and blood pressure (and therefore cardiovascular events, such as myocardial infarction and stroke).
There has been a lot of backwards and forwards over the decades about whether coffee is harmful, has no effect, or is in fact beneficial. 
Figure \@ref(fig:chap07-fig-regression) shows a linear regression example. 
Each point is a person.
The explanatory variable is average number of cups of coffee per day $(x)$ and systolic blood pressure is the dependent variable $(y)$. 
This next bit is important!
**These data are made up, fake, randomly generated, fabricated, not real.^[These data are created on the fly by the Shiny apps that are linked and explained in this chapter. This enables you to explore the different concepts using the same variables.
For example, if you tell the multivariable app that coffee and smoking should be confounded, it will change the underlying dataset to conform. 
You can then investigate the output of the regression model to see how that corresponds to the "truth" (that in this case, you control).]** 
So please do not alter your coffee habit on the basis of these plots!

<div class="figure">
<img src="images/chapter07/1_regression_terms.png" alt="The anatomy of a regression plot. A - univariable linear regression, B - multivariable linear regression." width="790" />
<p class="caption">(\#fig:chap07-fig-regression)The anatomy of a regression plot. A - univariable linear regression, B - multivariable linear regression.</p>
</div>

### Fitting a regression line {#chap07-linreg-fit}
\index{linear regression@\textbf{linear regression}!fitted line}

Simple linear regression uses the *ordinary least squares* method for fitting. 
The details are beyond the scope of this book, but if you want to get out the linear algebra/matrix maths you did in high school, an enjoyable afternoon can be spent proving to yourself how it actually works. 

Figure \@ref(fig:chap07-fig-residuals) aims to make this easy to understand.
The maths defines a line which best fits the data provided. 
For the line to fit best, the distances between it and the observed data should be as small as possible. 
The distance from each observed point to the line is called a *residual* - one of those statistical terms that bring on the sweats. 
It refers to the residual difference left over after the line is fitted. 

You can use the [simple regression Shiny app](https://argoshare.is.ed.ac.uk/simple_regression) to explore the concept.
We want the residuals to be as small as possible. 
We can square each residual (to get rid of minuses and make the algebra more convenient) and add them up. 
If this number is as small as possible, the line is fitting as best it can. 
Or in more formal language, we want to minimise the sum of squared residuals.

The regression apps and example figures in this chapter have been adapted from https://github.com/mwaskom/ShinyApps and https://github.com/ShinyEd/intro-stats with permission from Michael Waskom and Mine Çetinkaya-Rundel, respectively.

<div class="figure">
<img src="images/chapter07/2_residuals.png" alt="How a regression line is fitted. A - residuals are the green lines: the distance between each data point and the fitted line. B - the green circle indicates the minimum for these data, its absolute value is not meaningful or comparable with other datasets. Follow the &quot;simple regression Shiny app&quot; link to interact with the fitted line. A new sum of squares of residuals (the black cross) is calculated every time you move the line. C - Distribution of the residuals. App and plots adapted from https://github.com/mwaskom/ShinyApps with permission." width="790" />
<p class="caption">(\#fig:chap07-fig-residuals)How a regression line is fitted. A - residuals are the green lines: the distance between each data point and the fitted line. B - the green circle indicates the minimum for these data, its absolute value is not meaningful or comparable with other datasets. Follow the "simple regression Shiny app" link to interact with the fitted line. A new sum of squares of residuals (the black cross) is calculated every time you move the line. C - Distribution of the residuals. App and plots adapted from https://github.com/mwaskom/ShinyApps with permission.</p>
</div>



### When the line fits well

Linear regression modelling has four main assumptions:

1. Linear relationship between predictors and outcome;
2. Independence of residuals;
3. Normal distribution of residuals;
4. Equal variance of residuals. 
\index{linear regression@\textbf{linear regression}!assumptions}

You can use the [simple regression diagnostics shiny app](https://argoshare.is.ed.ac.uk/simple_regression_diagnostics) to get a handle on these. 

Figure \@ref(fig:chap07-fig-diags) shows diagnostic plots from the app, which we will run ourselves below Figure \@ref(fig:chap07-diags-example). 

*Linear relationship*

A simple scatter plot should show a linear relationship between the explanatory and the dependent variable, as in figure \@ref(fig:chap07-fig-diags)A. 
If the data describe a non-linear pattern (figure \@ref(fig:chap07-fig-diags)B), then a straight line is not going to fit it well. 
In this situation, an alternative model should be considered, such as including a quadratic ($x^2$) term. 

*Independence of residuals*

The observations and therefore the residuals should be independent.
This is more commonly a problem in time series data, where observations may be correlated across time with each other (autocorrelation). 

*Normal distribution of residuals*

The observations should be normally distributed around the fitted line. 
This means that the residuals should show a normal distribution with a mean of zero (figure \@ref(fig:chap07-fig-diags)A).
If the observations are not equally distributed around the line, the histogram of residuals will be skewed and a normal Q-Q plot will show residuals diverging from the straight line (figure \@ref(fig:chap07-fig-diags)B) (see Section \@ref(chap06-h3-qq-plot)).

*Equal variance of residuals*

The distance of the observations from the fitted line should be the same on the left side as on the right side. 
Look at the fan-shaped data on the simple regression diagnostics Shiny app. 
This fan shape can be seen on the residuals vs. fitted values plot. 

Everything we talk about in this chapter is really about making sure that the line you draw through your data points is valid.
It is about ensuring that the regression line is appropriate across the range of the explanatory variable and dependent variable.
It is about understanding the underlying data, rather than relying on a fancy statistical test that gives you a *p*-value. 

<div class="figure">
<img src="images/chapter07/3_diags.png" alt="Regression diagnostics. A - this is what a linear fit should look like. B - this is not approriate, a non-linear model should be used instead. App and plots adapted from adapted from https://github.com/ShinyEd/intro-stats with permission." width="624" />
<p class="caption">(\#fig:chap07-fig-diags)Regression diagnostics. A - this is what a linear fit should look like. B - this is not approriate, a non-linear model should be used instead. App and plots adapted from adapted from https://github.com/ShinyEd/intro-stats with permission.</p>
</div>

### The fitted line and the linear equation

We promised to keep the equations to a minimum, but this one is so important it needs to be included. But it is easy to understand, so fear not. 

Figure \@ref(fig:chap07-fig-equation) links the fitted line, the linear equation, and the output from R. Some of this will likely be already familiar to you. 

Figure \@ref(fig:chap07-fig-equation)A shows a scatter plot with fitted lines from a multivariable linear regression model. 
The plot is taken from the [multivariable regression Shiny app](https://argoshare.is.ed.ac.uk/multi_regression/). 
Remember, these data are simulated and are not real. 
This app will really help you understand different regression models, more on this below. 
The app allows us to specify "the truth" with the sliders on the left hand side. 
For instance, we can set the $intercept=1$, meaning that when all $x=0$, the value of the dependent variable, $y=1$.  

Our model has a continuous explanatory variable of interest (average coffee consumption) and a further categorical variable (smoking). 
In the example the truth is set as $intercept=1$, $\beta_1=1$ (true effect of coffee on blood pressure, slope of line), and $\beta_2=2$ (true effect of smoking on blood pressure).
The points on the plot are simulated and include random noise. 

Figure \@ref(fig:chap07-fig-equation)B shows the default output in R for this linear regression model. 
Look carefully and make sure you are clear how the fitted lines, the linear equation, and the R output fit together. 
In this example, the random sample from our true population specified above shows $intercept=0.67$, $\beta_1=1.00$ (coffee), and $\beta_2=2.48$ (smoking). 
A *p*-value is provided ($Pr(> \left| t \right|)$), which is the result of a null hypothesis significance test for the slope of the line being equal to zero. 

<div class="figure">
<img src="images/chapter07/4_equation.png" alt="Linking the fitted line, regression equation and R output." width="790" />
<p class="caption">(\#fig:chap07-fig-equation)Linking the fitted line, regression equation and R output.</p>
</div>

### Effect modification
\index{linear regression@\textbf{linear regression}!effect modification}
\index{effect modification}

Effect modification occurs when the size of the effect of the explanatory variable of interest (exposure) on the outcome (dependent variable) differs depending on the level of a third variable. 
Said another way, this is a situation in which an explanatory variable differentially (positively or negatively) modifies the observed effect of another explanatory variable on the outcome.


Figure \@ref(fig:chap07-fig-dags) shows three potential causal pathways using examples from the [multivariable regression Shiny app](https://argoshare.is.ed.ac.uk/multi_regression/). 

In the first, smoking is not associated with the outcome (blood pressure) or our explanatory variable of interest (coffee consumption). 

In the second, smoking is associated with elevated blood pressure, but not with coffee consumption. 
This is an example of effect modification. 

In the third, smoking is associated with elevated blood pressure and with coffee consumption. 
This is an example of confounding. 

<div class="figure">
<img src="images/chapter07/5_dags.png" alt="Causal pathways, effect modification and confounding." width="877" />
<p class="caption">(\#fig:chap07-fig-dags)Causal pathways, effect modification and confounding.</p>
</div>

*Additive vs. multiplicative effect modification (interaction)*
\index{linear regression@\textbf{linear regression}!interactions}
\index{interaction terms}

Which set of terms you use can depend on the field you work in. 
Effect modification can be additive or multiplicative. 
We refer to multiplicative effect modification as "including a statistical interaction". 

Figure \@ref(fig:chap07-fig-types) should make it clear exactly how these work. 
The data have been set up to include an interaction between the two explanatory variables. 
What does this mean? 

* $intercept=1$: the blood pressure ($\hat{y}$) for non-smokers who drink no coffee (all $x=0$);
* $\beta_1=1$ (`coffee`): the additional blood pressure for each cup of coffee drunk by non-smokers (slope of the line when $x_2=0$);
* $\beta_2=1$ (`smoking`): the difference in blood pressure between non-smokers and smokers who drink no coffee ($x_1=0$);
* $\beta_3=1$ (`coffee:smoking` interaction): the blood pressure ($\hat{y}$) in addition to $\beta_1$ and $\beta_2$, for each cup of coffee drunk by smokers ($x_2=1)$.

You may have to read that a couple of times in combination with looking at Figure \@ref(fig:chap07-fig-types).

With the additive model, the fitted lines for non-smoking vs smoking are constrained to be parallel. 
Look at the equation in Figure \@ref(fig:chap07-fig-types)B and convince yourself that the lines can never be anything other than parallel. 

A statistical interaction (or multiplicative effect modification) is a situation where the effect of an explanatory variable on the outcome is modified in non-additive manner. 
In other words using our example, the fitted lines are no longer constrained to be parallel.

If we had not checked for an interaction effect, we would have inadequately described the true relationship between these three variables. 

What does this mean back in reality? 
Well it may be biologically plausible for the effect of smoking on blood pressure to increase multiplicatively due to a chemical interaction between cigarette smoke and caffeine, for example.

Note, we are just trying to find a model which best describes the underlying data. 
All models are approximations of reality. 

<div class="figure">
<img src="images/chapter07/6_types.png" alt="Multivariable linear regression with additive and multiplicative effect modification." width="790" />
<p class="caption">(\#fig:chap07-fig-types)Multivariable linear regression with additive and multiplicative effect modification.</p>
</div>

### R-squared and model fit
\index{linear regression@\textbf{linear regression}!r-squared}

Figure \@ref(fig:chap07-fig-types) includes a further metric from the R output: `Adjusted R-squared`. 

R-squared is another measure of how close the data are to the fitted line. 
It is also known as the coefficient of determination and represents the proportion of the dependent variable which is explained by the explanatory variable(s). 
So 0.0 indicates that none of the variability in the dependent is explained by the explanatory (no relationship between data points and fitted line) and 1.0 indicates that the model explains all of the variability in the dependent (fitted line follows data points exactly).

R provides the `R-squared` and the `Adjusted R-squared`. 
The adjusted R-squared includes a penalty the more explanatory variables are included in the model. 
So if the model includes variables which do not contribute to the description of the dependent variable, the adjusted R-squared will be lower. 

Looking again at Figure \@ref(fig:chap07-fig-types), in A, a simple model of coffee alone does not describe the data well (adjusted R-squared 0.38). 
Adding smoking to the model improves the fit as can be seen by the fitted lines (0.87).
But a true interaction exists in the actual data. 
By including this interaction in the model, the fit is very good indeed (0.93).

### Confounding {#chap07-confound}
\index{linear regression@\textbf{linear regression}!confounding}
\index{confounding}

The last important concept to mention here is confounding. 
Confounding is a situation in which the association between an explanatory variable (exposure) and outcome (dependent variable) is distorted by the presence of another explanatory variable.

In our example, confounding exists if there is an association between smoking and blood pressure AND smoking and coffee consumption (Figure \@ref(fig:chap07-fig-dags)C). 
This exists if smokers drink more coffee than non-smokers. 

Figure \@ref(fig:chap07-fig-confounding) shows this really clearly. 
The underlying data have now been altered so that those who drink more than two cups of coffee per day also smoke and those who drink fewer than two cups per day do not smoke. 
A true effect of smoking on blood pressure is simulated, but there is NO effect of coffee on blood pressure in this example. 

If we only fit blood pressure by coffee consumption (Figure \@ref(fig:chap07-fig-confounding)A), then we may mistakenly conclude a relationship between coffee consumption and blood pressure. 
But this does not exist, because the ground truth we have set is that no relationship exists between coffee and blood pressure. 
We are actually looking at the effect of smoking on blood pressure, which is confounding the effect of coffee on blood pressure. 

If we include the confounder in the model by adding smoking, the true relationship becomes apparent. 
Two parallel flat lines indicating no effect of coffee on blood pressure, but a relationship between smoking and blood pressure. 
This procedure is referred to as controlling for or adjusting for confounders. 

<div class="figure">
<img src="images/chapter07/7_confounding.png" alt="Multivariable linear regression with confounding of coffee drinking by smoking." width="790" />
<p class="caption">(\#fig:chap07-fig-confounding)Multivariable linear regression with confounding of coffee drinking by smoking.</p>
</div>

### Summary
We have intentionally spent some time going through the principles and applications of linear regression because it is so important. 
A firm grasp of these concepts leads to an understanding of other regression procedures, such as logistic regression and Cox Proportional Hazards regression. 

We will now perform all this ourselves in R using the gapminder dataset which you are familiar with from preceding chapters. 

## Fitting simple models

### The Question (2)
We are interested in modelling the change in life expectancy for different countries over the past 60 years.  

### Get the data

```r
library(tidyverse)
library(gapminder) # dataset
library(finalfit)
library(broom)

theme_set(theme_bw())
mydata = gapminder
```

### Check the data
Always check a new dataset, as described in Section \@ref(chap06-h2-check).


```r
glimpse(mydata) # each variable as line, variable type, first values
missing_glimpse(mydata) # missing data for each variable
ff_glimpse(mydata) # summary statistics for each variable
```

### Plot the data

Let's plot the life expectancies in European countries over the past 60 years, focussing on the UK and Turkey. 
We can add in simple best fit lines using `geom_smooth()`.


```r
mydata %>%                        
  filter(continent == "Europe") %>%    # Europe only
  ggplot(aes(x = year, y = lifeExp)) + # lifeExp~year  
  geom_point() +                       # plot points
  facet_wrap(~ country) +              # facet by country
  scale_x_continuous(
    breaks = c(1960, 2000)) +          # adjust x-axis 
  geom_smooth(method = "lm")           # add regression lines
```

<div class="figure">
<img src="07_linear_regression_files/figure-html/unnamed-chunk-3-1.png" alt="Scatterplots with linear regression lines: Life expectancy by year in European countries" width="672" />
<p class="caption">(\#fig:unnamed-chunk-3)Scatterplots with linear regression lines: Life expectancy by year in European countries</p>
</div>

### Simple linear regression
\index{functions@\textbf{functions}!lm}

As you can see, `ggplot()` is very happy to run and plot linear regression models for us.
While this is convenient for a quick look, we usually want to build, run, and explore these models ourselves. 
We can then investigate the intercepts and the slope coefficients (linear increase per year):

First let's plot two countries to compare, Turkey and United Kingdom:


```r
mydata %>% 
  filter(country %in% c("Turkey", "United Kingdom")) %>% 
  ggplot(aes(x = year, y = lifeExp, colour = country)) + 
  geom_point()
```

<div class="figure">
<img src="07_linear_regression_files/figure-html/unnamed-chunk-4-1.png" alt="Scatterplot: Life expectancy by year: Turkey and United Kingdom" width="432" />
<p class="caption">(\#fig:unnamed-chunk-4)Scatterplot: Life expectancy by year: Turkey and United Kingdom</p>
</div>

The two non-parallel lines may make you think of what has been discussed above (Figure \@ref(chap07-fig-types)). 

First, let's model the two countries separately. 


```r
# United Kingdom
fit_uk = mydata %>%
  filter(country == "United Kingdom") %>% 
  lm(lifeExp~year, data = .)

fit_uk %>% 
  summary()
```

```
## 
## Call:
## lm(formula = lifeExp ~ year, data = .)
## 
## Residuals:
##      Min       1Q   Median       3Q      Max 
## -0.69767 -0.31962  0.06642  0.36601  0.68165 
## 
## Coefficients:
##               Estimate Std. Error t value Pr(>|t|)    
## (Intercept) -2.942e+02  1.464e+01  -20.10 2.05e-09 ***
## year         1.860e-01  7.394e-03   25.15 2.26e-10 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.4421 on 10 degrees of freedom
## Multiple R-squared:  0.9844,	Adjusted R-squared:  0.9829 
## F-statistic: 632.5 on 1 and 10 DF,  p-value: 2.262e-10
```



```r
# Turkey
fit_turkey = mydata %>%
  filter(country == "Turkey") %>% 
  lm(lifeExp~year, data = .)

fit_turkey %>% 
  summary()
```

```
## 
## Call:
## lm(formula = lifeExp ~ year, data = .)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -2.4373 -0.3457  0.1653  0.9008  1.1033 
## 
## Coefficients:
##               Estimate Std. Error t value Pr(>|t|)    
## (Intercept) -924.58989   37.97715  -24.35 3.12e-10 ***
## year           0.49724    0.01918   25.92 1.68e-10 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 1.147 on 10 degrees of freedom
## Multiple R-squared:  0.9853,	Adjusted R-squared:  0.9839 
## F-statistic: 671.8 on 1 and 10 DF,  p-value: 1.681e-10
```


*Accessing the coefficients of linear regression*
\index{linear regression@\textbf{linear regression}!coefficients}

A simple linear regression model will return two coefficients - the intercept and the slope (the second returned value). 
Compare these coefficients to the `summary()` output above to see where these numbers came from.


```r
fit_uk$coefficients
```

```
##  (Intercept)         year 
## -294.1965876    0.1859657
```


```r
fit_turkey$coefficients
```

```
##  (Intercept)         year 
## -924.5898865    0.4972399
```

The slopes make sense - the results of the linear regression say that in the UK, life expectancy increases by 0.186 every year, whereas in Turkey the change is 0.497 per year.
The negative intercepts, however, are less obvious to think about.
In this example, the intercept is telling us that life expectancy at year 0 in the United Kingdom (some 2000 years ago) was -294 years.
While this is mathematically correct (based on the data we have), it obviously makes no sense in practice.
It is important to think about the range over which you can extend your model predictions, and where they just become unrealistic. 

To make the intercepts meaningful, we will add in a new column called `year_from1952` and re-run `fit_uk` and `fit_turkey` using `year_from1952` instead of `year`.


```r
mydata = mydata %>% 
  mutate(year_from1952 = year - 1952)

fit_uk = mydata %>%
  filter(country == "United Kingdom") %>% 
  lm(lifeExp ~ year_from1952, data = .)

fit_turkey = mydata %>%
  filter(country == "Turkey") %>% 
  lm(lifeExp ~ year_from1952, data = .)
```



```r
fit_uk$coefficients
```

```
##   (Intercept) year_from1952 
##    68.8085256     0.1859657
```



```r
fit_turkey$coefficients
```

```
##   (Intercept) year_from1952 
##    46.0223205     0.4972399
```

Now, the updated results tell us that in year 1952, the life expectancy in the United Kingdom was 69 years. 
Note that the slopes do not change.
There was nothing wrong with the original model and the results were correct, the intercept was just not very meaningful.

*Accessing all model information `tidy()` and `glance()`*
\index{functions@\textbf{functions}!tidy}
\index{functions@\textbf{functions}!glance}

In the fit_uk and fit_turkey examples above, we were using `fit_uk %>% summary()` to get R to print out a summary of the model.
This summary is not, however, in a rectangular shape so we can't easily access the values or put them in a table/use as information on plot labels.

We use the `tidy()` function from `library(broom)` to get the variable(s) and specific values in a nice tibble:


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

In the `tidy()` output, the column `estimate` includes both the intercepts and slopes.

And we use the `glance()` function to get overall model statistics (mostly the r.squared).

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

### Multivariable linear regression
\index{linear regression@\textbf{linear regression}!multivariable}

Multivariable linear regression includes more than one explanatory variable.
There are a few ways to include more variables, depending on whether they should share the intercept and how they interact:

Simple linear regression (exactly one predictor variable):

`myfit = lm(lifeExp ~ year, data = mydata)`

Multivariable linear regression (additive):

`myfit = lm(lifeExp ~ year + country, data = mydata)`

Multivariable linear regression (interaction):

`myfit = lm(lifeExp ~ year * country, data = mydata)`

This equivalent to:
`myfit = lm(lifeExp ~ year + country + year:country, data = mydata)`

These examples of multivariable regression include two variables: `year` and `country`, but we could include more by adding them with `+`, it does not just have to be two.

We will now create three different linear regression models to further illustrate the difference between a simple model, additive model, and multiplicative model.

*Model 1: year only*


```r
# UK and Turkey dataset
mydata_UK_T = mydata %>% 
  filter(country %in% c("Turkey", "United Kingdom"))

fit_both1 = mydata_UK_T %>% 
  lm(lifeExp ~ year_from1952, data = .)
fit_both1
```

```
## 
## Call:
## lm(formula = lifeExp ~ year_from1952, data = .)
## 
## Coefficients:
##   (Intercept)  year_from1952  
##       57.4154         0.3416
```

```r
mydata_UK_T %>% 
  mutate(pred_lifeExp = predict(fit_both1)) %>% 
  ggplot() + 
  geom_point(aes(x = year, y = lifeExp, colour = country)) +
  geom_line(aes(x = year, y = pred_lifeExp))
```

<div class="figure">
<img src="07_linear_regression_files/figure-html/unnamed-chunk-14-1.png" alt="Scatter and line plot. Life expectancy in Turkey and the UK - univariable fit." width="432" />
<p class="caption">(\#fig:unnamed-chunk-14)Scatter and line plot. Life expectancy in Turkey and the UK - univariable fit.</p>
</div>

By fitting to year only (`lifeExp ~ year_from1952`), the model ignores country.
This gives us a fitted line which is the average of life expectancy in the UK and Turkey.
This may be desirable, depending on the question.
But here we want to best describe the data. 


**How we made the plot and what does `predict()` do?**
Previously, we were using `geom_smooth(method = "lm")` to conveniently add linear regression lines on a scatterplot.
When a scatterplot includes categorical value (e.g., the points are coloured by a variable), the regression lines `geom_smooth()` draws are multiplicative.
That is great, and almost always exactly what we want. 
Here, however, to illustrate the difference between the different models, we will have to use the `predict()` model and `geom_line()` to have full control over the plotted regression lines.


```r
mydata_UK_T %>% 
  mutate(pred_lifeExp = predict(fit_both1)) %>% 
  select(country, year, lifeExp, pred_lifeExp) %>% 
  group_by(country) %>%
  slice(1, 6, 12)
```

```
## # A tibble: 6 x 4
## # Groups:   country [2]
##   country         year lifeExp pred_lifeExp
##   <fct>          <int>   <dbl>        <dbl>
## 1 Turkey          1952    43.6         57.4
## 2 Turkey          1977    59.5         66.0
## 3 Turkey          2007    71.8         76.2
## 4 United Kingdom  1952    69.2         57.4
## 5 United Kingdom  1977    72.8         66.0
## 6 United Kingdom  2007    79.4         76.2
```

Note how the `slice()` function recognises group_by() and in this case shows us the 1st, 6th, and 12th observation within each group.



*Model 2: year + country*

```r
fit_both2 = mydata_UK_T %>% 
  lm(lifeExp ~ year_from1952 + country, data = .)
fit_both2
```

```
## 
## Call:
## lm(formula = lifeExp ~ year_from1952 + country, data = .)
## 
## Coefficients:
##           (Intercept)          year_from1952  countryUnited Kingdom  
##               50.3023                 0.3416                14.2262
```

```r
mydata_UK_T %>% 
  mutate(pred_lifeExp = predict(fit_both2)) %>% 
  ggplot() + 
  geom_point(aes(x = year, y = lifeExp, colour = country)) +
  geom_line(aes(x = year, y = pred_lifeExp, colour = country))
```

<div class="figure">
<img src="07_linear_regression_files/figure-html/unnamed-chunk-16-1.png" alt="Scatter and line plot. Life expectancy in Turkey and the UK - multivariable additive fit." width="432" />
<p class="caption">(\#fig:unnamed-chunk-16)Scatter and line plot. Life expectancy in Turkey and the UK - multivariable additive fit.</p>
</div>

This is better, by including country in the model, we now have fitted lines more closely representing the data.
However, the lines are constrained to be parallel. 
This is the additive model that was discussed above.
We need to include an interaction term to allow the effect of year on life expectancy to vary by country in a non-additive manner. 

*Model 3: year &ast; country*


```r
fit_both3 = mydata_UK_T %>% 
  lm(lifeExp ~ year_from1952 * country, data = .)
fit_both3
```

```
## 
## Call:
## lm(formula = lifeExp ~ year_from1952 * country, data = .)
## 
## Coefficients:
##                         (Intercept)                        year_from1952  
##                             46.0223                               0.4972  
##               countryUnited Kingdom  year_from1952:countryUnited Kingdom  
##                             22.7862                              -0.3113
```

```r
mydata_UK_T %>% 
  mutate(pred_lifeExp = predict(fit_both2)) %>% 
  ggplot() + 
  geom_point(aes(x = year, y = lifeExp, colour = country)) +
  geom_line(aes(x = year, y = pred_lifeExp, colour = country))
```

<div class="figure">
<img src="07_linear_regression_files/figure-html/unnamed-chunk-17-1.png" alt="Scatter and line plot. Life expectancy in Turkey and the UK - multivariable multiplicative fit." width="432" />
<p class="caption">(\#fig:unnamed-chunk-17)Scatter and line plot. Life expectancy in Turkey and the UK - multivariable multiplicative fit.</p>
</div>

This fits the data much better than the previous two models.
You can check the R-squared using `summary(fit_both3)`.

**Advanced tip:** we can apply a function on multiple objects at once by putting them in a `list()` and using a `map_()` function from the **purrr** package. `library(purrr)` gets installed and loaded with `library(tidyverse)`, but it is outwith the scope of this book. Do look it up once you get a little more comfortable with using R, and realise that you are starting to do similar things over and over again. For example, this code:


```r
mod_stats1 = glance(fit_both1)
mod_stats2 = glance(fit_both2)
mod_stats3 = glance(fit_both3)

bind_rows(mod_stats1, mod_stats2, mod_stats3)
```

returns the exact same thing as:

```r
list(fit_both1, fit_both2, fit_both3) %>% 
  map_df(glance)
```

```
## # A tibble: 3 x 11
##   r.squared adj.r.squared sigma statistic  p.value    df logLik   AIC   BIC
##       <dbl>         <dbl> <dbl>     <dbl>    <dbl> <int>  <dbl> <dbl> <dbl>
## 1     0.373         0.344 7.98       13.1 1.53e- 3     2  -82.9 172.  175. 
## 2     0.916         0.908 2.99      114.  5.18e-12     3  -58.8 126.  130. 
## 3     0.993         0.992 0.869     980.  7.30e-22     4  -28.5  67.0  72.9
## # … with 2 more variables: deviance <dbl>, df.residual <int>
```

What happens here is that `map_df()` applies a function on each object in the list it gets passed, and returns a df (data frame). In this case, the function is `glance()` (note that once inside `map_df()`, `glance` does not have its own brackets.

### Check assumptions

The assumptions of linear regression can be checked with diagnostic plots, either by passing the fitted object (`lm()` output) to base R `plot()`, or by using the more convenient function below. 


```r
library(ggfortify)
autoplot(fit_both3)
```

<div class="figure">
<img src="07_linear_regression_files/figure-html/chap07-diags-example-1.png" alt="Diagnostic plots. Life expectancy in Turkey and the UK - multivariable multiplicative model." width="518.4" />
<p class="caption">(\#fig:chap07-diags-example)Diagnostic plots. Life expectancy in Turkey and the UK - multivariable multiplicative model.</p>
</div>


## Fitting more complex models

### The Question (3)

Finally in this section, we are going to fit a more complex linear regression model.
Here, we will discuss variable selection and introduce the Akaike Information Criterion (AIC). 

We will introduce a new dataset: The Western Collaborative Group Study. 
This classic dataset includes observations of 3154 healthy young men aged 39-59 from the San Francisco area who were assessed for their personality type.
It aimed to capture the occurrence of coronary heart disease over the following 8.5 years. 

We will use it, however, to explore the relationship between systolic blood pressure (`sbp`) and personality type (`personality_2L`), accounting for potential confounders such as weight (`weight`). 
Now this is just for fun - don't write in!
The study was designed to look at cardiovascular events as the outcome, not blood pressure. 
But it is a convenient to use blood pressure as a continuous outcome from this dataset, even if that was not the intention of the study.

The included personality types are A: aggressive and B: passive. 

### Model fitting principles
\index{linear regression@\textbf{linear regression}!model fitting principles}

We suggest building statistical models on the basis of the following six pragmatic principles: 

1. As few explanatory variables should be used as possible (parsimony);
2. Explanatory variables associated with the outcome variable in previous studies should be accounted for; 
3. Demographic variables should be included in model exploration; 
4. Population stratification should be incorporated if available; 
5. Interactions should be checked and included if influential; 
6. Final model selection should be performed using a "criterion-based approach"
  + minimise the Akaike information criterion (AIC)
  + maximise the adjusted R-squared value.

  <!-- + maximise the c-statistic (area under the receiver operator curve). -->

This is not the law, but it probably should be. 
These principles are sensible as we will discuss through the rest of this book.
We strongly suggest you do not use automated methods of variable selection. 
These are often "forward selection" or "backward elimination" methods for including or excluding particular variables on the basis of a statistical property.

In certain settings, these approaches may be found to work. 
However, they create an artificial distance between you and the problem you are working on. 
They give you a false sense of certainty that the model you have created is in some sense valid. 
And quite frequently, they will just get it wrong. 

Alternatively, you can follow the six principles above.

A variable may have previously been shown to strongly predict an outcome (think smoking and risk of cancer). 
This should give you good reason to consider it in your model. 
But perhaps you think that previous studies were incorrect, or that the variable is confounded by another. 
All this is fair, but it will be expected that this new knowledge is clearly demonstrated by you, so do not omit these variables before you start.

There are some variables that are so commonly associated with particular outcomes in healthcare that they should almost always be included at the start. 
Age, sex, social class, and co-morbidity for instance are commonly associated with  survival. These need to be assessed before you start looking at your explanatory variable of interest.

Furthermore, patients are often clustered by a particular grouping variable, such as treating hospital. 
There will be commonalities between these patients that may not be fully explained by your observed variables. 
To estimate the coefficients of your variables of interest most accurately, clustering should be accounted for in the analysis. 

As demonstrated above, the purpose of the model is to provide a best fit approximation of the underlying data. 
Effect modification and interactions commonly exist in heath datasets, and should be incorporated if present. 

Finally, we want to assess how well our models fit the data with 'model checking'. 
The effect of adding or removing one variable to the coefficients of the other variables in the model is very important, and will be discussed later. 
Measures of goodness-of-fit such as the `AIC`, can also be of great use when deciding which model choice is most valid. 

### AIC {#chap07-aic}
\index{linear regression@\textbf{linear regression}!AIC}
\index{AIC}

The Akaike Information Criterion (AIC) is an alternative goodness-of-fit measure. 
In that sense, it is similar to the R-squared, but it has a different statistical basis. 
It is useful because it can be used to help guide the best fit in generalised linear models such as logistic regression (see chapter \@ref(chap09-h1)). 
It is based on the likelihood but is also penalised for the number of variables present in the model. We aim to have as small an AIC as possible. 
The value of the number itself has no inherent meaning, but it is used to compare different models of the same data. 

### Get the data


```r
mydata = finalfit::wcgs #press F1 here for details
```

### Check the data

As always, when you receive a new dataset, carefully check that it does not contain errors. 



<table class="table" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:unnamed-chunk-22)WCGS data, ff\_glimpse: continuous</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> label </th>
   <th style="text-align:left;"> var_type </th>
   <th style="text-align:left;"> n </th>
   <th style="text-align:right;"> missing_n </th>
   <th style="text-align:right;"> mean </th>
   <th style="text-align:right;"> sd </th>
   <th style="text-align:right;"> median </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;width: 4cm; "> Subject ID </td>
   <td style="text-align:left;"> &lt;int&gt; </td>
   <td style="text-align:left;"> 3154 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 10477.9 </td>
   <td style="text-align:right;"> 5877.4 </td>
   <td style="text-align:right;"> 11405.5 </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 4cm; "> Age (years) </td>
   <td style="text-align:left;"> &lt;int&gt; </td>
   <td style="text-align:left;"> 3154 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 46.3 </td>
   <td style="text-align:right;"> 5.5 </td>
   <td style="text-align:right;"> 45.0 </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 4cm; "> Height (inches) </td>
   <td style="text-align:left;"> &lt;int&gt; </td>
   <td style="text-align:left;"> 3154 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 69.8 </td>
   <td style="text-align:right;"> 2.5 </td>
   <td style="text-align:right;"> 70.0 </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 4cm; "> Weight (pounds) </td>
   <td style="text-align:left;"> &lt;int&gt; </td>
   <td style="text-align:left;"> 3154 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 170.0 </td>
   <td style="text-align:right;"> 21.1 </td>
   <td style="text-align:right;"> 170.0 </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 4cm; "> Systolic BP (mmHg) </td>
   <td style="text-align:left;"> &lt;int&gt; </td>
   <td style="text-align:left;"> 3154 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 128.6 </td>
   <td style="text-align:right;"> 15.1 </td>
   <td style="text-align:right;"> 126.0 </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 4cm; "> Diastolic BP (mmHg) </td>
   <td style="text-align:left;"> &lt;int&gt; </td>
   <td style="text-align:left;"> 3154 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 82.0 </td>
   <td style="text-align:right;"> 9.7 </td>
   <td style="text-align:right;"> 80.0 </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 4cm; "> Cholesterol (mg/100 ml) </td>
   <td style="text-align:left;"> &lt;int&gt; </td>
   <td style="text-align:left;"> 3142 </td>
   <td style="text-align:right;"> 12 </td>
   <td style="text-align:right;"> 226.4 </td>
   <td style="text-align:right;"> 43.4 </td>
   <td style="text-align:right;"> 223.0 </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 4cm; "> Cigarettes/day </td>
   <td style="text-align:left;"> &lt;int&gt; </td>
   <td style="text-align:left;"> 3154 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 11.6 </td>
   <td style="text-align:right;"> 14.5 </td>
   <td style="text-align:right;"> 0.0 </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 4cm; "> Time to CHD event </td>
   <td style="text-align:left;"> &lt;int&gt; </td>
   <td style="text-align:left;"> 3154 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 2683.9 </td>
   <td style="text-align:right;"> 666.5 </td>
   <td style="text-align:right;"> 2942.0 </td>
  </tr>
</tbody>
</table>

<table class="table" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:unnamed-chunk-22)WCGS data, ff\_glimpse: categorical</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> label </th>
   <th style="text-align:left;"> var_type </th>
   <th style="text-align:left;"> n </th>
   <th style="text-align:right;"> missing_n </th>
   <th style="text-align:right;"> levels_n </th>
   <th style="text-align:right;"> levels </th>
   <th style="text-align:right;"> levels_count </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Personality type </td>
   <td style="text-align:left;"> &lt;fct&gt; </td>
   <td style="text-align:left;"> 3154 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;width: 3cm; "> "A1", "A2", "B3", "B4" </td>
   <td style="text-align:right;width: 3cm; "> 264, 1325, 1216, 349 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Personality type </td>
   <td style="text-align:left;"> &lt;fct&gt; </td>
   <td style="text-align:left;"> 3154 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;width: 3cm; "> "B", "A" </td>
   <td style="text-align:right;width: 3cm; "> 1565, 1589 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Smoking </td>
   <td style="text-align:left;"> &lt;fct&gt; </td>
   <td style="text-align:left;"> 3154 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;width: 3cm; "> "Non-smoker", "Smoker" </td>
   <td style="text-align:right;width: 3cm; "> 1652, 1502 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Corneal arcus </td>
   <td style="text-align:left;"> &lt;fct&gt; </td>
   <td style="text-align:left;"> 3152 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;width: 3cm; "> "No", "Yes", "(Missing)" </td>
   <td style="text-align:right;width: 3cm; "> 2211, 941, 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> CHD event </td>
   <td style="text-align:left;"> &lt;fct&gt; </td>
   <td style="text-align:left;"> 3154 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;width: 3cm; "> "No", "Yes" </td>
   <td style="text-align:right;width: 3cm; "> 2897, 257 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Type CHD </td>
   <td style="text-align:left;"> &lt;fct&gt; </td>
   <td style="text-align:left;"> 3154 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;width: 3cm; "> "No", "MI_SD", "Silent_MI", "Angina" </td>
   <td style="text-align:right;width: 3cm; "> 2897, 135, 71, 51 </td>
  </tr>
</tbody>
</table>

### Plot the data




```r
mydata %>%
  ggplot(aes(y = sbp, x = weight,
             colour = personality_2L)) +   # Personality type
  geom_point(alpha = 0.2) +                # Add transparency
  geom_smooth(method = "lm", se = FALSE)
```

<div class="figure">
<img src="07_linear_regression_files/figure-html/chap07-fig-bp-personality_type-1.png" alt="Scatter and line plot. Systolic blood pressure by weight and personality type." width="432" />
<p class="caption">(\#fig:chap07-fig-bp-personality_type)Scatter and line plot. Systolic blood pressure by weight and personality type.</p>
</div>

From Figure \@ref(fig:chap07-fig-bp-personality_type)), we can see that there is a weak relationship between weight and blood pressure. 
In addition, there is really no meaningful effect of personality type on blood pressure. 
This is really important because, as you will see below, we are about to "find" some highly statistically significant effects in a model.

### Linear regression with finalfit
\index{linear regression@\textbf{linear regression}!finalfit}

**finalfit** is our own package and provides a convenient set of functions for fitting regression models with results presented in final tables.

There are a host of features with example code at the [finalfit website](https://finalfit.org).

Here we will use the all-in-one `finalfit()` function, which takes a dependent variable and one or more explanatory variables. 
The appropriate regression for the dependent variable is performed, from a choice of linear, logistic, and Cox Proportional Hazards regression models. 
Summary statistics, together with a univariable and a multivariable regression analysis are produced in a final results table. 


```r
dependent = "sbp"
explanatory = "personality_2L"
fit_sbp1 = mydata %>% 
  finalfit(dependent, explanatory, metrics = TRUE)
```
\index{functions@\textbf{functions}!finalfit}

<table class="table" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:unnamed-chunk-25)Linear regression: Systolic blood pressure by personality type.</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Dependent: Systolic BP (mmHg) </th>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> unit </th>
   <th style="text-align:right;"> value </th>
   <th style="text-align:right;"> Coefficient (univariable) </th>
   <th style="text-align:right;"> Coefficient (multivariable) </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;width: 4cm; "> Personality type </td>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> Mean (sd) </td>
   <td style="text-align:right;"> 127.5 (14.4) </td>
   <td style="text-align:right;"> - </td>
   <td style="text-align:right;"> - </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 4cm; ">  </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> Mean (sd) </td>
   <td style="text-align:right;"> 129.8 (15.7) </td>
   <td style="text-align:right;"> 2.32 (1.26 to 3.37, p&lt;0.001) </td>
   <td style="text-align:right;"> 2.32 (1.26 to 3.37, p&lt;0.001) </td>
  </tr>
</tbody>
</table>

<table class="table" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:unnamed-chunk-25)Model metrics: Systolic blood pressure by personality type.</caption>
 <thead>
  <tr>
   <th style="text-align:left;">  </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;width: 18cm; "> Number in dataframe = 3154, Number in model = 3154, Missing = 0, Log-likelihood = -13031.39, AIC = 26068.8, R-squared = 0.0059, Adjusted R-squared = 0.0056 </td>
  </tr>
</tbody>
</table>

Let's look first at our explanatory variable of interest, personality type.
When a factor is entered into a regression model, the default is to compare each level of the factor with a "reference level".
What you choose as the reference level can be easily changed (see section \@ref(chap08-h2-fct-relevel).
Alternative methods are available (sometimes called *contrasts*), but the default method is likely to be what you want almost all the time. 
Note this is sometimes referred to as creating a "dummy variable". 

It can be seen that the mean blood pressure for type A is higher than for type B. 
As there is only one variable, the univariable and multivariable analyses are the same (the multivariable column can be removed if desired by including `select(-5) #5th column` in the piped function). 

Although the difference is numerically quite small (2.3 mmHg), it is statistically significant partly because of the large number of patients in the study. 
The optional `metrics = TRUE` output gives us the number of rows (in this case, subjects) included in the model. 
This is important as frequently people forget that in standard regression models, missing data from any variable results in the that entire row being excluded from the analysis (see chapter \@ref(chap13-h1)). 

Note the `AIC` and `Adjusted R-squared` results. 
The adjusted R-squared is very low - the model only explains only 0.6% of the variation in systolic blood pressure. 
This is to be expected, given our scatterplot above. 

Let's now include subject weight, which we have hypothesised may influence blood pressure. 


```r
dependent = "sbp"
explanatory = c("weight", "personality_2L")
fit_sbp2 = mydata %>% 
  finalfit(dependent, explanatory, metrics = TRUE)
```

<table class="table" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:chap07-tab-bp-personality-weight)Multivariable linear regression: Systolic blood pressure by personality type and weight.</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Dependent: Systolic BP (mmHg) </th>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> unit </th>
   <th style="text-align:right;"> value </th>
   <th style="text-align:right;"> Coefficient (univariable) </th>
   <th style="text-align:right;"> Coefficient (multivariable) </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;width: 4cm; "> Weight (pounds) </td>
   <td style="text-align:left;"> [78,320] </td>
   <td style="text-align:right;"> Mean (sd) </td>
   <td style="text-align:right;"> 128.6 (15.1) </td>
   <td style="text-align:right;"> 0.18 (0.16 to 0.21, p&lt;0.001) </td>
   <td style="text-align:right;"> 0.18 (0.16 to 0.20, p&lt;0.001) </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 4cm; "> Personality type </td>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> Mean (sd) </td>
   <td style="text-align:right;"> 127.5 (14.4) </td>
   <td style="text-align:right;"> - </td>
   <td style="text-align:right;"> - </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 4cm; ">  </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> Mean (sd) </td>
   <td style="text-align:right;"> 129.8 (15.7) </td>
   <td style="text-align:right;"> 2.32 (1.26 to 3.37, p&lt;0.001) </td>
   <td style="text-align:right;"> 1.99 (0.97 to 3.01, p&lt;0.001) </td>
  </tr>
</tbody>
</table>

<table class="table" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:chap07-tab-bp-personality-weight)Multivariable linear regression metrics: Systolic blood pressure by personality type and weight.</caption>
 <thead>
  <tr>
   <th style="text-align:left;">  </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;width: 18cm; "> Number in dataframe = 3154, Number in model = 3154, Missing = 0, Log-likelihood = -12928.82, AIC = 25865.6, R-squared = 0.068, Adjusted R-squared = 0.068 </td>
  </tr>
</tbody>
</table>

The output shows us the range for weight (78 to 320 pounds) and the mean (standard deviation) systolic blood pressure for the whole cohort. 

The coefficient with 95% confidence interval is provided by default. 
This is interpreted as: for each pound increase in weight, there is on average a corresponding increase of 0.18 mmHg in systolic blood pressure.

Note the difference in the interpretation of continuous and categorical variables in the regression model output (Figure \@ref(tab:chap07-tab-bp-personality-weight)). 

The adjusted R-squared is now higher - the personality and weight together explain 6.8% of the variation in blood pressure.  
The AIC is also slightly lower meaning this new model better fits the data. 

There is little change in the size of the coefficients for each variable in the multivariable analysis, meaning that they are reasonably independent. 
As an exercise, check the the distribution of weight by personality type using a boxplot. 

Let's now add in other variables that may influence systolic blood pressure.



```r
dependent = "sbp"
explanatory = c("personality_2L", "weight", "age", 
                "height", "chol", "smoking") 
fit_sbp3 = mydata %>% 
  finalfit(dependent, explanatory, metrics = TRUE)
```

<table class="table" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:unnamed-chunk-28)Multivariable linear regression: Systolic blood pressure by available explanatory variables.</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Dependent: Systolic BP (mmHg) </th>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> unit </th>
   <th style="text-align:right;"> value </th>
   <th style="text-align:right;"> Coefficient (univariable) </th>
   <th style="text-align:right;"> Coefficient (multivariable) </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;width: 4cm; "> Personality type </td>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> Mean (sd) </td>
   <td style="text-align:right;"> 127.4 (14.3) </td>
   <td style="text-align:right;"> - </td>
   <td style="text-align:right;"> - </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 4cm; ">  </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> Mean (sd) </td>
   <td style="text-align:right;"> 129.8 (15.7) </td>
   <td style="text-align:right;"> 2.32 (1.26 to 3.37, p&lt;0.001) </td>
   <td style="text-align:right;"> 1.44 (0.44 to 2.43, p=0.005) </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 4cm; "> Weight (pounds) </td>
   <td style="text-align:left;"> [78,320] </td>
   <td style="text-align:right;"> Mean (sd) </td>
   <td style="text-align:right;"> 128.6 (15.1) </td>
   <td style="text-align:right;"> 0.18 (0.16 to 0.21, p&lt;0.001) </td>
   <td style="text-align:right;"> 0.24 (0.21 to 0.27, p&lt;0.001) </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 4cm; "> Age (years) </td>
   <td style="text-align:left;"> [39,59] </td>
   <td style="text-align:right;"> Mean (sd) </td>
   <td style="text-align:right;"> 128.6 (15.1) </td>
   <td style="text-align:right;"> 0.45 (0.36 to 0.55, p&lt;0.001) </td>
   <td style="text-align:right;"> 0.43 (0.33 to 0.52, p&lt;0.001) </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 4cm; "> Height (inches) </td>
   <td style="text-align:left;"> [60,78] </td>
   <td style="text-align:right;"> Mean (sd) </td>
   <td style="text-align:right;"> 128.6 (15.1) </td>
   <td style="text-align:right;"> 0.11 (-0.10 to 0.32, p=0.302) </td>
   <td style="text-align:right;"> -0.84 (-1.08 to -0.61, p&lt;0.001) </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 4cm; "> Cholesterol (mg/100 ml) </td>
   <td style="text-align:left;"> [103,645] </td>
   <td style="text-align:right;"> Mean (sd) </td>
   <td style="text-align:right;"> 128.6 (15.1) </td>
   <td style="text-align:right;"> 0.04 (0.03 to 0.05, p&lt;0.001) </td>
   <td style="text-align:right;"> 0.03 (0.02 to 0.04, p&lt;0.001) </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 4cm; "> Smoking </td>
   <td style="text-align:left;"> Non-smoker </td>
   <td style="text-align:right;"> Mean (sd) </td>
   <td style="text-align:right;"> 128.6 (15.4) </td>
   <td style="text-align:right;"> - </td>
   <td style="text-align:right;"> - </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 4cm; ">  </td>
   <td style="text-align:left;"> Smoker </td>
   <td style="text-align:right;"> Mean (sd) </td>
   <td style="text-align:right;"> 128.7 (14.6) </td>
   <td style="text-align:right;"> 0.08 (-0.98 to 1.14, p=0.883) </td>
   <td style="text-align:right;"> 0.95 (-0.05 to 1.96, p=0.063) </td>
  </tr>
</tbody>
</table>

<table class="table" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:unnamed-chunk-28)Model metrics: Systolic blood pressure by available explanatory variables.</caption>
 <thead>
  <tr>
   <th style="text-align:left;">  </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;width: 18cm; "> Number in dataframe = 3154, Number in model = 3142, Missing = 12, Log-likelihood = -12772.04, AIC = 25560.1, R-squared = 0.12, Adjusted R-squared = 0.12 </td>
  </tr>
</tbody>
</table>

Age, height, serum cholesterol, and smoking status have been added. 
Some of the variation explained by personality type has been taken up by these new variables - personality is now associated with an average change of blood pressure of 1.4 mmHg.

The adjusted R-squared now tells us that 12% of the variation in blood pressure is explained by the model, which is an improvement. 

Look out for variables that show large changes in effect size or a change in the direction of effect when going from a univariable to multivariable model. 
This means that the other variables in the model are having a large effect on this variable and the cause of this should be explored. 
For instance, in this example the effect of height changes size and direction. 
This is because of the close association between weight and height. 
For instance, it may be more sensible to work with body mass index ($weight / height^2$) rather than the two separate variables. 

In general, variables that are highly correlated with each other should be treated carefully in regression analysis. 
This is called collinearity and can lead to unstable estimates of coefficients. 
For more on this, see section \@ref(chap09-h2-multicollinearity).

Let's create a new variable called `bmi`, note the conversion from pounds and inches to kg and m:



```r
mydata = mydata %>% 
  mutate(
    bmi = ((weight*0.4536) / (height*0.0254)^2) %>% 
      ff_label("BMI")
  )
```

Weight and height can now be replaced in the model with BMI. 


```r
explanatory = c("personality_2L", "bmi", "age", 
                "chol", "smoking") 

fit_sbp4 = mydata %>% 
  finalfit(dependent, explanatory, metrics = TRUE)
```

<table class="table" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:unnamed-chunk-31)Multivariable linear regression: Systolic blood pressure using BMI.</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Dependent: Systolic BP (mmHg) </th>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> unit </th>
   <th style="text-align:right;"> value </th>
   <th style="text-align:right;"> Coefficient (univariable) </th>
   <th style="text-align:right;"> Coefficient (multivariable) </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;width: 4cm; "> Personality type </td>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> Mean (sd) </td>
   <td style="text-align:right;"> 127.4 (14.3) </td>
   <td style="text-align:right;"> - </td>
   <td style="text-align:right;"> - </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 4cm; ">  </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> Mean (sd) </td>
   <td style="text-align:right;"> 129.8 (15.7) </td>
   <td style="text-align:right;"> 2.32 (1.26 to 3.37, p&lt;0.001) </td>
   <td style="text-align:right;"> 1.51 (0.51 to 2.50, p=0.003) </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 4cm; "> BMI </td>
   <td style="text-align:left;"> [11.1919080981019,38.9518784577735] </td>
   <td style="text-align:right;"> Mean (sd) </td>
   <td style="text-align:right;"> 128.6 (15.1) </td>
   <td style="text-align:right;"> 1.69 (1.50 to 1.89, p&lt;0.001) </td>
   <td style="text-align:right;"> 1.65 (1.46 to 1.85, p&lt;0.001) </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 4cm; "> Age (years) </td>
   <td style="text-align:left;"> [39,59] </td>
   <td style="text-align:right;"> Mean (sd) </td>
   <td style="text-align:right;"> 128.6 (15.1) </td>
   <td style="text-align:right;"> 0.45 (0.36 to 0.55, p&lt;0.001) </td>
   <td style="text-align:right;"> 0.41 (0.32 to 0.50, p&lt;0.001) </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 4cm; "> Cholesterol (mg/100 ml) </td>
   <td style="text-align:left;"> [103,645] </td>
   <td style="text-align:right;"> Mean (sd) </td>
   <td style="text-align:right;"> 128.6 (15.1) </td>
   <td style="text-align:right;"> 0.04 (0.03 to 0.05, p&lt;0.001) </td>
   <td style="text-align:right;"> 0.03 (0.02 to 0.04, p&lt;0.001) </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 4cm; "> Smoking </td>
   <td style="text-align:left;"> Non-smoker </td>
   <td style="text-align:right;"> Mean (sd) </td>
   <td style="text-align:right;"> 128.6 (15.4) </td>
   <td style="text-align:right;"> - </td>
   <td style="text-align:right;"> - </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 4cm; ">  </td>
   <td style="text-align:left;"> Smoker </td>
   <td style="text-align:right;"> Mean (sd) </td>
   <td style="text-align:right;"> 128.7 (14.6) </td>
   <td style="text-align:right;"> 0.08 (-0.98 to 1.14, p=0.883) </td>
   <td style="text-align:right;"> 0.98 (-0.03 to 1.98, p=0.057) </td>
  </tr>
</tbody>
</table>

<table class="table" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:unnamed-chunk-31)Model metrics: Systolic blood pressure using BMI.</caption>
 <thead>
  <tr>
   <th style="text-align:left;">  </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;width: 18cm; "> Number in dataframe = 3154, Number in model = 3142, Missing = 12, Log-likelihood = -12775.03, AIC = 25564.1, R-squared = 0.12, Adjusted R-squared = 0.12 </td>
  </tr>
</tbody>
</table>

On the principle of parsimony, we may want to remove variables which are not contributing much to the model. 
For instance, let's compare models with and without the inclusion of smoking. 
This can be easily done using the `finalfit` `explanatory_multi` option.


```r
dependent = "sbp"
explanatory       = c("personality_2L", "bmi", "age", 
                      "chol", "smoking") 
explanatory_multi = c("bmi", "personality_2L", "age", 
                      "chol") 
fit_sbp5 = mydata %>% 
  finalfit(dependent, explanatory, 
           explanatory_multi, 
           keep_models = TRUE, metrics = TRUE)
```

<table class="table" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:unnamed-chunk-33)Multivariable linear regression: Systolic blood pressure by available explanatory variables and reduced model.</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Dependent: Systolic BP (mmHg) </th>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> unit </th>
   <th style="text-align:right;"> value </th>
   <th style="text-align:right;"> Coefficient (univariable) </th>
   <th style="text-align:right;"> Coefficient (multivariable) </th>
   <th style="text-align:right;"> Coefficient (multivariable reduced) </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;width: 4cm; "> Personality type </td>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> Mean (sd) </td>
   <td style="text-align:right;width: 4cm; "> 127.4 (14.3) </td>
   <td style="text-align:right;width: 4cm; "> - </td>
   <td style="text-align:right;width: 4cm; "> - </td>
   <td style="text-align:right;"> - </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 4cm; ">  </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> Mean (sd) </td>
   <td style="text-align:right;width: 4cm; "> 129.8 (15.7) </td>
   <td style="text-align:right;width: 4cm; "> 2.32 (1.26 to 3.37, p&lt;0.001) </td>
   <td style="text-align:right;width: 4cm; "> 1.51 (0.51 to 2.50, p=0.003) </td>
   <td style="text-align:right;"> 1.56 (0.57 to 2.56, p=0.002) </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 4cm; "> BMI </td>
   <td style="text-align:left;"> [11.1919080981019,38.9518784577735] </td>
   <td style="text-align:right;"> Mean (sd) </td>
   <td style="text-align:right;width: 4cm; "> 128.6 (15.1) </td>
   <td style="text-align:right;width: 4cm; "> 1.69 (1.50 to 1.89, p&lt;0.001) </td>
   <td style="text-align:right;width: 4cm; "> 1.65 (1.46 to 1.85, p&lt;0.001) </td>
   <td style="text-align:right;"> 1.62 (1.43 to 1.82, p&lt;0.001) </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 4cm; "> Age (years) </td>
   <td style="text-align:left;"> [39,59] </td>
   <td style="text-align:right;"> Mean (sd) </td>
   <td style="text-align:right;width: 4cm; "> 128.6 (15.1) </td>
   <td style="text-align:right;width: 4cm; "> 0.45 (0.36 to 0.55, p&lt;0.001) </td>
   <td style="text-align:right;width: 4cm; "> 0.41 (0.32 to 0.50, p&lt;0.001) </td>
   <td style="text-align:right;"> 0.41 (0.32 to 0.50, p&lt;0.001) </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 4cm; "> Cholesterol (mg/100 ml) </td>
   <td style="text-align:left;"> [103,645] </td>
   <td style="text-align:right;"> Mean (sd) </td>
   <td style="text-align:right;width: 4cm; "> 128.6 (15.1) </td>
   <td style="text-align:right;width: 4cm; "> 0.04 (0.03 to 0.05, p&lt;0.001) </td>
   <td style="text-align:right;width: 4cm; "> 0.03 (0.02 to 0.04, p&lt;0.001) </td>
   <td style="text-align:right;"> 0.03 (0.02 to 0.04, p&lt;0.001) </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 4cm; "> Smoking </td>
   <td style="text-align:left;"> Non-smoker </td>
   <td style="text-align:right;"> Mean (sd) </td>
   <td style="text-align:right;width: 4cm; "> 128.6 (15.4) </td>
   <td style="text-align:right;width: 4cm; "> - </td>
   <td style="text-align:right;width: 4cm; "> - </td>
   <td style="text-align:right;"> - </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 4cm; ">  </td>
   <td style="text-align:left;"> Smoker </td>
   <td style="text-align:right;"> Mean (sd) </td>
   <td style="text-align:right;width: 4cm; "> 128.7 (14.6) </td>
   <td style="text-align:right;width: 4cm; "> 0.08 (-0.98 to 1.14, p=0.883) </td>
   <td style="text-align:right;width: 4cm; "> 0.98 (-0.03 to 1.98, p=0.057) </td>
   <td style="text-align:right;"> - </td>
  </tr>
</tbody>
</table>

<table class="kable_wrapper table" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:unnamed-chunk-33)Model metrics: Systolic blood pressure by available explanatory variables (top) with reduced model (bottom).</caption>
<tbody>
  <tr>
   <td style="width: 18cm; "> 

<table>
 <thead>
  <tr>
   <th style="text-align:left;">  </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Number in dataframe = 3154, Number in model = 3142, Missing = 12, Log-likelihood = -12775.03, AIC = 25564.1, R-squared = 0.12, Adjusted R-squared = 0.12 </td>
  </tr>
</tbody>
</table>

 </td>
   <td> 

<table>
 <thead>
  <tr>
   <th style="text-align:left;">  </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Number in dataframe = 3154, Number in model = 3142, Missing = 12, Log-likelihood = -12776.83, AIC = 25565.7, R-squared = 0.12, Adjusted R-squared = 0.12 </td>
  </tr>
</tbody>
</table>

 </td>
  </tr>
</tbody>
</table>

This results in little change in the other coefficients and very little change in the AIC. 
We will consider the reduced model the final model. 

We can check the assumptions as above.


```r
dependent = "sbp"
explanatory_multi = c("bmi", "personality_2L", "age", 
                      "chol") 
mydata %>%
  lmmulti(dependent, explanatory_multi) %>% 
  autoplot()
```

<div class="figure">
<img src="07_linear_regression_files/figure-html/unnamed-chunk-34-1.png" alt="Diagnostic plots: linear regression model of systolic blood pressure." width="480" />
<p class="caption">(\#fig:unnamed-chunk-34)Diagnostic plots: linear regression model of systolic blood pressure.</p>
</div>


An important message in the results relates to the highly significant *p*-values in the table above. 
Should we conclude that in a "multivariable regression model controlling for BMI, age, and serum cholesterol, blood pressure was significantly elevated in those with a Type A personality (1.56 (0.57 to 2.56, p=0.002) compared with Type B?
The *p*-value looks impressive, but the actual difference in blood pressure is only 1.6 mmHg. 
Even at a population level, that seems unlikely to be clinically significant, fitting with our first thoughts when we saw the scatter plot. 

This serves to emphasise our most important point.
Our focus should be on understanding the underlying data itself, rather than relying on complex multidimensional modelling procedures. 
By making liberal use of upfront plotting, together with further visualisation as you understand the data, you will likely be able to draw most of the important conclusions that the data has to offer. 
Use modelling to quantify and confirm this, rather than as the primary method of data exploration. 

<!-- Coefficient plot -->
<!-- Consider lmer / random effects -->

### Summary

Time spent truly understanding linear regression is well spent. 
Not because you will spend a lot of time making linear regression models in health data science (we rarely do), but because it the essential foundation for understanding more advanced statistical models. 

It can even be argued that all [common statistical tests are linear models](https://lindeloev.github.io/tests-as-linear).
This great post demonstrates beautifully how the statistical tests we are most familiar with (such as t-test, Mann-Whitney U test, ANOVA, chi-squared test) can simply be considered as special cases of linear models, or close approximations. 

Regression is fitting lines, preferably straight, through data points. 
Make $\hat{y} = \beta_0 + \beta_1 x_1$ a close friend.

<!-- ## Exercise 5 -->

<!-- 1. Copy the multivariable linear regression model (where "Turkey" and the "United Kingdom" are in the same `lm()` model) from Exercise 4. -->

<!-- 2. Include a third country (e.g. "Portugal") in the `filter(country %in% c("Turkey", "United Kingdom", "Portugal"))` to your multivariable linear regression model. -->

<!-- 3. Do the results change? How, and why? -->

<!-- ```{r} -->
<!-- # Exercise 5 - your R code -->
<!-- ``` -->


<!-- ## Exercise 2 -->

<!-- Open the first Shiny app ("Simple regression"). Move the sliders until the red lines (residuals*) turn green - this means you've made the line fit the points as well as possible. Look at the intercept and slope - discuss with your neighbour or a tutor what these numbers mean/how they affect the straight line on the plot. -->

<!-- *Residual is how far away each point (observation) is from the linear regression line. (In this example it's the linear regression line, but residuals are relevant in many other contexts as well.) -->



<!-- ## Solutions -->

<!-- ## Exercise 1 solution -->

<!-- ```{r} -->
<!-- mydata %>%  -->
<!--   filter(country %in% c("United Kingdom", "Turkey")) %>%  -->
<!--   ggplot(aes(x = year, y = lifeExp)) + -->
<!--   geom_point() + -->
<!--   facet_wrap(~country) + -->
<!--   theme_bw() + -->
<!--   scale_x_continuous(breaks = c(1960, 1980, 2000)) + -->
<!--   geom_smooth(method = "lm") -->
<!-- ``` -->

<!-- ## Exercise 5 solution -->


<!-- ```{r} -->

<!-- mydata %>%  -->
<!--   filter(country %in% c("Turkey", "United Kingdom", "Portugal")) %>%  -->
<!--   lm(lifeExp ~ year_from1952*country, data = .)   %>%  -->
<!--   tidy() %>% -->
<!--   mutate(estimate = round(estimate, 2)) %>%  -->
<!--   select(term, estimate) -->

<!-- ``` -->

<!-- Overall, the estimates for Turkey and the UK do not change, but Portugal becomes the reference (alphabetically first) and you need to subtract or add the relevant lines for Turkey and UK to get their intercept values. -->







<!-- ## Exercise 4 -->

<!-- Convince yourself that using an fully interactive multivariable model is the same as running several separate simple linear regression models. Remember that we calculate the life expectancy in 1952 (intercept) and improvement per year (slope) for Turkey and the United Kingdom: -->

<!-- ```{r} -->
<!-- fit_uk %>% -->
<!--   tidy() %>% -->
<!--   mutate(estimate = round(estimate, 2)) %>%  -->
<!--   select(term, estimate) -->
<!-- ``` -->


<!-- ```{r} -->
<!-- fit_turkey %>% -->
<!--   tidy() %>% -->
<!--   mutate(estimate = round(estimate, 2)) %>%  -->
<!--   select(term, estimate) -->
<!-- ``` -->

<!-- These were the two separate models from above (now using `tidy() %>%  mutate() %>%  select()` instead of `summary()`). And this is how we can get to the same coefficients using a single multivariable linear regression model (note the `year_from1952*country`): -->

<!-- ```{r} -->
<!-- mydata %>%  -->
<!--   filter(country %in% c("Turkey", "United Kingdom")) %>%  -->
<!--   lm(lifeExp ~ year_from1952 * country, data = .)   %>%  -->
<!--   tidy() %>% -->
<!--   mutate(estimate = round(estimate, 2)) %>%  -->
<!--   select(term, estimate) -->
<!-- ``` -->

<!-- Now. It may seem like R has omitted Turkey but the values for Turkey are actually in the Intercept = 46.02 and in year_from1952 = 0.50. Can you make out the intercept and slope for the UK? Are they the same as in the simple linear regression model? -->

