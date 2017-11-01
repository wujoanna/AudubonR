

### -- Introduction to R: basic syntax, loading data, and libraries
### -- By - Matt Boone (2015) & Auriel Fournier (2015)
### -- Modified by Joanna Wu for Audubon R tutorial (November 2017)

#######################################
### -- Tour around R Studio
#######################################

# Write script here, save.
# New scripts, tabs.
# Check for version of R and RStudio.
# Global options for customization. Saving workspace/RData option.

#######################################
### -- Basic syntax & objects
#######################################

# indicates a comment and is ignored by the console. Incredibly useful for making notes to yourself/colleagues!
# color coding. ()
# case-sensitive. space-insensitive *between commands, not within
# "Run" at the top right of the code editor, or CTRL + Enter

# Object-based. Assigning:
a<-4
b <- 2 #space-insensitive
a + b
4+2 #R is also a calculator
4^7/3

# object names have to start with a letter
2a<-2

#* space case study
x<-3
x< -3

# Types of objects:
# 1. character - quote marks
print('Hello world')
h<-'Hello world'
print(h)
typeof(h)

# 2. numeric: includes decimals like 1.5
my_numeric<-1.5
typeof(my_numeric)

# 3. interger
my_integer<-1L #capital L specifies an integer.
typeof(my_integer)

# What if you assign an integer without an "L"?
my_number<-1
typeof(my_number)

# Convert to numeric
my_converted_numeric<-as.numeric(my_integer) #convert from integer to numeric
typeof(my_converted_numeric)

# 4. complex
My_complex<-1+4i #imaginary number
typeof(My_complex) # what do we need to fix?

# 5. logical (true/false)
my_logical<-TRUE #you need to use CAPS for T/F and not quotation marks!
typeof(my_logical)

#Shorthand: caps T or F
my_logical2<-F
typeof(my_logical2)

#######################################
### -- All about vectors
#######################################

# Vectors are one-dimension arrays that can hold numeric data, character data, or logical data. 
# In other words, a vector is a simple tool to store data.  

numeric_vector <- c(1, 10, 49) # c() stands for combine.
character_vector <- c("a", "b", "c")
# Check your vectors on the workspace history panel

# Complete the code for boolean_vector that contains the three elements: TRUE, FALSE and TRUE (in that order).
boolean_vector <- c(TRUE, FALSE, TRUE)

# You are monitoring 2 shorebird species over 3 days at your local beach.
  
# For Sanderling:
# On Monday you saw 50
# Tuesday you saw 20
# Wednesday you saw 100

# For Whimbrel:
# On Monday you saw 2
# Tuesday you saw 25
# Wednesday you saw 80

# Sanderlings over the 3 days:
sand <- c(50, 20, 100)
# Whimbrel over the 3 days:
whim <- c(2,25,80)

# Now that you have your vectors, it would be helpful to assign metadata (days of the week) to them.
# Each element matches the position in a vector of the same length
days_vector<-c('Monday', 'Tuesday', 'Wednesday')
names(sand)<-days_vector
sand

names(whim)<-days_vector   
sand; whim #print
  
# If you sum two vectors in R, it takes the element-wise sum:
A_vector <- c(1, 2, 3)
B_vector <- c(4, 5, 6)
total_vector <- A_vector+B_vector

# Print out total_vector
print(total_vector)
total_vector

# How many target shorebirds did you see on each day?
total_daily<-sand+whim

# Assign weekday names to the total_daily vector
names(total_daily) <- days_vector
total_daily
  
# You can sum the values inside vectors:
# How many total SAND and WHIM did you see over 3 days?
sum_AB<-sum(A_vector, B_vector)
sum_AB

sum(total_daily)
sum(sand, whim)
sum(sand+whim)

?sum #call the help files

# On Wednesday there was an influx of offshore resources. You want to know how many birds you saw on that day.
# We can use brackets, [], to select specific elements of the vector.
# In this case, total_daily[1] indicates the total shorebirds on the first day, Monday. 
# How would you subsample the total shorebirds on Wednesday?
total_daily[3]

# There are shorthands for selecting a series of elements or several at once.
# Daily totals for Tuesday and Wednesday:
total_daily[2:3]
# Daily totals for just Monday and Wednesday:
total_daily[c(1,3)];total_daily[c('Monday','Wednesday')] 
#Same; just need to use quotes for characters.
# ; separates 2 commands. Same as line break.

## Logical operators ##

# < for less than
# > for greater than
# <= for less than or equal to
# >= for greater than or equal to
# == for equal to each other
# != not equal to each other

# Did we see more Sanderlings than Whimbrels on Monday?
sand[1]>whim[1]

# Challenge: Was there a day we saw more Whimbrels than Sanderlings?
whim>sand

#######################################
### -- Data structures 
#######################################

# We're going to talk about the matrix, list, and data frame.

## Matrices ## 
# In R, a matrix is a collection of elements of the same data type (numeric, character, or logical) arranged into a 
# fixed number of rows and columns. Since you are only working with rows and columns, a matrix is two-dimensional. 

# Let's create a 3x3 matrix with the numbers 1-9:
my_matrix<-matrix(1:9, byrow = F, nrow = 3) 
my_matrix
#matrix() is the function to create a matrix
#byrow indicates whether you want to fill byrow (T), or by column (F)
#nrow tells R to make 3 rows.
#considered "Data" in your workspace history.

# You can also combine vectors into matrices.
# In the editor, three vectors are defined. Each one represents the box office numbers from the first three Star Wars movies. 
# The first element of each vector indicates the US box office revenue, the second element refers to the Non-US box office (source: Wikipedia).
# Box office Star Wars (in millions!)
new_hope <- c(460.998, 314.4)
empire_strikes <- c(290.475, 247.900)
return_jedi <- c(309.306, 165.8)

# Create box_office vector combining those values
box_office <- c(new_hope, empire_strikes, return_jedi)
box_office
  
# Construct star_wars_matrix with 3 rows, and enter the values by row.
star_wars_matrix <- matrix(box_office, byrow=T, nrow=3)
star_wars_matrix[1,2]

# That's good, but let's add row and column names to reduce ambiguity.
region<-c('US', 'non-US')
titles<-c("A New Hope", "The Empire Strikes Back", "Return of the Jedi")

# Name the columns with region
colnames(star_wars_matrix)<-region

# Name the rows with titles
rownames(star_wars_matrix)<-titles

print(star_wars_matrix)

# We can calculate the worldwide box office revenue using the rowSums() function:
total_rev <- rowSums(star_wars_matrix)

# Let's add that as a new column using cbind(), column-bind.
all_wars_matrix<-cbind(star_wars_matrix, total_rev)
all_wars_matrix


## Lists ##
# In R lists act as containers. Unlike atomic vectors, the contents of a list are not restricted to a single mode 
# and can encompass any mixture of data types. Lists are sometimes called generic vectors, because the elements of a 
# list can be of any type of R object, even lists containing further lists. This property makes them fundamentally 
# different from atomic vectors.

x <- list(1, "a", TRUE, 1+4i)
x

# The content of elements of a list can be retrieved by using double square brackets.
x[[2]]

# Vectors can be coerced to lists:
x<-as.list(1:10)
x

# Lists can be extremely useful inside functions. Because the functions in R are able to return only a single object, 
# you can "staple" together lots of different kinds of results into a single object that a function can return.

## Data frames ## 
# A data frame is a very important data type in R. It's pretty much the de facto data structure for most tabular data and what we use for statistics.
 
# A data frame is a special type of list where every element of the list has same length (i.e. data frame is a "rectangular" list).

# Data frames can have additional attributes such as rownames(), which can be useful for annotating data, like subject_id or sample_id. 
 
# Some additional information on data frames:
# Usually created by read.csv() and read.table(), i.e. when importing the data into R.
# Assuming all columns in a data frame are of same type, data frame can be converted to a matrix with data.matrix() 
# (preferred) or as.matrix(). Otherwise type coercion will be enforced and the results may not always be what you expect.
# Can also create a new data frame with data.frame() function.
# Find the number of rows and columns with nrow(dat) and ncol(dat), respectively.

# To create a data frame by hand:
df <- data.frame(id = letters[1:10], x = 1:10, y = 11:20)
df

# Useful data frame functions:
# head() - shows first 6 rows
# tail() - shows last 6 rows
# dim() - returns the dimensions of data frame (i.e. number of rows and number of columns)
# nrow() - number of rows
# ncol() - number of columns
# str() - structure of data frame - name, type and preview of data in each column
# names() - shows the names attribute for a data frame, which gives the column names.
# sapply(df, class) - shows the class of each column in the data frame

#######################################
### -- Necessary packages
#######################################

library(gapminder)
library(dplyr)
library(tidyr)
library(ggplot2)

###################
### -- Loading In The Data
####################

data(gapminder)
head(gapminder)   

# Explain What Pipes are %>% 

# Explain the verbs of dplyr

#########################
### -- Filtering
#########################

gdat <- gapminder %>%
        filter(continent=='Europe',
               year==1987)

gapminder %>%
  filter(continent=='Europe',
         year==1987) %>% 
        select(country,lifeExp,gdpPercap)

# the "|" means 'or' in R
gapminder %>%
      filter(continent=="Europe"|continent=="Asia") %>%
      # comments here 
      distinct(continent)

# the "&" means "and" in R
gapminder %>%
          filter(year>=1987 & year<=2002) %>% distinct(year)

#########################
### -- Match %in%   
#########################

sub_countries <- c("Afghanistan","Australia", "Zambia")

gapminder %>%
  filter(country %in% sub_countries) %>% 
  distinct(country)

gdat <- gapminder %>%
  filter(country %in% sub_countries)

distinct(gdat, country)


#########################
### -- GROUPING
#########################

gapminder %>%
  group_by(continent) %>%
  summarize(mean.exp = mean(lifeExp),
            median = median(lifeExp))


gdat <- gapminder %>% 
  group_by(continent, year) %>%
  summarize(mean.exp=mean(lifeExp))
gdat

#########################################
### -- CHALLENGE
#########################################

# What is the median life expenctancy 
# and population for each country in Asia?

head(gapminder)

new_data <- gapminder %>% 
  filter(continent=='Asia') %>%
  group_by(country) %>%
  summarise(median.exp=median(lifeExp),
            median.pop=median(pop))

  
new_data

#note to self talk about Kiwi vs Us spelling
# note to self talk about n()

########################
## Joins
########################

# for no reason other than the awesomeness of star wars 
# we are going to join our data set with another dataset 
# indicating whether or not the original star wars had been released yet in that year

star_wars_dat <- data.frame(year=c(unique(gapminder$year)[2:10], 2012), 
                            star_wars_released=c("No","No","No","No","YES","YES","YES","YES","YES","YES"))
star_wars_dat
# you will notice this does not include 1952, 2002 and 2007

gapminder %>% distinct(year)
# does not include 2012.

full_join(gapminder, star_wars_dat, by="year") %>% distinct(year)
# we have everything, and NAs are inserted for years where things don't exist

right_join(gapminder, star_wars_dat, by="year") %>% distinct(year)
# notice that 1952, 2002, 2007 are missing, bc they don't exist in star_wars_dat

left_join(gapminder, star_wars_dat, by="year") %>% distinct(year)
# notice that 2012 is missing, bc it doesn't exist in gapminder

inner_join(gapminder, star_wars_dat, by="year") %>% distinct(year)
# only things that are in common


g1 <- gapminder %>% select(country, year)

g2 <- gapminder %>% select(lifeExp, continent)

gg <- cbind(g1, g2)
head(gg)

gg <- bind_cols(g1, g2) # returns the same type as the first input (data frame, tbl_df, or grouped_df)
gg

rbind()
bind_rows()

##########################
## GGplot 
## - or - 
## MUTATE
##########################

colors <- c("red","green")

gapminder %>%
  mutate(example = ifelse(country == "Afghanistan","Yes","No"),
         n1980s = ifelse(year>=1980 & year<=1989,"Yes","No")) %>%
  select(example, n1980s)

# or

mgap <- gapminder %>%  
  mutate(country_continent = paste0(country,"_",continent),
         gdp = gdpPercap/pop,
         favorite_color = 'green',
         yearfactor = factor(year)) %>%
   select(year, country_continent, gdp, favorite_color, yearfactor)
mgap

########################
## Separate
########################

mgap %>% 
  separate(country_continent, 
           sep="_", 
           into=c("country",
                  "continent"),
           remove=FALSE) 

# or

mgap %>% 
  separate(year, sep=c(-4,-3), # negative values start at -1 at the far right of the string
           into=c("century","y1","y2")) %>%
  mutate(century=as.numeric(century),
         year = as.numeric(y1))

#####################################
## CHALLENGE
#####################################

# Calculate the average life expectancy in 2002 
# of 2 randomly selected countries for each continent. 
# Then arrange the continent names in reverse order. \
# Hint: Use the dplyr functions arrange() and sample_n(), 
# they have similar syntax to other dplyr functions.
# ?arrange ?sample_n for help

gapminder %>%
  filter()
# ...

########################
## Dates and Times
########################

#########dates and times#############################

# We're first going to need to tackle dates. R can handle dates, and it can be quite powerful, but a bit annoying.
# The base functions for this are as.Date, as.POSIXct, as.POSIXlt
# The syntax for these is essentially the same, feed it a date, and tell it the format

Sys.time()

## Good Resource on what letters = what in format
# https://stat.ethz.ch/R-manual/R-devel/library/base/html/strptime.html

(dt<-as.Date(Sys.time(),format='%Y-%m-%d'))
(ct<-as.POSIXct(Sys.time(),format='%Y-%m-%d %H%M%D'))
(lt<-as.POSIXlt(Sys.time(),format='%Y-%m-%d %H%M%D'))

# whats great is we can now do math on time

dt-10   ##since day is the lowest measurement it counts in days
ct-10   ##however counts in seconds
lt-10   ##does the same thing

# as.POSIXlt is really useful because it allows you to call particular pieces of the time out
lt$yday   ##julian date
lt$hour   ##hour
lt$year   ##what.....time since 1900???
lt$year+1900  ##converts you to standard time

##these are particularly useful because you can do math on time
earlytime<-as.POSIXct('2015-03-23',format='%Y-%m-%d')

ct - earlytime 

##as well as logical statements
ct > earlytime
ct == earlytime

