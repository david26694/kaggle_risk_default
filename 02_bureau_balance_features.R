# We start from bottom to top, generating aggregation features



# Load data -----------------------------------------------------------------------------------

bureau_balance <- read.csv2('data/bureau_balance.csv', sep = ',')


# Do all the bureaus start at month balance equal to 0?

bureau_balance %>% head

bureau_balance %>% 
  group_by(MONTHS_BALANCE == 0) %>% 
  summarise(
    n_distinct(SK_ID_BUREAU)
  )
# There are many bureaus balances without data of 1 month ago.

bureau_balance %>% head(100) %>% View


# Feature generation --------------------------------------------------------------------------

# Features regarding binary general aggregations
balance_aggregation_binary <- bureau_balance %>% 
  group_by(SK_ID_BUREAU) %>% 
  summarise(
    has_number = sum(grepl('[0-9]', STATUS)) >= 1,
    has_positive_number = sum(grepl('[1-9]', STATUS)) >= 1,
    has_5 = sum(STATUS == '5') >= 1,
    has_non_c = sum(STATUS != 'C') >= 1,
    has_x = sum(STATUS == 'X') >= 1,
    has_c = sum(STATUS == 'C') >= 1
  )


# Features with last bureau
balance_aggregation_last <- bureau_balance %>% 
  group_by(SK_ID_BUREAU) %>% 
  summarise(
    last_status = last(STATUS)
  )

# Count status features
balance_aggregation_count <- bureau_balance %>% 
  group_by(SK_ID_BUREAU) %>% 
  summarise(
    sum_number = sum(grepl('[0-9]', STATUS)),
    count_number = sum(grepl('[0-9]', STATUS)),
    count_positive_number = sum(grepl('[1-9]', STATUS)),
    count_5 = sum(STATUS == '5'),
    count_x = sum(STATUS == 'X'),
    count_c = sum(STATUS == 'C'),
    num_mensualities = n()
  )

# Month related features
month_aggregations <- bureau_balance %>% 
  group_by(SK_ID_BUREAU) %>% 
  summarise(
    mean(MONTHS_BALANCE),
    max(MONTHS_BALANCE),
    min(MONTHS_BALANCE)
  )

balance_aggregation_binary %>% head

balance_aggregation_count %>% head

balance_aggregation <- left_join(balance_aggregation_binary, balance_aggregation_count)
balance_aggregation <- left_join(balance_aggregation, balance_aggregation_last)
balance_aggregation <- left_join(balance_aggregation, month_aggregations)


write.csv2(balance_aggregation, 'data/bureau_balance_features.csv')
