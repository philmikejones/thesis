% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/population_funcs.R
\name{sum_con_rows}
\alias{sum_con_rows}
\title{sum_con_rows}
\usage{
sum_con_rows(zone_size)
}
\arguments{
\item{zone_size}{usually one of pilot_con, pilot_con_lsoa, or pilot_con_msoa
These should be unquoted because they (should be) objects in .GlobalEnv}
}
\value{
Vector of zone populations
}
\description{
This function calculates the total population in each zone and returns
a vector of these totals
This function is essential because there are multiples of the population
in the constraint tables, i.e. all `age_` variables sum to the population,
as do all `sex_` variables, etc. so it's not possible to just take
`rowSums()`
}
