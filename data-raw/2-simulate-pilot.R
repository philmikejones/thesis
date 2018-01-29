# Pilot simulation: limiting long-term illness or disability


# Individual-level data ====
if (!file.exists("data/pilot_ind.RData")) {

  load("data/us.RData")

  pilot_ind <- us %>%
    select(pidp,
           sex, qual, eth, ten, car, age,
           llid) %>%
    arrange(pidp) %>%
    na.omit()

  save(pilot_ind, file = "data/pilot_ind.RData", compress = "xz")

}


# Prepare constraints ====
if (!file.exists("data/pilot_con.RData")) {

  # Age
  census_age <- readr::read_csv(
    paste0("https://www.nomisweb.co.uk/api/v01/",
           "dataset/NM_145_1.data.csv?date=latest&",
           "geography=1254133554...1254134501,",
           "1254264241...1254264270&rural_urban=",
           "0&cell=1...16&measures=20100")) %>%
    select(GEOGRAPHY_CODE, CELL_NAME, OBS_VALUE) %>%
    rename(code = GEOGRAPHY_CODE,
           age  = CELL_NAME,
           freq = OBS_VALUE) %>%
    filter(age != "Age 0 to 4") %>%  # remove <16 to match US
    filter(age != "Age 5 to 7") %>%
    filter(age != "Age 8 to 9") %>%
    filter(age != "Age 10 to 14") %>%
    filter(age != "Age 15") %>%
    spread(age, freq) %>%
    arrange(code)

  colnames(census_age) <- c("code", "age_16_17", "age_18_19", "age_20_24",
                            "age_25_29", "age_30_44", "age_45_59", "age_60_64",
                            "age_65_74", "age_75_84", "age_85_89",
                            "age_90_plus")

  rakeR::check_constraint(census_age, 978)


  # Car
  census_car <- readr::read_csv(
    paste0("https://www.nomisweb.co.uk/api/v01/dataset/",
           "NM_1065_1.data.csv?date=latest&geography=1254133554",
           "...1254134501,1254264241...1254264270&c_carsno=1...3&",
           "economic_activity=0&measures=20100")) %>%
    select(GEOGRAPHY_CODE, C_CARSNO_NAME, OBS_VALUE) %>%
    rename(code = GEOGRAPHY_CODE,
           cars = C_CARSNO_NAME,
           freq = OBS_VALUE) %>%
    spread(cars, freq) %>%
    arrange(code)

  colnames(census_car) <- c("code", "car_1", "car_2_plus", "car_0")

  stopifnot(
    all.equal(census_age$code, census_car$code)
  )

  # The number of respondents in car does not match age and they must
  #
  #   Find which zone(s) don't match
  #   Find the probabilities/distribution for these zones based on age
  #   Reassign the 'real' population based on these probabilities
  #   Probabilities will match, and correct number of people imputed

  # Get the total population based on the _age variable
  census_age <- census_age %>%
    arrange(code)
  census_car <- census_car %>%
    arrange(code)

  stopifnot(
    all(census_age$code == census_car$code)
  )

  original_length <- nrow(census_car)

  census_car$actual_pop  <- rowSums(census_age[, 2:ncol(census_age)])
  census_car$current_pop <- rowSums(census_car[, 2:ncol(census_car)])
  census_car$current_pop <- census_car$current_pop - census_car$actual_pop
  census_car$diff        <- census_car$actual_pop  - census_car$current_pop

  max_col <- (grep("actual_pop", colnames(census_car))) - 1

  change     <- census_car[census_car$diff != 0, ]
  census_car <- census_car[census_car$diff == 0, ]

  change[, 2:max_col] <- lapply(change[, 2:max_col], function(x) {

    round((x / change[["current_pop"]]) * change[["actual_pop"]])

  })

  change$current_pop <- rowSums(change[, 2:max_col])
  change$diff        <- change$actual_pop - change$current_pop

  census_car <- rbind(census_car, change[change$diff == 0, ])
  change     <- change[change$diff != 0, ]

  change_col <- which.max(lapply(change[change$diff > 0, 2:max_col], mean))

  # use change_col + 1 because change_col created without column 1 (zone)
  change[change$diff > 0, change_col + 1] <-
    change[change$diff > 0, change_col + 1] + 1
  change[change$diff < 0, change_col + 1] <-
    change[change$diff < 0, change_col + 1] - 1

  change$current_pop <- rowSums(change[, 2:max_col])
  change$diff        <- change$actual_pop - change$current_pop

  census_car <- rbind(census_car, change[change$diff == 0, ])

  stopifnot(
    all.equal(rowSums(census_car[, 2:4]), census_car$actual_pop),
    all.equal(nrow(census_car), original_length)
  )

  # Order doesn't match individual level data; re-order
  census_car <- census_car %>%
    select(code, car_0, car_1, car_2_plus) %>%
    arrange(code)

  stopifnot(
    all.equal(sum(census_car[, 2:ncol(census_car)]),
              sum(census_age[, 2:ncol(census_age)])  )
  )

  rakeR::check_constraint(census_car, 978)


  # Ethnicity
  census_eth <- readr::read_csv(
    paste0("https://www.nomisweb.co.uk/api/v01/",
           "dataset/NM_818_1.data.csv?date=latest&",
           "geography=1254133554...1254134501,",
           "1254264241...1254264270&c_age=0&",
           "c_ecopuk11=0&c_ethpuk11=2...8&measures=",
           "20100")) %>%
    select(GEOGRAPHY_CODE, C_ETHPUK11_NAME, OBS_VALUE) %>%
    rename(code         = GEOGRAPHY_CODE,
           ethnic_group = C_ETHPUK11_NAME,
           freq         = OBS_VALUE) %>%
    spread(ethnic_group, freq) %>%
    arrange(code)

  # Rename to match ind_eth names
  colnames(census_eth) <- c("code", "asian_asian_british",
                            "black_african_caribbean_british",
                            "mixed_multiple_ethnic", "other_ethnicity",
                            "british", "irish", "other_white")

  # reorder ethnicity vars to match us data
  census_eth <- select(census_eth, code, british, irish, other_white,
                       mixed_multiple_ethnic, asian_asian_british,
                       black_african_caribbean_british, other_ethnicity)

  stopifnot(
    all.equal(sum(census_eth[, 2:ncol(census_eth)]),
              sum(census_age[, 2:ncol(census_age)])  )
  )

  rakeR::check_constraint(census_eth, 978)


  # Highest qualification
  census_qual <- readr::read_csv(
    paste0("https://www.nomisweb.co.uk/api/v01/",
           "dataset/NM_554_1.data.csv?date=latest&geography=",
           "1254133554...1254134501,1254264241...1254264270&",
           "rural_urban=0&cell=1...7&measures=20100")) %>%
    select(GEOGRAPHY_CODE, CELL_NAME, OBS_VALUE) %>%
    rename(code = GEOGRAPHY_CODE,
           qual = CELL_NAME,
           freq = OBS_VALUE) %>%
    spread(qual, freq) %>%
    arrange(code)

  # Combine some qualifications to make compatible with survey
  # see notes in 0-prep-understanding-society.R
  colnames(census_qual) <- c("code", "apprenticeship", "level_1",
                             "level_2", "level_3", "level_4", "no_qual",
                             "other_qual")
  census_qual$level_2 <- census_qual$level_1 + census_qual$level_2
  census_qual$level_1 <- NULL

  census_qual$other_qual <- census_qual$other_qual + census_qual$apprenticeship
  census_qual$apprenticeship <- NULL

  colnames(census_qual) <- c("code", "qual_2", "qual_3", "qual_4_plus",
                             "qual_0", "qual_other")

  # reorder to match ind_hiq
  census_qual <- select(census_qual, code, qual_0, qual_2, qual_3, qual_4_plus,
                        qual_other)

  stopifnot(
    all.equal(sum(census_qual[, 2:ncol(census_qual)]),
              sum(census_age[, 2:ncol(census_age)])  )
  )

  rakeR::check_constraint(census_qual, 978)


  # Sex
  census_sex <- readr::read_csv(
    paste0("https://www.nomisweb.co.uk/api/v01/",
           "dataset/NM_1414_1.data.csv?date=latest&geography=",
           "1254133554...1254134501,1254264241...1254264270&c_sex=1,2&",
           "c_age=17...39&measures=20100&signature=NPK-0c73734c0f725c979cee3a:",
           "0x7e92136e4376f41731ee5d07a91447ff2668e0ac")) %>%
    select(GEOGRAPHY_CODE, C_SEX_NAME, C_AGE_NAME, OBS_VALUE) %>%
    rename(code = GEOGRAPHY_CODE,
           sex  = C_SEX_NAME,
           age  = C_AGE_NAME,
           freq = OBS_VALUE) %>%
    spread(age, freq) %>%
    arrange(code)

  census_sex$freq <- rowSums(census_sex[, 3:ncol(census_sex)])

  census_sex <- census_sex %>%
    select(code, sex, freq) %>%
    spread(sex, freq) %>%
    arrange(code)

  colnames(census_sex) <- c("code", "female", "male")
  census_sex <- census_sex[, c("code", "male", "female")]  # match us

  stopifnot(
    all.equal(sum(census_sex[, 2:ncol(census_sex)]),
              sum(census_age[, 2:ncol(census_age)])  )
  )

  rakeR::check_constraint(census_sex, 978)


  # Tenure
  census_ten <- readr::read_csv(paste0("https://www.nomisweb.co.uk/api/v01/",
                                       "dataset/NM_1404_1.data.csv?date=latest&geography=1254133554...1254134501,",
                                       "1254264241...1254264270&c_tenhuk11=2,3,5,6&c_age=1...4&c_health=0&",
                                       "measures=20100")) %>%
    select(GEOGRAPHY_CODE, C_TENHUK11_NAME, C_AGE_NAME, OBS_VALUE) %>%
    rename(code   = GEOGRAPHY_CODE,
           tenure = C_TENHUK11_NAME,
           age    = C_AGE_NAME,
           freq   = OBS_VALUE) %>%
    spread(tenure, freq) %>%
    filter(age != "Age 0 to 15") %>%
    select(-age) %>%
    rename(
      owned_outright          = `Owned: Owned outright`,
      owned_mortgage_shared   = `Owned: Owned with a mortgage or loan or shared ownership`,
      rented_private_rentfree = `Rented: Private rented or living rent free`,
      rented_social           = `Rented: Social rented`) %>%
    # Combine rented_private_rentfree + rented_social to match us
    mutate(rented = rented_private_rentfree + rented_social) %>%
    group_by(code) %>%
    select(-rented_private_rentfree, -rented_social) %>%
    summarise(owned_outright        = sum(owned_outright),
              owned_mortgage_shared = sum(owned_mortgage_shared),
              rented                = sum(rented)) %>%
    arrange(code)

  # Number of respondents in tenure does not match other vars (e.g. age).
  # Impute 'correct' numbers from proportion and age population.
  original_length <- nrow(census_ten)

  census_ten$actual_pop  <- rowSums(census_age[, 2:ncol(census_age)])
  census_ten$current_pop <- rowSums(census_ten[, 2:ncol(census_ten)])
  census_ten$current_pop <- census_ten$current_pop - census_ten$actual_pop
  census_ten$diff        <- census_ten$actual_pop  - census_ten$current_pop

  max_col <- (grep("actual_pop", colnames(census_ten))) - 1

  change     <- census_ten[census_ten$diff != 0, ]
  census_ten <- census_ten[census_ten$diff == 0, ]

  change[, 2:max_col] <- lapply(change[, 2:max_col], function(x) {

    round((x / change[["current_pop"]]) * change[["actual_pop"]])

  })

  change$current_pop <- rowSums(change[, 2:max_col])
  change$diff        <- change$actual_pop - change$current_pop

  census_ten <- rbind(census_ten, change[change$diff == 0, ])
  change     <- change[change$diff != 0, ]

  change_col <- which.max(lapply(change[change$diff > 0, 2:max_col], mean))

  # use change_col + 1 because change_col created without column 1 (zone)
  change[change$diff > 0, change_col + 1] <-
    change[change$diff > 0, change_col + 1] + 1
  change[change$diff < 0, change_col + 1] <-
    change[change$diff < 0, change_col + 1] - 1

  change$current_pop <- rowSums(change[, 2:max_col])
  change$diff        <- change$actual_pop - change$current_pop

  census_ten <- rbind(census_ten, change[change$diff == 0, ])

  stopifnot(
    all.equal(rowSums(census_ten[, 2:4]), census_ten$actual_pop),
    all.equal(nrow(census_ten), original_length)
  )

  # reorder to match ind_ten
  census_ten <- census_ten %>%
    select(code, owned_outright, owned_mortgage_shared, rented) %>%
    arrange(code)

  rakeR::check_constraint(census_ten, 978)


  # Create final constraint table
  stopifnot(
    census_age[["code"]] == census_car[["code"]],
    census_age[["code"]] == census_eth[["code"]],
    census_age[["code"]] == census_qual[["code"]],
    census_age[["code"]] == census_sex[["code"]],
    census_age[["code"]] == census_ten[["code"]]
  )

  pilot_con <- inner_join(census_age, census_car, by = "code") %>%
    inner_join(census_eth, by = "code") %>%
    inner_join(census_qual, by = "code") %>%
    inner_join(census_sex, by = "code") %>%
    inner_join(census_ten, by = "code") %>%
    arrange(code)

  stopifnot(
    all.equal(pilot_con$code, unique(pilot_con$code)),
    all.equal(sum(census_age[, 2:ncol(census_age)]),
              (sum(pilot_con[, 2:ncol(pilot_con)])) / 6)
    # 6 no. of constraints
  )

  pilot_con <- pilot_con %>%
    select(code,
           female, male,
           qual_0, qual_2, qual_3, qual_4_plus, qual_other,
           british, irish, other_white, mixed_multiple_ethnic,
           asian_asian_british, black_african_caribbean_british,
           other_ethnicity,
           owned_outright, owned_mortgage_shared, rented,
           car_0, car_1, car_2_plus,
           age_16_17, age_18_19, age_20_24, age_25_29, age_30_44, age_45_59,
           age_60_64, age_65_74, age_75_84, age_85_89, age_90_plus) %>%
    rename(
      sex_female                          = female,
      sex_male                            = male,
      eth_british                         = british,
      eth_irish                           = irish,
      eth_other_white                     = other_white,
      eth_mixed_multiple_ethnic           = mixed_multiple_ethnic,
      eth_asian_asian_british             = asian_asian_british,
      eth_black_african_caribbean_british = black_african_caribbean_british,
      eth_other_ethnicity                 = other_ethnicity,
      ten_owned_outright                  = owned_outright,
      ten_owned_mortgage_shared           = owned_mortgage_shared,
      ten_rented                          = rented)

  save(pilot_con, file = "data/pilot_con.RData", compress = "xz")

  rm(list = ls(pattern = "census_"),
     change, max_col, change_col,
     us)

}


# Weight OA! ====
# fractional weights
if (!file.exists("data/weights_oa.RData")) {

  # weights_oa is huge and can't be uploaded to github without LFS
  # still worth saving to cache it (added to gitignore and build ignore)

  load("data/pilot_con.RData")
  load("data/pilot_ind.RData")

  vars <- colnames(pilot_ind)[2:(ncol(pilot_ind) - 1)]
  weights_oa <- rakeR::weight(pilot_con, pilot_ind,
                              vars = vars, iterations = 15)
  weights_oa$rownames <- row.names(weights_oa)
  save(weights_oa, file = "data/weights_oa.RData", compress = "xz")

}

# extract weights
if (!file.exists("data/pilot_oa_ext.RData")) {

  load("data/weights_oa.RData")
  load("data/pilot_ind.RData")

  weights_oa <- as.data.frame(weights_oa)
  row.names(weights_oa) <- weights_oa$rownames
  weights_oa$rownames <- NULL

  pilot_oa_ext <- rakeR::extract(weights_oa, pilot_ind, "pidp")

  save(pilot_oa_ext, file = "data/pilot_oa_ext.RData", compress = "xz")

}

# integerise weights
if (!file.exists("data/pilot_oa_int.RData")) {

  # Have to use the raw weights so pilot_oa_ext is not suitable
  load("data/weights_oa.RData")
  weights_oa <- as.data.frame(weights_oa)
  row.names(weights_oa) <- weights_oa$rownames
  weights_oa$rownames <- NULL

  pilot_oa_int <- rakeR::integerise(weights_oa, pilot_ind)

  save(pilot_oa_int, file = "data/pilot_oa_int.RData", compress = "xz")

}


# LSOAs ====
if (!file.exists("data/pilot_con_lsoa.RData")) {

  load("data/pilot_con.RData")
  lup <- geolookup::oa_lsoa_msoa_lad

  pilot_con_lsoa <- dplyr::inner_join(pilot_con, lup[, 1:2],
                                      by = c("code" = "oa_cd"))

  stopifnot(
    nrow(pilot_con_lsoa) == 978
  )

  pilot_con_lsoa <- pilot_con_lsoa %>%
    select(-code) %>%
    group_by(lsoa_cd) %>%
    summarise_all(funs(sum)) %>%
    rename(code = lsoa_cd)

  stopifnot(
    all.equal(sum(pilot_con_lsoa[, grep("sex_", colnames(pilot_con_lsoa))]),
              sum(pilot_con[, grep("sex_", colnames(pilot_con))]))
  )

  save(pilot_con_lsoa, file = "data/pilot_con_lsoa.RData", compress = "xz")

}

if (!file.exists("data/weights_lsoa.RData")) {

  load("data/pilot_ind.RData")
  load("data/pilot_con_lsoa.RData")
  vars <- colnames(pilot_ind)[2:(ncol(pilot_ind) - 1)]

  weights_lsoa <- rakeR::weight(pilot_con_lsoa, pilot_ind,
                                vars = vars, iterations = 15)

  weights_lsoa$row_names  <- row.names(weights_lsoa)
  row.names(weights_lsoa) <- NULL

  save(weights_lsoa, file = "data/weights_lsoa.RData", compress = "xz")

}

if (!file.exists("data/pilot_lsoa_ext.RData")) {

  load("data/weights_lsoa.RData")
  load("data/pilot_ind.RData")
  weights_lsoa <- as.data.frame(weights_lsoa)

  row.names(weights_lsoa) <- weights_lsoa$row_names
  weights_lsoa$row_names  <- NULL

  pilot_lsoa_ext <- rakeR::extract(weights_lsoa, pilot_ind, "pidp")

  save(pilot_lsoa_ext, file = "data/pilot_lsoa_ext.RData", compress = "xz")

}


# MSOAs ====
if (!file.exists("data/pilot_con_msoa.RData")) {

  load("data/pilot_con.RData")
  lup <- geolookup::oa_lsoa_msoa_lad

  pilot_con_msoa <- dplyr::inner_join(pilot_con, lup[, c(1, 4)],
                                      by = c("code" = "oa_cd"))

  stopifnot(
    nrow(pilot_con_msoa) == 978
  )

  pilot_con_msoa <- pilot_con_msoa %>%
    select(-code) %>%
    group_by(msoa_cd) %>%
    summarise_all(funs(sum)) %>%
    rename(code = msoa_cd)

  stopifnot(
    all.equal(sum(pilot_con[, grep("sex_", colnames(pilot_con))]),
              sum(pilot_con_msoa[, grep("sex_", colnames(pilot_con_msoa))]))
  )

  save(pilot_con_msoa, file = "data/pilot_con_msoa.RData", compress = "xz")

}

if (!file.exists("data/weights_msoa.RData")) {

  load("data/pilot_con_msoa.RData")
  load("data/pilot_ind.RData")
  vars <- colnames(pilot_ind)[2:(ncol(pilot_ind) - 1)]

  weights_msoa <- rakeR::weight(pilot_con_msoa, pilot_ind,
                                vars = vars, iterations = 15)

  weights_msoa$row_names  <- row.names(weights_msoa)
  row.names(weights_msoa) <- NULL

  save(weights_msoa, file = "data/weights_msoa.RData", compress = "xz")

}

if (!file.exists("data/pilot_msoa_ext.RData")) {

  load("data/weights_msoa.RData")
  load("data/pilot_ind.RData")
  weights_msoa <- as.data.frame(weights_msoa)

  row.names(weights_msoa) <- weights_msoa$row_names
  weights_msoa$row_names  <- NULL

  pilot_msoa_ext <- rakeR::extract(weights_msoa, pilot_ind, "pidp")

  save(pilot_msoa_ext, file = "data/pilot_msoa_ext.RData", compress = "xz")

}
