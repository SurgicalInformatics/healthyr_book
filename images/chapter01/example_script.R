# Loading two packages into your library
# tidyverse and gapminder
library(tidyverse)
library(gapminder)

# Modify data
gapminder2007 = gapminder %>%
  filter(year == 2007)

# Plot data
gapminder2007 %>%
  ggplot(aes(x = gdpPercap, y = lifeExp)) +
  geom_point()

# Statistical test
t.test(lifeExp ~ gdpPercap > 20000, data = gapminder2007)

