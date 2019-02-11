# Different types of plots 

## Data
We will be using the gapminder dataset:


```r
library(tidyverse)
library(forcats)
library(gapminder)

mydata = gapminder

summary(mydata)
```

```
##         country        continent        year         lifeExp     
##  Afghanistan:  12   Africa  :624   Min.   :1952   Min.   :23.60  
##  Albania    :  12   Americas:300   1st Qu.:1966   1st Qu.:48.20  
##  Algeria    :  12   Asia    :396   Median :1980   Median :60.71  
##  Angola     :  12   Europe  :360   Mean   :1980   Mean   :59.47  
##  Argentina  :  12   Oceania : 24   3rd Qu.:1993   3rd Qu.:70.85  
##  Australia  :  12                  Max.   :2007   Max.   :82.60  
##  (Other)    :1632                                                
##       pop              gdpPercap       
##  Min.   :6.001e+04   Min.   :   241.2  
##  1st Qu.:2.794e+06   1st Qu.:  1202.1  
##  Median :7.024e+06   Median :  3531.8  
##  Mean   :2.960e+07   Mean   :  7215.3  
##  3rd Qu.:1.959e+07   3rd Qu.:  9325.5  
##  Max.   :1.319e+09   Max.   :113523.1  
## 
```

```r
mydata$year %>% unique()
```

```
##  [1] 1952 1957 1962 1967 1972 1977 1982 1987 1992 1997 2002 2007
```

## Scatter plots/bubble plots - `geom_point()`

Plot life expectancy against GDP per capita (`x = gdpPercap, y=lifeExp`) at year 2007:

```r
mydata %>% 
  filter(year == 2007) %>% 
  ggplot(aes(x = gdpPercap, y=lifeExp)) +
  geom_point()
```

![](04_plotting_files/figure-epub3/unnamed-chunk-2-1.png)<!-- -->


### Exercise

Follow the step-by-step instructions to transform the grey plot just above into this:

![](04_plotting_files/figure-epub3/unnamed-chunk-3-1.png)<!-- -->


* Add points: `geom_point()`
    + Change point type: `shape = 1` (or any number from your Quickstart Sheet) inside the `geom_point()`
* Colour each country point by its continent: `colour=continent` to aes()
* Size each country point by its population: `size=pop` to aes()
* Put the country points of each continent on a separate panel: `+ facet_wrap(~continent)`
* Make the background white: `+ theme_bw()`



 
 
## Line chart/timeplot - `geom_line()`

Plot life expectancy against year (`x = year, y=lifeExp`), add `geom_line()`:


```r
mydata %>% 
  ggplot(aes(x = year, y=lifeExp)) +
  geom_line()
```

![](04_plotting_files/figure-epub3/unnamed-chunk-4-1.png)<!-- -->

The reason you now see this weird zig-zag is that, using the above code, R does not know you want a connected line for each country. 
Specify how you want data points grouped to lines: `group = country` in `aes()`:


```r
mydata %>% 
  ggplot(aes(x = year, y=lifeExp, group = country)) +
  geom_line()
```

![](04_plotting_files/figure-epub3/unnamed-chunk-5-1.png)<!-- -->

### Exercise

Follow the step-by-step instructions to transform the grey plot just above into this:


![](04_plotting_files/figure-epub3/unnamed-chunk-6-1.png)<!-- -->

* Colour lines by continents: `colour=continent` to `aes()`
* *Similarly to what we did in `geom_point()`, you can even size the line thicknesses by each country's population: `size=pop` to `aes()`*
* Continents on separate panels: `+ facet_wrap(~continent)`
* Make the background white: `+ theme_bw()`
* Use a nicer colour scheme: `+ scale_colour_brewer(palette = "Paired")`





### Advanced example

For European countries only (`filter(continent == "Europe") %>%`), plot life expectancy over time in grey colour for all countries, then add United Kingdom as a red line:



```r
mydata %>%
  filter(continent == "Europe") %>% #Europe only
  ggplot(aes(x = year, y=lifeExp, group = country)) +
  geom_line(colour = "grey") +
  theme_bw() +
  geom_line(data = filter(mydata, country == "United Kingdom"), colour = "red")
```

![](04_plotting_files/figure-epub3/unnamed-chunk-7-1.png)<!-- -->


### Advanced Exercise

As previous, but add a line for France in blue:

![](04_plotting_files/figure-epub3/unnamed-chunk-8-1.png)<!-- -->



## Box-plot - `geom_boxplot()`

Plot the distribution of life expectancies within each continent at year 2007:

* `filter(year == 2007) %>%`
* `x = continent, y = lifeExp`
* `+ geom_boxplot()`


```r
mydata %>% 
  filter(year == 2007) %>% 
  ggplot(aes(x = continent, y = lifeExp)) +
  geom_boxplot() +
  theme_bw()
```

![](04_plotting_files/figure-epub3/unnamed-chunk-9-1.png)<!-- -->


### Exercise

Add individual (country) points on top of the box plot:

![](04_plotting_files/figure-epub3/unnamed-chunk-10-1.png)<!-- -->

Hint: Use `geom_jitter()` instead of `geom_point()` to reduce overlap by spreading the points horizontally. Include the `width=0.3` option to reduce the width of the jitter.

**Optional:**

Include text labels for the highest life expectancy country of each continent.

**Hint 1** Create a separate dataframe called `label_data` with the maximum countries for each continent:

```r
label_data = mydata %>% 
  filter(year == max(year)) %>% # same as year == 2007
  group_by(continent) %>% 
  filter(lifeExp == max(lifeExp) )
```

**Hint 2** Add `geom_label()` with appropriate `aes()`:

```r
+ geom_label(data = label_data, aes(label=country), vjust = 0)
```



### Dot-plot - `geom_dotplot()`

`geom_dotplot(aes(fill=continent), binaxis = 'y', stackdir = 'center', alpha=0.6)`

![](04_plotting_files/figure-epub3/unnamed-chunk-13-1.png)<!-- -->

## Barplot - `geom_bar()` and `geom_col()`


In the first module, we plotted barplots from already summarised data (using the `geom_col`), but `geom_bar()` is perfectly happy to count up data for you. 
For example, we can plot the number of countries in each continent without summarising the data beforehand:


```r
mydata %>% 
  filter(year == 2007) %>% 
  ggplot(aes(x = continent)) +
  geom_bar() + 
  ylab("Number of countries") +
  theme_bw()
```

![](04_plotting_files/figure-epub3/unnamed-chunk-14-1.png)<!-- -->


### Exercise

Create this barplot of life expectancies in European countries (year 2007). Hint: `coord_flip()` makes the bars horizontal, `fill = NA` makes them empty, have a look at your QuickStar sheet for different themes.

![](04_plotting_files/figure-epub3/unnamed-chunk-15-1.png)<!-- -->



## All other types of plots

These are just some of the main ones, see this gallery for more options: http://www.r-graph-gallery.com/portfolio/ggplot2-package/

And the `ggplot()` documentation: http://docs.ggplot2.org/

Remember that you can always combine different types of plots - i.e. add lines or points on bars, etc.

## Specifying `aes()` variables

The `aes()` variables wrapped inside `ggplot()` will be taken into account by all geoms. 
If you put `aes(colour = lifeExp)` inside `geom_point()`, only points will be coloured:


```r
mydata %>% 
  filter(continent == "Europe") %>% 
  ggplot(aes(x = year, y = lifeExp, group = country)) +
  geom_line() +
  geom_point(aes(colour = lifeExp))
```

![](04_plotting_files/figure-epub3/unnamed-chunk-16-1.png)<!-- -->

## Extra: Optional exercises

### Exercise

Make this:



```r
mydata$dummy = 1  # create a column called "dummy" that includes number 1 for each country

mydata2007 = mydata %>% 
  filter(year==max(year)) %>% 
  group_by(continent) %>% 
  mutate(country_number = cumsum(dummy))  # create a column called "country_number" that
  #is a cumulative sum of the number of countries before it - basically indexing


mydata2007 %>% 
  ggplot(aes(x = continent)) +
  geom_bar(aes(colour=continent), fill = NA) +
  geom_text(aes(y = country_number, label=country), size=4, vjust=1, colour='black')+
  theme_void()
```

![](04_plotting_files/figure-epub3/unnamed-chunk-17-1.png)<!-- -->

\newpage

### Exercise

Make this:

Hints: `coord_flip()`, `scale_color_gradient(...)`, `geom_segment(...)`, `annotate("text", ...)`


```r
mydata %>% 
  filter(continent == "Europe") %>% 
  ggplot(aes(y = fct_reorder(country, gdpPercap, .fun=max), x=lifeExp, colour=year)) +
  geom_point(shape = 15, size = 2) +
  theme_bw() +
  scale_colour_distiller(palette = "Greens", direction = 1) +
  geom_segment(aes(yend = "Switzerland", x = 85, y = "Bosnia and Herzegovina", xend = 85),
               colour = "black", size=1,
               arrow = arrow(length = unit(0.3, "cm"))) +
  annotate("text", y = "Greece", x=83, label = "Higher GDP per capita", angle = 90)
```

![](04_plotting_files/figure-epub3/unnamed-chunk-18-1.png)<!-- -->




## Solutions

**4.2.1**


```r
mydata %>% 
  filter(year == 2007) %>% 
  ggplot(  aes(x = gdpPercap/1000, #divide by 1000 to tidy the x-axis
               y=lifeExp,
               colour=continent,
               size=pop)) +
  geom_point(shape = 1) +
  facet_wrap(~continent) +
  theme_bw()
```

**4.3.1**


```r
mydata %>% 
  ggplot(  aes(x = year, y=lifeExp, group = country, colour=continent)) +
  geom_line() +
  facet_wrap(~continent) + 
  theme_bw() +
  scale_colour_brewer(palette = "Paired")
```

**which**

Add ` + 
geom_line(data = filter(mydata, country == "France"), colour = "blue")`

**4.4.1**


```r
mydata %>% 
  filter(year == 2007) %>% 
  ggplot(aes(x = continent, y = lifeExp)) +
  geom_boxplot(outlier.shape = NA) +
  geom_jitter(aes(colour=continent), width=0.3, alpha=0.8) + #width defaults to 0.8 of box width
  theme_bw()
```



```r
mydata %>% 
  filter(year == 2007) %>% 
  ggplot(aes(x = continent, y = lifeExp)) +
  geom_boxplot(outlier.shape = NA) +
  geom_jitter(aes(colour=continent), width=0.3, alpha=0.8)
  theme_bw()
```

**4.5.1**


```r
mydata %>% 
  filter(year == 2007) %>%
  filter(continent == "Europe") %>% 
  ggplot(aes(x = country, y = lifeExp)) +
  geom_col(colour = "#91bfdb", fill = NA) +
  coord_flip() +
  theme_classic()
```

