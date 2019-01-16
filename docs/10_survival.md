# Time-to-event data (survival)

## Data
The `boot::melanoma` dataset was introduced in module 7.

In the previous session, we used logistic regression to calculate the odds ratios of different factors to death from melanoma at any point during the study period.


```r
library(tidyverse)
library(broom)
library(survival)
library(survminer)
mydata = boot::melanoma


mydata$status %>% 
	factor() %>% 
	fct_recode("Died" = "1",
						 "Alive" = "2",
						 "Died - other causes" = "3") %>% 
	fct_relevel("Alive") -> # move Alive to front (first factor level) 
	mydata$status.factor    # so OR will be relative to that

mydata$sex %>% 
	factor() %>% 
	fct_recode("Female" = "0",
						 "Male"   = "1") ->
	mydata$sex.factor

mydata$ulcer %>% 
	factor() %>% 
	fct_recode("Present" = "1",
						 "Absent" = "0") -> 
	mydata$ulcer.factor

mydata$age %>% 
	cut(breaks = c(4,20,40,60,95), include.lowest=TRUE) ->
	mydata$age.factor
```

## Kaplan-Meier survival estimator
The KM survival estimator is a non-parametric statistic used to estimate the survival function from life time data.

'Time' is time from event to last known status. This status could be the event, for instance death. Or could be when the patient was last seen, for instance at a clinic. In this circumstance the patient is considered 'censored'. 


```r
survival_object = Surv(mydata$time, mydata$status.factor == "Died")

# It is often useful to convert days into years
survival_object = Surv(mydata$time/365, mydata$status.factor == "Died")

# Investigate this:
head(survival_object) # + marks censoring in this case "Died of other causes"
# Or that the follow-up ended and the patient is censored.
```

```
## [1] 0.02739726+ 0.08219178+ 0.09589041+ 0.27123288+ 0.50684932  0.55890411
```

### KM analysis for whole cohort
### Model
The survival object is the first step to performing univariable and multivariable survival analyses. A univariable model can then be fitted.

If you want to plot survival stratified by a single grouping variable, you can substitute "survival_object ~ 1" by "survival_object ~ factor"


```r
# For all patients
my_survfit = survfit(survival_object ~ 1, data = mydata)
my_survfit # 205 patients, 57 events
```

```
## Call: survfit(formula = survival_object ~ 1, data = mydata)
## 
##       n  events  median 0.95LCL 0.95UCL 
##     205      57      NA      NA      NA
```

### Life table
A life table is the tabular form of a KM plot, which you may be familiar with. It shows survival as a proportion, together with confidence limits. 

```r
# The whole table is shown with, summary(my_survfit)
# Here is 
summary(my_survfit, times=c(0, 1, 2, 3, 4, 5))
```

```
## Call: survfit(formula = survival_object ~ 1, data = mydata)
## 
##  time n.risk n.event survival std.err lower 95% CI upper 95% CI
##     0    205       0    1.000  0.0000        1.000        1.000
##     1    193       6    0.970  0.0120        0.947        0.994
##     2    183       9    0.925  0.0187        0.889        0.962
##     3    167      15    0.849  0.0255        0.800        0.900
##     4    160       6    0.818  0.0274        0.766        0.874
##     5    122       9    0.769  0.0303        0.712        0.831
```

```r
# 5 year survival is 77%

# Help is at hand
help(summary.survfit)
```

### KM plot
A KM plot can easily be generated using the `survminer` package. 

For more information on how the survminer package draws this plot, or how to modify it: http://www.sthda.com/english/wiki/survminer-r-package-survival-data-analysis-and-visualization and https://github.com/kassambara/survminer


```r
library(survminer)
my_survplot = ggsurvplot(my_survfit, data = mydata,                 
           risk.table = TRUE,
           ggtheme = theme_bw(),
           palette = 'Dark2',
           conf.int = TRUE,
           pval=FALSE)
my_survplot
```

![](10_survival_files/figure-epub3/unnamed-chunk-5-1.png)<!-- -->


```r
# Note can also take `ggplot()` options. 
my_survplot$plot + 
	annotate('text', x = 5, y = 0.25, label='Whole cohort')
```

Here is an alternative plot in base R to compare. Not only does this produce a more basic survival plot, but tailoring the plot can be more difficult to achieve.

Furthermore, appending a life table ("risk.table") alongside the plot can also be difficult (yet this is often required for interpretation / publication).


```r
plot(my_survfit, mark.time=FALSE, conf.int=TRUE, 
		 xlab="Time (years)", ylab="Survival")
```

![](10_survival_files/figure-epub3/unnamed-chunk-7-1.png)<!-- -->

### Exercise
Using the above scripts, perform a univariable Kaplam Meier analysis to determine if `ulcer.factor` influences overall survival. Hint: `survival_object ~ ulcer.factor`. 

Try modifying the plot produced (see Help for ggsurvplot). For example:

*  Add in a medial survival lines: `surv.median.line="hv"`
*  Alter the plot legend: `legend.title = "Ulcer Present", legend.labs = c("No", "Yes")`
*  Change the y-axis to a percentage: `ylab = "Probability of survival (%)", surv.scale = "percent"`
*  Display follow-up up to 10 years, and change the scale to 1 year: `xlim = c(0,10), break.time.by = 1)`


![](10_survival_files/figure-epub3/unnamed-chunk-8-1.png)<!-- -->



### Log-rank test
Two KM survival curves can be compared using the log-rank test. Note survival curves can also be compared using a Wilcoxon test that may be appropriate in some circumstances. 

This can easily be performed in `library(survival)` using the function `survdiff()`.

```r
survdiff(survival_object ~ ulcer.factor, data = mydata)
```

```
## Call:
## survdiff(formula = survival_object ~ ulcer.factor, data = mydata)
## 
##                        N Observed Expected (O-E)^2/E (O-E)^2/V
## ulcer.factor=Absent  115       16     35.8      10.9      29.6
## ulcer.factor=Present  90       41     21.2      18.5      29.6
## 
##  Chisq= 29.6  on 1 degrees of freedom, p= 5e-08
```

Is there a signficiant difference between survival curves?

## Cox proportional hazard regression
### Model
Multivariable survival analysis can be complex with parametric and semi-parametric methods available. The latter is performed using a Cox proportional hazard  regression analysis. 


```r
# Note several variables are now introduced into the model. 
# Variables should be selected carefully based on published methods.  
my_hazard = coxph(survival_object~sex.factor+ulcer.factor+age.factor, data=mydata)
summary(my_hazard)
```

```
## Call:
## coxph(formula = survival_object ~ sex.factor + ulcer.factor + 
##     age.factor, data = mydata)
## 
##   n= 205, number of events= 57 
## 
##                         coef exp(coef) se(coef)      z Pr(>|z|)    
## sex.factorMale       0.48249   1.62011  0.26835  1.798   0.0722 .  
## ulcer.factorPresent  1.38972   4.01372  0.29772  4.668 3.04e-06 ***
## age.factor(20,40]   -0.40628   0.66613  0.69339 -0.586   0.5579    
## age.factor(40,60]   -0.04513   0.95588  0.61334 -0.074   0.9414    
## age.factor(60,95]    0.17889   1.19588  0.62160  0.288   0.7735    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
##                     exp(coef) exp(-coef) lower .95 upper .95
## sex.factorMale         1.6201     0.6172    0.9575     2.741
## ulcer.factorPresent    4.0137     0.2491    2.2394     7.194
## age.factor(20,40]      0.6661     1.5012    0.1711     2.593
## age.factor(40,60]      0.9559     1.0462    0.2873     3.180
## age.factor(60,95]      1.1959     0.8362    0.3537     4.044
## 
## Concordance= 0.735  (se = 0.04 )
## Rsquare= 0.153   (max possible= 0.937 )
## Likelihood ratio test= 34.08  on 5 df,   p=2e-06
## Wald test            = 30.19  on 5 df,   p=1e-05
## Score (logrank) test = 35.21  on 5 df,   p=1e-06
```

```r
library(broom)
tidy(my_hazard)
```

```
## # A tibble: 5 x 7
##   term            estimate std.error statistic   p.value conf.low conf.high
##   <chr>              <dbl>     <dbl>     <dbl>     <dbl>    <dbl>     <dbl>
## 1 sex.factorMale    0.482      0.268    1.80     7.22e-2  -0.0435     1.01 
## 2 ulcer.factorPr…   1.39       0.298    4.67     3.04e-6   0.806      1.97 
## 3 age.factor(20,…  -0.406      0.693   -0.586    5.58e-1  -1.77       0.953
## 4 age.factor(40,…  -0.0451     0.613   -0.0736   9.41e-1  -1.25       1.16 
## 5 age.factor(60,…   0.179      0.622    0.288    7.74e-1  -1.04       1.40
```
The interpretation of the results of model fitting are beyond the aims of this course. The exponentiated coefficient (`exp(coef)`) represents the hazard ratio. Therefore, patients with ulcers are 4-times more likely to die at any given time than those without ulcers. 

### Assumptions
The CPH model presumes 'constant hazards'. That means that the risk associated with any given variable (like ulcer status) shouldn't get worse or better over time. This can be checked.


```r
ph = cox.zph(my_hazard)
ph
```

```
##                        rho chisq      p
## sex.factorMale      -0.104 0.647 0.4212
## ulcer.factorPresent -0.238 3.135 0.0766
## age.factor(20,40]    0.110 0.716 0.3976
## age.factor(40,60]    0.194 2.222 0.1361
## age.factor(60,95]    0.146 1.257 0.2622
## GLOBAL                  NA 6.949 0.2244
```

```r
# GLOBAL shows no overall violation of assumptions. 
# Ulcer.status is borderline significant

# Plot Schoenfield residuals to evaluate PH
plot(ph, var=2) # ulcer.status is variable 2
```

![](10_survival_files/figure-epub3/unnamed-chunk-11-1.png)<!-- -->

```r
# help(plot.cox.zph)
```
Hazard decreases a little between 2 and 5 years, but is acceptable.

### Exercise
Create a new CPH model, but now include the variable `thickness` as a variable. How would you interpret the output? Is it an independent predictor of overall survival in this model? Are CPH assumptions maintained?

## Dates in R
### Converting dates to survival time
In the melanoma example dataset, we already had the time in a convenient format for survial analysis - survival time in days since the operation. This section shows how to convert dates into "days from event". First we will generate a dummy operation date and censoring date based on the melanoma data. 


```r
library(lubridate)
first_date = ymd("1966-01-01")           # let's create made-up dates for the operations
last_date = first_date + days(nrow(mydata)-1) # assume tone every day from 1-Jan 1966
operation_date = seq(from = first_date, to = last_date, by = "1 day") # create dates

mydata$operation_date = operation_date # add the created sequence to melanoma dataset
```
Now we will to create a 'censoring' date by adding `time` from the melanoma dataset to our made up operation date. Remember the censoring date is either when an event occurred (e.g. death) or the last known alive status of the patient. 


```r
mydata %>% 
  mutate(censoring_date = operation_date + days(time)) ->
  mydata

# (Same as doing:):
mydata$censoring_date = mydata$operation_date + days(mydata$time)
```

Now consider if we only had the `operation date` and `censoring date`. We want to create the `time` variable. 

```r
mydata %>% 
  mutate(time_days = censoring_date - operation_date) ->
  mydata
```
The `Surv()` function expects a number (`numeric` variable), rather than a `date` object, so we'll convert it:


```r
# Surv(mydata$time_days, mydata$status==1) # this doesn't work

mydata %>% 
  mutate(time_days_numeric = as.numeric(time_days))  ->
  mydata

survival_object = Surv(mydata$time_days_numeric, mydata$status.factor == "Died") # this works as expected
```


## Solutions

**9.2.2**


```r
# Fit survival model
my_survfit.solution = survfit(survival_object ~ ulcer.factor, data = mydata)

# Show results
my_survfit.solution
summary(my_survfit.solution, times=c(0,1,2,3,4,5))

# Plot results
my_survplot.solution = ggsurvplot(my_survfit.solution,
                         data = mydata,
                         palette = 'Dark2',
                         risk.table = TRUE,
                         ggtheme = theme_bw(),
                         conf.int = TRUE,
                         pval=TRUE,
                         
                         # Add in a medial survival line.
                         surv.median.line="hv",

                         # Alter the plot legend (change the names)
                         legend.title = "Ulcer Present", 
                         legend.labs = c("No", "Yes"),
                        
                         # Change the y-axis to a percentage
                         ylab = "Probability of survival (%)",
                         surv.scale = "percent",

                         # Display follow-up up to 10 years, and change the scale to 1 year
                         xlab = "Time (years)",
                         # present narrower X axis, but not affect survival estimates.
                         xlim = c(0,10),
                         # break X axis in time intervals by 1 year
                         break.time.by = 1)    

my_survplot.solution
```

**9.3.3**


```r
# Fit model
my_hazard = coxph(survival_object~sex.factor+ulcer.factor+age.factor+thickness, data=mydata)
summary(my_hazard)

# Melanoma thickness has a HR 1.12 (1.04 to 1.21). 
# This is interpretted as a 12% increase in the
# risk of death at any time for each 1 mm increase in thickness. 

# Check assumptions
ph = cox.zph(my_hazard)
ph
# GLOBAL shows no overall violation of assumptions. 
# Plot Schoenfield residuals to evaluate PH
plot(ph, var=6)
```
