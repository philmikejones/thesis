context("Check validation functions")


# calc_tae() ####
con_pops = sample(50:100, 20, replace = TRUE)
sim_pops = con_pops - sample(0:2, 20, replace = TRUE)
tae      = calc_tae(con_pops, sim_pops)

test_that("tae is a numeric vector", {
  expect_true(purrr::is_numeric(tae))
  expect_true(is.list(tae) || is.atomic(tae))
})


# calc_sae() ####
sae = calc_sae(tae, sim_pops)

test_that("sae is a numeric vector", {
  expect_true(purrr::is_numeric(sae))
  expect_true(is.list(sae) || is.atomic(sae))
})

test_that("sae is standardised (i.e. 0 <= sae <= 1)", {
  expect_true(all(sae >= 0),
              all(sae <= 1))
})


# calc_sei() ####
area_sim_values = sample(50:100, 20, replace = TRUE)
area_cen_values = area_sim_values - sample(0:2, 20, replace = TRUE)
sei             = calc_sei(area_sim_values, area_cen_values)

test_that("sae returns a numeric vector", {
  expect_true(is.atomic(sei) || is.list(sei))
  expect_true(purrr::is_numeric(sei))
})


# calc_perc_error() ####
zone_pops  = sample(101:1000, 20, replace = TRUE)
perc_error = calc_perc_error(area_sim_values, area_cen_values, zone_pops)

test_that("calc_perc_error returns a number", {
  expect_true(purrr::is_numeric(perc_error))
  expect_length(perc_error, 1L)
})
