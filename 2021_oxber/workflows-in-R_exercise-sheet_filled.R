## R script for workshop "Reproducible workflows in R --- Oxford" as
## part of the Ox|Ber Summer School 2001 programme. Workshop by Adam
## Kenny, Matt Jaquiery, and Olly Robertson. This script is based on
## the lessons from the Carpentries' R for Reproducible Scientific
## Analysis material
## (http://swcarpentry.github.io/r-novice-gapminder/), which is
## Copyright (c) Software Carpentry (http://software-carpentry.org/)
## available under CC BY 4.0
## (http://swcarpentry.github.io/r-novice-gapminder/LICENSE.html).

##################################################
## Setup
##################################################

## If you haven't been able to download the files, follow instructions
## here: http://swcarpentry.github.io/r-novice-gapminder/setup.html

##################################################
## Lesson 13 Data frame Manipulation with dplyr
##################################################

##### Loading Data

## Load the data into R using read.csv (downloading directly github):
gapminder <- read.csv("https://raw.githubusercontent.com/swcarpentry/r-novice-gapminder/gh-pages/_episodes_rmd/data/gapminder_data.csv", stringsAsFactors = TRUE)

## Now look at data, you'll see it has demographic information for
## countries across years:
head(gapminder)

##### Data Manipulation

## We can do these operations using the normal base R operations. Try
## to calculate mean 'gdpPercap' for countries in Africa:
mean(gapminder[gapminder$continent == "Africa", "gdpPercap"])

## Now do the same for Asia:
mean(gapminder[gapminder$continent == "Africa", "gdpPercap"])

##### The dplyr package

## The dplyr package provides a number of very useful functions for
## manipulating data frames in a way that will reduce the above
## repetition, reduce the probability of making errors, and probably
## even save you some typing. As an added bonus, you might even find
## the dplyr grammar easier to read. We're going to cover five of the
## most commonly used functions and use the 'pipe' (%>%) to combine
## them.

## If you have have not installed this package earlier, please do so:
install.packages('dplyr')

## Now let's load the package:
install.packages('dplyr')



##### Using select()

## If we wanted to move forward with only a few of the variables in our
## data frame we could use the select() function. This will keep only
## the variables you select. Select 'year', 'country', and
## 'gdpPercap':
year_country_gdp <- select(gapminder, year, country, gdpPercap)

## If we want to remove one column only from the gapminder data, for
## example, removing the 'continent' column:
smaller_gapminder_data <- select(gapminder, -continent)

## Let's repeat what we've done above using pipes:
year_country_gdp <- gapminder %>% select(year, country, gdpPercap)



##### Tip: Renaming data frame columns in dplyr

## Use syntax of rename(new_name = old_name) to rename the gdpPercap
## column name from our select() statement above to 'gdp_per_capita':
tidy_gdp <- year_country_gdp %>% rename(gdp_per_capita = gdpPercap)



##### Using filter()

## If we now want to move forward with the above, but only with
## European countries, we can combine select and filter:
year_country_gdp_euro <- gapminder %>%
    filter(continent == "Europe") %>%
    select(year, country, gdpPercap)

## If we now want to show life expectancy of European countries but
## only for 2007, we can do so:
europe_lifeExp_2007 <- gapminder %>%
  filter(continent == "Europe", year == 2007) %>%
    select(country, lifeExp)



##################################################
##### Challenge 1
##################################################

## Write a single command (which can span multiple lines and includes
## pipes) that will produce a data frame that has the African values
## for lifeExp, country and year, but not for other Continents. How
## many rows does your data frame have and why?

##### Using group_by()

## Instead of filter(), which will only pass observations that meet
## your criteria (in the above: continent=="Europe"), we can use
## group_by(), which will essentially use every unique criteria that
## you could have used in filter:
str(gapminder %>% group_by(continent))

##### Using summarize()

## group_by() is much more exciting in conjunction with
## summarize(). This will allow us to create new variable(s) by using
## functions that repeat for each of the continent-specific data
## frames. That is to say, using the group_by() function, we split our
## original data frame into multiple pieces, then we can run functions
## (e.g. mean() or sd()) within summarize(). Try to calculate mean
## gdpPercap by continent:
gdp_bycontinents <- gapminder %>%
    group_by(continent) %>%
    summarize(mean_gdpPercap = mean(gdpPercap))



##################################################
##### Challenge 2
##################################################

## Calculate the average life expectancy per country. Which has the
## longest average life expectancy and which has the shortest average
## life expectancy?

## The function group_by() allows us to group by multiple
## variables. Let's group by year and continent:

## It gets even better! You're not limited to defining 1 new variable
## in summarize(). Add standard deviation of gdp to summarize (and
## mean and sd for population if you'd like):

##### count() and n()

## If we wanted to check the number of countries included in the
## dataset for the year 2002, we can use the count() function. It
## takes the name of one or more columns that contain the groups we
## are interested in, and we can optionally sort the results in
## descending order by adding sort=TRUE:
gapminder %>%
    filter(year == 2002) %>%
    count(continent, sort = TRUE)

## If we need to use the number of observations in calculations, the
## n() function is useful. It will return the total number of
## observations in the current group rather than counting the number
## of observations in each group within a specific column. For
## instance, if we wanted to get the standard error of the life
## expectancy per continent:
gapminder %>%
    group_by(continent) %>%
    summarize(se_le = sd(lifeExp)/sqrt(n()))

## You can also chain together several summary operations; in this
## case calculating the minimum, maximum, mean and se of each
## continent’s per-country life-expectancy:
gapminder %>%
    group_by(continent) %>%
    summarize(
      mean_le = mean(lifeExp),
      min_le = min(lifeExp),
      max_le = max(lifeExp),
      se_le = sd(lifeExp)/sqrt(n()))



##### Using mutate()

## We can also create new variables prior to (or even after)
## summarizing information using mutate():
gdp_pop_bycontinents_byyear <- gapminder %>%
    mutate(gdp_billion = gdpPercap*pop/10^9) %>%
    group_by(continent,year) %>%
    summarize(mean_gdpPercap = mean(gdpPercap),
              sd_gdpPercap = sd(gdpPercap),
              mean_pop = mean(pop),
              sd_pop = sd(pop),
              mean_gdp_billion = mean(gdp_billion),
              sd_gdp_billion = sd(gdp_billion)

              

##### Connect mutate with logical filtering: ifelse

## When creating new variables, we can hook this with a logical
## condition. A simple combination of mutate() and ifelse()
## facilitates filtering right where it is needed: in the moment of
## creating something new. This easy-to-read statement is a fast and
## powerful way of discarding certain data (even though the overall
## dimension of the data frame will not change) or for updating values
## depending on this given condition.

## keeping all data but "filtering" after a certain condition
# calculate GDP only for people with a life expectation above 25
gdp_pop_bycontinents_byyear_above25 <- gapminder %>%
    mutate(gdp_billion = ifelse(lifeExp > 25, gdpPercap * pop / 10^9, NA)) %>%
    group_by(continent, year) %>%
    summarize(mean_gdpPercap = mean(gdpPercap),
              sd_gdpPercap = sd(gdpPercap),
              mean_pop = mean(pop),
              sd_pop = sd(pop),
              mean_gdp_billion = mean(gdp_billion),
              sd_gdp_billion = sd(gdp_billion))
              
##### Combining dplyr and ggplot2

## First install and load ggplot2:
install.packages("ggplot2")
library("ggplot2")

## Create a plot that filters countries located in the Americas, and
## then make a plot using 'ggplot(mapping = aes(x = year, y =
## lifeExp))', 'geom_line()', and 'facet_wrap( ~ country)':
# Filter countries located in the Americas
americas <- gapminder[gapminder$continent == "Americas", ]
# Make the plot
ggplot(data = americas, mapping = aes(x = year, y = lifeExp)) +
  geom_line() +
  facet_wrap( ~ country) +
  theme(axis.text.x = element_text(angle = 45))

## For extra points, change the angle of the text in the x axis:
gapminder %>%
  # Filter countries located in the Americas
  filter(continent == "Americas") %>%
  # Make the plot
  ggplot(mapping = aes(x = year, y = lifeExp)) +
  geom_line() +
  facet_wrap( ~ country) +
  theme(axis.text.x = element_text(angle = 45))


##################################################
#### Advanced Challenge
##################################################

## Calculate the average life expectancy in 2002 of 2 randomly
## selected countries for each continent. Then arrange the continent
## names in reverse order. Hint: Use the dplyr functions arrange() and
## sample_n(), they have similar syntax to other dplyr functions:



##################################################
## Lesson 14 Data frame Manipulation with tidyr
##################################################

##### Getting started

## First install and load tidyr:
install.packages("tidyr")
library("tidyr")

## First, lets look at the structure of our original gapminder data
## frame:
str(gapminder)

##### Challenge 1

## Is gapminder a purely long, purely wide, or some intermediate
## format?

##### From wide to long format with pivot_longer()

## Load the data into R using read.csv (downloading directly github):
gap_wide <- read.csv("https://raw.githubusercontent.com/swcarpentry/r-novice-gapminder/gh-pages/_episodes_rmd/data/gapminder_wide.csv", stringsAsFactors = TRUE)

## To convert from wide to a longer format, we will use the
## pivot_longer() function. pivot_longer() makes datasets longer by
## increasing the number of rows and decreasing the number of columns,
## or 'lengthening' your observation variables into a single variable:
gap_long <- gap_wide %>%
  pivot_longer(
    cols = c(starts_with('pop'), starts_with('lifeExp'), starts_with('gdpPercap')),
    names_to = "obstype_year", values_to = "obs_values"
  )
str(gap_long)

## Now obstype_year actually contains 2 pieces of information, the
## observation type (pop,lifeExp, or gdpPercap) and the year. We can
## use the separate() function to split the character strings into
## multiple variables:
gap_long <- gap_long %>% separate(obstype_year, into = c('obs_type', 'year'), sep = "_")

##### Challenge 2

## Using gap_long, calculate the mean life expectancy, population, and
## gdpPercap for each continent. Hint: use the group_by() and
## summarize() functions we learned in the dplyr lesson.

##### From long to intermediate format with pivot_wider()

## We can use pivot_wider() to pivot or reshape our gap_long to the
## original intermediate format or the widest format. Let’s start with
## the intermediate format:
gap_normal <- gap_long %>%
  pivot_wider(names_from = obs_type, values_from = obs_values)
dim(gap_normal)

## Now let's convert the long all the way back to the wide. In the
## wide format, we will keep country and continent as ID variables and
## pivot the observations across the 3 metrics (pop,lifeExp,gdpPercap)
## and time (year). First we need to create appropriate labels for all
## our new variables (time*metric combinations) and we also need to
## unify our ID variables to simplify the process of defining
## gap_wide:
gap_temp <- gap_long %>% unite(var_ID, continent, country, sep = "_")
str(gap_temp)

gap_wide_new <- gap_long %>%
  unite(ID_var, continent, country, sep = "_") %>%
  unite(var_names, obs_type, year, sep = "_") %>%
  pivot_wider(names_from = var_names, values_from = obs_values)
str(gap_wide_new)

## Now we have a great 'wide' format data frame, but the ID_var could
## be more usable, let’s separate it into 2 variables with separate():
gap_wide_new <- gap_long %>%
  unite(ID_var, continent, country, sep = "_") %>%
  unite(var_names, obs_type, year, sep = "_") %>%
  pivot_wider(names_from = var_names, values_from = obs_values)
str(gap_wide_new)

##### Challenge 3

## Take this one step further and create a gap_ludicrously_wide format
## data by pivoting over countries, year and the 3 metrics? Hint this
## new data frame should only have 5 rows.

