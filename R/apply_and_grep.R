df_rcid$Year <- c(2015, 2016, 2017, 2018)

trunc_legacy <- new_df_rc %>% select(Title, Year, Donor, Mandating.body.agency, REACH.Pillar, Country)
trunc_rcid <- df_rcid %>% select(Research.Cycle.ID, Year, Donor, Mandating.Body.agency, Sub.Pillar, Country)


names(trunc_rcid) <- c("Research.Cycle.ID", "Year", "Donor", "Mandating.Body.agency", "REACH.Pillar", "Country")

v1 <- trunc_legacy[1,]

compare.linkage(v1, trunc_rcid, blockfld = c(6))$pairs

epiWeights(compare.linkage(v1, trunc_rcid, blockfld = c(6)))


### OR GREP

f1 <- function(v){
result <- mapply(grep, pattern = v, x = trunc_rcid) %>% unlist %>% as.vector
ind <- getmode(result)
trunc_rcid$Research.Cycle.ID[ind]
}

apply(trunc_legacy, 1, f1)

getmode <- function(v) {
  uniqv <- unique(v)
  uniqv[which.max(tabulate(match(v, uniqv)))]
}

### Apply thid to
