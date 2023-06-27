##################################################
## preamble

## R script for mini-lecture on confidence intervals
## SPDX-License-Identifier: GPL-3.0

## load packages
library(rethinking) 
## you will have to install this package using
## install.packages("rethinking"); it might
## take a while

## save data
data(Howell1)
data <- Howell1

## filter by age
data_kung <- data[ data$age >= 18 , ] # adults
data_kung_child <- data[ data$age < 18 , ] # children

##################################################

## data stored in dataframe called "data_kung"

data_kung

## look at the dataframe with "View()"
View(data_kung)

##### mean

## calculate mean

mean(data_kung$height)

## store mean value in object "xbar"

xbar <- mean(data_kung$height)

## check output of "xbar"

xbar

##### standard deviation

## calculate and store standard deviation in object "sd"

sd <- sd(data_kung$height)

##### sample size

## calculate and store sample size in object "n"

n <- length(data_kung$height)

## check output of "n"

n

##### t-value

## calculate t-value

t <- qt(p = .05/2, df = n - 1, lower.tail = FALSE)

## check output of "t"

t

##################################################

## calculate confidence intervals!

## construct upper confidence interval

ci_upper <- xbar + t * (sd / sqrt(n))

## check output

ci_upper

## construct lower confidence interval

ci_lower <- xbar - t * (sd / sqrt(n))

## check output

ci_lower

##################################################

## using t-test

t.test(data_kung$height)

