# Fine tuning plots




## Data and initial plot


We can save a `ggplot()` object into a variable (usually called `p` but can be any name). This then appear in the Environment tab. To plot it it needs to be recalled on a separate line. Saving a plot into a variable allows us to modify it later (e.g., `p+theme_bw()`).


```r
library(gapminder)
library(tidyverse)

mydata = gapminder

mydata$year %>% unique()
```

```
##  [1] 1952 1957 1962 1967 1972 1977 1982 1987 1992 1997 2002 2007
```

```r
p = gapminder %>% 
  filter(year == 2007) %>% 
  group_by(continent, year) %>% 
  ggplot(aes(y = lifeExp, x = gdpPercap, colour = continent)) +
  geom_point(alpha = 0.3) +
  theme_bw() +
  geom_smooth(method = "lm", se = FALSE) +
  scale_colour_brewer(palette = "Set1")

p
```

![](05_fine_tuning_plots_files/figure-epub3/unnamed-chunk-1-1.png)<!-- -->



## Scales

### Logarithmic


```r
p + scale_x_log10()
```

![](05_fine_tuning_plots_files/figure-epub3/unnamed-chunk-2-1.png)<!-- -->

### Expand limits

Specify the value you want to be included:


```r
p + expand_limits(y = 0)
```

![](05_fine_tuning_plots_files/figure-epub3/unnamed-chunk-3-1.png)<!-- -->

\newpage 

Or two:


```r
p + expand_limits(y = c(0, 100))
```

![](05_fine_tuning_plots_files/figure-epub3/unnamed-chunk-4-1.png)<!-- -->

By default, `ggplot` adds some padding around the included area (see how the scale doesn't start from 0, but slightly before). You can remove this padding with the expand option:


```r
p +
  expand_limits(y = c(0, 100)) +
  coord_cartesian(expand = FALSE)
```

![](05_fine_tuning_plots_files/figure-epub3/unnamed-chunk-5-1.png)<!-- -->


### Zoom in


```r
p + coord_cartesian(ylim = c(70, 85), xlim = c(20000, 40000))
```

![](05_fine_tuning_plots_files/figure-epub3/unnamed-chunk-6-1.png)<!-- -->


###Exercise

How is this one different to the previous:


```r
p +
  scale_y_continuous(limits = c(70, 85)) +
  scale_x_continuous(limits = c(20000, 40000))
```

```
## Warning: Removed 114 rows containing non-finite values (stat_smooth).
```

```
## Warning: Removed 114 rows containing missing values (geom_point).
```

![](05_fine_tuning_plots_files/figure-epub3/unnamed-chunk-7-1.png)<!-- -->

Answer: the first one zooms in, still retaining information about the excluded points when calculating the linear regression lines. The second one removes the data (as the warnings say), calculating the linear regression lines only for the visible points.

### Axis ticks


```r
p +
  coord_cartesian(ylim = c(0, 100), expand = 0) +
  scale_y_continuous(breaks = c(17, 35, 88))
```

![](05_fine_tuning_plots_files/figure-epub3/unnamed-chunk-8-1.png)<!-- -->


### Swap the axes


```r
p +
  coord_flip()
```

![](05_fine_tuning_plots_files/figure-epub3/unnamed-chunk-9-1.png)<!-- -->


## Colours

### Using the Brewer palettes:


```r
p +
  scale_color_brewer(palette = "Paired")
```

![](05_fine_tuning_plots_files/figure-epub3/unnamed-chunk-10-1.png)<!-- -->


### Legend title

`scale_colour_brewer()` is also a conventient place to change the legend title:


```r
p +
  scale_color_brewer("Continent - \n one of 5", palette = "Paired")
```

![](05_fine_tuning_plots_files/figure-epub3/unnamed-chunk-11-1.png)<!-- -->

Note the `\n` inside the new legend title - new line.

### Choosing colours manually

Use words:


```r
p +
  scale_color_manual(values = c("red", "green", "blue", "purple", "pink"))
```

![](05_fine_tuning_plots_files/figure-epub3/unnamed-chunk-12-1.png)<!-- -->

Or HEX codes (either from http://colorbrewer2.org/ or any other resource):



```r
p +
  scale_color_manual(values = c("#e41a1c", "#377eb8", "#4daf4a", "#984ea3", "#ff7f00"))
```

![](05_fine_tuning_plots_files/figure-epub3/unnamed-chunk-13-1.png)<!-- -->


Note that http://colorbrewer2.org/ also has options for *Colourblind safe* and *Print friendly*.

\newpage 

## Titles and labels


```r
p +
  labs(x = "Gross domestic product per capita",
         y = "Life expectancy",
         title = "Health and economics",
         subtitle = "Gapminder dataset, 2007")
```

![](05_fine_tuning_plots_files/figure-epub3/unnamed-chunk-14-1.png)<!-- -->


### Annotation



```r
p +
  annotate("text",
           x = 25000,
           y = 50,
           label = "No points here!")
```

![](05_fine_tuning_plots_files/figure-epub3/unnamed-chunk-15-1.png)<!-- -->



```r
p +
  annotate("label",
           x = 25000,
           y = 50,
           label = "No points here!")
```

![](05_fine_tuning_plots_files/figure-epub3/unnamed-chunk-16-1.png)<!-- -->




```r
p +
  annotate("label",
           x = 25000, 
           y = 50,
           label = "No points here!", 
           hjust = 0)
```

![](05_fine_tuning_plots_files/figure-epub3/unnamed-chunk-17-1.png)<!-- -->



`hjust` stand for horizontal justification. It's default value is 0.5 (see how the label was centered at 25,000 - our chosen x location), 0 means the label goes to the right from 25,000, 1 would make it end at 25,000.


### Annotation with a superscript and a variable


```r
fit_glance = data.frame(r.squared = 0.7693465)


plot_rsquared = paste0(
  "R^2 == ",
  fit_glance$r.squared %>% round(2))


p +
  annotate("text",
           x = 25000, 
           y = 50,
           label = plot_rsquared, parse = TRUE,
           hjust = 0)
```

![](05_fine_tuning_plots_files/figure-epub3/unnamed-chunk-18-1.png)<!-- -->

## Text size




```r
p +
  theme(axis.text.y = element_text(size = 16),
        axis.text.x = element_text(colour = "red", angle = 45, vjust = 0.5),
        axis.title = element_text(size = 16, colour = "darkgreen")
        )
```

![](05_fine_tuning_plots_files/figure-epub3/unnamed-chunk-19-1.png)<!-- -->


### Legend position


Use the following words: `"right", "left", "top", "bottom"`, or "none" to remove the legend.

```r
p +
  theme(legend.position = "none")
```

![](05_fine_tuning_plots_files/figure-epub3/unnamed-chunk-20-1.png)<!-- -->

Or use relative coordinates (0--1) to give it an -y location:


```r
p +
  theme(legend.position=c(1,0),
        legend.justification=c(1,0)) #bottom-right corner
```

![](05_fine_tuning_plots_files/figure-epub3/unnamed-chunk-21-1.png)<!-- -->




```r
p +
  theme(legend.position = "top") +
  guides(colour = guide_legend(ncol=2))
```

![](05_fine_tuning_plots_files/figure-epub3/unnamed-chunk-22-1.png)<!-- -->


## Saving your plot



```r
ggsave(p, file = "my_saved_plot.png", width = 5, height = 4)
```



