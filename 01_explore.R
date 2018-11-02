library(dplyr)
library(ggplot2)


# Columns description -------------------------------------------------------------------------

columns_description <- read.csv2('data/HomeCredit_columns_description.csv', sep = ',')

columns_description %>% View




# Let’s see the application train data --------------------------------------------------------

application_train <- read.csv2('data/application_train.csv', sep = ',')

application_train %>% head %>% View

application_train %>% dim
# 300k rows, 122 columns


application_train %>% count(TARGET) %>% mutate(proportion = n/sum(n))
# DR is around 8%

application_train %>% count(as.factor(TARGET))

application_train %>% 
  ggplot(
    aes(x = as.numeric(AMT_CREDIT), color = as.factor(TARGET), fill = as.factor(TARGET))
  ) +
  geom_density(alpha = 0.3) + 
  geom_rug()
# Specially bad performance between 3k and 4k

application_train %>% summary



# What about the bureaus ----------------------------------------------------------------------


bureau <- read.csv2('data/bureau.csv', sep = ',')

bureau %>% head

bureau %>% dim

# # Ideas to generate features
# bureau %>% 
#   group_by(SK_ID_CURR) %>% 
#   summarise(
#     has_credit_closed = sum(CREDIT_ACTIVE == 'Closed') >= 1,
#     has_credit_active = sum(CREDIT_ACTIVE == 'Active') >= 1,
#     has_credit_sold = sum(CREDIT_ACTIVE == 'Sold') >= 1,
#     prop_credit_closed = sum(CREDIT_ACTIVE == 'Closed')/n(),
#     mean_days_credit = mean(DAYS_CREDIT, na.rm = T),
#     max_days_credit = max(DAYS_CREDIT, na.rm = T),
#     min_days_credit = min(DAYS_CREDIT, na.rm = T)
#   ) %>% head

bureau %>% 
  filter(
    SK_ID_CURR == 215354
  )
# Some missings

# Bureau Balance ------------------------------------------------------------------------------

bureau_balance <- read.csv2('data/bureau_balance.csv', sep = ',')

bureau_balance %>% head

# Previous application ------------------------------------------------------------------------

previous_application <- read.csv2('data/previous_application.csv', sep = ',')

previous_application %>% head

application_train %>% filter(SK_ID_CURR == 2030495)
# Not every application on the training set






