

## Importing data to R, visualizing, basic analysis 
## Audubon R workship Part II. 
## By Joanna Wu & Auriel Fournier, November 15, 2017

library(ggplot2)
library(plyr)
library(dplyr)
# library(tidyverse) # encompasses both above, and a few more libraries.
# warnings vs. errors.

# We will be working with data frames, (probably) the most common data type for ecologists
# Data entry still done in Excel.

## ------- Loading data into R ------- ##
# It is easiest to read in a .csv file, comma-separated value
# CSVs can be created in excel with Save As/CSV.

# Example (data: Corrie Folsom-O'Keefe, Elizabeth Amendola). 

# Set the working directory, where you'll be reading and writing files.
getwd()

# Absolute file path:
setwd('C:/Users/jwu/Documents/GitHub/AudubonR')

# Relative file path: 
# two dots mean go up a level in the directory.
setwd('../../../Box Sync/9_Admin_Conservation_Science/R series') # Or wherever you've put your files.

# Single dot: access files within the working directory "./file.csv" (I usually don't use)
# The top of console shows your working directory.
# Within user home directory: "~/path/to/file"

# Read our data, amoy.csv
amoy<-read.csv('amoy.csv', stringsAsFactors=F)
# Best practice: work with "long" instead of "wide" data. 
head(amoy)

# NA vs. 0: NAs are lack of data (not sure if 0 or something else), whereas 0 is you know it's a 0.
# in this case, all NAs in `fledglings` column are real 0's --> change those
amoy$fledglings[is.na(amoy$fledglings)] <- 0 # $ calls a column.

## ------- Scatter plots (points) ------- ##

# ggplot2 is built on the grammar of graphics, the idea that any plot can be expressed from the same set of components: 
#-- a **data** set
#-- a **coordinate system**
#-- and a set of **geoms** --the visual representation of data points.

# The key to understanding ggplot2 is thinking about a figure in layers. This idea may be familiar to you if you have used 
# image editing programs like Photoshop or Illustrator.
# Let's start off with an example:

ggplot(data = amoy, 
       aes(x = year, y = fledglings))

# this gives us a plot, with no data on it, but for a good reason. 
# we have told ggplot what data we want to use, and what axis we want
# the variables to be on, but we haven't told it how we want the data displayed
# do we want points? lines? box plots? it has no idea
# so it gives us the blank canvas
# so lets add a layer

ggplot(data = amoy, 
       aes(x = year, y = fledglings)) +
  geom_point() 

# now we can see the data! huzzah!
# we use a '+' sign to connect layers in ggplot
# Also: ggplot can handle  NAs.

# lets go into a bit more detail of what the above code says
# We've passed in two arguments to `ggplot`. First, we tell `ggplot` what data we
# want to show on our figure, in this example the amoy data. 
# For the second argument we passed in the `aes` function, which
# tells `ggplot` how variables in the **data** map to *aesthetic* properties of
# the figure, in this case the **x** and **y** variables. 
# Here we told `ggplot` we want to plot the "year" column of the  
# data frame on the x-axis, and the "fledglings" column on the y-axis. 
# Notice that we didn't need to explicitly pass `aes` these columns (e.g. `x = amoy[, "year"]`), 
# this is because `ggplot` is smart enough to know to look in the **data** for that column!

### Challenge 1

# What do we need to change to look at how productivity (the number of fledglings/breeding pairs) is related to year? 
# way 1: calculate productivity in ggplot function:
ggplot(data = amoy, 
       aes(x = year, y = fledglings/pairs.b)) +
  geom_point() 

# way 2: calculate productivity as a separate column, then plot
amoy$prod <- amoy$fledglings/amoy$pairs.b # make a new column called `prod`

# Writing outputs
write.csv(amoy, 'amoy.prod.csv', row.names=F) # otherwise you get a column with row numbers (1,2,3...)

# Plot
ggplot(data = amoy, 
       aes(x = year, y = prod)) +
  geom_point() 
# Another thing to note is that aes() is nested within the ggplot() function,
# and geom is mapped outside of the ggplot function.

# Main question: Does productivity differ amoung mainland vs. island sites?
View(amoy)
ggplot(data = amoy,
       aes(x=year, y=prod))+
  geom_point()+
  facet_wrap(~type)

## Challenge 2: instead of making two plots with the `type,` how can you make a plot for each year (6 total panels),
## with island/mainland type compared within each year?
ggplot(data = amoy,
       aes(x=type, y=prod))+
  geom_point()+
  facet_wrap(~year)
# facet wraps breaks graph into two (or more) based on variable(s) of interest.
# the y-axis is standardized by default to create a multi-panel figure.

## ------- Bar plots with error bars ------- ##
# let's make a bar plot with mean and error bars.
# stat='count' <- default
ggplot(data = amoy,
       aes(x = type)) +  
  geom_bar()
# number of sites of each type (beach vs. island)
# notice y aesthetic wasn't specified - because ggplot counts all the sites fitting those categories.

# stat='identity' to map y-aesthetic to a number (e.g. mean number of fledglings)
head(amoy)

# First create a summary table with year, mean and SD
mean.amoy <- amoy %>%
  group_by(year, type) %>%
  summarise(mean.fledge=mean(fledglings), 
            sd=sd(fledglings))
mean.amoy

p1<-ggplot(data = mean.amoy, # store this in memory as `plot1`
           aes(x = year, y = mean.fledge)) + 
  geom_bar(stat='identity')+
  facet_wrap(~type)
p1

# now let's add error bars for SD
# it's a new layer on top of p1:
p1 + geom_errorbar(aes(ymin=mean.fledge-sd, 
                       ymax=mean.fledge+sd)) #auto-indentation

# Super large bars! Most people plot SE when comparing means or across groups (years). let's try that.
# go back to the summary table, using the formula for SE instead: SE = SD/sqrt(n)
mean.amoy <- amoy %>%
  group_by(year, type) %>%
  summarise(mean.fledge=mean(fledglings), # remove NA values
            se=(sd(fledglings))/sqrt(sum(fledglings)))
mean.amoy

p1 + geom_errorbar(aes(ymin=mean.fledge-se,
                       ymax=mean.fledge+se))
# first re-run p1, because the current p1 in memory is defined by the old `mean.amoy` that doesn't have the `se` field.
# zoom to open plot. 
# let's say we want to make this plot prettier and save it.


## ------- Modifying text and exporting graphs ------- ##

# we'll call our plot p2, and add axes/aesthetic modifiers
p2 <- p1 + geom_errorbar(aes(ymin=mean.fledge-se,
                             ymax=mean.fledge+se))

# A quick way is to use pre-defined themes
p2 + theme_bw() # a clean bw look
p2 + theme_minimal()

# Many other themes exist in library(ggthemes), or you can build your own specifications.

p2 + theme_bw(16) + # size 16 font for labels
  ggtitle('American Oystercatch fledglings, 2012-2017') +
  ylab('Mean') +
  xlab('Year') +
  theme(axis.text=element_text(size=14)) 

# export graphics using ggsave
# this exports the last plot in memory
ggsave('amoy_mean.png', width=9, height=6, units='in', dpi=300) # saves to default working directory. You might want a `figures/` folder.
ggsave('C:/Users/jwu/Documents/TrainingTutorials/R_for_Audubon/amoy_mean.pdf', width=10, height=7, units='in') # specify the directory.

## NOTE: you must use forward slashes (`/`) in R. back slashes (used in windows)
## are escape characters in R and copied directories need to be modified!


## ------- Analysis: means comparison ------- ##
## Does productivity differ on beach vs. island? 
## Note: it is important to conduct proper statistics, and this tutorial does not substitute for consultation with an expert.
# Statistical test flowcharts.
# Pseudo code: compare means of fledglings on beach vs. island types

# 1. are data normally distributed? --> T test if parametric, wilcox test if non-parametric
# in linear regressions, you want to test if the residuals are normally distributed following a regression (roughly, sum(X-mean)).
# in means testing, you can approximate by using the `shapiro.test()` function
# (technically you want to test if the residuals are normally distributed, but the approximation is close for means testing)

# make vectors of beach and island productivity
beach <- amoy$fledglings[amoy$type=='Beach']
island <- amoy$fledglings[amoy$type=='Island']

shapiro.test(beach) # reject the null of normal distribution
shapiro.test(island) # reject the null of normal distribution
# normally when you have a low p-value, you find a "significant difference."
# the shapiro test is sort of flipped in that if P>0.05, you can use parametric statistical tests.
# if P<0.05, use non-parametric tests.

# 2. perform the test to look for differences in fledgling rates.
mean(beach)
mean(island)
wilcox.test(beach, island) # ranks values and infer whether distributions are significantly different
# YES, as Corrie and Beth suspected, mean fledgling rates are a lot higher (P<0.001) on the island than mainland!

## Challenge 3: how would you test if mean productivity (amoy$prod) differs on island vs. beach?
beach <- amoy$prod[amoy$type=='Beach']
island <- amoy$prod[amoy$type=='Island']
shapiro.test(beach) 
shapiro.test(island)
mean(beach, na.rm=T); mean(island, na.rm=T)
wilcox.test(beach, island)
# the order in t.test() and wilcox.test() doesn't matter UNLESS you are testing for an alternative hypothesis:
# alternative='less' or alternative='greater' (referring to the 1st element)

## ------- Means comparison over years ------- ##
# In above, we compared all means across all years. What if we were interested in whether the means differed within each year?
# BONUS: for loop.

# 1. Do a Shapiro test for productivity at beach and island sites in each year.
# you can create a subset of the data, and then run a shapiro test on each combination of year x site type.
# OR we can automate through combinations of year + type!

?aggregate
aggregate(cbind(shapiro.sig=prod) ~ year + type, amoy,
          FUN=function(x) shapiro.test(x)$p.value)
# binds the `shapiro.sig` column to `year` and `type`
# runs the aggregate function on `amoy` (points to data set)
# defines function to run as `shapiro.test`, pulling out p-values from results.

# Most results are non-parametric --> Wilcox test

# 2. Wilcox test for prod (beach vs. island) in each year.
# Make vector of all years to cycle through
years <- unique(amoy$year)

# Write function testing for difference between B and I sites
# For loops:

# for(variable in sequence){
#   Do something
# }

for(i in 1:4){
  j <- i + 10
  print(j)
}

# Steps to a function:
# 1. Define a function,
# 2. Load the function into the R session,
# 3. Use the function with your parameters.

fun.wilcox <- function(i, all) { # () enclose arguments, {} encloses function code.
  for(i in years[1:length(years)]) { # 2nd set of braces to enclose looping thru years.
    
    temp.b <- all[all$year==i & all$type=='Beach', 'prod'] # brackets [] enclose rows, columns
    temp.i <- all[all$year==i & all$type=='Island', 'prod']
    w.fun <- wilcox.test(temp.b, temp.i) # wilcox test to compare beach vs. island sites
    
    print(i) # tells you which year is being printed below
    print(w.fun) # prints Wilcox test outputs.
    
  }
}

fun.wilcox(i=years, all=amoy) # define the arguments to run the function.

# Which years were means not significantly different?
# 2012, 2014 (borderline), 2015.

## ------- Linear regression ------- ##
# Regression: relating one response variable to one or more independent variables
# predictors/independent variables can be continuous (e.g. productivity) or discrete (beach or island)

lm1 <- lm(prod ~ type, data=amoy)
summary(lm1)
# being an island has a significant positive effect on productivity

lm2 <- lm(prod ~ acres, data=amoy)
summary(lm2) 
# no effect of "acres"

lm3 <- lm(prod ~ miles.coastline, data=amoy)
summary(lm3)
# no effect of miles of coastline

# Assumptions of a linear model (often not met):
# - there is a linear relationship
# - parameters are not correlated (no multicollinearity)
# - residuals normally distributed
# - residuals have equal variance

# Sample distribution
ggplot(mtcars, 
       aes(x= wt, y=mpg))+
  geom_point()

lm.x<-lm(mpg ~ wt, mtcars)
summary(lm.x)

plot(lm.x$residuals)
plot(lm.x)

# check if residuals of our regression equation are normal. Obtain the standardized residual of the first linear model.
plot(lm1$residuals)
# create a plot to visualize residuals
plot(lm1)

#gvlma::gvlma

## Multiple linear regression - lm with multiple predictors
lm4 <- lm(prod ~ adults.nb + pairs.b + type + miles.coastline + acres, data=amoy)
summary(lm4)
plot(lm4)



# More on regression in R:
# methods: 
# http://tutorials.iq.harvard.edu/R/Rstatistics/Rstatistics.html 
# http://blog.yhat.com/posts/r-lm-summary.html (interpreting the lm summary)
# statistics of regression:
# http://r-statistics.co/Linear-Regression.html 
# https://onlinecourses.science.psu.edu/stat501/node/250

# Variants to regression:
# - interactions between factors (e.g. island AND small acreage have a net negative effect, but not beach and small.)
# - error structures
# - model random effects
# - model autocorrelation: time-series/repeat-sampling


## ------- Discrete data: Chi-square tests ------- ##

# Sometimes you might want to compare discrete data, like whether there are more beach vs island sites.
# A chi-squared test can be used to test this

# create your own custom headers for summarizing combinations of fields
# all  years have the same number of site types, so just choose one.
n.sum <- amoy %>%
  subset(year==2017) %>%
  ddply('year', summarise,
        beach.fs=length(site[type=='Beach' & fencing.stewardship=='yes']),
        beach.no.fs=length(site[type=='Beach' & fencing.stewardship=='no']),
        island.fs=length(site[type=='Island' & fencing.stewardship=='yes']),
        island.no.fs=length(site[type=='Island' & fencing.stewardship=='no']))
n.sum

?chisq.test
x<-c(12, 8, 6, 42)

chisq.test(x)
