# Fine tuning plots {#finetuning}
\index{plots@\textbf{plots}!finetuning}



## Get the data

We can save a `ggplot()` object into a variable (we usually call it `p` but can be any name). 
This then appears in the **Environment** tab. 
To plot it it needs to be recalled on a separate line. 
Saving a plot into a variable allows us to modify it later (e.g., `p + theme_bw()`).


```r
library(gapminder)
library(tidyverse)

p0 = gapminder %>% 
  filter(year == 2007) %>% 
  group_by(continent, year) %>% 
  ggplot(aes(y = lifeExp, x = gdpPercap, colour = continent)) +
  geom_point(alpha = 0.3) +
  theme_bw() +
  geom_smooth(method = "lm", se = FALSE) +
  scale_colour_brewer(palette = "Set1")

p0
```

![](05_fine_tuning_plots_files/figure-latex/unnamed-chunk-1-1.pdf)<!-- --> 

## Scales
\index{plots@\textbf{plots}!scales}
\index{plots@\textbf{plots}!log scales}
\index{plots@\textbf{plots}!transformations}
\index{plots@\textbf{plots}!sub}

### Logarithmic


```r
p1 = p0 + scale_x_log10()
```

### Expand limits
\index{plots@\textbf{plots}!expand limits}

Specify the value you want to be included:


```r
p2 = p0 + expand_limits(y = 0)
```

Or two:


```r
p3 = p0 + expand_limits(y = c(0, 100))
```

By default, `ggplot()` adds some padding around the included area (see how the scale doesn't start from 0, but slightly before). 
You can remove this padding with the expand option:


```r
p4 = p0 +
  expand_limits(y = c(0, 100)) +
  coord_cartesian(expand = FALSE)
```

We are now using a new library - **patchwork** - to print all 4 plots together.
Installing **patchwork** is slightly different to how we install other packages (neither using the Packages tab or `install.packages("patchwork")` will not work).
**patchwork** lives in GitHub (more about this in Chapter \@ref(chap13-h1)), not on CRAN like most R packages, so to install it, you'll need to run this (just once):


```r
remotes::install_github("thomasp85/patchwork")
```

You can then start using this package as usual by including `library(patchwork)` in your script.
Its syntax is very simple - it allows us to add ggplot objects together.
(Trying to do `p1 + p2` without loading the **patchwork** package will not work, R will say "Error: Don't know how to add p2 to a plot".)



```r
library(patchwork)
p1 + p2 + p3 + p4 + plot_annotation(tag_levels = "1", tag_prefix = "p")
```

![](05_fine_tuning_plots_files/figure-latex/unnamed-chunk-7-1.pdf)<!-- --> 

### Zoom in
\index{plots@\textbf{plots}!zoom}


```r
p1 = p0 +
  coord_cartesian(ylim = c(70, 85), xlim = c(20000, 40000))
```

### Exercise

How is this one different to the previous?


```r
p2 = p0 +
  scale_y_continuous(limits = c(70, 85)) +
  scale_x_continuous(limits = c(20000, 40000))
```

Answer: the first one zooms in, still retaining information about the excluded points when calculating the linear regression lines. 
The second one removes the data (as the warnings say), calculating the linear regression lines only for the visible points.


```r
p1 + p2
```

```
## Warning: Removed 114 rows containing non-finite values (stat_smooth).
```

```
## Warning: Removed 114 rows containing missing values (geom_point).
```

![](05_fine_tuning_plots_files/figure-latex/unnamed-chunk-10-1.pdf)<!-- --> 

### Axis ticks
\index{plots@\textbf{plots}!axes}


```r
p1 = p0 +
  coord_cartesian(ylim = c(0, 100), expand = 0) +
  scale_y_continuous(breaks = c(17, 35, 88))
```

### Swap the axes


```r
p2 = p0 +
  coord_flip()
```


```r
p1 + p2
```

![](05_fine_tuning_plots_files/figure-latex/unnamed-chunk-13-1.pdf)<!-- --> 

## Colours
\index{plots@\textbf{plots}!colours}

### Using the Brewer palettes:


```r
p1 = p0 +
  scale_color_brewer(palette = "Paired")
```

### Legend title
\index{plots@\textbf{plots}!legend}

`scale_colour_brewer()` is also a convenient place to change the legend title:


```r
p2 = p0 +
  scale_color_brewer("Continent - \n one of 5", palette = "Paired")
```

Note the `\n` inside the new legend title - new line.


```r
p1 + p2
```

![](05_fine_tuning_plots_files/figure-latex/unnamed-chunk-16-1.pdf)<!-- --> 

### Choosing colours manually

Use words:


```r
p1 = p0 +
  scale_color_manual(values = c("red", "green", "blue", "purple", "pink"))
```

Or HEX codes (either from http://colorbrewer2.org/ or any other resource):



```r
p2 = p0 +
  scale_color_manual(values = c("#8dd3c7", "#ffffb3", "#bebada",
                                "#fb8072", "#80b1d3"))
```


```r
p1 + p2
```

![](05_fine_tuning_plots_files/figure-latex/unnamed-chunk-19-1.pdf)<!-- --> 

Note that http://colorbrewer2.org/ also has options for *Colourblind safe* and *Print friendly*.

\newpage 

## Titles and labels
\index{plots@\textbf{plots}!titles}
\index{plots@\textbf{plots}!labels}


```r
p0 +
  labs(x = "Gross domestic product per capita",
         y = "Life expectancy",
         title = "Health and economics",
         subtitle = "Gapminder dataset, 2007")
```

![](05_fine_tuning_plots_files/figure-latex/unnamed-chunk-20-1.pdf)<!-- --> 

### Annotation
\index{plots@\textbf{plots}!annotate}


```r
p1 = p0 +
  annotate("text",
           x = 25000,
           y = 50,
           label = "No points here!")
```


```r
p2 = p0 +
  annotate("label",
           x = 25000,
           y = 50,
           label = "No points here!")
```


```r
p3 = p0 +
  annotate("label",
           x = 25000, 
           y = 50,
           label = "No points here!", 
           hjust = 0)
```


```r
p1 + p2 / p3
```

![](05_fine_tuning_plots_files/figure-latex/unnamed-chunk-24-1.pdf)<!-- --> 

`hjust` stands for horizontal justification. It's default value is 0.5 (see how the label was centred at 25,000 - our chosen x location), 0 means the label goes to the right from 25,000, 1 would make it end at 25,000.

### Annotation with a superscript and a variable
\index{plots@\textbf{plots}!superscript}


```r
fit_glance = tibble(r.squared = 0.7693465)


plot_rsquared = paste0(
  "R^2 == ",
  fit_glance$r.squared %>% round(2))


p0 +
  annotate("text",
           x = 25000, 
           y = 50,
           label = plot_rsquared, parse = TRUE,
           hjust = 0)
```

![](05_fine_tuning_plots_files/figure-latex/unnamed-chunk-25-1.pdf)<!-- --> 

## Text size
\index{plots@\textbf{plots}!text size}


```r
p0 +
  theme(axis.text.y = element_text(size = 16),
        axis.text.x = element_text(colour = "red", angle = 45, vjust = 0.5),
        axis.title = element_text(size = 16, colour = "darkgreen")
        )
```

![](05_fine_tuning_plots_files/figure-latex/unnamed-chunk-26-1.pdf)<!-- --> 

### Legend position
\index{plots@\textbf{plots}!legend}

<!-- Move to above where legend introduced? -->

Use the following words: `"right", "left", "top", "bottom"`, or `"none"` to remove the legend.

```r
p1 = p0 +
  theme(legend.position = "none")
```

Or use relative coordinates (0--1) to give it an -y location:


```r
p2 = p0 +
  theme(legend.position      = c(1,0),
        legend.justification = c(1,0)) #bottom-right corner
```


```r
p3 = p0 +
  theme(legend.position = "top") +
  guides(colour = guide_legend(ncol = 2))
```


```r
p1 + p2
```

![](05_fine_tuning_plots_files/figure-latex/unnamed-chunk-30-1.pdf)<!-- --> 


```r
p3
```

![](05_fine_tuning_plots_files/figure-latex/unnamed-chunk-31-1.pdf)<!-- --> 

## Saving your plot
\index{plots@\textbf{plots}!saving}


```r
ggsave(p0, file = "my_saved_plot.png", width = 5, height = 4)
```
