

ggplot <- function(...) ggplot2::ggplot(...) + 
  scale_fill_brewer(palette="Paired") + 
  scale_colour_brewer(palette="Paired") +
  theme_bw() +
  theme(legend.position='right') +
  guides(fill=guide_legend(ncol=1))

suppressPackageStartupMessages(library(tidyverse))  #this loads a list of helpful packages
