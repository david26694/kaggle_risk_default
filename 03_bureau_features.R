
# Load data -----------------------------------------------------------------------------------


bureau_balance_features <- read.csv2('data/bureau_balance_features.csv')

bureau <- read.csv('data/bureau.csv')


bureau_features <- left_join(bureau, bureau_balance_features)

bureau_features %>% count(is.na(has_number))
# There isn't a perfect match

# Create binary variable wether there's balance.
bureau_features$has_balance <- 0
bureau_features[!is.na(bureau_features$has_number), 'has_balance'] <- 1 


bureau %>% head

# Create credit active related features
bureau %>% count(CREDIT_ACTIVE)
bureau_credit_active_count <- bureau %>% 
  group_by(SK_ID_CURR) %>% 
  summarise(
    count_active = sum(CREDIT_ACTIVE == 'Active'),
    count_closed = sum(CREDIT_ACTIVE == 'Closed'),
    count_sold = sum(CREDIT_ACTIVE == 'Sold'),
    num_bureaus = n()
  )
