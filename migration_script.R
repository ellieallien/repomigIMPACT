#this is the script that we will use to run the selection of the RCIDs, and that will call the utilities from the respective package

#create a data frame from the initial excel files, transformed in csvs
#one for the res centre info
df_rc <- read.csv2("data/legacy_data_chad.csv")
#one for the RCID info
df_rcid <- read.csv2("data/chad_repository.csv")

#create a new column that records just the beginning of the date info -- the year -- inspired by: https://stackoverflow.com/questions/4350440/split-data-frame-string-column-into-multiple-columns
new_col_names <- c("Year", "Month")
new_cols <- reshape2::colsplit(df_rc$Date, "-", new_col_names)
new_df_rc <- cbind(df_rc, new_cols)
#this is now in a function that outputs the new column

#try to use the function suggested here: https://stackoverflow.com/questions/43531737/in-r-how-to-perform-an-operation-on-a-specific-subset-of-a-data-frame to identify the row index for a specific year
#basically build a new column that states whether this is a new or an old dataset form the year column
new_df_rc$RC.Age <- ifelse(new_df_rc$Year < 2018, "old", "new")

#now can build the RC id for the old ones based on the country and the year!
#this we take from the other table! Has country as entry, and has year info in the RCid! should be easy!!! :) need to re-wrie in the initial df_rc!!! reminder!!
#create a subset df for the country of interest, use: https://www.statmethods.net/management/subset.html
#sub_df_rc <- subset(new_df_rc, Country == "Chad" & Year == 2016) #questo e inutile qua
#here we should build a function that outputs the res cycle code for this simple case (map of coutry code to country --> can be built from the RCIDs excel), and this is used to input the full row, after transforming the info in the original one (do a transpose)
#subset the small file to create a vector containing exactly the same info that is needed in the empty boxes
#one new column is filled with NAs: https://lembra.wordpress.com/2010/03/12/adding-new-column-to-a-data-frame-in-r/
df_rcid["OngoingPast"] <- NA
sub_rcid <- subset(df_rcid, Research.Cycle.ID == "TCD1600", c(Research.Cycle.ID, Research.Cycle.Title, OngoingPast, Initiative))

#now, in the new df legacy in cui poi alla fine rimuovero le colonne inutili che ho aggiunto io, metto le info nelle caselle rilevanti
#problema del factor se non uso as character, vedi: https://stackoverflow.com/questions/11949613/assigning-a-column-value-from-one-data-frame-to-another-in-r
new_df_rc$RC.ID <- ifelse(new_df_rc$Country == "Chad" & new_df_rc$Year == 2016, as.character(sub_rcid$Research.Cycle.ID), "")
