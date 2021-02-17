library(tidyverse)
library("ggrepel") # repel overlapping text labels

# set working directory
setwd("C:/OneDrive/OneDrive - Faculty of IT Taras Shevchenko National University of Kyiv/Леша_ун.Шевченка/Erasmus/Erasmus Бронин/Тренинг июль/R")

# #### Points (scatterplot)
#
# Now that we know about geometric objects and aesthetic mapping, 
# we can make a `ggplot()`. `geom_point()` requires mappings for x 
# and y, all others are optional.
#
# **Example data: housing prices**
#
# Let's look at housing prices.

housing <- read_csv("dataSets/landdata-states.csv")
head(housing[1:5]) # view first 5 columns

# create a subset for 1st quarter 2001
hp2001Q1 <- housing %>% filter(Date == 2001.25)

# **Step 1:** create a blank canvas by specifying data:

ggplot(data = hp2001Q1)

# **Step 2:** specify aesthetic mappings 
# (how you want to map variables to visual aspects):

# here we map "Land_Value" and "Structure_Cost" to the x- and y-axes.
ggplot(data = hp2001Q1, mapping = aes(x = Land_Value, y = Structure_Cost))

# **Step 3:** add new layers of geometric objects that will show up on the plot: 

# here we use geom_point() to add a layer with point (dot) elements 
# as the geometric shapes to represent the data.
ggplot(data = hp2001Q1, aes(x = Land_Value, y = Structure_Cost)) +
    geom_point()


# #### Lines (prediction line)
#
# A plot constructed with `ggplot()` can have more than one geom. 
# In that case the mappings established in the `ggplot()` 
# call are plot defaults that can be added to or overridden --- 
# this is referred to as **aesthetic inheritance**. 
# Our plot could use a regression line:

# get predicted values from a linear regression
hp2001Q1$pred_SC <- lm(Structure_Cost ~ log(Land_Value), 
                       data = hp2001Q1) %>%
    predict()

p1 <- ggplot(hp2001Q1, aes(x = log(Land_Value), y = Structure_Cost))

p1 + geom_point(aes(color = Home_Value)) + # values for x and y are inherited from the ggplot() call above
    geom_line(aes(y = pred_SC)) # add predicted values to the plot overriding the y values from the ggplot() call above


# #### Smoothers
#
# Not all geometric objects are simple shapes; 
# the smooth geom includes a line and a ribbon.

p1 +
    geom_point(aes(color = Home_Value)) +
    geom_smooth()


# #### Text (label points)
#
# Each geom accepts a particular set of mappings; 
# for example `geom_text()` accepts a `label` mapping.

p1 + 
    geom_text(aes(label = State), size = 3)

# But what if we want to include points and labels? 
# We can use `geom_text_repel()` to keep labels from overlapping 
# the points and each other.

p1 + 
    geom_point() + 
    geom_text_repel(aes(label = State), size = 3)


# ### Aesthetic mapping VS assignment
#
# 1.  Variables are **mapped** to aesthetics inside the `aes()` 
# function.

p1 +
    geom_point(aes(size = Home_Value))

# 2.  Constants are **assigned** to aesthetics outside the `aes()` 
# call

p1 +
    geom_point(size = 2)

# This sometimes leads to confusion, as in this example:

p1 +
    geom_point(aes(size = 2),# incorrect! 2 is not a variable
               color="red") # this is fine -- all points red


# ### Mapping variables to other aesthetics
#
# Other aesthetics are mapped in the same way as x and y 
# in the previous example.

p1 +
    geom_point(aes(color = Home_Value, shape = region))

# ## Statistical transformations
#
# ### Why transform data?
#
# Some plot types (such as scatterplots) do not require 
# transformations; each point is plotted at x and y coordinates 
# equal to the original value. Other plots, such as boxplots, 
# histograms, prediction lines etc. require statistical 
# transformations:
#
# * for a boxplot the y values must be transformed to the median 
# and 1.5(IQR)
# * for a smoother the y values must be transformed into predicted 
# values
#
# Each geom has a default statistic, but these can be changed. 
# For example, the default statistic for `geom_histogram()` 
# is `stat_bin()`:

# ### Setting arguments
#
# Arguments to `stat_` functions can be passed through `geom_` 
# functions. This can be slightly annoying because in order 
# to change them you have to first determine which stat the geom 
# uses, then determine the arguments to that stat.
#
# For example, here is the default histogram of `Home_Value`:

p2 <- ggplot(housing, aes(x = Home_Value))
p2 + geom_histogram()

# We can change the binning scheme by passing the `binwidth` 
# argument to the `stat_bin()` function:

p2 + geom_histogram(stat = "bin", binwidth = 4000)


# ### Changing the transformation
#
# Sometimes the default statistical transformation is not 
# what you need. This is often the case with pre-summarized data:

housing_sum <- 
    housing %>%
    group_by(State) %>%
    summarize(Home_Value_Mean = mean(Home_Value)) %>%
    ungroup()

head(housing_sum)

ggplot(housing_sum, aes(x = State, y = Home_Value_Mean)) + 
    geom_bar()

## Error: stat_count() must not be used with a y aesthetic.  

# What is the problem with the previous plot? 
# Basically we take binned and summarized data and ask ggplot 
# to bin and summarize it again (remember, `geom_bar()` defaults 
# to `stat = stat_count`; obviously this will not work. 
# We can fix it by telling `geom_bar()` 
# to use a different statistical transformation function. 
# The `identity` function returns the same output as the input.

ggplot(housing_sum, aes(x = State, y = Home_Value_Mean)) + 
    geom_bar(stat = "identity")

