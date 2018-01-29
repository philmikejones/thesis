# ========================================================================
# This file performs calculations that relies on more than one data set,
# so they can be prepared, loaded, then this file called
#
# Often these join calculations to other data sets
# ========================================================================

# Population calculations ====

# Zone populations based on pilot constraints
pilot_con_pops      <- sum_con_rows(pilot_con)
pilot_con_lsoa_pops <- sum_con_rows(pilot_con_lsoa)
pilot_con_msoa_pops <- sum_con_rows(pilot_con_msoa)

# Populations based on resilience constraints
# Should be same as pilot_con_pops, but you never know...
res_con_pops <- sum_con_rows(res_con)

# Simulated and actual populations
don_pop_sim <- sum(res_weights_ext[["total"]])
don_pop_act <- sum(res_con[, grep("sex_", colnames(res_con))])
don_pop_18p <- sum(pilot_con[, grep("^age_", colnames(pilot_con))]) -
  sum(pilot_con$age_16_17)

stopifnot(
  don_pop_18p < don_pop_act
)


# Pilot simulation ====
#  corrections for pilot simulation (original overestimates)
pilot_oa_ext$llid_correc <- pilot_oa_ext$llid_yes -
  (mean(pilot_oa_ext$llid_yes) - mean(don_oa@data$cen_llid_yes))

# Add simulated llid results to shapefiles (don_oa and don_comm)
don_oa@data <- don_oa@data %>%
  inner_join(pilot_oa_ext[, c("code", "llid_correc", "total")], by = "code") %>%
  mutate(p_llid_sim = llid_correc / total)

llid_sim_data <- don_oa@data %>%
  select(codecomm, namecomm, p_llid_sim) %>%
  group_by(codecomm, namecomm) %>%
  summarise_all(sum)

don_comm@data <- don_comm@data %>%
  inner_join(llid_sim_data,
             by = c("comm_code" = "codecomm", "comm_name" = "namecomm")) %>%
  mutate(cen_llid_yes_p = (cen_llid_little + cen_llid_lot) / pop_16_plus)

don_oa@data$p_llid_sim[don_oa@data$p_llid_sim < 0]     <- 0
don_comm@data$p_llid_sim[don_comm@data$p_llid_sim < 0] <- 0


# Resilience simulation ====
# Add the results of the resilience simulation to the shapefiles
don_oa@data <- don_oa@data %>%
  rename(total_cen = total) %>%  # total already in res_weights_ext
  left_join(res_weights_ext, by = "code") %>%
  rename(total_sim = total)


# Add IMD to shapefiles ====
don_oa@data <- don_oa@data %>%
  left_join(geolookup::oa_lsoa_msoa_lad[, c("oa_cd", "lsoa_cd")],
            by = c("code" = "oa_cd")) %>%
  left_join(don_lsoa@data[, c("code", "imd_rank", "imd_dec")],
            by = c("lsoa_cd" = "code"))

stopifnot(  # check correct number of OAs
  all.equal(nrow(don_oa@data), 978)
)


# Fix prison OAs ====
prison_oa   <- c("E00038161", "E00038290", "E00172382")
# Have to exclude simulated prison OAs
don_oa@data$depress_no[!is.na(don_oa@data$prison_pop)]  <- NA
don_oa@data$depress_yes[!is.na(don_oa@data$prison_pop)] <- NA


# Depression prevalence ====
dep_prev <- 12.8 # taken from phe2016a
depress_sim <- sum(don_oa@data$depress_yes, na.rm = TRUE)
depress_act <- round((don_pop_18p / 100) * dep_prev)

stopifnot(  # confirm prison zones have NAs (i.e. aren't accidentally counted)
  any(is.na(don_oa@data$depress_yes))
)


# Calculate resilience ====
# I've not placed this in a separate file because it's not very abstract
# It's more a helper or wrapper than a function
calc_resilience <- function(deprivation, health, threshold) {

  high_probs <- 1 - threshold
  low_probs  <- threshold

  # set prison OAs to NA so they don't screw up the results
  don_oa@data[[deprivation]][!is.na(don_oa@data$prison_pop)] <- NA

  # identify most deprived output areas
  high <- quantile(don_oa@data[[deprivation]], probs = high_probs, na.rm = TRUE)

  don_oa@data$high <- 0
  don_oa@data$high[don_oa@data[[deprivation]] >= high] <- 1
  don_oa@data$high[!is.na(don_oa@data$prison_pop)]     <- NA

  # identify lowest health problem
  don_oa@data[[health]][!is.na(don_oa@data$prison_pop)] <- NA
  low <- quantile(don_oa@data[[health]], probs = low_probs, na.rm = TRUE)

  don_oa@data$low <- 0
  don_oa@data$low[don_oa@data[[health]] < low]    <- 1
  don_oa@data$low[!is.na(don_oa@data$prison_pop)] <- NA

  # Resilient = 2 (i.e. both conditions met)
  resilient <- don_oa@data$low + don_oa@data$high

  # Final check to make sure I've got the quantile probabilities correct
  # Should be more cases of deprivation lower than the threshold &
  # fewer cases of good health lower than the threshold
  stopifnot(
    length(don_oa@data[[deprivation]][don_oa@data[[deprivation]] < high]) >
      length(don_oa@data[[deprivation]][don_oa@data[[deprivation]] >= high]),

    length(don_oa@data[[health]][don_oa@data[[health]] < low]) <
      length(don_oa@data[[health]][don_oa@data[[health]] >= low]),

    length(resilient[is.na(resilient)]) == 3
  )

  resilient

}

# Unemployment
don_oa@data$res_unem_20 <- calc_resilience("unem", "depress_yes", 0.2)
don_oa@data$res_unem_25 <- calc_resilience("unem", "depress_yes", 0.25)
don_oa@data$res_unem_30 <- calc_resilience("unem", "depress_yes", 0.3)
don_oa@data$res_unem_33 <- calc_resilience("unem", "depress_yes", 0.33)
don_oa@data$res_unem_40 <- calc_resilience("unem", "depress_yes", 0.4)

# Long-term unemployed
don_oa@data$res_ltun_20 <- calc_resilience("lt_unem_8", "depress_yes", 0.2)
don_oa@data$res_ltun_25 <- calc_resilience("lt_unem_8", "depress_yes", 0.25)
don_oa@data$res_ltun_30 <- calc_resilience("lt_unem_8", "depress_yes", 0.3)
don_oa@data$res_ltun_33 <- calc_resilience("lt_unem_8", "depress_yes", 0.33)
don_oa@data$res_ltun_40 <- calc_resilience("lt_unem_8", "depress_yes", 0.4)

# Routine (low grade) employment
don_oa@data$res_rout_20 <- calc_resilience("routine_7", "depress_yes", 0.2)
don_oa@data$res_rout_25 <- calc_resilience("routine_7", "depress_yes", 0.25)
don_oa@data$res_rout_30 <- calc_resilience("routine_7", "depress_yes", 0.3)
don_oa@data$res_rout_33 <- calc_resilience("routine_7", "depress_yes", 0.33)
don_oa@data$res_rout_40 <- calc_resilience("routine_7", "depress_yes", 0.4)

# Hard pressed living OAC
# OAC needs to be calculated slightly differently because I identify
# high deprivation as supergroup 'Hard-pressed living'
calc_oac_resilience <- function(threshold) {

  don_oa@data$high <- 0
  don_oa@data$high[don_oa@data$spr_name == "Hard-Pressed Living"] <- 1
  don_oa@data$high[!is.na(don_oa@data$prison_pop)]                <- NA

  don_oa@data$depress_yes[!is.na(don_oa@data$prison_pop)] <- NA
  low <- quantile(don_oa@data$depress_yes[is.na(don_oa@data$prison_pop)],
                  probs = threshold, na.rm = TRUE)
  don_oa@data$low <- 0
  don_oa@data$low[don_oa@data$depress_yes < low]  <- 1
  don_oa@data$low[!is.na(don_oa@data$prison_pop)] <- NA

  resilient <- don_oa@data$low + don_oa@data$high

  stopifnot(
    length(don_oa@data$depress_yes[don_oa@data$depress_yes < low]) <
      length(don_oa@data$depress_yes[don_oa@data$depress_yes >= low]),

    length(resilient[is.na(resilient)]) == 3
  )

  resilient

}

don_oa@data$res_oac_20 <- calc_oac_resilience(0.2)
don_oa@data$res_oac_25 <- calc_oac_resilience(0.25)
don_oa@data$res_oac_30 <- calc_oac_resilience(0.3)
don_oa@data$res_oac_33 <- calc_oac_resilience(0.33)
don_oa@data$res_oac_40 <- calc_oac_resilience(0.4)

# Can't use calc_resilience because IMD rank is reversed
# (i.e. low rank = high dep)
calc_imd_resilience <- function(threshold) {

  # Remove prison OAs
  don_oa@data$imd_rank[!is.na(don_oa@data$prison_pop)] <- NA

  # Low IMD rank = high deprivation so want < threshold
  high_deprivation <- quantile(don_oa@data$imd_rank,
                               probs = threshold, na.rm = TRUE)

  don_oa@data$high <- 0
  # < is correct; low IMD = high deprivation
  don_oa@data$high[don_oa@data$imd_rank < high_deprivation] <- 1
  don_oa@data$high[!is.na(don_oa@data$prison_pop)]          <- NA

  # Remove prison OAs
  don_oa@data$depress_yes[!is.na(don_oa@data$prison_pop)] <- NA

  low_bad_health <- quantile(don_oa@data$depress_yes,
                             probs = threshold, na.rm = TRUE)

  don_oa@data$low <- 0
  don_oa@data$low[don_oa@data$depress_yes < low_bad_health] <- 1
  don_oa@data$low[!is.na(don_oa@data$prison_pop)]           <- NA

  resilience <- don_oa@data$low + don_oa@data$high

  stopifnot(
    length(don_oa@data$depress_yes[don_oa@data$depress_yes < low_bad_health]) <
      length(don_oa@data$depress_yes[don_oa@data$depress_yes > low_bad_health]),

    length(resilience[is.na(resilience)]) == 3
  )

  resilience

}

don_oa@data$res_imd_20 <- calc_imd_resilience(0.2)
don_oa@data$res_imd_25 <- calc_imd_resilience(0.25)
don_oa@data$res_imd_30 <- calc_imd_resilience(0.3)
don_oa@data$res_imd_33 <- calc_imd_resilience(0.33)
don_oa@data$res_imd_40 <- calc_imd_resilience(0.4)


# Calculate number of resilient areas ====
# Drop unneeded resilient variables (ie ones with unwanted thresholds) so they
# aren't added to the calculation
# Recode the remaining variables so non-res = 0; res area = 1
# rowSum resilient areas
# merge result into don_oa
res_df <- don_oa@data %>%
  select(matches("^res_.*_33$"))

res_df[] <- lapply(res_df, function(x) {
  x <- x - 1
  x[!is.na(x) & x < 0] <- 0

  x
})

don_oa@data$res_total <- rowSums(res_df)


# Resilient characteristics ====

# Variables with resilience characteristics end with _yes, _good, or _low
# So does 'depress_yes' so we need to remove this
res_chars <- grepl("_yes$|_good$|_low$", colnames(don_oa@data))
res_chars <- colnames(don_oa@data[, res_chars])
res_chars <- res_chars[res_chars != "depress_yes"]
# switch 'isol_yes' for 'isol_no'
res_chars <- res_chars[res_chars != "isol_yes"]
res_chars <- c(res_chars, "isol_no")

don_oa@data <-
  don_oa@data %>%
  mutate_at(
    .vars = vars(res_chars),
    .funs = funs(p = . / pop_16_plus)
  )


# Identify deprived resilient areas ====
don_oa@data$res_depr <- FALSE
don_oa@data$res_depr[don_oa@data$res_total > 0] <- TRUE


# Distance to GP surgery ====
don_oa_cent@data <- don_oa_cent@data %>%
  inner_join(don_oa@data[, c("code", "res_total")], by = "code")

dist_doc <- rgeos::gDistance(doctors,
                             don_oa_cent[!is.na(don_oa@data$res_total), ],
                             byid = TRUE)
dist_doc <- apply(dist_doc, 1, min)
dist_doc <- data.frame(
  coords   =  attr(dist_doc, "names"),
  min_dist_doc = dist_doc,
  stringsAsFactors = FALSE,
  row.names = NULL
)

don_oa_cent@data$coords <- attr(don_oa_cent@coords, "dimnames")[[1]]

don_oa_cent@data <- don_oa_cent@data %>%
  full_join(dist_doc, by = "coords")


# Distance to leisure centres ====
# First clip leisure centres
leisure_centres <- leisure_centres[don_oa, ]

dist_lc <- rgeos::gDistance(leisure_centres,
                            don_oa_cent[!is.na(don_oa@data$res_total), ],
                            byid = TRUE)
dist_lc <- apply(dist_lc, 1, min)
dist_lc <- data.frame(
  coords = attr(dist_lc, "names"),
  min_dist_lc = dist_lc,
  stringsAsFactors = FALSE,
  row.names = NULL
)

don_oa_cent@data <- don_oa_cent@data %>%
  full_join(dist_lc, by = "coords")


# Distance to green space ====
gs_centroid <- rgeos::gCentroid(gs, byid = TRUE)

dist_gs <- rgeos::gDistance(gs_centroid,
                            don_oa_cent[!is.na(don_oa@data$res_total), ],
                            byid = TRUE)
dist_gs <- apply(dist_gs, 1, min)
dist_gs <- data.frame(
  coords           = attr(dist_gs, "names"),
  min_dist_gs      = dist_gs,
  stringsAsFactors = FALSE,
  row.names        = NULL
)

don_oa_cent@data <- don_oa_cent@data %>%
  full_join(dist_gs, by = "coords")


# Calculate poverty ====
median_income <- median(res_ind$hh_income, na.rm = TRUE)
poverty_thres <- median_income * 0.6

us$poverty <- NA
us$poverty[us$hh_income < poverty_thres]  <- "poverty_yes"
us$poverty[us$hh_income >= poverty_thres] <- "poverty_no"

# Calculate n kids in poverty ====
# £23,200 pa
kids_pov <- res_weights_int %>%
  inner_join(us[, c("pidp",
                    "f_hidp", "e_hidp", "d_hidp", "c_hidp", "b_hidp",
                    "a_hidp")],
             by = "pidp")

kids_pov$nkids <- NA
kids_pov$nkids[kids_pov$kids == "kids_1"]       <- 1
kids_pov$nkids[kids_pov$kids == "kids_2"]       <- 2
kids_pov$nkids[kids_pov$kids == "kids_3"]       <- 3
kids_pov$nkids[kids_pov$kids == "kids_4"]       <- 4
kids_pov$nkids[kids_pov$kids == "kids_5ormore"] <- 5

kids_pov <- kids_pov %>%
  group_by(zone) %>%
  filter(!duplicated(f_hidp)) %>%
  filter(!duplicated(e_hidp)) %>%
  filter(!duplicated(d_hidp)) %>%
  filter(!duplicated(c_hidp)) %>%
  filter(!duplicated(b_hidp)) %>%
  filter(!duplicated(a_hidp)) %>%
  filter(hh_income < poverty_thres) %>%
  summarise(kids_pov = sum(nkids, na.rm = TRUE)) %>%
  ungroup()

don_oa@data <- don_oa@data %>%
  full_join(kids_pov, by = c("code" = "zone"))

don_oa@data$kids_pov[is.na(don_oa@data$kids_pov)]    <- 0
don_oa@data$kids_pov[!is.na(don_oa@data$prison_pop)] <- 0

stopifnot(
  all.equal(nrow(don_oa@data), 978)
)


# Poor subjective financial situation ====
kids_fin_bad <- res_weights_int

kids_fin_bad <- kids_fin_bad %>%
  inner_join(us[, c("pidp", "nkids",
                    "f_hidp", "e_hidp", "d_hidp", "c_hidp", "b_hidp",
                    "a_hidp")], by = "pidp") %>%
  filter(nkids > 0) %>%
  filter(fin_sit == "fin_bad") %>%
  group_by(zone) %>%
  filter(!duplicated(f_hidp)) %>%
  filter(!duplicated(e_hidp)) %>%
  filter(!duplicated(d_hidp)) %>%
  filter(!duplicated(c_hidp)) %>%
  filter(!duplicated(b_hidp)) %>%
  filter(!duplicated(a_hidp)) %>%
  summarise(kids_fin_bad = sum(nkids))

don_oa@data <- don_oa@data %>%
  full_join(kids_fin_bad, by = c("code" = "zone"))

don_oa@data$kids_fin_bad[is.na(don_oa@data$kids_fin_bad)] <- 0
don_oa@data$kids_fin_bad[!is.na(don_oa@data$prison_pop)]  <- 0


# Case study areas ====
don_oa@data$case_study <- FALSE
don_oa@data$case_study[don_oa@data$code == "E00038777"] <- 1
don_oa@data$case_study[don_oa@data$code == "E00037924"] <- 2
don_oa@data$case_study[don_oa@data$code == "E00172394"] <- 3
don_oa@data$case_study[don_oa@data$code == "E00038232"] <- 4

don_oa@data$case_study <- factor(don_oa@data$case_study,
                                 levels = 1:4,
                                 labels = c("Wheatley",
                                            "North Armthorpe",
                                            "Five Streets",
                                            "Denaby Main"))


# Working-age population in poverty ====
pov_thres <- median(res_weights_int$hh_income[
  res_weights_int$zone != "E00038161" &
    res_weights_int$zone != "E00038290" &
    res_weights_int$zone != "E00172382"
], na.rm = TRUE)
pov_thres <- pov_thres * 0.6

work_age_pov <- res_weights_int %>%
  filter(age != "age_90_plus") %>%
  filter(age != "age_85_89") %>%
  filter(age != "age_75_84") %>%
  filter(age != "age_65_74") %>%
  filter(hh_income < pov_thres) %>%
  group_by(zone) %>%
  summarise(work_age_pov = n())

don_oa@data <- don_oa@data %>%
  inner_join(work_age_pov, by = c("code" = "zone")) %>%
  mutate(work_age_pov = work_age_pov - unem)


# Social isolation ====
soc_isol <- res_weights_int %>%
  filter(soc_isol == "isol_yes") %>%
  group_by(zone) %>%
  summarise(soc_isol = n())

don_oa@data <- don_oa@data %>%
  left_join(soc_isol, by = c("code" = "zone"))

don_oa@data$soc_isol[don_oa@data$prison_pop == "E00038161"] <- NA
don_oa@data$soc_isol[don_oa@data$prison_pop == "E00038290"] <- NA
don_oa@data$soc_isol[don_oa@data$prison_pop == "E00172382"] <- NA


# IHD and stoke (air pollution) ====
# Add ihd to the simulation individuals
ihd <- res_weights_int %>%
  left_join(us[, c("pidp", "ihd")], by = "pidp") %>%
  filter(ihd == "ihd_yes") %>%
  group_by(zone) %>%
  summarise(ihd = n())

don_oa@data <- don_oa@data %>%
  full_join(ihd, by = c("code" = "zone"))

# There are some missing, which are because there's no-one in these zones
# with IHD. Set these to 0 before returning the prison OAs to NA
don_oa@data$ihd[is.na(don_oa@data$ihd)] <- 0
don_oa@data$ihd[!is.na(don_oa@data$prison_pop)] <- NA


# CHD rate over 50 ====
# NHS Direct specify over 50 is the most common age group to have CHD
# Because of how I've had to set my data up to match the census categories I
# can only use over 45
ihd_rate <- res_weights_int %>%
  left_join(us[, c("pidp", "ihd")], by = "pidp") %>%
  filter(age == "age_45_59" |
           age == "age_60_64" |
           age == "age_65_74" |
           age == "age_75_84" |
           age == "age_85_89" |
           age == "age_90_plus") %>%
  select(zone, ihd) %>%
  group_by(zone) %>%
  mutate(pop_risk = n(),
         ihd      = sum(ihd == "ihd_yes")) %>%
  ungroup() %>%
  filter(!duplicated(.)) %>%
  transmute(zone,
            p_ihd = ihd / pop_risk)

don_oa@data <- don_oa@data %>%
  left_join(ihd_rate, by = c("code" = "zone"))


# Safe alone after dark ====
safe_alone <- res_weights_int %>%
  left_join(us[, c("pidp", "safe_alone")], by = "pidp") %>%
  filter(safe_alone == "safe_no") %>%
  group_by(zone) %>%
  summarise(safe_alone = n())

don_oa@data <- don_oa@data %>%
  full_join(safe_alone, by = c("code" = "zone"))


# housing costs ====
res_weights_int <- res_weights_int %>%
  inner_join(us[, c("pidp", "hh_cost", "prob_pay")], by = "pidp")

hh_prop <- res_weights_int %>%
  filter(!is.na(hh_cost)) %>%
  mutate(hh_prop = hh_cost / hh_income) %>%
  group_by(zone) %>%
  summarise(hh_prop = median(hh_prop))

don_oa@data <- don_oa@data %>%
  inner_join(hh_prop, by = c("code" = "zone"))


# Receives benefit to be replaced by UC ====
# Residents who currently receive a benefit that is to be replaced with
# Universal Credit
uc_replace <- res_weights_int %>%
  inner_join(us[, c("pidp", "uc_replace")], by = "pidp") %>%
  filter(uc_replace == 1) %>%
  group_by(zone) %>%
  summarise(uc_replace = n())

don_oa@data <- don_oa@data %>%
  full_join(uc_replace, by = c("code" = "zone"))


# Work allowance UC ====
res_weights_int$under_25 <- 0
res_weights_int$under_25[res_weights_int$age == "age_16_17"] <- 1
res_weights_int$under_25[res_weights_int$age == "age_18_19"] <- 1
res_weights_int$under_25[res_weights_int$age == "age_20_24"] <- 1

res_weights_int <- res_weights_int %>%
  full_join(us[, c("pidp", "couple")], by = "pidp")
res_weights_int$couple[is.na(res_weights_int$couple)] <- 0

res_weights_int$work_allow <- NA
res_weights_int$work_allow[res_weights_int$couple == 0 &
                             res_weights_int$under_25 == 1] <- 796.63
res_weights_int$work_allow[res_weights_int$couple == 0 &
                             res_weights_int$under_25 == 0] <- 901.48
res_weights_int$work_allow[res_weights_int$couple == 1 &
                             res_weights_int$under_25 == 1] <- 1024.3
res_weights_int$work_allow[res_weights_int$couple == 1 &
                             res_weights_int$under_25 == 0] <- 1188.88

res_weights_int$uc <- 0
res_weights_int$uc[res_weights_int$hh_income < res_weights_int$work_allow] <- 1

uc <- res_weights_int %>%
  filter(uc == 1) %>%
  group_by(zone) %>%
  summarise(uc = n())

don_oa@data <- don_oa@data %>%
  full_join(uc, by = c("code" = "zone"))


# Low income but not eligible UC ====
# The following individuals are not eligible for UC because they earn more than
# their threshold, but still earn less than the 60% median income poverty line
res_weights_int$pov_not_uc <- 0
res_weights_int$pov_not_uc[res_weights_int$hh_income < poverty_thres &
                            res_weights_int$uc == 0] <- 1

pov_not_uc <- res_weights_int %>%
  filter(pov_not_uc == 1) %>%
  group_by(zone) %>%
  summarise(pov_not_uc = n())

don_oa@data <- don_oa@data %>%
  full_join(pov_not_uc, by = c("code" = "zone"))
