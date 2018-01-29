
##
##  Warning!
##  Requires ~8GB RAM to run the script
##

if (!dir.exists("inst/extdata/restricted_us")) {

  if (Sys.info()["sysname"] != "Linux") {
    warning("It looks like you're not using a Linux system\n
            I cannot automatically unzip and place the
            Understanding Society data files in the correct place.\n
            Manually copy the *.tab files in UKDA-6614-tab/tab
            to inst/extdata/restricted_us/\n
            You can also move the documentation to
            inst/doc/restricted_us [optional]")
  } else {
    dir.create("inst/extdata/restricted_us/", showWarnings = FALSE)

    # Looks like filename is unique; use 6614TAB_ to obtain the filename
    us_zip <- list.files("inst/extdata/", pattern = "6614TAB_",
                         full.names = TRUE)
    unzip(us_zip, exdir = "inst/extdata/restricted_us/")

    # Move documentation
    dir.create("inst/doc/restricted_us",
               recursive = TRUE, showWarnings = FALSE)
    system2("mv", args = c("inst/extdata/restricted_us/UKDA-6614-tab/mrdoc",
                           "inst/doc/restricted_us"))

    # Move data files
    system2("mv",
            args = c("inst/extdata/restricted_us/UKDA-6614-tab/tab/*.tab",
                     "inst/extdata/restricted_us/"))
    system2("rm", c("-rf", "inst/extdata/restricted_us/UKDA-6614-tab/tab/"))

    # Move README and file information
    system2("mv", c("inst/extdata/restricted_us/UKDA-6614-tab/*.*",
                    "inst/doc/restricted_us/"))
    system2("rm", c("-rf", "inst/extdata/restricted_us/UKDA-6614-tab/"))

  }
  rm(us_zip)

}


if (!file.exists("data/us.RData")) {

  # Prepare wave f ====
  usf <- readr::read_tsv("inst/extdata/restricted_us/f_indresp.tab",
                  na = c("-11", "-10", "-9", "-8", "-7", "-2", "-1")
                  # -11 only available for IEMB
                  # -10 not available for IEMB
                  # -9 missing
                  # -8 Inapplicable
                  # -7 Proxy
                  # -2 Refused
                  # -1 Don't know
  ) %>%
    select(pidp, f_hidp,   # id and household id
           f_hhorig,       # sample origin (i.e. BHPS)
           f_dvage,        # derived age
           f_sex,          # sex corrected
           f_racel,        # ethnic group
           f_hiqual_dv,    # highest qualification
           f_jbstat,       # current economic activity
           f_health,       # long-standing illness or disability
           f_scsf1,        # self-reported general health
           f_jbnssec_dv,   # NS-SEC/social class
           f_jbnssec8_dv,  # NS-SEC 8
           f_jbnssec5_dv,  # NS-SEC 5
           f_jbnssec3_dv,  # NS-SEC 3
           f_mlstat,       # marital status
           f_scopngbhe,    # willing to improve neighbourhood
           f_scopngbhg,    # similar to others in neighbourhood
           f_nbrcoh3,      # people in neighbourhood can be trusted
           f_scopngbha,    # belong to neighbourhood
           f_orga1,        # active in organisation
           f_orga2,        # active in organisation
           f_orga3,        # active in organisation
           f_orga4,        # active in organisation
           f_orga5,        # active in organisation
           f_orga6,        # active in organisation
           f_orga7,        # active in organisation
           f_orga8,        # active in organisation
           f_orga9,        # active in organisation
           f_orga10,       # active in organisation
           f_orga11,       # active in organisation
           f_orga12,       # active in organisation
           f_orga13,       # active in organisation
           f_orga14,       # active in organisation
           f_orga15,       # active in organisation
           f_orga16,       # active in organisation
           f_nbrcoh4,      # people in neighbourhood don't get along
           f_crdark,       # feel safe walking alone at night
           f_siminc,       # Prop friends with similar income
           f_simrace,      # Friends similar ethnicity
           f_poleff4,      # don't have say in what g'ment does
           f_finnow,       # subjective financial status
           f_closenum,     # number of close friends
           f_scghqa,       # GHQ: concentration
           f_scghqb,       # GHQ: loss of sleep
           f_scghqc,       # GHQ: playing a useful role
           f_scghqd,       # GHQ: capable of making decisions
           f_scghqe,       # GHQ: constantly under strain
           f_scghqf,       # GHQ: problem overcoming difficulties
           f_scghqg,       # GHQ: enjoy day-to-day activities
           f_scghqh,       # GHQ: ability to face problems
           f_scghqi,       # GHQ: unhappy or depressed
           f_scghqj,       # GHQ: losing confidence
           f_scghqk,       # GHQ: believe worthless
           f_scghql,       # GHQ: general happiness
           f_ncigs,        # Cigs smoked
           f_netlv_1,      # distance best friend lives
           f_netlv_2,      # distance best friend lives
           f_netlv_3,      # distance best friend lives
           f_netph_1,      # best friend often in touch
           f_netph_2,      # best friend often in touch
           f_netph_3,      # best friend often in touch
           f_save,         # saves money
                           # received core benefit:
           f_benbase1,     #   1 == income support
           f_benbase2,     #   2 == job-seekers allowance
                           # other benefit:
           f_othben5,      #   5 == working tax credit;
           f_othben8,      #   8 == housing benefit
           f_benctc,       # received child tax credit
           f_bendis2,      # disability benefits (ESA == 2)
           f_hubuys,       # who does food shopping? (for cohabiting couples)
           f_hcondno1,
           f_hcondno2,
           f_hcondno3,
           f_hcondno4,
           f_hcondno5,
           f_hcondno6,
           f_hcondno7,
           f_hcondno8,
           f_hcond17       # clinical depression
           # f_btype6,     # tax credits
           # f_disdif,     # Type of impairment or disability
           # f_hcondno1,   # Diagnosed health condition(s)
           # f_hcondno2, f_hcondno3, f_hcondno4, f_hcondno5, f_hcondno6,
           # f_hcondno7,
           # f_hcondns1,   # still has condition
           # f_hcondns2, f_hcondns3, f_hcondns4, f_hcondns5, f_hcondns6,
           # f_hcondns7,
           # f_scsf2a,     # health limits moderate activities
           # f_scsf2b,     # health limits several flights of stairs
           # f_scsf3a,     # health limits work (last 4 wks)
           # f_scsf3b,     # health limits kind of work (last 4 wks)
           # f_scsf4a,     # mental health accomp. less (last 4 wks)
           # f_scsf4b,     # mental health worked less carefully (last 4 wks)
           # f_scsf5,      # pain interfered w/ work (last 4 wks)
           # f_scsf6a,     # felt calm & peaceful (last 4 wks)
           # f_scsf6b,     # Had lots of energy (last 4 wks)
           # f_scsf6c,     # Felt downhearted/depressed (last 4 wks)
           # f_scsf7,      # health (p or m) interfered w/ social life (4 wks)
           # f_sclfsat1,     # Satisfaction with health
           # f_sclfsato,     # Satisfaction with life overall
    )

  # Prepare wave e ====
  use <- readr::read_tsv("inst/extdata/restricted_us/e_indresp.tab",
                         na = c("-11", "-10", "-9", "-8", "-7", "-2", "-1")) %>%
    select(pidp, e_hidp,   # id and household id
           e_hhorig,       # sample origin (i.e. BHPS)
           e_dvage,        # derived age
           e_sex,          # sex corrected
           e_racel,        # ethnic group
           e_hiqual_dv,    # highest qualification
           e_jbstat,       # current economic activity
           e_health,       # long-standing illness or disability
           e_scsf1,        # self-reported general health
           e_jbnssec_dv,   # NS-SEC/social class
           e_jbnssec8_dv,  # NS-SEC 8
           e_jbnssec5_dv,  # NS-SEC 5
           e_jbnssec3_dv,  # NS-SEC 3
           e_mlstat,       # marital status
           e_finnow,       # subjective financial status
           e_scghqa,       # GHQ: concentration
           e_scghqb,       # GHQ: loss of sleep
           e_scghqc,       # GHQ: playing a useful role
           e_scghqd,       # GHQ: capable of making decisions
           e_scghqe,       # GHQ: constantly under strain
           e_scghqf,       # GHQ: problem overcoming difficulties
           e_scghqg,       # GHQ: enjoy day-to-day activities
           e_scghqh,       # GHQ: ability to face problems
           e_scghqi,       # GHQ: unhappy or depressed
           e_scghqj,       # GHQ: losing confidence
           e_scghqk,       # GHQ: believe worthless
           e_scghql,       # GHQ: general happiness
           e_ncigs,        # cigs smoked per day
           e_benunemp1,    # job-seekers allowance
           e_btype2,       # income support
           e_btype3,       # sickness benefit, incl. ESA
           # I think there's an error in the coding of Universal Credit
           # it's labelled as e_btype10 but is in the wrong order
           e_btype6,       # tax credits
           e_hcondno1,
           e_hcondno2,
           e_hcondno3,
           e_hcondno4,
           e_hcondno5,
           e_hcondno6,
           e_hcondno7,
           e_hcond17       # clinical depression
    )


  # Prepare wave d ====
  usd <- readr::read_tsv("inst/extdata/restricted_us/d_indresp.tab",
                  na = c("-11", "-10", "-9", "-8", "-7", "-2", "-1")) %>%
    select(pidp, d_hidp,
           d_hhorig,
           d_dvage,
           d_sex,
           d_racel,
           d_hiqual_dv,
           d_jbstat,       # economic activity
           d_health,
           d_scsf1,
           d_jbnssec_dv,   # NS-SEC/social class
           d_jbnssec8_dv,  # NS-SEC 8
           d_jbnssec5_dv,  # NS-SEC 5
           d_jbnssec3_dv,  # NS-SEC 3
           d_mlstat,       # marital status
           d_finnow,       # subjective financial situation
           d_scghqa,       # GHQ: concentration
           d_scghqb,       # GHQ: loss of sleep
           d_scghqc,       # GHQ: playing a useful role
           d_scghqd,       # GHQ: capable of making decisions
           d_scghqe,       # GHQ: constantly under strain
           d_scghqf,       # GHQ: problem overcoming difficulties
           d_scghqg,       # GHQ: enjoy day-to-day activities
           d_scghqh,       # GHQ: ability to face problems
           d_scghqi,       # GHQ: unhappy or depressed
           d_scghqj,       # GHQ: losing confidence
           d_scghqk,       # GHQ: believe worthless
           d_scghql,       # GHQ: general happiness
           d_save,         # saves money
           d_benunemp1,    # job-seekers allowance
           d_btype2,       # income support
           d_btype3,       # sickness benefit, incl. ESA
           # I think there's an error in the coding of Universal Credit
           # it's labelled as e_btype10 but is in the wrong order
           d_btype6,       # tax credits
           d_hubuys,       # who does food shopping? (for cohabiting couples)
           d_hcondno1,
           d_hcondno2,
           d_hcondno3,
           d_hcondno4,
           d_hcondno5,
           d_hcondno6,
           d_hcondno7,
           d_hcondno8,
           d_hcondno9,
           d_hcondno10,
           d_hcond17     # clinical depression
    )


  # Prepare wave c ====
  usc <- readr::read_tsv("inst/extdata/restricted_us/c_indresp.tab",
                  na = c("-11", "-10", "-9", "-8", "-7", "-2", "-1")) %>%
    select(pidp, c_hidp,
           c_hhorig,
           c_dvage,
           c_sex,
           c_racel,
           c_hiqual_dv,
           c_jbstat,
           c_health,
           c_sf1,
           c_jbnssec_dv,   # NS-SEC/social class
           c_jbnssec8_dv,  # NS-SEC 8
           c_jbnssec5_dv,  # NS-SEC 5
           c_jbnssec3_dv,  # NS-SEC 3
           c_mlstat,       # marital status
           c_scopngbhe,    # willing improve neighbourhood
           c_scopngbhg,    # similar to others in neighbourhood
           c_scopngbha,    # belong neighbourhood
           c_nbrcoh3,      # people in neighbourhood can be trusted
           c_crdark,       # safe walking alone at night
           c_orga1,        # active in organisation
           c_orga2,        # active in organisation
           c_orga3,        # active in organisation
           c_orga4,        # active in organisation
           c_orga5,        # active in organisation
           c_orga6,        # active in organisation
           c_orga7,        # active in organisation
           c_orga8,        # active in organisation
           c_orga9,        # active in organisation
           c_orga10,       # active in organisation
           c_orga11,       # active in organisation
           c_orga12,       # active in organisation
           c_orga13,       # active in organisation
           c_orga14,       # active in organisation
           c_orga15,       # active in organisation
           c_orga16,       # active in organisation
           c_nbrcoh4,      # people in neighbourhood don't get along
           c_poleff4,      # don't have say in what g'ment does
           c_siminc,       # Prop. friends with similar income
           c_simrace,      # Prop. friends similar ethnicity
           c_finnow,       # subjective financial situation
           c_benunemp1,    # job-seekers allowance
           c_btype2,       # income support
           c_btype3,       # sickness benefit (inc. ESA)
           # I think there's an error in the coding of Universal Credit
           # it's labelled as e_btype10 but is in the wrong order
           c_btype6,       # tax credits
           c_closenum,     # Number of close friends
           c_scghqa,       # GHQ: concentration
           c_scghqb,       # GHQ: loss of sleep
           c_scghqc,       # GHQ: playing a useful role
           c_scghqd,       # GHQ: capable of making decisions
           c_scghqe,       # GHQ: constantly under strain
           c_scghqf,       # GHQ: problem overcoming difficulties
           c_scghqg,       # GHQ: enjoy day-to-day activities
           c_scghqh,       # GHQ: ability to face problems
           c_scghqi,       # GHQ: unhappy or depressed
           c_scghqj,       # GHQ: losing confidence
           c_scghqk,       # GHQ: believe worthless
           c_scghql,       # GHQ: general happiness
           c_netlv_1,      # distance best friend lives
           c_netlv_2,      # distance best friend lives
           c_netlv_3,      # distance best friend lives
           c_netph_1,      # best friend often in touch
           c_netph_2,      # best friend often in touch
           c_netph_3,      # best friend often in touch
           c_hcondno1,
           c_hcondno2,
           c_hcondno3,
           c_hcondno4,
           c_hcondno5,
           c_hcondno6,
           c_hcondno7,
           c_hcondno8,
           c_hcond17       # clinical depression
    )


  # Prepare wave b ====
  usb <- readr::read_tsv("inst/extdata/restricted_us/b_indresp.tab",
                  na = c("-11", "-10", "-9", "-8", "-7", "-2", "-1")) %>%
    select(pidp, b_hidp,
           b_hhorig,
           b_dvage,
           b_sex,
           b_racel,
           b_hiqual_dv,
           b_jbstat,
           b_health,
           b_sf1,
           b_jbnssec_dv,   # NS-SEC/social class
           b_jbnssec8_dv,  # NS-SEC 8
           b_jbnssec5_dv,  # NS-SEC 5
           b_jbnssec3_dv,  # NS-SEC 3
           b_mlstat,       # marital status
           b_finnow,       # subjective financial situation
           b_scghqa,       # GHQ: concentration
           b_scghqb,       # GHQ: loss of sleep
           b_scghqc,       # GHQ: playing a useful role
           b_scghqd,       # GHQ: capable of making decisions
           b_scghqe,       # GHQ: constantly under strain
           b_scghqf,       # GHQ: problem overcoming difficulties
           b_scghqg,       # GHQ: enjoy day-to-day activities
           b_scghqh,       # GHQ: ability to face problems
           b_scghqi,       # GHQ: unhappy or depressed
           b_scghqj,       # GHQ: losing confidence
           b_scghqk,       # GHQ: believe worthless
           b_scghql,       # GHQ: general happiness
           b_ncigs,        # cigs smoked per day
           b_save,         # saves money
           b_benunemp1,    # job-seekers allowance
           b_btype2,       # income support
           b_btype3,       # sickness benefit (inc. ESA)
           # I think there's an error in the coding of Universal Credit
           # it's labelled as e_btype10 but is in the wrong order
           b_btype6,       # tax credits
           b_hubuys,       # who does food shopping? (for cohabiting couples)
           b_hcondno1,
           b_hcondno2,
           b_hcondno3,
           b_hcondno4,
           b_hcondno5,
           b_hcondno6,
           b_hcondno7,
           b_hcondno8,
           b_hcondn17      # clinical depression
    )


  # Prepare wave a ====
  usa <- readr::read_tsv("inst/extdata/restricted_us/a_indresp.tab",
                  na = c("-11", "-10", "-9", "-8", "-7", "-2", "-1")) %>%
    select(pidp, a_hidp,
           a_hhorig,
           a_dvage,
           a_sex,
           a_racel,
           a_hiqual_dv,
           a_jbstat,
           a_health,
           a_sf1,
           a_jbnssec_dv,   # NS-SEC/social class
           a_jbnssec8_dv,  # NS-SEC 8
           a_jbnssec5_dv,  # NS-SEC 5
           a_jbnssec3_dv,  # NS-SEC 3
           a_mlstat,       # marital status
           a_scopngbhe,    # willing to improve neighbourhood
           a_scopngbhg,    # similar to others in neighbourhood
           a_scopngbha,    # belong to neighbourhood
           a_sctrust,      # trust in others (neighbourhood)
           a_finnow,       # subjective financial situation
           a_benunemp1,    # job-seekers allowance
           a_btype2,       # income support
           a_btype3,       # sickness benefit (inc. ESA)
           # I think there's an error in the coding of Universal Credit
           # it's labelled as e_btype10 but is in the wrong order
           a_btype6,       # tax credits
           a_scghqa,       # GHQ: concentration
           a_scghqb,       # GHQ: loss of sleep
           a_scghqc,       # GHQ: playing a useful role
           a_scghqd,       # GHQ: capable of making decisions
           a_scghqe,       # GHQ: constantly under strain
           a_scghqf,       # GHQ: problem overcoming difficulties
           a_scghqg,       # GHQ: enjoy day-to-day activities
           a_scghqh,       # GHQ: ability to face problems
           a_scghqi,       # GHQ: unhappy or depressed
           a_scghqj,       # GHQ: losing confidence
           a_scghqk,       # GHQ: believe worthless
           a_scghql,       # GHQ: general happiness
           a_hcond17       # clinical depression
    )


  # Merge waves ====
  us <- usf %>%
    full_join(use, by = "pidp") %>%
    full_join(usd, by = "pidp") %>%
    full_join(usc, by = "pidp") %>%
    full_join(usb, by = "pidp") %>%
    full_join(usa, by = "pidp")

  rm(usa, usb, usc, usd, use, usf)

  stopifnot(
    us$pidp == unique(us$pidp),
    !(any(us == -9, na.rm = TRUE))
  )


  # Prepare household responses ====
  hhf <- readr::read_tsv("inst/extdata/restricted_us/f_hhresp.tab",
                  na = c("-11", "-10", "-9", "-8", "-7", "-2", "-1")) %>%
    select(f_hidp,
           f_hsownd, f_tenure_dv,
           f_ncars,
           f_heatch,
           f_gor_dv,
           f_hsbeds,        # no. bedrooms
           f_hsrooms,       # no. other rooms
           f_hhsize,        # no. people currently in household
           f_nkids015,      # no. children 0-15 in hhold
           f_fihhmngrs_dv,  # gross hh income month before interview
           f_rent,          # last rental payment
           f_rentwc,        # weeks covered by last rent payment f_rent
           f_xpmg,          # last mortgage payment
           f_xphsdb,        # problems paying housing costs
           f_xpaltob_g3     # £ spent on alcohol
           )

  hhe <- readr::read_tsv("inst/extdata/restricted_us/e_hhresp.tab",
                  na = c("-11", "-10", "-9", "-8", "-7", "-2", "-1")) %>%
    select(e_hidp,
           e_hsownd, e_tenure_dv,
           e_ncars,
           e_heatch,
           e_gor_dv,
           e_hsbeds,        # no. bedrooms
           e_hsrooms,       # no. other rooms
           e_hhsize,        # no. people currently in household
           e_nkids_dv,      # no. children in hhold
           e_fihhmngrs_dv,  # gross hh income month before interview
           e_rent,          # last rent payment £
           e_rentwc,        # weeks covered by e_rent
           e_xpmg,          # last mortgage payment
           e_xphsdb,        # behind with rent/mortgage
           e_xpaltob_g3     # £ spent on alcohol
    )

  hhd <- readr::read_tsv("inst/extdata/restricted_us/d_hhresp.tab",
                  na = c("-11", "-10", "-9", "-8", "-7", "-2", "-1")) %>%
    select(d_hidp,
           d_hsownd, d_tenure_dv,
           d_ncars,
           d_heatch,
           d_gor_dv,
           d_hsbeds,
           d_hsrooms,
           d_hhsize,
           d_nkids015,
           d_fihhmngrs_dv,  # gross hh income month before interview
           d_rent,          # last rent payment £
           d_rentwc,        # weeks covered by d_rent
           d_xphsdb,        # problems paying for housing costs
           d_xpmg,        # last mortgage payment
           d_xpaltob_g3     # £ spent on alcohol
    )

  hhc <- readr::read_tsv("inst/extdata/restricted_us/c_hhresp.tab",
                  na = c("-11", "-10", "-9", "-8", "-7", "-2", "-1")) %>%
    select(c_hidp,
           c_hsownd, c_tenure_dv,
           c_ncars,
           c_heatch,
           c_gor_dv,
           c_hsbeds,
           c_hsrooms,
           c_hhsize,
           c_nkids015,      # no. children (<16) in hhold
           c_fihhmngrs_dv,  # gross hh income month before interview
           c_rent,          # last rent payment £
           c_rentwc,        # period covered c_rent
           c_xpmg,          # last mortgage payment
           c_xphsdb,        # behind with rent/mortgage
           c_xpaltob_g3     # £ spent on alcohol
    )

  hhb <- readr::read_tsv("inst/extdata/restricted_us/b_hhresp.tab",
                  na = c("-11", "-10", "-9", "-8", "-7", "-2", "-1")) %>%
    select(b_hidp,
           b_hsownd, b_tenure_dv,
           b_ncars,
           b_heatch,
           b_gor_dv,
           b_hsbeds,
           b_hsrooms,
           b_hhsize,
           b_nkids015,      # no. children in hhold (<16)
           b_fihhmngrs_dv,  # gross hh income month before interview
           b_xphsdb,        # problems paying housing costs
           b_xpmg,          # last mortgage payment
           b_rent,          # last rent payment £
           b_rentwc,        # weeks covered b_rent
           b_xpaltob_g3     # £ spent on alcohol
    )

  hha <- readr::read_tsv("inst/extdata/restricted_us/a_hhresp.tab",
                  na = c("-11", "-10", "-9", "-8", "-7", "-2", "-1")) %>%
    select(a_hidp,
           a_hsownd, a_tenure_dv,
           a_ncars,
           a_heatch,
           a_gor_dv,
           a_hsbeds,
           a_hsrooms,
           a_hhsize,
           a_numchild,      # no. children in hhold
           a_fihhmngrs_dv,  # gross hh income month before interview
           a_rent,          # last rent payment £
           a_rentwc,        # weeks covered last rent payment
           a_xpmg,          # last mortgage payment
           a_xphsdb,        # problems paying housing costs
           a_xpaltob_g3     # £ spent on alcohol
    )

  stopifnot(
    !(any(hhe == -9, na.rm = TRUE)),
    !(any(hhd == -9, na.rm = TRUE)),
    !(any(hhc == -9, na.rm = TRUE)),
    !(any(hhb == -9, na.rm = TRUE)),
    !(any(hha == -9, na.rm = TRUE))
  )


  # Merge household responses ====
  us <- us %>%
    left_join(hhf, by = "f_hidp") %>%
    left_join(hhe, by = "e_hidp") %>%
    left_join(hhd, by = "d_hidp") %>%
    left_join(hhc, by = "c_hidp") %>%
    left_join(hhb, by = "b_hidp") %>%
    left_join(hha, by = "a_hidp")

  rm(hhf, hhe, hhd, hhc, hhb, hha)


  # # Nurse health assessments ====
  #
  # nhac <- readr::read_tsv("inst/extdata/restricted_us_nha/c_indresp_ns.tab")
  #
  # nhac <- select(nhac, -c_waist3)  # All NA
  #
  # nhac[nhac == -9] <- NA  # missing
  # nhac[nhac == -8] <- NA  # Inapplicable
  # nhac[nhac == -7] <- NA  # Proxy
  # nhac[nhac == -2] <- NA  # Refused
  # nhac[nhac == -1] <- NA  # Don't know
  #
  # stopifnot(
  #   !(any(nhac == -9, na.rm = TRUE))
  # )
  #
  # nhab <- readr::read_tsv("inst/extdata/restricted_us_nha/b_indresp_ns.tab",
  #                  col_types = cols(
  #                    b_wtpc        = col_double()
  #                  )
  # )
  #
  # nhab[nhab == -9] <- NA  # missing
  # nhab[nhab == -8] <- NA  # Inapplicable
  # nhab[nhab == -7] <- NA  # Proxy
  # nhab[nhab == -2] <- NA  # Refused
  # nhab[nhab == -1] <- NA  # Don't know
  #
  # stopifnot(
  #   !(any(nhab == -9, na.rm = TRUE))
  # )
  #
  #
  # # Merge nurse health assessments ====
  #
  # us <- left_join(us, nhac, by = "pidp")
  # us <- left_join(us, nhab, by = "pidp")
  #
  # rm(nhac, nhab)


  # Test ====
  stopifnot(  # make sure variables from all waves are present
    any(grepl("a_", colnames(us))),
    any(grepl("b_", colnames(us))),
    any(grepl("c_", colnames(us))),
    any(grepl("d_", colnames(us))),
    any(grepl("e_", colnames(us))),
    any(grepl("f_", colnames(us))),
    any(grepl("hh", colnames(us)))
  )


  # Code region ====
  us$region <- NA
  us$region <- us$f_gor_dv
  us$region[is.na(us$region)] <- us$e_gor_dv[is.na(us$region)]
  us$region[is.na(us$region)] <- us$d_gor_dv[is.na(us$region)]
  us$region[is.na(us$region)] <- us$c_gor_dv[is.na(us$region)]
  us$region[is.na(us$region)] <- us$b_gor_dv[is.na(us$region)]
  us$region[is.na(us$region)] <- us$a_gor_dv[is.na(us$region)]

  us$region <- factor(us$region, levels = 1:12,
                      labels = c("NE", "NW", "YH", "EM", "WM", "EE",
                                 "LN", "SE", "SW", "WA", "SC", "NI"),
                      ordered = FALSE)

  us <- us %>%
    select(-f_gor_dv, -e_gor_dv, -d_gor_dv, -c_gor_dv, -b_gor_dv, -a_gor_dv)


  # Code respondent origin ====
  # Was going to remove BHPS sample members because of survey fatigue
  # us$origin <- NA
  # us$origin <- us$f_hhorig
  # us$origin[is.na(us$origin)] <- us$e_hhorig[is.na(us$origin)]
  # us$origin[is.na(us$origin)] <- us$d_hhorig[is.na(us$origin)]
  # us$origin[is.na(us$origin)] <- us$c_hhorig[is.na(us$origin)]
  # us$origin[is.na(us$origin)] <- us$b_hhorig[is.na(us$origin)]
  # us$origin[is.na(us$origin)] <- us$a_hhorig[is.na(us$origin)]

  # us <- us %>%
  #   filter(origin != 3) %>%
  #   filter(origin != 4) %>%
  #   filter(origin != 5) %>%
  #   filter(origin != 6)

  us <- us %>%
    select(-f_hhorig, -e_hhorig, -d_hhorig, -c_hhorig, -b_hhorig, -a_hhorig)


  # Recode age ====
  # cut us$c_dvage to match census
  us$age_full <- NA
  us$age_full <- us$f_dvage
  us$age_full[is.na(us$age_full)] <- us$e_dvage[is.na(us$age_full)] + 1
  us$age_full[is.na(us$age_full)] <- us$d_dvage[is.na(us$age_full)] + 2
  us$age_full[is.na(us$age_full)] <- us$c_dvage[is.na(us$age_full)] + 3
  us$age_full[is.na(us$age_full)] <- us$b_dvage[is.na(us$age_full)] + 4
  us$age_full[is.na(us$age_full)] <- us$a_dvage[is.na(us$age_full)] + 5
  us$age_full[is.na(us$age_full)] <- round(mean(us$age_full, na.rm = TRUE))

  us$age <- cut(us$age_full,
                breaks = c(min(us$age_full),
                           17, 19, 24, 29, 44, 59, 64, 74, 84, 89,
                           max(us$age_full)),
                include.lowest = TRUE,
                labels = c("age_16_17", "age_18_19", "age_20_24",
                           "age_25_29", "age_30_44", "age_45_59",
                           "age_60_64", "age_65_74", "age_75_84",
                           "age_85_89", "age_90_plus"))

  stopifnot(
    all(!is.na(us$age))
  )

  us <- us %>%
    select(-f_dvage, -e_dvage, -d_dvage, -c_dvage, -b_dvage, -a_dvage)


  # Recode sex ====
  us$sex <- NA
  us$sex <- us$f_sex
  us$sex[is.na(us$sex)] <- us$e_sex[is.na(us$sex)]
  us$sex[is.na(us$sex)] <- us$d_sex[is.na(us$sex)]
  us$sex[is.na(us$sex)] <- us$c_sex[is.na(us$sex)]
  us$sex[is.na(us$sex)] <- us$b_sex[is.na(us$sex)]
  us$sex[is.na(us$sex)] <- us$a_sex[is.na(us$sex)]

  us$sex <- factor(us$sex,
                   levels = 1:2,
                   labels = c("sex_male", "sex_female"))

  us$sex <- forcats::fct_relevel(us$sex, "sex_female", "sex_male")

  us <- us %>%
    select(-f_sex, -e_sex, -d_sex, -c_sex, -b_sex, -a_sex)


  # Recode ethnicity ====
  us$eth_full <- NA
  us$eth_full <- us$f_racel
  us$eth_full[is.na(us$eth_full)] <- us$e_racel[is.na(us$eth_full)]
  us$eth_full[is.na(us$eth_full)] <- us$d_racel[is.na(us$eth_full)]
  us$eth_full[is.na(us$eth_full)] <- us$c_racel[is.na(us$eth_full)]
  us$eth_full[is.na(us$eth_full)] <- us$b_racel[is.na(us$eth_full)]
  us$eth_full[is.na(us$eth_full)] <- us$a_racel[is.na(us$eth_full)]

  us$eth_full <- factor(us$eth_full, levels = c(1:17, 97),
                        labels = c("White British",
                                   "Irish",
                                   "Gypsy or Irish Traveller",
                                   "other White",
                                   "White and Black Caribbean",
                                   "White and Black African",
                                   "White and Asian",
                                   "other mixed",
                                   "Indian",
                                   "Pakistani",
                                   "Bangladeshi",
                                   "Chinese",
                                   "other Asian",
                                   "Caribbean",
                                   "African",
                                   "other black",
                                   "Arab",
                                   "other ethnic group"),
                        ordered = FALSE)

  us <- us %>%
    select(-f_racel, -e_racel, -d_racel, -c_racel, -b_racel, -a_racel)


  # Code ethnic minority group
  us$eth_minority <- NA
  us$eth_minority[us$eth_full == "White British"] <- FALSE
  us$eth_minority[us$eth_full != "White British"] <- TRUE


  # Code reduced ethnic groups
  # Reduced ethnic group classes - to match census aggregate files
  us$eth <- NA
  us$eth[us$eth_full == "White British"]             <- 1
  us$eth[us$eth_full == "Irish"]                     <- 2
  us$eth[us$eth_full == "Gypsy or Irish Traveller"]  <- 3
  us$eth[us$eth_full == "other White"]               <- 3
  us$eth[us$eth_full == "White and Black Caribbean"] <- 4
  us$eth[us$eth_full == "White and Black African"]   <- 4
  us$eth[us$eth_full == "White and Asian"]           <- 4
  us$eth[us$eth_full == "other mixed"]               <- 4
  us$eth[us$eth_full == "Indian"]                    <- 5
  us$eth[us$eth_full == "Pakistani"]                 <- 5
  us$eth[us$eth_full == "Bangladeshi"]               <- 5
  us$eth[us$eth_full == "Chinese"]                   <- 5
  us$eth[us$eth_full == "other Asian"]               <- 5
  us$eth[us$eth_full == "Caribbean"]                 <- 6
  us$eth[us$eth_full == "African"]                   <- 6
  us$eth[us$eth_full == "other black"]               <- 6
  us$eth[us$eth_full == "Arab"]                      <- 7
  us$eth[us$eth_full == "other ethnic group"]        <- 7
  us$eth <- factor(us$eth,
                   levels = 1:7,
                   labels = c("eth_british",
                              "eth_irish",
                              "eth_other_white",
                              "eth_mixed_multiple_ethnic",
                              "eth_asian_asian_british",
                              "eth_black_african_caribbean_british",
                              "eth_other_ethnicity"),
                   ordered = FALSE)


  # Recode education ====
  # Create most recent known hiqual
  us$tmp <- NA
  us$tmp <- us$f_hiqual_dv
  us$tmp[is.na(us$tmp)] <- us$e_hiqual_dv[is.na(us$tmp)]
  us$tmp[is.na(us$tmp)] <- us$d_hiqual_dv[is.na(us$tmp)]
  us$tmp[is.na(us$tmp)] <- us$c_hiqual_dv[is.na(us$tmp)]
  us$tmp[is.na(us$tmp)] <- us$b_hiqual_dv[is.na(us$tmp)]
  us$tmp[is.na(us$tmp)] <- us$a_hiqual_dv[is.na(us$tmp)]

  us$qual <- NA
  us$qual[us$tmp == 9] <- 0  # No qualification
  # GCSE A*-C Level 2; GCSE D-G Level 1. US not split, so all GCSEs L2
  us$qual[us$tmp == 4] <- 2  # L1 or L2: GCSE
  us$qual[us$tmp == 3] <- 3  # L3: AS/A Level
  us$qual[us$tmp == 2] <- 4  # L4: Degree or above
  us$qual[us$tmp == 1] <- 4  # L4: Degree or above
  us$qual[us$tmp == 5] <- 5  # other qualification

  us$qual <- factor(us$qual,
                    levels = c(0, 2:5),
                    labels = c("qual_0",
                               "qual_2",
                               "qual_3",
                               "qual_4_plus",
                               "qual_other"),
                    ordered = FALSE)

  us <- us %>%
    select(-tmp,
           -f_hiqual_dv, -e_hiqual_dv, -d_hiqual_dv, -c_hiqual_dv, -b_hiqual_dv,
           -a_hiqual_dv)


  # Recode car or van availability ====
  us$car <- NA
  us$car <- us$f_ncars
  us$car[is.na(us$car)] <- us$e_ncars[is.na(us$car)]
  us$car[is.na(us$car)] <- us$d_ncars[is.na(us$car)]
  us$car[is.na(us$car)] <- us$c_ncars[is.na(us$car)]
  us$car[is.na(us$car)] <- us$b_ncars[is.na(us$car)]
  us$car[is.na(us$car)] <- us$a_ncars[is.na(us$car)]

  us$car <- replace(us$car, us$car > 2 & !is.na(us$car), 2)
  us$car <- factor(us$car, levels = 0:2,
                   labels = c("car_0", "car_1", "car_2_plus"),
                   ordered = FALSE)

  us <- us %>%
    select(-f_ncars, -e_ncars, -d_ncars, -c_ncars, -b_ncars, -a_ncars)


  # Recode heat ====
  us$heat <- NA
  us$heat <- us$f_heatch
  us$heat[is.na(us$heat)] <- us$e_heatch[is.na(us$heat)]
  us$heat[is.na(us$heat)] <- us$d_heatch[is.na(us$heat)]
  us$heat[is.na(us$heat)] <- us$c_heatch[is.na(us$heat)]
  us$heat[is.na(us$heat)] <- us$b_heatch[is.na(us$heat)]
  us$heat[is.na(us$heat)] <- us$a_heatch[is.na(us$heat)]

  us$heat[us$heat == 2] <- 0

  us$heat <- factor(us$heat, levels = 0:1,
                    labels = c("heat_no", "heat_yes"),
                    ordered = FALSE)

  us <- us %>%
    select(-f_heatch, -e_heatch, -d_heatch, -c_heatch, -b_heatch, -a_heatch)


  # Recode tenure ====
  us$ten_full <- NA
  us$ten_full <- us$f_hsownd
  us$ten_full[is.na(us$ten_full)] <- us$e_hsownd[is.na(us$ten_full)]
  us$ten_full[is.na(us$ten_full)] <- us$d_hsownd[is.na(us$ten_full)]
  us$ten_full[is.na(us$ten_full)] <- us$c_hsownd[is.na(us$ten_full)]
  us$ten_full[is.na(us$ten_full)] <- us$b_hsownd[is.na(us$ten_full)]
  us$ten_full[is.na(us$ten_full)] <- us$a_hsownd[is.na(us$ten_full)]

  us$ten_full <- factor(us$ten_full, levels = c(1:5, 97),
                        labels = c("owned_outright",
                                   "owned_mortgage_loan",
                                   "shared_ownership",
                                   "rented",
                                   "living_rent_free",
                                   "other_tenure"),
                        ordered = FALSE)

  # Reduced categories of tenure to match census aggregates
  us$ten <- NA
  us$ten[us$ten_full == "owned_outright"]      <- 1
  us$ten[us$ten_full == "owned_mortgage_loan"] <- 2
  us$ten[us$ten_full == "shared_ownership"]    <- 2
  us$ten[us$ten_full == "rented"]              <- 3
  us$ten[us$ten_full == "living_rent_free"]    <- 3
  us$ten[us$ten_full == "other_tenure"]        <- NA

  us$ten <- factor(us$ten,
                   levels = 1:3,
                   labels = c("ten_owned_outright",
                              "ten_owned_mortgage_shared",
                              "ten_rented"),
                   ordered = FALSE)

  us <- us %>%
    select(-f_tenure_dv, -e_tenure_dv, -d_tenure_dv, -c_tenure_dv,
           -b_tenure_dv, -a_tenure_dv) %>%
    select(-f_hsownd, -e_hsownd, -d_hsownd, -c_hsownd, -b_hsownd, -a_hsownd)


  # Recode economic activity ====
  us$econ_act <- NA
  us$econ_act <- us$f_jbstat
  us$econ_act[is.na(us$econ_act)] <- us$e_jbstat[is.na(us$econ_act)]
  us$econ_act[is.na(us$econ_act)] <- us$d_jbstat[is.na(us$econ_act)]
  us$econ_act[is.na(us$econ_act)] <- us$c_jbstat[is.na(us$econ_act)]
  us$econ_act[is.na(us$econ_act)] <- us$b_jbstat[is.na(us$econ_act)]
  us$econ_act[is.na(us$econ_act)] <- us$a_jbstat[is.na(us$econ_act)]

  # levels checked as correct 2018-01-12
  us$econ_act <- factor(us$econ_act, levels = c(1:11, 97),
                        labels = c("self_emp",
                                   "emp",
                                   "unemp",
                                   "retired",
                                   "maternity",
                                   "home_fam",
                                   "stu_ft",
                                   "lt_sick",
                                   "gment_train",
                                   "unpaid_fam",
                                   "apprent",
                                   "other"))

  # Reaggregate some variables to match census
  us$econ_act <- us$econ_act %>%
    forcats::fct_collapse(home_fam = c("home_fam", "maternity"),
                          other    = c("other", "gment_train", "unpaid_fam",
                                       "apprent"))

  us$econ_act <- us$econ_act %>%
    forcats::fct_recode(
      eca_emp     = "emp",
      eca_homefam = "home_fam",
      eca_ltsick  = "lt_sick",
      eca_other   = "other",
      eca_retired = "retired",
      eca_selfemp = "self_emp",
      eca_student = "stu_ft",
      eca_unemp   = "unemp"
    ) %>%
    forcats::fct_relevel(  # order alphabetically for simulation
      "eca_emp", "eca_homefam", "eca_ltsick", "eca_other", "eca_retired",
      "eca_selfemp", "eca_student", "eca_unemp"
    )

  us <- us %>%
    select(-f_jbstat, -e_jbstat, -d_jbstat, -c_jbstat, -b_jbstat, -a_jbstat)


  # Overcrowding (> 1 persons per room) ====
  us$rooms <- NA
  # add bedrooms + other accommodation rooms
  us$rooms <- us$f_hsbeds + us$f_hsrooms

  # make sure bedrooms and other rooms are from the same wave, i.e. the
  # same property
  # e.g. e_hsrooms + d_hsbeds might be two different properties
  us$rooms[is.na(us$rooms)] <-
    us$e_hsbeds[is.na(us$rooms)] + us$e_hsrooms[is.na(us$rooms)]
  us$rooms[is.na(us$rooms)] <-
    us$d_hsbeds[is.na(us$rooms)] + us$d_hsrooms[is.na(us$rooms)]
  us$rooms[is.na(us$rooms)] <-
    us$c_hsbeds[is.na(us$rooms)] + us$c_hsrooms[is.na(us$rooms)]
  us$rooms[is.na(us$rooms)] <-
    us$b_hsbeds[is.na(us$rooms)] + us$b_hsrooms[is.na(us$rooms)]
  us$rooms[is.na(us$rooms)] <-
    us$a_hsbeds[is.na(us$rooms)] + us$a_hsrooms[is.na(us$rooms)]

  us$ppr <- NA
  us$ppr <- us$f_hhsize
  us$ppr[is.na(us$ppr)] <- us$e_hhsize[is.na(us$ppr)]
  us$ppr[is.na(us$ppr)] <- us$d_hhsize[is.na(us$ppr)]
  us$ppr[is.na(us$ppr)] <- us$c_hhsize[is.na(us$ppr)]
  us$ppr[is.na(us$ppr)] <- us$b_hhsize[is.na(us$ppr)]
  us$ppr[is.na(us$ppr)] <- us$a_hhsize[is.na(us$ppr)]

  us$ppr <- us$ppr / us$rooms

  us$ocrowd <- NA
  us$ocrowd[us$ppr >  1] <- 1
  us$ocrowd[us$ppr <= 1] <- 0

  us$ocrowd <- factor(us$ocrowd, levels = c(0, 1),
                      labels = c("ocrowd_no",
                                 "ocrowd_yes"),
                      ordered = FALSE)

  stopifnot(  # check ocrowd coded properly
    all.equal(nrow(filter(us, ppr > 1,  ocrowd == "ocrowd_no")),  0),
    all.equal(nrow(filter(us, ppr <= 1, ocrowd == "ocrowd_yes")), 0)
  )

  # hhsize needed for alcohol consumption
  us <- us %>%
    select(-rooms, -ppr) %>%
    select(-f_hsbeds, -e_hsbeds, -d_hsbeds, -c_hsbeds, -b_hsbeds, -a_hsbeds) %>%
    select(-f_hsrooms, -e_hsrooms, -d_hsrooms, -c_hsrooms, -b_hsrooms,
           -a_hsrooms)


  # Limiting long-term illness or disability ====
  us$llid <- NA
  us$llid <- us$f_health
  us$llid[is.na(us$llid)] <- us$e_health[is.na(us$llid)]
  us$llid[is.na(us$llid)] <- us$d_health[is.na(us$llid)]
  us$llid[is.na(us$llid)] <- us$c_health[is.na(us$llid)]
  us$llid[is.na(us$llid)] <- us$b_health[is.na(us$llid)]
  us$llid[is.na(us$llid)] <- us$a_health[is.na(us$llid)]

  us$llid <- replace(us$llid, us$llid == 2, 0)
  us$llid <- factor(us$llid, levels = 0:1,
                    labels = c("llid_no", "llid_yes"))

  us <- us %>%
    select(-f_health, -e_health, -d_health, -c_health, -b_health, -a_health)


  # Recode self-reported general health ====
  us$tmp <- NA
  us$tmp <- us$f_scsf1
  us$tmp[is.na(us$tmp)] <- us$e_scsf1[is.na(us$tmp)]
  us$tmp[is.na(us$tmp)] <- us$d_scsf1[is.na(us$tmp)]
  us$tmp[is.na(us$tmp)] <- us$c_sf1[is.na(us$tmp)]
  us$tmp[is.na(us$tmp)] <- us$b_sf1[is.na(us$tmp)]
  us$tmp[is.na(us$tmp)] <- us$a_sf1[is.na(us$tmp)]

  us$srgh <- NA
  us$srgh[us$tmp == 1] <- 5  # excellent
  us$srgh[us$tmp == 2] <- 4  # very good
  us$srgh[us$tmp == 3] <- 3  # good
  us$srgh[us$tmp == 4] <- 2  # fair
  us$srgh[us$tmp == 5] <- 1  # poor

  us$srgh <- factor(us$srgh, levels = 5:1,
                    labels = c("srgh_excellent",
                               "srgh_verygood",
                               "srgh_good",
                               "srgh_fair",
                               "srgh_poor"),
                    ordered = FALSE)

  us <- us %>%
    select(-f_scsf1, -e_scsf1, -d_scsf1, -c_sf1, -b_sf1, -a_sf1,
           -tmp)


  # Recode social class ====
  us$class8 <- NA
  us$class8 <- us$f_jbnssec8_dv
  us$class8[is.na(us$class8)] <- us$e_jbnssec8_dv[is.na(us$class8)]
  us$class8[is.na(us$class8)] <- us$d_jbnssec8_dv[is.na(us$class8)]
  us$class8[is.na(us$class8)] <- us$c_jbnssec8_dv[is.na(us$class8)]
  us$class8[is.na(us$class8)] <- us$b_jbnssec8_dv[is.na(us$class8)]
  us$class8[is.na(us$class8)] <- us$a_jbnssec8_dv[is.na(us$class8)]

  # Full NS-SEC, NS-SEC5 and NS-SEC3 have same number of NAs as NSSEC8
  # us$class <- NA
  # us$class <- us$f_jbnssec_dv
  # us$class[is.na(us$class)] <- us$e_jbnssec_dv[is.na(us$class)]
  # us$class[is.na(us$class)] <- us$d_jbnssec_dv[is.na(us$class)]
  # us$class[is.na(us$class)] <- us$c_jbnssec_dv[is.na(us$class)]
  # us$class[is.na(us$class)] <- us$b_jbnssec_dv[is.na(us$class)]
  # us$class[is.na(us$class)] <- us$a_jbnssec_dv[is.na(us$class)]
  #
  # us$class5 <- NA
  # us$class5 <- us$f_jbnssec5_dv
  # us$class5[is.na(us$class5)] <- us$e_jbnssec5_dv[is.na(us$class5)]
  # us$class5[is.na(us$class5)] <- us$d_jbnssec5_dv[is.na(us$class5)]
  # us$class5[is.na(us$class5)] <- us$c_jbnssec5_dv[is.na(us$class5)]
  # us$class5[is.na(us$class5)] <- us$b_jbnssec5_dv[is.na(us$class5)]
  # us$class5[is.na(us$class5)] <- us$a_jbnssec5_dv[is.na(us$class5)]
  #
  # us$class3 <- NA
  # us$class3 <- us$f_jbnssec3_dv
  # us$class3[is.na(us$class3)] <- us$e_jbnssec3_dv[is.na(us$class3)]
  # us$class3[is.na(us$class3)] <- us$d_jbnssec3_dv[is.na(us$class3)]
  # us$class3[is.na(us$class3)] <- us$c_jbnssec3_dv[is.na(us$class3)]
  # us$class3[is.na(us$class3)] <- us$b_jbnssec3_dv[is.na(us$class3)]
  # us$class3[is.na(us$class3)] <- us$a_jbnssec3_dv[is.na(us$class3)]

  us$class8 <- factor(us$class8, levels = 1:9,
                      labels = c("Large employers & higher management",
                      "Higher professional",
                      "Lower management & professional",
                      "Intermediate",
                      "Small employers & own account",
                      "Lower supervisory & technical",
                      "Semi-routine",
                      "Routine",
                      "Never worked & LT unemployed"),
           ordered = FALSE)

  us <- us %>%
    select(-f_jbnssec_dv, -f_jbnssec8_dv, -f_jbnssec5_dv, -f_jbnssec3_dv) %>%
    select(-e_jbnssec_dv, -e_jbnssec8_dv, -e_jbnssec5_dv, -e_jbnssec3_dv) %>%
    select(-d_jbnssec_dv, -d_jbnssec8_dv, -d_jbnssec5_dv, -d_jbnssec3_dv) %>%
    select(-c_jbnssec_dv, -c_jbnssec8_dv, -c_jbnssec5_dv, -c_jbnssec3_dv) %>%
    select(-b_jbnssec_dv, -b_jbnssec8_dv, -b_jbnssec5_dv, -b_jbnssec3_dv) %>%
    select(-a_jbnssec_dv, -a_jbnssec8_dv, -a_jbnssec5_dv, -a_jbnssec3_dv)


  # # Tax credits ====
  # us$taxcred <- NA
  # us$taxcred <- us$f_btype6
  # us$taxcred[is.na(us$taxcred)] <- us$e_btype6[is.na(us$taxcred)]
  # us$taxcred[is.na(us$taxcred)] <- us$d_btype6[is.na(us$taxcred)]
  # us$taxcred[is.na(us$taxcred)] <- us$c_btype6[is.na(us$taxcred)]
  # us$taxcred[is.na(us$taxcred)] <- us$b_btype6[is.na(us$taxcred)]
  # us$taxcred[is.na(us$taxcred)] <- us$a_btype6[is.na(us$taxcred)]


  # Marital status ====
  us$marital <- NA
  us$marital <- us$f_mlstat
  us$marital[is.na(us$marital)] <- us$e_mlstat[is.na(us$marital)]
  us$marital[is.na(us$marital)] <- us$d_mlstat[is.na(us$marital)]
  us$marital[is.na(us$marital)] <- us$c_mlstat[is.na(us$marital)]
  us$marital[is.na(us$marital)] <- us$b_mlstat[is.na(us$marital)]
  us$marital[is.na(us$marital)] <- us$a_mlstat[is.na(us$marital)]

  # checked these levels are correct 2018-01-18
  us$marital <- factor(us$marital, levels = 1:9,
                       labels = c("single",
                                  "married",
                                  "civil_part",
                                  "separated",
                                  "divorced",
                                  "widowed",
                                  "sep_civil_part",
                                  "former_civil_part",
                                  "surviving_civil_part")) %>%
    forcats::fct_collapse(
      separated = c("separated", "sep_civil_part"),
      divorced  = c("divorced", "former_civil_part"),
      widowed   = c("widowed", "surviving_civil_part")) %>%
    forcats::fct_recode(
      mar_civil_part = "civil_part",
      mar_divorced   = "divorced",
      mar_married    = "married",
      mar_separated  = "separated",
      mar_single     = "single",
      mar_widowed    = "widowed"
    ) %>%
    forcats::fct_relevel(  # make alphabetical for simulation
      "mar_civil_part", "mar_divorced", "mar_married", "mar_separated",
      "mar_single", "mar_widowed"
    )

  us <- us %>%
    select(-f_mlstat, -e_mlstat, -d_mlstat, -c_mlstat, -b_mlstat, -a_mlstat)


  # Couple ====
  # This is couple, married or not
  # In waves f_, d_ and b_ asked about domestic chores
  # if there's any answer (or they're married) they're part of a couple
  # I have to assume the remaining NAs are single
  us$couple <- NA
  us$couple[us$f_hubuys > 0 & !is.na(us$f_hubuys)] <- 1
  us$couple[is.na(us$couple) & us$marital == "mar_married"] <- 1
  us$couple[is.na(us$couple) & us$d_hubuys > 0 & !is.na(us$d_hubuys)] <- 1
  us$couple[is.na(us$couple) & us$b_hubuys > 0 & !is.na(us$b_hubuys)] <- 1

  us <- us %>%
    select(-f_hubuys, -d_hubuys, -b_hubuys)


  # Neighbourhood cohesion ====
  # Paper 13 neighbourhood cohesion:
  #   extent to which neighbours pull together to improve neighbourhood
  # No direct analogy but proxy:
  #   willing to improve neighbourhood, and
  #   similar to others in neighbourhood

  # Willing to improve neighbourhood
  us$imp_nhood <- NA
  us$imp_nhood <- us$f_scopngbhe
  us$imp_nhood[is.na(us$imp_nhood)] <- us$c_scopngbhe[is.na(us$imp_nhood)]
  us$imp_nhood[is.na(us$imp_nhood)] <- us$a_scopngbhe[is.na(us$imp_nhood)]

  # Similar to others in neighbourhood
  us$sim_nhood <- NA
  us$sim_nhood <- us$f_scopngbhg
  us$sim_nhood[is.na(us$sim_nhood)] <- us$c_scopngbhg[is.na(us$sim_nhood)]
  us$sim_nhood[is.na(us$sim_nhood)] <- us$a_scopngbhg[is.na(us$sim_nhood)]

  # dplyr::case_when() doesn't yet work inside mutate()
  # <= 2 == strongly agree + agree
  # >= 3 == Neither + disagree + strongly disagree
  us <- us %>%
    mutate(nhood_coh = if_else(imp_nhood <= 2 & sim_nhood <= 2,
                               "ncoh_yes", "ncoh_no"))

  stopifnot(
    # more agree + strongly agree than cohesive neighbourhoods
    nrow(us[us$imp_nhood <= 2 & !is.na(us$imp_nhood), ]) >
      nrow(us[us$nhood_coh == "ncoh_yes" & !is.na(us$nhood_coh), ]),

    nrow(us[us$sim_nhood <= 2 & !is.na(us$sim_nhood), ]) >
      nrow(us[us$nhood_coh == "ncoh_yes" & !is.na(us$nhood_coh), ])
  )

  us <- us %>%
    select(-imp_nhood, -sim_nhood,
           -f_scopngbhe, -c_scopngbhe, -a_scopngbhe,
           -f_scopngbhg, -c_scopngbhg, -a_scopngbhg)


  # Neighbourhood trust ====
  # Waves f and c are different to how wave a is coded
  # Wave f and c: strongly agree + agree == trust
  # wave a: most people can be trusted == trust
  us$nhood_trust <- NA
  us$nhood_trust <- if_else(us$f_nbrcoh3 <= 2, "trust_yes", "trust_no")
  us$nhood_trust[is.na(us$nhood_trust)] <-
    if_else(us$c_nbrcoh3[is.na(us$nhood_trust)] <= 2,
            "trust_yes",
            "trust_no")
  us$nhood_trust[is.na(us$nhood_trust)] <-
    if_else(us$a_sctrust[is.na(us$nhood_trust)] == 1,
            "trust_yes",
            "trust_no")

  us <- us %>%
    select(-f_nbrcoh3, -c_nbrcoh3, -a_sctrust)


  # Neighbourhood belonging ====
  us$nhood_belong <- NA
  us$nhood_belong <- us$f_scopngbha
  us$nhood_belong[is.na(us$nhood_belong)] <-
    us$c_scopngbha[is.na(us$nhood_belong)]
  us$nhood_belong[is.na(us$nhood_belong)] <-
    us$a_scopngbha[is.na(us$nhood_belong)]

  us$nhood_belong <- if_else(us$nhood_belong <= 2, "belong_yes", "belong_no")

  us <- us %>%
    select(-f_scopngbha, -c_scopngbha, -a_scopngbha)


  # Civic participation ====
  civic_vars <- colnames(us[, grep("f_orga", colnames(us))])
  civic_vars <- civic_vars[civic_vars != "f_orga96"]  # 'none of these'

  us$civic <- NA
  us$civic <- rowSums(us[, civic_vars])

  civic_vars <- colnames(us[, grep("c_orga", colnames(us))])
  civic_vars <- civic_vars[civic_vars != "c_orga96"]  # 'none of these'

  us$civic[is.na(us$civic)] <- rowSums(us[is.na(us$civic), civic_vars])
  us$civic <- if_else(us$civic >= 1, "civic_yes", "civic_no")

  us <- us %>%
    select(-f_orga1,  -f_orga2,  -f_orga3,  -f_orga4,  -f_orga5,  -f_orga6,
           -f_orga7,  -f_orga8,  -f_orga9,  -f_orga10, -f_orga11, -f_orga12,
           -f_orga13, -f_orga14, -f_orga15, -f_orga16,
           -c_orga1,  -c_orga2,  -c_orga3,  -c_orga4,  -c_orga5,  -c_orga6,
           -c_orga7,  -c_orga8,  -c_orga9,  -c_orga10, -c_orga11, -c_orga12,
           -c_orga13, -c_orga14, -c_orga15, -c_orga16)
  rm(civic_vars)


  # Social cohesion ====
  # People in this neighbourhood get along - paper 13
  # People in this neighbourhood DON'T get along - US
  # Reverse, so take strongly disagree + disagree
  us$social_coh <- NA
  us$social_coh <- us$f_nbrcoh4
  us$social_coh[is.na(us$social_coh)] <- us$c_nbrcoh4[is.na(us$social_coh)]
  us$social_coh <- if_else(us$social_coh >= 4, "scoh_yes", "scoh_no")

  us <- us %>%
    select(-f_nbrcoh4, -c_nbrcoh4)


  # Safe walking alone at night ====
  us$safe_alone <- NA
  us$safe_alone <- us$f_crdark
  us$safe_alone[is.na(us$safe_alone)] <- us$c_crdark[is.na(us$safe_alone)]

  # Recode to safe or unsafe
  # 1 = very safe
  us$safe_alone[us$safe_alone == 2] <- 1  # fairly safe

  us$safe_alone[us$safe_alone == 3] <- 2  # a bit unsafe
  us$safe_alone[us$safe_alone == 4] <- 2  # very unsafe
  us$safe_alone[us$safe_alone == 5] <- 2  # don't go out after dark

  us$safe_alone <- factor(us$safe_alone, levels = 1:2,
                          labels = c("safe_yes",
                                     "safe_no"))

  us <- us %>%
    select(-f_crdark, -c_crdark)


  # Similar income to friends ====
  # Paper 13 doesn't specify which levels map to 'hetergeneous' or homogeneous
  # friendship. Assume ~ <= 1/2 is hetero
  us$sim_inc <- NA
  us$sim_inc <- us$f_siminc
  us$sim_inc[is.na(us$sim_inc)] <- us$c_siminc[is.na(us$sim_inc)]

  us$sim_inc <- if_else(us$sim_inc >= 3, "siminc_het", "siminc_hom")

  us <- us %>%
    select(-f_siminc, -c_siminc)


  # Similiar ethnicity to friends ====
  # Paper 13 again doesn't specify which levels map to hetero/homo
  # Assume again ~ <= 1/2 hetero; >= 1/2 homo
  us$sim_eth <- NA
  us$sim_eth <- us$f_simrace
  us$sim_eth[is.na(us$sim_eth)] <- us$c_simrace[is.na(us$sim_eth)]

  us$sim_eth <- if_else(us$sim_eth >= 3, "simeth_het", "simeth_hom")

  us <- us %>%
    select(-f_simrace, -c_simrace)


  # Political efficacy ====
  # Don't have a say in what government does, reversed
  us$pol_eff <- NA
  us$pol_eff <- us$f_poleff4
  us$pol_eff[is.na(us$pol_eff)] <- us$c_poleff4[is.na(us$pol_eff)]

  us$pol_eff <- if_else(us$pol_eff >= 4, "poleff_yes", "poleff_no")

  us <- us %>%
    select(-f_poleff4, -c_poleff4)



  # Financial situation ====
  us$fin_sit <- NA
  us$fin_sit <- us$f_finnow
  us$fin_sit[is.na(us$fin_sit)] <- us$e_finnow[is.na(us$fin_sit)]
  us$fin_sit[is.na(us$fin_sit)] <- us$d_finnow[is.na(us$fin_sit)]
  us$fin_sit[is.na(us$fin_sit)] <- us$c_finnow[is.na(us$fin_sit)]
  us$fin_sit[is.na(us$fin_sit)] <- us$b_finnow[is.na(us$fin_sit)]
  us$fin_sit[is.na(us$fin_sit)] <- us$a_finnow[is.na(us$fin_sit)]

  us$fin_sit <- if_else(us$fin_sit <= 2, "fin_good", "fin_bad")

  us <- us %>%
    select(-f_finnow, -e_finnow, -d_finnow, -c_finnow, -b_finnow, -a_finnow)


  # Social isolation ====
  # >=1 close friend
  us$soc_isol <- NA
  us$soc_isol <- us$f_closenum
  us$soc_isol[is.na(us$soc_isol)] <- us$c_closenum[is.na(us$soc_isol)]

  us$soc_isol <- if_else(us$soc_isol > 0, "isol_no", "isol_yes")

  us <- us %>%
    select(-f_closenum, -c_closenum)


  # Income ====
  # I've tested:
  #   - total earnings annually (x_prearna)
  #   - total earnings weekly (x_prearnw)
  #   - total personal income annually (x_prfitba)
  #   - total personal income weekly (x_prfitw)
  #
  #    All (even when combined) have low response rates and ~ 77k missing cases


  # General Health Questionnaire (GHQ) ====
  recode_ghq <- function(varname) {
    x <- NA
    x <- us[[paste0("f_", varname)]]
    x[is.na(x)] <- us[[paste0("f_", varname)]][is.na(x)]
    x[is.na(x)] <- us[[paste0("e_", varname)]][is.na(x)]
    x[is.na(x)] <- us[[paste0("d_", varname)]][is.na(x)]
    x[is.na(x)] <- us[[paste0("c_", varname)]][is.na(x)]
    x[is.na(x)] <- us[[paste0("b_", varname)]][is.na(x)]
    x[is.na(x)] <- us[[paste0("a_", varname)]][is.na(x)]

    x
  }

  us$ghq_conc     <- recode_ghq("scghqa")
  us$ghq_sleep    <- recode_ghq("scghqb")
  us$ghq_useful   <- recode_ghq("scghqc")
  us$ghq_decision <- recode_ghq("scghqd")
  us$ghq_strain   <- recode_ghq("scghqe")
  us$ghq_diff     <- recode_ghq("scghqf")
  us$ghq_enjoy    <- recode_ghq("scghqg")
  us$ghq_face     <- recode_ghq("scghqh")
  us$ghq_unhappy  <- recode_ghq("scghqi")
  us$ghq_confid   <- recode_ghq("scghqj")
  us$ghq_worth    <- recode_ghq("scghqk")
  us$ghq_happy    <- recode_ghq("scghql")

  us$ghq_conc     <- if_else(us$ghq_conc <= 2,
                             "ghq_conc_good", "ghq_conc_bad")

  us$ghq_sleep    <- if_else(us$ghq_sleep <= 2,
                             "ghq_sleep_good", "ghq_sleep_bad")

  us$ghq_useful   <- if_else(us$ghq_useful <= 2,
                             "ghq_useful_good", "ghq_useful_bad")

  us$ghq_decision <- if_else(us$ghq_decision <= 2,
                             "ghq_decision_good", "ghq_decision_bad")

  us$ghq_strain   <- if_else(us$ghq_strain <= 2,
                             "ghq_strain_good", "ghq_strain_bad")

  us$ghq_diff     <- if_else(us$ghq_diff <= 2,
                             "ghq_diff_good", "ghq_diff_bad")

  us$ghq_enjoy    <- if_else(us$ghq_enjoy <= 2,
                             "ghq_enjoy_good", "ghq_enjoy_bad")

  us$ghq_face     <- if_else(us$ghq_face <= 2,
                             "ghq_face_good", "ghq_face_bad")

  us$ghq_unhappy  <- if_else(us$ghq_unhappy <= 2,
                             "ghq_unhappy_good", "ghq_unhappy_bad")

  us$ghq_confid   <- if_else(us$ghq_confid <= 2,
                             "ghq_confid_good", "ghq_confid_bad")

  us$ghq_worth    <- if_else(us$ghq_worth <= 2,
                             "ghq_worth_good", "ghq_worth_bad")

  us$ghq_happy    <- if_else(us$ghq_happy <= 2,
                             "ghq_happy_good", "ghq_happy_bad")

  us <- us %>%
    select(-f_scghqa, -e_scghqa, -d_scghqa, -c_scghqa, -b_scghqa, -a_scghqa,
           -f_scghqb, -e_scghqb, -d_scghqb, -c_scghqb, -b_scghqb, -a_scghqb,
           -f_scghqc, -e_scghqc, -d_scghqc, -c_scghqc, -b_scghqc, -a_scghqc,
           -f_scghqd, -e_scghqd, -d_scghqd, -c_scghqd, -b_scghqd, -a_scghqd,
           -f_scghqe, -e_scghqe, -d_scghqe, -c_scghqe, -b_scghqe, -a_scghqe,
           -f_scghqf, -e_scghqf, -d_scghqf, -c_scghqf, -b_scghqf, -a_scghqf,
           -f_scghqg, -e_scghqg, -d_scghqg, -c_scghqg, -b_scghqg, -a_scghqg,
           -f_scghqh, -e_scghqh, -d_scghqh, -c_scghqh, -b_scghqh, -a_scghqh,
           -f_scghqi, -e_scghqi, -d_scghqi, -c_scghqi, -b_scghqi, -a_scghqi,
           -f_scghqj, -e_scghqj, -d_scghqj, -c_scghqj, -b_scghqj, -a_scghqj,
           -f_scghqk, -e_scghqk, -d_scghqk, -c_scghqk, -b_scghqk, -a_scghqk,
           -f_scghql, -e_scghql, -d_scghql, -c_scghql, -b_scghql, -a_scghql)
  rm(recode_ghq)


  # Cigarettes smoked ====
  us$cig <- NA
  us$cig <- us$f_ncigs
  us$cig[is.na(us$cig)] <- us$e_ncigs[is.na(us$cig)]
  us$cig[is.na(us$cig)] <- us$b_ncigs[is.na(us$cig)]

  us$cig <- if_else(us$cig > 0, "cig_yes", "cig_no")

  us <- us %>%
    select(-f_ncigs, -e_ncigs, -b_ncigs)


  # Alcohol ====
  # units = (volume (ml) * ABV) / 1000
  # 1 pint = 568.261ml (Google)
  # Source of alcohol costs: institute alcohol studies
  # http://www.ias.org.uk/uploads/pdf/Factsheets/Alcohol%20pricing%20factsheet%20April%202014.pdf
  # All dates 2012 data
  #
  # ABV from NHS.uk/livewell/alcohol/pages/alcohol-units.aspx and IAS
  #
  # Beer:    £2.70  pint 3.6% abv
  # Lager:   £2.96  pint 5.2% abv
  # Cider:   £1.82  pint 5.3% abv
  # Sherry:  £6.55  70cl 17.5% abv
  # Wine:    £4.04  75cl 12% abv
  # Whiskey: £15.35 70cl 40% abv
  # Vodka:   £13.86 70cl 37.5% abv

  units <- data.frame(
    beer    = c(2.7,   3.6,  568),
    lager   = c(2.96,  5.2,  568),
    cider   = c(1.82,  5.3,  568),
    sherry  = c(6.55,  17.5, 700),
    wine    = c(4.04,  12.0, 750),
    whiskey = c(15.35, 40.0, 700),
    vodka   = c(13.86, 37.5, 700)
  )
  units <- as.data.frame(t(units))
  colnames(units) <- c("cost", "abv", "ml")

  units$units     <- (units$ml * units$abv) / 1000
  # source: http://www.nhs.uk/Livewell/alcohol/Pages/alcohol-units.aspx

  units$unit_cost <- units$units / units$cost
  units$unit_cost <- round(units$unit_cost, digits = 2)
  unit_cost <- median(units$unit_cost)

  us <- us %>%
    mutate(f_alc = (f_xpaltob_g3 / (f_hhsize - f_nkids015)) / unit_cost / 4,
           e_alc = (e_xpaltob_g3 / (e_hhsize - e_nkids_dv)) / unit_cost / 4,
           d_alc = (d_xpaltob_g3 / (d_hhsize - d_nkids015)) / unit_cost / 4,
           c_alc = (c_xpaltob_g3 / (c_hhsize - c_nkids015)) / unit_cost / 4,
           b_alc = (b_xpaltob_g3 / (b_hhsize - b_nkids015)) / unit_cost / 4,
           a_alc = (a_xpaltob_g3 / (a_hhsize - a_numchild)) / unit_cost / 4)

  us$alcohol <- NA
  us$alcohol <- us$f_alc
  us$alcohol[is.na(us$alcohol)] <- us$e_alc[is.na(us$alcohol)]
  us$alcohol[is.na(us$alcohol)] <- us$d_alc[is.na(us$alcohol)]
  us$alcohol[is.na(us$alcohol)] <- us$c_alc[is.na(us$alcohol)]
  us$alcohol[is.na(us$alcohol)] <- us$b_alc[is.na(us$alcohol)]
  us$alcohol[is.na(us$alcohol)] <- us$a_alc[is.na(us$alcohol)]

  # Low/high risk thresholds
  # cmo2016a, p. 4
  us$alcohol <- if_else(us$alcohol <= 14, "alcohol_low", "alcohol_high")

  us <- us %>%
    select(-f_xpaltob_g3, -e_xpaltob_g3, -d_xpaltob_g3,
           -c_xpaltob_g3, -b_xpaltob_g3, -a_xpaltob_g3,
           -f_alc, -e_alc, -d_alc, -c_alc, -b_alc, -a_alc)
  rm(units, unit_cost)


  # Best friend distance ====
  us <- us %>%
    rowwise() %>%
    mutate(f_bfdist = min(f_netlv_1, f_netlv_2, f_netlv_3),
           c_bfdist = min(c_netlv_1, c_netlv_2, c_netlv_3))

  us$bf_dist <- NA
  us$bf_dist <- us$f_bfdist
  us$bf_dist[is.na(us$bf_dist)] <- us$f_bfdist[is.na(us$bf_dist)]

  # Paper: < 5 mins. Use < 1 mile as proxy
  us$bf_dist <- if_else(us$bf_dist > 1, "bfdist_far", "bfdist_near")

  us <- us %>%
    select(-f_bfdist, -c_bfdist,
           -f_netlv_1, -f_netlv_2, -f_netlv_3,
           -c_netlv_1, -c_netlv_2, -c_netlv_3)


  # Best friend often in touch ====
  # Paper: frequent contact == at least weekly
  us <- us %>%
    rowwise() %>%
    mutate(f_bfoften = min(f_netph_1, f_netph_2, f_netph_3),
           c_bfoften = min(c_netph_1, c_netph_2, c_netph_3))

  us$bf_often <- NA
  us$bf_often <- us$f_bfoften
  us$bf_often[is.na(us$bf_often)] <- us$c_bfoften[is.na(us$bf_often)]

  us$bf_often <- if_else(us$bf_often > 1, "bfoften_not", "bfoften_often")

  us <- us %>%
    select(-f_bfoften, -c_bfoften,
           -f_netph_1, -f_netph_2, -f_netph_3,
           -c_netph_1, -c_netph_2, -c_netph_3)


  # Savings ====
  # Budgeting/money management skills
  # Too many NAs save_reg
  us$save <- NA
  us$save <- us$f_save
  us$save[is.na(us$save)] <- us$d_save[is.na(us$save)]
  us$save[is.na(us$save)] <- us$b_save[is.na(us$save)]
  us$save <- if_else(us$save == 1, "save_yes", "save_no")

  us <- us %>%
    select(-f_save, -d_save, -b_save)


  # Number of children ====
  us$nkids <- NA
  us$nkids <- us$f_nkids015
  us$nkids[is.na(us$nkids)] <- us$e_nkids_dv[is.na(us$nkids)]
  us$nkids[is.na(us$nkids)] <- us$d_nkids015[is.na(us$nkids)]
  us$nkids[is.na(us$nkids)] <- us$c_nkids015[is.na(us$nkids)]
  us$nkids[is.na(us$nkids)] <- us$b_nkids015[is.na(us$nkids)]
  us$nkids[is.na(us$nkids)] <- us$a_numchild[is.na(us$nkids)]

  us <- us %>%
    select(-f_nkids015, -e_nkids_dv, -d_nkids015, -c_nkids015, -b_nkids015,
           -a_numchild)

  # Can't use numeric data with rakeR::extract() easily because it creates a
  # new variable for each level of the variable (i.e. one for each unique
  # integer)
  # Recode and top-code to 5 kids
  us$kids <- cut(us$nkids,
                 breaks = c(0, 1, 2, 3, 4, 5, max(us$nkids, na.rm = TRUE)),
                 labels = c("kids_0", "kids_1", "kids_2", "kids_3", "kids_4",
                            "kids_5ormore"),
                 right = FALSE, include.lowest = TRUE)

  # Household income and poverty ====
  # Many measures of poverty based on household income (i.e. children do not
  # earn but are not in poverty if earning adults aren't)

  # US provides monthly hh income. Convert to annual.
  # Poverty defined as <60% median income
  # Median income in 2011 was £23,200 (source: ons2013c, p. 5)
  us$hh_income <- us$f_fihhmngrs_dv
  us$hh_income[is.na(us$hh_income)] <- us$e_fihhmngrs_dv[is.na(us$hh_income)]
  us$hh_income[is.na(us$hh_income)] <- us$d_fihhmngrs_dv[is.na(us$hh_income)]
  us$hh_income[is.na(us$hh_income)] <- us$c_fihhmngrs_dv[is.na(us$hh_income)]
  us$hh_income[is.na(us$hh_income)] <- us$b_fihhmngrs_dv[is.na(us$hh_income)]
  us$hh_income[is.na(us$hh_income)] <- us$a_fihhmngrs_dv[is.na(us$hh_income)]

  # Set negative values to 0
  us$hh_income[us$hh_income < 0] <- 0L

  us <- us %>%
    select(-f_fihhmngrs_dv, -e_fihhmngrs_dv, -d_fihhmngrs_dv, -c_fihhmngrs_dv,
           -b_fihhmngrs_dv, -a_fihhmngrs_dv)



  # Number of cohabitants ====
  us$cohab <- NA
  us$cohab <- us$f_hhsize
  us$cohab[is.na(us$cohab)] <- us$e_hhsize[is.na(us$cohab)]
  us$cohab[is.na(us$cohab)] <- us$d_hhsize[is.na(us$cohab)]
  us$cohab[is.na(us$cohab)] <- us$c_hhsize[is.na(us$cohab)]
  us$cohab[is.na(us$cohab)] <- us$b_hhsize[is.na(us$cohab)]
  us$cohab[is.na(us$cohab)] <- us$a_hhsize[is.na(us$cohab)]

  us$cohab <- us$cohab - 1  # remove the respondent!

  us <- us %>%
    select(-f_hhsize, -e_hhsize, -d_hhsize, -c_hhsize, -b_hhsize, -a_hhsize)


  # Clinical depression ====
  us$depress <- NA_integer_

  hconds <- colnames(us)[grepl("_hcond", colnames(us))]
  for (i in hconds) {
    us[[i]] <- as.integer(us[[i]])
    us$depress[is.na(us$depress) & us[[i]] == 17 & !is.na(us[[i]])] <- 1
  }
  rm(i)

  us$depress[is.na(us$depress)] <- us$f_hcond17[is.na(us$depress)]
  us$depress[is.na(us$depress)] <- us$e_hcond17[is.na(us$depress)]
  us$depress[is.na(us$depress)] <- us$d_hcond17[is.na(us$depress)]
  us$depress[is.na(us$depress)] <- us$c_hcond17[is.na(us$depress)]
  us$depress[is.na(us$depress)] <- us$b_hcondn17[is.na(us$depress)]
  us$depress[is.na(us$depress)] <- us$a_hcond17[is.na(us$depress)]

  us$depress <- factor(us$depress, levels = 0:1,
                       labels = c("depress_no", "depress_yes"),
                       ordered = FALSE)


  # IHD and stroke ====
  # Air pollution is associated with IHD and stroke (among others)
  # This ihd measure therefore includes IND and stroke
  # IHD includes angina and myocardial infarction (MI)
  us$ihd <- NA_integer_
  for (i in hconds) {
    us[[i]] <- as.integer(us[[i]])
    us$ihd[is.na(us$ihd) & !is.na(us[[i]]) &
             us[[i]] == 4 |  # coronary heart disease
             us[[i]] == 5 |  # angina
             us[[i]] == 6 |  # myocardial infarction
             us[[i]] == 7] <- 1   # stroke
  }
  us$ihd[is.na(us$ihd)] <- 0

  us$ihd <- factor(us$ihd, levels = 0:1,
                   labels = c("ihd_no", "ihd_yes"))

  us <- us %>%
    select(-f_hcond17, -e_hcond17, -d_hcond17, -c_hcond17, -b_hcondn17,
           -a_hcond17)

  us <- us %>%
    select(-f_hcondno1:-f_hcondno8) %>%
    select(-e_hcondno1:-e_hcondno7) %>%
    select(-d_hcondno1:-d_hcondno10) %>%
    select(-c_hcondno1:-c_hcondno8) %>%
    select(-b_hcondno1:-b_hcondno8)


  # Problems paying housing costs ====
  us$prob_pay <- us$f_xphsdb
  us$prob_pay[is.na(us$prob_pay)] <- us$e_xphsdb[is.na(us$prob_pay)]
  us$prob_pay[is.na(us$prob_pay)] <- us$d_xphsdb[is.na(us$prob_pay)]
  us$prob_pay[is.na(us$prob_pay)] <- us$c_xphsdb[is.na(us$prob_pay)]
  us$prob_pay[is.na(us$prob_pay)] <- us$b_xphsdb[is.na(us$prob_pay)]
  us$prob_pay[is.na(us$prob_pay)] <- us$a_xphsdb[is.na(us$prob_pay)]

  us <- us %>%
    select(-f_xphsdb, -e_xphsdb, -d_xphsdb, -c_xphsdb, -b_xphsdb, -a_xphsdb)

  us$prob_pay <- factor(us$prob_pay, levels = 1:2,
                        labels = c("prob_pay_yes", "prob_pay_no"))


  # Housing costs ====
  # household income is based on monthly, so standardise on monthly
  us$f_rent[us$f_rentwc == 1 & !is.na(us$f_rentwc)] <-
    us$f_rent[us$f_rentwc == 1 & !is.na(us$f_rentwc)]  * 52 / 12
  us$f_rent[us$f_rentwc == 2 & !is.na(us$f_rentwc)] <-
    us$f_rent[us$f_rentwc == 2 & !is.na(us$f_rentwc)]  * 52 / 2 / 12
  us$f_rent[us$f_rentwc == 3 & !is.na(us$f_rentwc)] <-
    us$f_rent[us$f_rentwc == 3 & !is.na(us$f_rentwc)]  * 52 / 3 / 12
  us$f_rent[us$f_rentwc == 4 & !is.na(us$f_rentwc)] <-
    us$f_rent[us$f_rentwc == 4 & !is.na(us$f_rentwc)]  * 52 / 4 / 12
  us$f_rent[us$f_rentwc == 7 & !is.na(us$f_rentwc)] <-
    us$f_rent[us$f_rentwc == 7 & !is.na(us$f_rentwc)]  / 2
  us$f_rent[us$f_rentwc == 8 & !is.na(us$f_rentwc)] <-
    us$f_rent[us$f_rentwc == 8 & !is.na(us$f_rentwc)]  * 8  / 12
  us$f_rent[us$f_rentwc == 9 & !is.na(us$f_rentwc)] <-
    us$f_rent[us$f_rentwc == 9 & !is.na(us$f_rentwc)]  * 9  / 12
  us$f_rent[us$f_rentwc == 10 & !is.na(us$f_rentwc)] <-
    us$f_rent[us$f_rentwc == 10 & !is.na(us$f_rentwc)] * 10 / 12
  us$f_rent[us$f_rentwc == 13 & !is.na(us$f_rentwc)] <-
    us$f_rent[us$f_rentwc == 13 & !is.na(us$f_rentwc)] / 3
  us$f_rent[us$f_rentwc == 26 & !is.na(us$f_rentwc)] <-
    us$f_rent[us$f_rentwc == 26 & !is.na(us$f_rentwc)] / 6
  us$f_rent[us$f_rentwc == 52 & !is.na(us$f_rentwc)] <-
    us$f_rent[us$f_rentwc == 52 & !is.na(us$f_rentwc)] / 12
  us$f_rent[us$f_rentwc == 90 & !is.na(us$f_rentwc)] <-
    us$f_rent[us$f_rentwc == 90 & !is.na(us$f_rentwc)] * 52 / 12
  us$f_rent[us$f_rentwc == 95 & !is.na(us$f_rentwc)] <- NA  # one-off payment
  us$f_rent[us$f_rentwc == 96 & !is.na(us$f_rentwc)] <- NA  # none of these

  us$e_rent[us$e_rentwc == 1 & !is.na(us$e_rentwc)] <-
    us$e_rent[us$e_rentwc == 1 & !is.na(us$e_rentwc)]  * 52 / 12
  us$e_rent[us$e_rentwc == 2 & !is.na(us$e_rentwc)] <-
    us$e_rent[us$e_rentwc == 2 & !is.na(us$e_rentwc)]  * 52 / 2 / 12
  us$e_rent[us$e_rentwc == 3 & !is.na(us$e_rentwc)] <-
    us$e_rent[us$e_rentwc == 3 & !is.na(us$e_rentwc)]  * 52 / 3 / 12
  us$e_rent[us$e_rentwc == 4 & !is.na(us$e_rentwc)] <-
    us$e_rent[us$e_rentwc == 4 & !is.na(us$e_rentwc)]  * 52 / 4 / 12
  us$e_rent[us$e_rentwc == 7 & !is.na(us$e_rentwc)] <-
    us$e_rent[us$e_rentwc == 7 & !is.na(us$e_rentwc)]  / 2
  us$e_rent[us$e_rentwc == 8 & !is.na(us$e_rentwc)] <-
    us$e_rent[us$e_rentwc == 8 & !is.na(us$e_rentwc)]  * 8  / 12
  us$e_rent[us$e_rentwc == 9 & !is.na(us$e_rentwc)] <-
    us$e_rent[us$e_rentwc == 9 & !is.na(us$e_rentwc)]  * 9  / 12
  us$e_rent[us$e_rentwc == 10 & !is.na(us$e_rentwc)] <-
    us$e_rent[us$e_rentwc == 10 & !is.na(us$e_rentwc)] * 10 / 12
  us$e_rent[us$e_rentwc == 13 & !is.na(us$e_rentwc)] <-
    us$e_rent[us$e_rentwc == 13 & !is.na(us$e_rentwc)] / 3
  us$e_rent[us$e_rentwc == 26 & !is.na(us$e_rentwc)] <-
    us$e_rent[us$e_rentwc == 26 & !is.na(us$e_rentwc)] / 6
  us$e_rent[us$e_rentwc == 52 & !is.na(us$e_rentwc)] <-
    us$e_rent[us$e_rentwc == 52 & !is.na(us$e_rentwc)] / 12
  us$e_rent[us$e_rentwc == 90 & !is.na(us$e_rentwc)] <-
    us$e_rent[us$e_rentwc == 90 & !is.na(us$e_rentwc)] * 52 / 12
  us$e_rent[us$e_rentwc == 95 & !is.na(us$e_rentwc)] <- NA  # one-off payment
  us$e_rent[us$e_rentwc == 96 & !is.na(us$e_rentwc)] <- NA  # none of these

  us$d_rent[us$d_rentwc == 1 & !is.na(us$d_rentwc)] <-
    us$d_rent[us$d_rentwc == 1 & !is.na(us$d_rentwc)]  * 52 / 12
  us$d_rent[us$d_rentwc == 2 & !is.na(us$d_rentwc)] <-
    us$d_rent[us$d_rentwc == 2 & !is.na(us$d_rentwc)]  * 52 / 2 / 12
  us$d_rent[us$d_rentwc == 3 & !is.na(us$d_rentwc)] <-
    us$d_rent[us$d_rentwc == 3 & !is.na(us$d_rentwc)]  * 52 / 3 / 12
  us$d_rent[us$d_rentwc == 4 & !is.na(us$d_rentwc)] <-
    us$d_rent[us$d_rentwc == 4 & !is.na(us$d_rentwc)]  * 52 / 4 / 12
  us$d_rent[us$d_rentwc == 7 & !is.na(us$d_rentwc)] <-
    us$d_rent[us$d_rentwc == 7 & !is.na(us$d_rentwc)]  / 2
  us$d_rent[us$d_rentwc == 8 & !is.na(us$d_rentwc)] <-
    us$d_rent[us$d_rentwc == 8 & !is.na(us$d_rentwc)]  * 8  / 12
  us$d_rent[us$d_rentwc == 9 & !is.na(us$d_rentwc)] <-
    us$d_rent[us$d_rentwc == 9 & !is.na(us$d_rentwc)]  * 9  / 12
  us$d_rent[us$d_rentwc == 10 & !is.na(us$d_rentwc)] <-
    us$d_rent[us$d_rentwc == 10 & !is.na(us$d_rentwc)] * 10 / 12
  us$d_rent[us$d_rentwc == 13 & !is.na(us$d_rentwc)] <-
    us$d_rent[us$d_rentwc == 13 & !is.na(us$d_rentwc)] / 3
  us$d_rent[us$d_rentwc == 26 & !is.na(us$d_rentwc)] <-
    us$d_rent[us$d_rentwc == 26 & !is.na(us$d_rentwc)] / 6
  us$d_rent[us$d_rentwc == 52 & !is.na(us$d_rentwc)] <-
    us$d_rent[us$d_rentwc == 52 & !is.na(us$d_rentwc)] / 12
  us$d_rent[us$d_rentwc == 90 & !is.na(us$d_rentwc)] <-
    us$d_rent[us$d_rentwc == 90 & !is.na(us$d_rentwc)] * 52 / 12
  us$d_rent[us$d_rentwc == 95 & !is.na(us$d_rentwc)] <- NA  # one-off payment
  us$d_rent[us$d_rentwc == 96 & !is.na(us$d_rentwc)] <- NA  # none of these

  us$c_rent[us$c_rentwc == 1 & !is.na(us$c_rentwc)] <-
    us$c_rent[us$c_rentwc == 1 & !is.na(us$c_rentwc)]  * 52 / 12
  us$c_rent[us$c_rentwc == 2 & !is.na(us$c_rentwc)] <-
    us$c_rent[us$c_rentwc == 2 & !is.na(us$c_rentwc)]  * 52 / 2 / 12
  us$c_rent[us$c_rentwc == 3 & !is.na(us$c_rentwc)] <-
    us$c_rent[us$c_rentwc == 3 & !is.na(us$c_rentwc)]  * 52 / 3 / 12
  us$c_rent[us$c_rentwc == 4 & !is.na(us$c_rentwc)] <-
    us$c_rent[us$c_rentwc == 4 & !is.na(us$c_rentwc)]  * 52 / 4 / 12
  us$c_rent[us$c_rentwc == 7 & !is.na(us$c_rentwc)] <-
    us$c_rent[us$c_rentwc == 7 & !is.na(us$c_rentwc)]  / 2
  us$c_rent[us$c_rentwc == 8 & !is.na(us$c_rentwc)] <-
    us$c_rent[us$c_rentwc == 8 & !is.na(us$c_rentwc)]  * 8  / 12
  us$c_rent[us$c_rentwc == 9 & !is.na(us$c_rentwc)] <-
    us$c_rent[us$c_rentwc == 9 & !is.na(us$c_rentwc)]  * 9  / 12
  us$c_rent[us$c_rentwc == 10 & !is.na(us$c_rentwc)] <-
    us$c_rent[us$c_rentwc == 10 & !is.na(us$c_rentwc)] * 10 / 12
  us$c_rent[us$c_rentwc == 13 & !is.na(us$c_rentwc)] <-
    us$c_rent[us$c_rentwc == 13 & !is.na(us$c_rentwc)] / 3
  us$c_rent[us$c_rentwc == 26 & !is.na(us$c_rentwc)] <-
    us$c_rent[us$c_rentwc == 26 & !is.na(us$c_rentwc)] / 6
  us$c_rent[us$c_rentwc == 52 & !is.na(us$c_rentwc)] <-
    us$c_rent[us$c_rentwc == 52 & !is.na(us$c_rentwc)] / 12
  us$c_rent[us$c_rentwc == 90 & !is.na(us$c_rentwc)] <-
    us$c_rent[us$c_rentwc == 90 & !is.na(us$c_rentwc)] * 52 / 12
  us$c_rent[us$c_rentwc == 95 & !is.na(us$c_rentwc)] <- NA  # one-off payment
  us$c_rent[us$c_rentwc == 96 & !is.na(us$c_rentwc)] <- NA  # none of these

  us$b_rent[us$b_rentwc == 1 & !is.na(us$b_rentwc)] <-
    us$b_rent[us$b_rentwc == 1 & !is.na(us$b_rentwc)]  * 52 / 12
  us$b_rent[us$b_rentwc == 2 & !is.na(us$b_rentwc)] <-
    us$b_rent[us$b_rentwc == 2 & !is.na(us$b_rentwc)]  * 52 / 2 / 12
  us$b_rent[us$b_rentwc == 3 & !is.na(us$b_rentwc)] <-
    us$b_rent[us$b_rentwc == 3 & !is.na(us$b_rentwc)]  * 52 / 3 / 12
  us$b_rent[us$b_rentwc == 4 & !is.na(us$b_rentwc)] <-
    us$b_rent[us$b_rentwc == 4 & !is.na(us$b_rentwc)]  * 52 / 4 / 12
  us$b_rent[us$b_rentwc == 7 & !is.na(us$b_rentwc)] <-
    us$b_rent[us$b_rentwc == 7 & !is.na(us$b_rentwc)]  / 2
  us$b_rent[us$b_rentwc == 8 & !is.na(us$b_rentwc)] <-
    us$b_rent[us$b_rentwc == 8 & !is.na(us$b_rentwc)]  * 8  / 12
  us$b_rent[us$b_rentwc == 9 & !is.na(us$b_rentwc)] <-
    us$b_rent[us$b_rentwc == 9 & !is.na(us$b_rentwc)]  * 9  / 12
  us$b_rent[us$b_rentwc == 10 & !is.na(us$b_rentwc)] <-
    us$b_rent[us$b_rentwc == 10 & !is.na(us$b_rentwc)] * 10 / 12
  us$b_rent[us$b_rentwc == 13 & !is.na(us$b_rentwc)] <-
    us$b_rent[us$b_rentwc == 13 & !is.na(us$b_rentwc)] / 3
  us$b_rent[us$b_rentwc == 26 & !is.na(us$b_rentwc)] <-
    us$b_rent[us$b_rentwc == 26 & !is.na(us$b_rentwc)] / 6
  us$b_rent[us$b_rentwc == 52 & !is.na(us$b_rentwc)] <-
    us$b_rent[us$b_rentwc == 52 & !is.na(us$b_rentwc)] / 12
  us$b_rent[us$b_rentwc == 90 & !is.na(us$b_rentwc)] <-
    us$b_rent[us$b_rentwc == 90 & !is.na(us$b_rentwc)] * 52 / 12
  us$b_rent[us$b_rentwc == 95 & !is.na(us$b_rentwc)] <- NA  # one-off payment
  us$b_rent[us$b_rentwc == 96 & !is.na(us$b_rentwc)] <- NA  # none of these

  us$a_rent[us$a_rentwc == 1 & !is.na(us$a_rentwc)] <-
    us$a_rent[us$a_rentwc == 1 & !is.na(us$a_rentwc)]  * 52 / 12
  us$a_rent[us$a_rentwc == 2 & !is.na(us$a_rentwc)] <-
    us$a_rent[us$a_rentwc == 2 & !is.na(us$a_rentwc)]  * 52 / 2 / 12
  us$a_rent[us$a_rentwc == 3 & !is.na(us$a_rentwc)] <-
    us$a_rent[us$a_rentwc == 3 & !is.na(us$a_rentwc)]  * 52 / 3 / 12
  us$a_rent[us$a_rentwc == 4 & !is.na(us$a_rentwc)] <-
    us$a_rent[us$a_rentwc == 4 & !is.na(us$a_rentwc)]  * 52 / 4 / 12
  us$a_rent[us$a_rentwc == 7 & !is.na(us$a_rentwc)] <-
    us$a_rent[us$a_rentwc == 7 & !is.na(us$a_rentwc)]  / 2
  us$a_rent[us$a_rentwc == 8 & !is.na(us$a_rentwc)] <-
    us$a_rent[us$a_rentwc == 8 & !is.na(us$a_rentwc)]  * 8  / 12
  us$a_rent[us$a_rentwc == 9 & !is.na(us$a_rentwc)] <-
    us$a_rent[us$a_rentwc == 9 & !is.na(us$a_rentwc)]  * 9  / 12
  us$a_rent[us$a_rentwc == 10 & !is.na(us$a_rentwc)] <-
    us$a_rent[us$a_rentwc == 10 & !is.na(us$a_rentwc)] * 10 / 12
  us$a_rent[us$a_rentwc == 13 & !is.na(us$a_rentwc)] <-
    us$a_rent[us$a_rentwc == 13 & !is.na(us$a_rentwc)] / 3
  us$a_rent[us$a_rentwc == 26 & !is.na(us$a_rentwc)] <-
    us$a_rent[us$a_rentwc == 26 & !is.na(us$a_rentwc)] / 6
  us$a_rent[us$a_rentwc == 52 & !is.na(us$a_rentwc)] <-
    us$a_rent[us$a_rentwc == 52 & !is.na(us$a_rentwc)] / 12
  us$a_rent[us$a_rentwc == 90 & !is.na(us$a_rentwc)] <-
    us$a_rent[us$a_rentwc == 90 & !is.na(us$a_rentwc)] * 52 / 12
  us$a_rent[us$a_rentwc == 95 & !is.na(us$a_rentwc)] <- NA  # one-off payment
  us$a_rent[us$a_rentwc == 96 & !is.na(us$a_rentwc)] <- NA  # none of these

  us <- us %>%
    select(-f_rentwc, -e_rentwc, -d_rentwc, -c_rentwc, -b_rentwc, -a_rentwc)

  us$hh_cost <- us$f_xpmg
  us$hh_cost[is.na(us$hh_cost)] <- us$f_rent[is.na(us$hh_cost)]

  us$hh_cost[is.na(us$hh_cost)] <- us$e_xpmg[is.na(us$hh_cost)]
  us$hh_cost[is.na(us$hh_cost)] <- us$e_rent[is.na(us$hh_cost)]

  us$hh_cost[is.na(us$hh_cost)] <- us$d_xpmg[is.na(us$hh_cost)]
  us$hh_cost[is.na(us$hh_cost)] <- us$d_rent[is.na(us$hh_cost)]

  us$hh_cost[is.na(us$hh_cost)] <- us$c_xpmg[is.na(us$hh_cost)]
  us$hh_cost[is.na(us$hh_cost)] <- us$c_rent[is.na(us$hh_cost)]

  us$hh_cost[is.na(us$hh_cost)] <- us$b_xpmg[is.na(us$hh_cost)]
  us$hh_cost[is.na(us$hh_cost)] <- us$b_rent[is.na(us$hh_cost)]

  us$hh_cost[is.na(us$hh_cost)] <- us$a_xpmg[is.na(us$hh_cost)]
  us$hh_cost[is.na(us$hh_cost)] <- us$a_rent[is.na(us$hh_cost)]

  # top code to £20,000
  us$hh_cost[us$hh_cost > 20000] <- 20000

  us <- us %>%
    select(-f_xpmg, -e_xpmg, -d_xpmg, -c_xpmg, -b_xpmg, -a_xpmg) %>%
    select(-f_rent, -e_rent, -d_rent, -c_rent, -b_rent, -a_rent)


  # Benefits ====
  us$uc_replace <- 0
  us$uc_replace[us$f_benbase1 == 1] <- 1  # income support
  us$uc_replace[us$f_benbase2 == 1] <- 1  # JSA
  us$uc_replace[us$f_othben5  == 1] <- 1  # working tax credit
  us$uc_replace[us$f_othben8  == 1] <- 1  # housing benefit
  us$uc_replace[us$f_benctc   == 1] <- 1  # housing benefit (2 == no)
  us$uc_replace[us$f_bendis2  == 1] <- 1  # ESA

  us$uc_replace[is.na(us$uc_replace) & us$e_benunemp1 == 1] <- 1  # JSA
  us$uc_replace[is.na(us$uc_replace) & us$e_btype2    == 1] <- 1  # income sup
  us$uc_replace[is.na(us$uc_replace) & us$e_btype3    == 1] <- 1  # ESA
  us$uc_replace[is.na(us$uc_replace) & us$e_btype6    == 1] <- 1  # tax cred

  us$uc_replace[is.na(us$uc_replace) & us$d_benunemp1 == 1] <- 1  # JSA
  us$uc_replace[is.na(us$uc_replace) & us$d_btype2    == 1] <- 1  # income sup
  us$uc_replace[is.na(us$uc_replace) & us$d_btype3    == 1] <- 1  # ESA
  us$uc_replace[is.na(us$uc_replace) & us$d_btype6    == 1] <- 1  # tax cred

  us$uc_replace[is.na(us$uc_replace) & us$c_benunemp1 == 1] <- 1  # JSA
  us$uc_replace[is.na(us$uc_replace) & us$c_btype2    == 1] <- 1  # income sup
  us$uc_replace[is.na(us$uc_replace) & us$c_btype3    == 1] <- 1  # ESA
  us$uc_replace[is.na(us$uc_replace) & us$c_btype6    == 1] <- 1  # tax cred

  us$uc_replace[is.na(us$uc_replace) & us$b_benunemp1 == 1] <- 1  # JSA
  us$uc_replace[is.na(us$uc_replace) & us$b_btype2    == 1] <- 1  # income sup
  us$uc_replace[is.na(us$uc_replace) & us$b_btype3    == 1] <- 1  # ESA
  us$uc_replace[is.na(us$uc_replace) & us$b_btype6    == 1] <- 1  # tax cred

  us$uc_replace[is.na(us$uc_replace) & us$a_benunemp1 == 1] <- 1  # JSA
  us$uc_replace[is.na(us$uc_replace) & us$a_btype2    == 1] <- 1  # income sup
  us$uc_replace[is.na(us$uc_replace) & us$a_btype3    == 1] <- 1  # ESA
  us$uc_replace[is.na(us$uc_replace) & us$a_btype6    == 1] <- 1  # tax cred

  us <- us %>%
    select(-f_benbase1, -f_benbase2, -f_othben5, -f_othben8, -f_benctc,
           -f_bendis2,
           -e_benunemp1, -e_btype2,  -e_btype3, -e_btype6,
           -d_benunemp1, -d_btype2,  -d_btype3, -d_btype6,
           -c_benunemp1, -c_btype2,  -c_btype3, -c_btype6,
           -b_benunemp1, -b_btype2,  -b_btype3, -b_btype6,
           -a_benunemp1, -a_btype2,  -a_btype3, -a_btype6)


  # Save data frame ====
  save(us, file = "data/us.RData", compress = "xz")
  rm(us)

}
