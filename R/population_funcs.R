#' sum_con_rows
#'
#' This function calculates the total population in each zone and returns
#' a vector of these totals
#' This function is essential because there are multiples of the population
#' in the constraint tables, i.e. all `age_` variables sum to the population,
#' as do all `sex_` variables, etc. so it's not possible to just take
#' `rowSums()`
#'
#' @param zone_size usually one of pilot_con, pilot_con_lsoa, or pilot_con_msoa
#' These should be unquoted because they (should be) objects in .GlobalEnv
#'
#' @return Vector of zone populations
#' @export
#'
sum_con_rows <- function(zone_size) {
  pop <- rowSums(zone_size[, grep("sex_", colnames(zone_size))])

  pop
}
