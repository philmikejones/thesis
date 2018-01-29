# Resilience simulation


# Prepare constraints ====
# Can take constraints from pilot and append to these
if (!file.exists("data/res_con.RData")) {

  load("data/pilot_con.RData")
  res_con <- pilot_con
  rm(pilot_con)

  census_eca <- readr::read_csv(paste0(
    "https://www.nomisweb.co.uk/api/v01/dataset/NM_556_1.data.csv?",
    "date=latest&geography=1254133554...1254134501,1254264241...1254264270&",
    "rural_urban=0&cell=2...9,11...15&measures=20100&signature=",
    "NPK-0c73734c0f725c979cee3a:0x042ee1241e8eca07f483c9d5749ca344b852f65c"
  )) %>%
    select(GEOGRAPHY_CODE, CELL_NAME, OBS_VALUE) %>%
    spread(CELL_NAME, OBS_VALUE) %>%
    rename(
      code   = GEOGRAPHY_CODE,
      emp_ft = `Economically active: Employee: Full-time`,
      emp_pt = `Economically active: Employee: Part-time`,
      stu_ft = `Economically active: Full-time student`,
      self_withemp_ft = `Economically active: Self-employed with employees: Full-time`,
      self_withemp_pt = `Economically active: Self-employed with employees: Part-time`,
      self_woutemp_ft = `Economically active: Self-employed without employees: Full-time`,
      self_woutemp_pt = `Economically active: Self-employed without employees: Part-time`,
      unemp    = `Economically active: Unemployed`,
      lt_sick  = `Economically inactive: Long-term sick or disabled`,
      home_fam = `Economically inactive: Looking after home or family`,
      other    = `Economically inactive: Other`,
      retired  = `Economically inactive: Retired`,
      stu_inac = `Economically inactive: Student (including full-time students)`
    ) %>%
    left_join(res_con[, c("code", "age_75_84", "age_85_89", "age_90_plus")],
              by = "code") %>%
    mutate(retired = retired + age_75_84 + age_85_89 + age_90_plus) %>%
    select(-age_75_84, -age_85_89, -age_90_plus) %>%
    mutate(  # reaggreaget some variables to match survey
      emp      = emp_ft + emp_pt,
      self_emp = self_withemp_ft + self_withemp_pt +
        self_woutemp_ft + self_woutemp_pt,
      student  = stu_ft + stu_inac
    ) %>%
    select(
      -emp_ft, -emp_pt,
      -self_withemp_ft, -self_withemp_pt,
      -self_woutemp_ft, -self_woutemp_pt,
      -stu_inac) %>%
    rename(  # order alphabetically
      eca_student = student,
      eca_unemp   = unemp,
      eca_ltsick  = lt_sick,
      eca_homefam = home_fam,
      eca_other   = other,
      eca_retired = retired,
      eca_emp     = emp,
      eca_selfemp = self_emp
    ) %>%
    select(code, eca_emp, eca_homefam, eca_ltsick, eca_other, eca_retired,
           eca_selfemp, eca_student, eca_unemp)

  stopifnot(  # population matches
    all.equal(
      rowSums(census_eca[, 2:ncol(census_eca)]),
      rowSums(res_con[, c("sex_female", "sex_male")])
    )
  )

  res_con <- res_con %>%
    left_join(census_eca, by = "code")

  stopifnot(
    all.equal(
      rowSums(res_con[, grep("eca_", colnames(res_con))]),
      rowSums(res_con[, c("sex_female", "sex_male")])
    )
  )

  rm(census_eca)

  # Marital status
  census_mar <- readr::read_csv(
    paste0("https://www.nomisweb.co.uk/api/v01/dataset/NM_603_1.data.csv?",
           "date=latest&geography=1254133554...1254134501,1254264241...",
           "1254264270&rural_urban=0&cell=1...6&measures=20100&signature=",
           "NPK-0c73734c0f725c979cee3a:",
           "0x45b9815a6dbe25aef1c0352ed6ab6febaa3e1151")) %>%
    select(GEOGRAPHY_CODE, CELL_NAME, OBS_VALUE) %>%
    tidyr::spread(CELL_NAME, OBS_VALUE) %>%
    rename(
      "code"           = GEOGRAPHY_CODE,
      "mar_civil_part" = `In a registered same-sex civil partnership`,
      "mar_divorced"   = `Divorced or formerly in a same-sex civil partnership which is now legally dissolved`,
      "mar_married"    =  Married,
      "mar_separated"  = `Separated (but still legally married or still legally in a same-sex civil partnership)`,
      "mar_single"     = `Single (never married or never registered a same-sex civil partnership)`,
      "mar_widowed"    = `Widowed or surviving partner from a same-sex civil partnership`
    ) %>%
    select(
      code, mar_civil_part, mar_divorced, mar_married, mar_separated,
      mar_single, mar_widowed
    )

  res_con <- res_con %>%
    left_join(census_mar, by = "code")

  stopifnot(
    all.equal(nrow(census_mar), nrow(res_con)),
    all.equal(
      rowSums(res_con[, grep("sex_", colnames(res_con))]),
      rowSums(res_con[, grep("mar_", colnames(res_con))])
    )
  )
  rm(census_mar)

  # order constraints to match ind
  res_con <- res_con %>%
    select(code,
           grep("^car_", colnames(res_con)),
           grep("^ten_", colnames(res_con)),
           grep("^qual_", colnames(res_con)),
           grep("^mar_", colnames(res_con)),
           grep("^eca_", colnames(res_con)),
           grep("^sex_", colnames(res_con)),
           grep("^eth_", colnames(res_con)),
           grep("^age_", colnames(res_con))
    )

  save(res_con, file = "data/res_con.RData", compress = "xz")

}


# Prepare survey data ====
if (!file.exists("data/res_ind.RData")) {

  load("data/us.RData")

  # order for input in simulation based on chapter 6
  res_ind <- us %>%
    select(pidp,
           car, ten, qual, marital, econ_act, sex, eth, age,
           depress,
           nhood_coh, nhood_trust, nhood_belong,  # civic, social_coh ~17k NAs
           # sim_inc, sim_eth, >17.5k NAs
           # pol_eff, soc_isol, ~17.5k NAs
           fin_sit,  # save, 11k NAs
           ghq_conc, ghq_sleep, ghq_useful, ghq_decision, ghq_strain,
           ghq_diff, ghq_enjoy, ghq_face, ghq_unhappy, ghq_confid,
           ghq_worth, ghq_happy,
           soc_isol,
           # bf_dist, bf_often > 26k NAs
           # cigs 44.5k NAs,
           kids,
           hh_income, save,
           alcohol) %>%
    rename(mar = marital,
           eca = econ_act) %>%
    na.omit()

  save(res_ind, file = "data/res_ind.RData", compress = "xz")

}


# Weight ====
# Can't save raw weights to github because the file is > 100MB but still
# worth caching

# Set globals
iterations         <- 15

if (!file.exists("data/res_weights.RData")) {

  load("data/res_con.RData")
  load("data/res_ind.RData")

  # # Randomise cons order
  # set.seed(23)
  # res_ind <- res_ind[, c(1, sample(2:9, 8), 10:ncol(res_ind))]
  #
  # res_con_code <- res_con$code
  # res_con <- res_con[, c(grep("eca_",  colnames(res_con)),
  #                        grep("ten_",  colnames(res_con)),
  #                        grep("eth_",  colnames(res_con)),
  #                        grep("mar_",  colnames(res_con)),
  #                        grep("age_",  colnames(res_con)),
  #                        grep("sex_",  colnames(res_con)),
  #                        grep("qual_", colnames(res_con)),
  #                        grep("car_",  colnames(res_con)))]
  # res_con$code <- res_con_code
  # res_con <- res_con[, c(ncol(res_con), 1:(ncol(res_con) - 1))]
  # res_con <- res_con[, -26]  # mortgAGE_ is duplicated

  vars <- colnames(res_ind[, 2:9])

  res_weights <- rakeR::weight(res_con, res_ind,
                               vars = vars, iterations = iterations)
  save(res_weights, file = "data/res_weights.RData", compress = "xz")

}


# Extract ====
if (!file.exists("data/res_weights_ext.RData")) {

  load("data/res_weights.RData")
  load("data/res_ind.RData")

  # extract() doesn't work well with numeric columns because it creates a
  # unique column/variable for each unique level
  # remove income; this can be added back in for integerisation, which does
  # work with numeric variables
  res_ind <- res_ind %>%
    select(-hh_income)

  res_weights_ext <- rakeR::extract(res_weights, res_ind, id = "pidp")
  save(res_weights_ext, file = "data/res_weights_ext.RData", compress = "xz")

}


# Integerise ====
if (!file.exists("data/res_weights_int.RData")) {

  load("data/res_ind.RData")
  load("data/res_con.RData")
  vars <- colnames(res_ind[, 2:9])

  res_weights <- rakeR::weight(res_con, res_ind,
                               vars = vars, iterations = iterations)
  res_weights_int <- rakeR::integerise(res_weights, res_ind)
  save(res_weights_int, file = "data/res_weights_int.RData", compress = "xz")

}
