#' calc_tae
#'
#' Calculate the total absolute error (TAE) of a simulation
#'
#' @param con_pops Known/actual population usually taken from the constraints.
#' Should be a vector of numeric populations, one for each zone
#' @param sim_pops Simulated populations. Should be a vector of numeric
#' populations, one for each zone
#'
#' @return tae
#' @export
#'
calc_tae <- function(con_pops, sim_pops) {
  # TAE is absolute values of the contraint zone totals - sim zone totals
  # con_pops is a vector of contraint zone populations
  # sim_pops is a vector of simulated zone populations
  tae = abs(con_pops - sim_pops)
  tae
}

#' calc_sae
#'
#' Calculate the standardised absolute error (SAE) of a simulation.
#' Takes TAE as an argument, usually calculated using calc_tae()
#'
#' @param tae A vector of total absolute error for each zone, usually
#' calculated with calc_tae()
#' @param sim_pops A vector of simulated zone populations
#'
#' @return sae
#' @export
#'
calc_sae <- function(tae, sim_pops) {
  # SAE is TAE / known population of the area in total
  # tae is a vector of TAEs calculated with calc_tae()
  # sim_pops is a vector of simulated zone populations
  sae = tae / sum(sim_pops)
  sae
}

#' calc_sei
#'
#' Calculate the standard error around the identity (SEI) of a simulation
#'
#' @param area_sim_values A vector of simulated values for each zone
#' @param area_cen_values A vector of known (usually census) values for each
#' zone
#'
#' @return sei
#' @export
#'
calc_sei <- function(area_sim_values, area_cen_values) {
  # area_sim_values is a vector of simulated values for each zone for the var
  # area_cen_values is a vector of known (census) values for each zone
  stopifnot(
    length(area_sim_values) == length(area_cen_values)
  )

  sei <-
    sqrt(
      ((sum(
        (area_sim_values - area_cen_values) ^ 2)) /
         length(area_sim_values))
    )

  sei
}

#' calc_perc_error
#'
#' Calculates the percentage error of a simulation
#'
#' @param area_sim_values A vector of simulated values for each zone
#' @param area_cen_values A vector of known (usually census) values for each
#' zone
#' @param zone_pops A vector of known populations for each zone
#'
#' @return perc_error
#' @export
#'
calc_perc_error <- function(area_sim_values, area_cen_values, zone_pops) {
  # area_sim_values is a vector of simulated values for each zone
  # area_cen_values is a vector of known values for each zone
  # zone_pops are the known zone populations
  perc_error <- mean(abs(area_sim_values - area_cen_values) / zone_pops)
  perc_error
}
