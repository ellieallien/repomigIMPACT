#this is the script that we will use to run the selection of the RCIDs, and that will call the utilities from the respective package

library(dplyr)

#create a data frame from the initial excel files, transformed in csvs
#one for the res centre info
df_rc <- read.csv2("data/legacy_data_chad.csv")
df_rc %>% head
#one for the RCID info
df_rcid <- read.csv2("data/chad_repository.csv")
df_rcid %>% head

#TEMPORARY: discussed with Anna we might want it as an extra column in the legacy file - one new column is filled with NAs: https://lembra.wordpress.com/2010/03/12/adding-new-column-to-a-data-frame-in-r/
df_rcid["Ongoing.Past"] <- NA
df_rcid

#create a new column that records just the beginning of the date info -- the year -- inspired by: https://stackoverflow.com/questions/4350440/split-data-frame-string-column-into-multiple-columns
new_df_rc <- extract_year(df_rc, date_col = "Date")
new_df_rc

#understand if the cycle predates the RCID system -- build an extra column with old or new specified
new_df_rc <- is_old_cycle(new_df_rc)
new_df_rc

#now fill in the RCID column
list_of_dfs <- build_rcid(new_df_rc, df_rcid)
new_df_rc <- list_of_dfs[1]
df_rcid <- list_of_dfs[2]
new_df_rc
df_rcid
