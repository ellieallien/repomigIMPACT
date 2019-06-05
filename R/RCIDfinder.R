#this is the initial package for the IMPACT repository migration
#this is my first ever function file!
#this file contains functions useful to extract info on the RCID based on the excel metedata sheet extracted from the resource centre

#' function to split the legacy data Date column (yyyy-mm) in two columns containing year and month, to be added to the df
#' @return a new data frame, copying over the input one and adding the new columns
#' @export
#create a new column that records just the beginning of the date info -- the year -- inspired by: https://stackoverflow.com/questions/4350440/split-data-frame-string-column-into-multiple-columns
extract_year <- function(df_rc){

  new_col_names <- c("Year", "Month")
  new_cols <- reshape2::colsplit(df_rc$Date, "-", new_col_names)
  new_df_rc <- cbind(df_rc, new_cols)
  return(new_df_rc)
}


#' function identifying whether a cycle belongs to the RCID era, or predates it, and needs therefore to be classified on the year-based RCID
#' @return the input data frame after manipulation
#' @export
#try to use the function suggested here: https://stackoverflow.com/questions/43531737/in-r-how-to-perform-an-operation-on-a-specific-subset-of-a-data-frame to identify the row index for a specific year
#basically build a new column that states whether this is a new or an old dataset form the year column
is_old_cycle <- function(df){

  #variable defining the threshold for the year-grouping
  year_thr <- 2018
  df$RC.Age <- ifelse(df$Year < year_thr, "old", "new")
  return(df)
}


#' function identifying the RCID to be assigned in the legacy data frame
#' @return the input legacy data frame after updates to the RCID column, and the updated table for the rcid too
#' @export
build_rcid <- function(df_leg, df_rcid){

  #first we deal with the simple case of Chad old

  #map the country code -- this adds the extra column with the country codes and the cycle number in the rcid table
  df_rcid <- map_country_codes(df_rcid)

  #now need to map the cycle number with year -- intervals?
  df_rcid <- map_cycle_year(df_rcid)




#leftjoin  https://www.researchgate.net/post/How_to_match_two_data_frames_in_R_based_on_multiple_criteria_instead_of_a_key_variable

    #now can build the RC id for the old ones based on the country and the year!
  #this we take from the other table! Has country as entry, and has year info in the RCid! should be easy!!! :) need to re-wrie in the initial df_rc!!! reminder!!
  #create a subset df for the country of interest, use: https://www.statmethods.net/management/subset.html
  #sub_df_rc <- subset(new_df_rc, Country == "Chad" & Year == 2016) #questo e inutile qua
  #here we should build a function that outputs the res cycle code for this simple case (map of coutry code to country --> can be built from the RCIDs excel), and this is used to input the full row, after transforming the info in the original one (do a transpose)
  #subset the small file to create a vector containing exactly the same info that is needed in the empty boxes



  #sub_rcid <- subset(df_rcid, Research.Cycle.ID == "TCD1600", c(Research.Cycle.ID, Research.Cycle.Title, OngoingPast, Initiative))


  #now, in the new df legacy in cui poi alla fine rimuovero le colonne inutili che ho aggiunto io, metto le info nelle caselle rilevanti
  #problema del factor se non uso as character, vedi: https://stackoverflow.com/questions/11949613/assigning-a-column-value-from-one-data-frame-to-another-in-r




  country_rcid <- as.character(df_rcid$Country)
  country_leg <- as.character(df_leg$Country)
  bool_cond <- grepl(country_rcid, country_leg) & (df_leg$Year < 2018) & grepl(df_rcid$Year, df_leg$Year)

  df_leg$RC.ID <- ifelse(bool_cond, as.character(df_rcid$Research.Cycle.ID[which(bool_cond)]), "")




  df_list <- list(df_leg, df_rcid)
  return(df_list)
}
