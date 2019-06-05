#this is the initial package for the IMPACT repository migration
#this is my first ever function file!
#this file contains functions useful to extract info on the RCID based on the excel metedata sheet extracted from the resource centre

extract_year <- function(df_rc){

  new_col_names <- c("Year", "Month")
  new_cols <- reshape2::colsplit(df_rc$Date, "-", new_col_names)
  new_df_rc <- cbind(df_rc, new_cols)
  return(new_df_rc$Year)
}
