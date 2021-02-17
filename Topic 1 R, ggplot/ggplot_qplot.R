library(tidyverse)

### Scatter plots
## Basic scatter plots

#' The plot can be created using data from either numeric vectors 
#' or a data frame:

# Use data from numeric vectors
x <- 1:10; y = x*x
# Basic plot
qplot(x,y)
# Add line
qplot(x, y, geom=c("point", "line"))
# Use data from a data frame
qplot(x=mpg, y=wt, data=mtcars)


## Scatter plots with smoothed line

#' The option smooth is used to add a smoothed line 
#' with its standard error:

# Smoothing
qplot(mpg, wt, data = mtcars, geom = c("point", "smooth"))

## Smoothed line by groups

#' The argument color is used to tell R that we want to color 
#' the points by groups:
    
# Linear fits by group
qplot(mpg, wt, data = mtcars, color = factor(cyl),
      geom=c("point", "smooth"))

## Change scatter plot colors

#' Points can be colored according to the values of a continuous 
#' or a discrete variable. The argument colour is used.

# Change the color by a continuous numeric variable
qplot(mpg, wt, data = mtcars, colour = cyl)

# Change the color by groups (factor)
qplot(mpg, wt, data=mtcars, colour= factor(cyl))

# Add lines
qplot(mpg, wt, data = mtcars, colour = cyl,
      geom=c("point", "line"))

## Change the shape and the size of points

#' Like color, the shape and the size of points can be controlled 
#' by a continuous or discrete variable.

# Change the size of points according to 
# the values of a continuous variable
qplot(mpg, wt, data = mtcars, size = mpg)

# Change point shapes by groups
qplot(mpg, wt, data = mtcars, shape = factor(cyl))

## Scatter plot with texts

#' The argument label is used to specify the texts to be used 
#' for each points:
    
qplot(mpg, wt, data = mtcars, label = rownames(mtcars), 
      geom=c("point", "text"),
      hjust=0, vjust=0)

#--------------------------------

### Box plot, dot plot and violin plot

# PlantGrowth data set is used in the following example :
    
head(PlantGrowth)


# geom = “boxplot”: draws a box plot

# geom = “dotplot”: draws a dot plot. 
# The supplementary arguments stackdir = “center” and 
# binaxis = “y” are required.

# geom = “violin”: draws a violin plot. 
# The argument trim is set to FALSE

# Basic box plot from a numeric vector
x <- "1"
y <- rnorm(100)
qplot(x, y, geom="boxplot")

# Basic box plot from data frame
qplot(group, weight, data = PlantGrowth, 
      geom=c("boxplot"))

# Dot plot
qplot(group, weight, data = PlantGrowth, 
      geom=c("dotplot"), 
      stackdir = "center", binaxis = "y")

# Violin plot
qplot(group, weight, data = PlantGrowth, 
      geom=c("violin"), trim = FALSE)

# Change the color by groups:
    
# Box plot from a data frame
qplot(group, weight, data = PlantGrowth, 
      geom=c("boxplot"), fill = group)

# Dot plot
qplot(group, weight, data = PlantGrowth, 
      geom = "dotplot", stackdir = "center", binaxis = "y",
      color = group, fill = group)

#--------------------------------------------------

### Histogram and density plots

#' The histogram and density plots are used to display 
#' the distribution of data.

# Generate some data

# The R code below generates some data containing the weights 
# by sex (M for male; F for female):
    
set.seed(1234)
mydata = data.frame(
    sex = factor(rep(c("F", "M"), each=200)),
    weight = c(rnorm(200, 55), rnorm(200, 58)))

head(mydata)

## Histogram plot

# Basic histogram
qplot(weight, data = mydata, geom = "histogram")

# Change histogram fill color by group (sex)
qplot(weight, data = mydata, geom = "histogram",
      fill = sex)

## Density plot

# Basic density plot
qplot(weight, data = mydata, geom = "density")

# Change density plot line color by group (sex)
# change line type
qplot(weight, data = mydata, geom = "density",
      color = sex, linetype = sex)

#-------------------------------------------

### Main titles and axis labels

# Titles can be added to the plot as follow:
    
qplot(weight, data = mydata, geom = "density",
      xlab = "Weight (kg)", ylab = "Density", 
      main = "Density plot of Weight")

