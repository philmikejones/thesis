# NB: Removing prisoners is problematic because I often end up with negative
# numbers where too many prisoners are being removed because the number to
# remove is based on the proportion of prisoners in the district overall.
# I can't remove prisoners without making arbitrary manual adjustments, so it's
# difficult to justify these.
# I've therefore left this code as a separate sheet which originated from line
# ~53 in 3-pilot-sms.R

# # Remove prisoners
# # Age 16-24 don't map nicely so do these manually
# census_age[census_age$code == "E00038161", 2] <-
#   census_age[census_age$code == "E00038161", 2] - ((3   / 249) * (0.29 * 599))
# census_age[census_age$code == "E00038161", 3] <-
#   census_age[census_age$code == "E00038161", 3] - ((58  / 249) * (0.29 * 599))
# census_age[census_age$code == "E00038161", 4] <-
#   census_age[census_age$code == "E00038161", 4] - ((188 / 249) * (0.29 * 599))
#
# census_age[census_age$code == "E00038290", 2] <-
#   census_age[census_age$code == "E00038290", 2] - ((11 / 78) * (0.29 * 221))
# census_age[census_age$code == "E00038290", 3] <-
#   census_age[census_age$code == "E00038290", 3] - ((10 / 78) * (0.29 * 221))
# census_age[census_age$code == "E00038290", 4] <-
#   census_age[census_age$code == "E00038290", 4] - ((57 / 78) * (0.29 * 221))
#
# census_age[census_age$code == "E00172382", 2] <-
#   census_age[census_age$code == "E00172382", 2] - ((11 / 550) * (0.29 * 1702))
# census_age[census_age$code == "E00172382", 3] <-
#   census_age[census_age$code == "E00172382", 3] - ((73 / 550) * (0.29 * 1702))
# census_age[census_age$code == "E00172382", 4] <-
#   census_age[census_age$code == "E00172382", 4] - ((466 / 550) * (0.29 * 1702))
#
# # Age 25-29
# census_age[census_age$code == "E00038161", 5] <-
#   census_age[census_age$code == "E00038161", 5] - 599 * 0.27
# census_age[census_age$code == "E00038290", 5] <-
#   census_age[census_age$code == "E00038290", 5] - 221 * 0.27
# census_age[census_age$code == "E00172382", 5] <-
#   census_age[census_age$code == "E00172382", 5] - 1702 * 0.27
#
# # Age 30-44
# census_age[census_age$code == "E00038161", 6] <-
#   census_age[census_age$code == "E00038161", 6] - 599 * 0.35
# census_age[census_age$code == "E00038290", 6] <-
#   census_age[census_age$code == "E00038290", 6] - 221 * 0.35
# census_age[census_age$code == "E00172382", 6] <-
#   census_age[census_age$code == "E00172382", 6] - 1702 * 0.35
#
# # Age 45-59
# census_age[census_age$code == "E00038161", 7] <-
#   census_age[census_age$code == "E00038161", 7] - 599 * 0.08
# census_age[census_age$code == "E00038290", 7] <-
#   census_age[census_age$code == "E00038290", 7] - 221 * 0.08
# census_age[census_age$code == "E00172382", 7] <-
#   census_age[census_age$code == "E00172382", 7] - 1702 * 0.08
#
# # Age 60-64
# census_age[census_age$code == "E00038161", 8] <-
#   census_age[census_age$code == "E00038161", 8] - 599 * 0.01
# census_age[census_age$code == "E00038290", 8] <-
#   census_age[census_age$code == "E00038290", 8] - 221 * 0.01
# census_age[census_age$code == "E00172382", 8] <-
#   census_age[census_age$code == "E00172382", 8] - 1702 * 0.01
#
# # All prisoners aged 16-64 so ignore 65+
#
# # # Tests (allow small tolerance due to rounding)
# # # Prison OA should now have non-prison populations only
# # # E00038161  214
# # # E00038290  278
# # # E00172382  253
# # sum(census_age[census_age$code == "E00038161", 2:ncol(census_age)])
# # sum(census_age[census_age$code == "E00038290", 2:ncol(census_age)])
# # sum(census_age[census_age$code == "E00172382", 2:ncol(census_age)])
# # # look good
# #
# # # Population should = old population - number of prisoners
# # # Old population = 244909; n prisoners = 2522
# # sum(census_age[, 2:ncol(census_age)]) + (599 + 221 + 1702)
# #
# # # Any <0?
# # for (i in 1:nrow(census_age)) {
# #   if (any(census_age[i, ] < 0)) {
# #     print(i)
# #   }
# # }
# # # Row 959
# # census_age[959, ]
# # Age 60-64 = -4. Change to 0
# census_age[959, 8] <- 0
#
# # Remove 3 (I'm 1 short) from largest category
# census_age[959, 6] <- census_age[959, 6] - 3
#
# # # All tests pass but some decimals. Integerise!
# census_age[, 2:ncol(census_age)] <-
#   apply(census_age[, 2:ncol(census_age)], 2, round, digits = 0)
#
# # # Re-run tests. All pass
# # sum(census_age[, 2:ncol(census_age)])  # 242,387
