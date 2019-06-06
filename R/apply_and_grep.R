df_rcid$Year <- c(2015, 2016, 2017, 2018)

trunc_legacy <- new_df_rc %>% select(Title, Year, Donor, Mandating.body.agency, REACH.Pillar, Country)
trunc_rcid <- df_rcid %>% select(Research.Cycle.ID, Year, Donor, Mandating.Body.agency, Sub.Pillar, Country)


names(trunc_rcid) <- c("Research.Cycle.ID", "Year", "Donor", "Mandating.Body.agency", "REACH.Pillar", "Country")

v1 <- trunc_legacy[1,]

compare.linkage(v1, trunc_rcid, blockfld = c(6))$pairs

epiWeights(compare.linkage(v1, trunc_rcid, blockfld = c(6)))


### Functions to get the most likely or the three most likely
most_likely_RCID <- function(v){
result <- mapply(grep, pattern = v, x = trunc_rcid) %>% unlist %>% as.vector
ind <- getmode(result)
trunc_rcid$Research.Cycle.ID[ind]
}

most_likely_RCIDs <- function(v){
  result <- mapply(grep, pattern = v, x = trunc_rcid) %>% unlist %>% as.vector
  ind <- get_top_3(result) %>% as.numeric
  trunc_rcid$Research.Cycle.ID[ind]
}



### Functions that execute returning the most likely RCID or RCIDs
apply(trunc_legacy, 1, most_likely_RCID)
apply(trunc_legacy, 1, most_likely_RCIDs)



