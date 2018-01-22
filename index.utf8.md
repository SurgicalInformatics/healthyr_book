--- 
title: "HealthyR: R for healthcare data analysis"
author: "Riinu ots and Ewen Harrison"
date: "2018-01-22"
site: bookdown::bookdown_site
output: bookdown::gitbook
documentclass: book
bibliography: [book.bib, packages.bib]
biblio-style: apalike
link-citations: yes
github-repo: SurgicalInformatics/healthyr_book/
description: "A HealthyR texbook for our 2.5-day quickstart training course."
colorlinks: yes
cover-image: images/healthyr_book_cover.png
---

# Preface {-}

![](images/cover.png)<!-- -->

## Installation

<div class="healthyr">
<ul>
<li>Download R</li>
</ul>
</div>

https://www.r-project.org/

<div class="healthyr">
<ul>
<li>Install RStudio</li>
</ul>
</div>

https://www.rstudio.com/products/rstudio/

<div class="healthyr">
<ul>
<li>Install packages (copy these lines into the Console in RStudio):</li>
</ul>
</div>


```r
install.packages("tidyverse")

install.packages("gapminder")

install.packages("gmodels")

install.packages("Hmisc")

install.packages("devtools")

devtools::install_github("ewenharrison/summarizer")

install.packages("pROC")

install.packages("survminer")
```

<div class="warning">
<p>When working with data, don't copy or type code directly into the Console. We will only be using the Console for viewing output, warnings, and errors (and installing packages as in the previous section). All code should be in a script and executed (=Run) using Control+Enter (line or section) or Control+Shift+Enter (whole script). Make sure you are always working in a project (the right-top corner of your RStudio interface should say &quot;HealthyR&quot;).</p>
</div>

![](images/rstudio_vs_r.png)<!-- -->

## Datasets

<div class="healthyr">
<p>Files:</p>
<p>gbp.rda</p>
<p>gbp.csv</p>
<p>melaoma_factored</p>
</div>

<div class="error">
<p>These will include common errors.</p>
</div>
