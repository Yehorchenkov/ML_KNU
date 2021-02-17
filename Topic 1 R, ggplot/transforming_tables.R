library(tidyr)
library(dplyr)
library(readxl)
library(readr)

# reading data
data <- read_excel('./data/sales.xlsx', 
                   sheet = 'data')

# ==================
# Task: compare average monthly sales across regions
# in the first quarter of 2019 and 2020
# ==================

# fill region column
data <- fill(data, region, .direction = 'down')

# bring the table in the correct form
data <- pivot_longer(
    data, 
    cols = `january 2019`:`march 2020`, 
    names_to  = 'month', 
    values_to = 'sales')

# cut the month column to year and month
data <- separate(data, 
                 col = 'month', 
                 into = c('month', 'year'), 
                 remove = TRUE, sep = " ")

# final counts
data <-
    data %>%
    filter(month %in% c('january', 'february', 'march')) %>%
    group_by(region, year) %>%
    summarise(sales = mean(sales))

# make the table wider
data %>%
    pivot_wider(names_from = year, 
                values_from  = sales) %>%
    mutate(grow = (`2020` - `2019`) / `2020` * 100) %>%
    arrange(desc(grow))

# write everything through piplines
read_excel('./data/sales.xlsx', 
           sheet = 'data') %>%
    fill(region, 
         .direction = 'down') %>%
    pivot_longer(
        cols = `january 2019`:`march 2020`, 
        names_to  = 'month', 
        values_to = 'sales') %>%
    separate(col = 'month', 
             into = c('month', 'year'), 
             remove = TRUE, sep = " ") %>%
    filter(month %in% c('january', 'february', 'march')) %>%
    group_by(region, year) %>%
    summarise(sales = mean(sales)) %>%
    pivot_wider(names_from = year, 
                values_from  = sales) %>%
    mutate(grow = (`2020` - `2019`) / `2020` * 100) %>%
    arrange(desc(grow))


# ###############################
# Specifications
# Task: calculate the % of refunds from the sale amount
# ###############################

shop_data_2019 <- read_delim(
    './data/shop_data_2019.csv',
    delim = ';', locale = locale(decimal_mark = ",") )

# build the specification
wild_spec <- build_wider_spec(shop_data_2019, 
                              names_from = 'key', 
                              values_from = 'value')

# apply the specification
pivot_wider_spec(shop_data_2019, spec = wild_spec) %>%
    mutate(refund_rate = refund / ( sale + upsale )) %>%
    arrange(desc(refund_rate))

# read data of a similar structure
shop_data_2020 <- read_delim(
    './data/shop_data_2020.csv',
    delim = ';', locale = locale(decimal_mark = ","))

# apply the specification
shop_data_2020 %>%
    pivot_wider_spec(spec = wild_spec) %>%
    mutate(refund_rate = refund / ( sale + upsale )) %>%
    arrange(desc(refund_rate))

# save the specification
saveRDS(object = wild_spec, file = './data/spec.rds')

# read the specification
new_wild_spec <- readRDS('./data/spec.rds')

# apply
pivot_wider_spec(shop_data_2019, spec = new_wild_spec) %>%
    mutate(refund_rate = refund / ( sale + upsale )) %>%
    arrange(desc(refund_rate))
