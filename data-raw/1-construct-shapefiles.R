# This script creates and exports shapefiles of various geographies:

#   Hawaii and Kauai
#   Great Britain (England, Scotland, Wales) outline
#   England and Wales country outline (one shape)
#   Yorkshire and The Humber region outline
#   South Yorkshire county outline
#   England and Wales LADs
#   Doncaster LAD outline
#   Doncaster context map
#   Doncaster OAs
#   Doncaster OA centroids
#   Doncaster Community areas
#   Doncaster care homes
#   Doncaster GP surgeries
#   Doncaster leisure centres
#   Doncaster green spaces
#   Doncaster LSOAs
#   Doncaster MSOAs
#   Westminster Parliamentary Constituencies 2001 (Barnsley East and Mexboro')


# Global CRS ====
bng_crs   = paste0("+proj=tmerc +lat_0=49 +lon_0=-2 +k=0.9996012717 ",
                   "+x_0=400000 +y_0=-100000 +datum=OSGB36 +units=m +no_defs ",
                   "+ellps=airy +towgs84=446.448,-125.157,542.060,0.1502,",
                   "0.2470,0.8421,-20.4894")
wgs84_crs = "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"


# UK Bounding box ====
# For validating geocoded addresses
uk_min_lng <- -10.854492
uk_max_lng <- 2.021484
uk_min_lat <- 49.823809
uk_max_lat <- 59.478569


# functions ====
rm_shapes <- function(directory) {

  shp_files <- list.files(directory,
                          pattern = "dbf|prj|sbn|sbx|shp|shx|txt|html",
                          full.names = TRUE)

  file.remove(shp_files)

}

# create inst/extdata/shapefiles/
dir.create("inst/extdata/shapefiles/", showWarnings = FALSE, recursive = TRUE)


# Hawaii and Kauai ====
if (!file.exists("data/hawaii.RData")) {

  dir.create("inst/extdata/shapefiles/hawaii/", showWarnings = FALSE)

  if (!file.exists("inst/extdata/shapefiles/hawaii/hawaii.zip")) {

    utils::download.file("http://biogeo.ucdavis.edu/data/diva/adm/USA_adm.zip",
                         destfile = "inst/extdata/shapefiles/hawaii/hawaii.zip")

  }

  utils::unzip("inst/extdata/shapefiles/hawaii/hawaii.zip",
               exdir = "inst/extdata/shapefiles/hawaii/",
               overwrite = TRUE)

  hawaii <- rgdal::readOGR("inst/extdata/shapefiles/hawaii", "USA_adm1",
                           stringsAsFactors = FALSE)

  hawaii <- hawaii[hawaii@data$NAME_1 == "Hawaii", ]

  hawaii <- sp::spTransform(hawaii, sp::CRS("+init=epsg:26965"))

  hawaii <- rmapshaper::ms_simplify(hawaii, keep = 0.04)

  hawaii@data[] <- lapply(hawaii@data, as.character)

  hawaii@data <- hawaii@data[, c("ID_1", "NAME_1")]

  save(hawaii, file = "data/hawaii.RData", compress = "xz")
  rm(hawaii)

}

if (!file.exists("data/kauai.RData")) {

  dir.create("inst/extdata/shapefiles/hawaii/", showWarnings = FALSE)

  if (!file.exists("inst/extdata/shapefiles/hawaii/hawaii.zip")) {

    utils::download.file("http://biogeo.ucdavis.edu/data/diva/adm/USA_adm.zip",
                         destfile = "inst/extdata/shapefiles/hawaii/hawaii.zip")

  }

  utils::unzip("inst/extdata/shapefiles/hawaii/hawaii.zip",
               exdir = "inst/extdata/shapefiles/hawaii/",
               overwrite = TRUE)

  kauai <- rgdal::readOGR("inst/extdata/shapefiles/hawaii", "USA_adm2",
                          stringsAsFactors = FALSE)

  kauai <- kauai[kauai@data$NAME_2 == "Kauai", ]

  kauai <- sp::spTransform(kauai, sp::CRS("+init=epsg:26965"))

  kauai <- rmapshaper::ms_simplify(kauai, keep = 0.04)

  kauai@data[] <- lapply(kauai@data, as.character)

  kauai@data <- kauai@data[, c("ID_1", "NAME_1", "ID_2", "NAME_2")]

  save(kauai, file = "data/kauai.RData", compress = "xz")
  rm(kauai)

}

rm_shapes(directory = "inst/extdata/shapefiles/hawaii/")


# Great Britain outline ====
if (!file.exists("data/gb_outline.RData")) {

  dir.create("inst/extdata/shapefiles/gb_outline", showWarnings = FALSE)

  if (!file.exists("inst/extdata/shapefiles/gb_outline/gb_outline.zip")) {

    download.file(paste0("https://borders.ukdataservice.ac.uk/ukborders/",
                         "easy_download/prebuilt/shape/infuse_gb_2011.zip"),
                  method = "wget", quiet = TRUE,
                  destfile = "inst/extdata/shapefiles/gb_outline/gb_outline.zip")

  }

  unzip("inst/extdata/shapefiles/gb_outline/gb_outline.zip",
        exdir = "inst/extdata/shapefiles/gb_outline/",
        overwrite = TRUE)

  gb_outline <- rgdal::readOGR("inst/extdata/shapefiles/gb_outline",
                               "infuse_gb_2011", stringsAsFactors = FALSE)

  gb_outline <- rmapshaper::ms_simplify(gb_outline, keep = 0.005)

  gb_outline@data[] <- lapply(gb_outline@data, as.character)

  gb_outline@data$rmapshaperid <- NULL
  save(gb_outline, file = "data/gb_outline.RData", compress = "xz")
  rm(gb_outline)

}

rm_shapes("inst/extdata/shapefiles/gb_outline/")


# Yorkshire and The Humber region ====
if (!file.exists("data/yh_region.RData")) {

  dir.create("inst/extdata/shapefiles/yh_region", showWarnings = FALSE)

  if (!file.exists("inst/extdata/shapefiles/yh_region/gor.zip")) {

    gor <- paste0("https://borders.ukdataservice.ac.uk/ukborders/",
                  "easy_download/prebuilt/shape/England_gor_2011.zip")

    download.file(gor, method = "wget", quiet = TRUE,
                  destfile = "inst/extdata/shapefiles/yh_region/gor.zip")

  }

  unzip("inst/extdata/shapefiles/yh_region/gor.zip",
        exdir = "inst/extdata/shapefiles/yh_region/",
        overwrite = TRUE)

  yh_region <- rgdal::readOGR("inst/extdata/shapefiles/yh_region",
                              "england_gor_2011",
                              stringsAsFactors = FALSE)

  yh_region <- yh_region[yh_region@data$name == "Yorkshire and The Humber", ]

  yh_region <- rmapshaper::ms_simplify(yh_region, keep = 0.04)

  yh_region@data[] <- lapply(yh_region@data, as.character)
  yh_region@data$rmapshaperid <- NULL

  save(yh_region, file = "data/yh_region.RData")
  rm(yh_region)

}

rm_shapes("inst/extdata/shapefiles/yh_region/")


# South Yorkshire county ====
if (!file.exists("data/sy_county.RData")) {

  dir.create("inst/extdata/shapefiles/sy_county", showWarnings = FALSE)

  if (!file.exists("inst/extdata/shapefiles/sy_county/sy_county.zip")) {

    utils::download.file(paste0("https://borders.ukdataservice.ac.uk/",
                                "ukborders/easy_download/prebuilt/shape/",
                                "England_ct_2011.zip"),
                         destfile = "inst/extdata/shapefiles/sy_county/sy_county.zip",
                         method = "wget")

  }

  utils::unzip("inst/extdata/shapefiles/sy_county/sy_county.zip",
               exdir = "inst/extdata/shapefiles/sy_county/",
               overwrite = TRUE)

  sy_county <- rgdal::readOGR("inst/extdata/shapefiles/sy_county",
                              "england_ct_2011",
                              stringsAsFactors = FALSE)

  sy_county <- sy_county[sy_county@data$name == "Barnsley" |
                           sy_county@data$name == "Doncaster" |
                           sy_county@data$name == "Rotherham" |
                           sy_county@data$name == "Sheffield", ]

  sy_county <- rgeos::gUnaryUnion(sy_county)

  sy_county <- rmapshaper::ms_simplify(sy_county, keep = 0.04)

  save(sy_county, file = "data/sy_county.RData", compress = "xz")
  rm(sy_county)

}

rm_shapes("inst/extdata/shapefiles/sy_county/")


# England and Wales LADs ====
if (!file.exists("data/lads.RData")) {

  dir.create("inst/extdata/shapefiles/lads/",
             recursive = TRUE, showWarnings = FALSE)

  if (!file.exists("inst/extdata/shapefiles/lads/lads.zip")) {

    utils::download.file(paste0("https://borders.ukdataservice.ac.uk/ukborders/",
                                "easy_download/prebuilt/shape/",
                                "infuse_dist_lyr_2011.zip"),
                         destfile = "inst/extdata/shapefiles/lads/lads.zip",
                         method = "wget")

  }

  utils::unzip("inst/extdata/shapefiles/lads/lads.zip",
               exdir = "inst/extdata/shapefiles/lads/")

  lads <- rgdal::readOGR("inst/extdata/shapefiles/lads", "infuse_dist_lyr_2011",
                         stringsAsFactors = FALSE)

  lads <- sp::spChFIDs(lads, as.character(1:nrow(lads@data)))

  stopifnot(
    all.equal(row.names(lads),
              vapply(lads@polygons, function(x) slot(x, "ID"), ""))
  )

  # This is to remove Scot and NI
  lads <- lads[grep("^E[0-9]|^W[0-9]", lads@data$geo_code), ]

  lads <- rmapshaper::ms_simplify(lads, keep = 0.04)
  lads@data$rmapshaperid <- NULL

  lads@data <- lads@data %>%
    rename(code = geo_code,
           name = name) %>%
    select(code, name)

  # Add supergroup characteristics
  if (!file.exists("inst/extdata/shapefiles/lads/area_class.xls")) {

    utils::download.file(paste0("http://www.ons.gov.uk/ons/guide-method/",
                                "geography/products/area-classifications/",
                                "ns-area-classifications/",
                                "ns-2011-area-classifications/datasets/",
                                "2011-census-data.xls"),
                         destfile = "inst/extdata/shapefiles/lads/area_class.xls",
                         quiet = TRUE)

  }

  area_class <- readxl::read_excel("inst/extdata/shapefiles/lads/area_class.xls",
                                   sheet = 1, skip = 6, col_names = TRUE) %>%
    select(1, 2, 3, 4, 5, 6) %>%
    rename(code       = Code,
           name       = Name,
           region     = `Region/Country`,
           supergroup = `Supergroup code`,
           group      = `Group code`,
           subgroup   = `Subgroup code`) %>%
    filter(str_detect(code, "E[0-9]|W[0-9]"))

  lads <- sp::spChFIDs(lads, as.character(seq_along(lads)))
  stopifnot(
    all.equal(nrow(lads@data), nrow(area_class)),
    all.equal(row.names(lads@data),
              vapply(lads@polygons, function(x) slot(x, "ID"), ""))
  )

  # Life expectancy
  if (!file.exists("inst/extdata/life-expectancy-lad.xls")) {
    utils::download.file(paste0("http://www.ons.gov.uk/file?uri=/",
                                "peoplepopulationandcommunity/",
                                "birthsdeathsandmarriages/lifeexpectancies/",
                                "datasets/lifeexpectancyatbirthandatage65",
                                "bylocalareasinenglandandwalesreferencetable1/",
                                "current/corrected201214referencetable1final",
                                "newtcm77422242tcm77422242.xls"),
                         destfile = "inst/extdata/life-expectancy-lad.xls")
  }

  # Males
  le_m <- readxl::read_excel("inst/extdata/life-expectancy-lad.xls",
                             sheet = "E&W LAs at birth - M",
                             skip = 7, col_names = TRUE)
  colnames(le_m)[3] <- "name"
  le_m <- le_m %>%
    select(1, 3, 25) %>%
    rename("code"      = `Area code`,
           "lexp_male" = `2012–2014`) %>%
    filter(!is.na(name)) %>%
    arrange(code)

  le_m$lexp_male <- as.numeric(le_m$lexp_male)

  # Females
  le_f <- readxl::read_excel("inst/extdata/life-expectancy-lad.xls",
                             sheet = "E&W LAs at birth - F",
                             skip = 7, col_names = TRUE)
  colnames(le_f)[3] <- "name"
  le_f <- le_f %>%
    select(1, 3, 25) %>%
    rename("code" = `Area code`,
           "lexp_female" = `2012–2014`) %>%
    filter(!is.na(name)) %>%
    arrange(code)

  le_f$lexp_female <- as.numeric(le_f$lexp_female)
  stopifnot(
    all.equal(le_m$code, le_f$code)
  )

  # Self-reported general health
  if (!file.exists("inst/extdata/srgh_lad.csv")) {
    download.file(paste0("https://www.nomisweb.co.uk/api/v01/dataset/",
                         "NM_531_1.data.csv?date=latest&geography=1946157057",
                         "...1946157404&rural_urban=0&c_health=1...5&",
                         "measures=20100&signature=NPK-0c73734c0f725c979cee3a:",
                         "0xf037bb9dc3153d18ba57ca4f710f13b629ea7973"),
                  destfile = "inst/extdata/srgh_lad.csv",
                  method = "wget")
  }

  srgh_lad <- readr::read_csv("inst/extdata/srgh_lad.csv") %>%
    select(GEOGRAPHY_NAME, GEOGRAPHY_CODE, C_HEALTH_NAME, OBS_VALUE) %>%
    spread(C_HEALTH_NAME, OBS_VALUE) %>%
    rename("name" = GEOGRAPHY_NAME,
           "code" = GEOGRAPHY_CODE,
           "bad"      = `Bad health`,
           "fair"     = `Fair health`,
           "good"     = `Good health`,
           "v_bad"    = `Very bad health`,
           "v_good"   = `Very good health`) %>%
    select(code, name, v_bad, bad, fair, good, v_good) %>%
    arrange(code)

  if (!file.exists("inst/extdata/llid_lad.csv")) {
    download.file(paste0("https://www.nomisweb.co.uk/api/v01/dataset/",
                         "NM_532_1.data.csv?date=latest&geography=1946157057",
                         "...1946157404&rural_urban=0&c_disability=1...3&",
                         "measures=20100&signature=NPK-0c73734c0f725c979cee3a:",
                         "0xdbb370cb5f7b9f0efbd5e8af1dedc7e5b57a9713"),
                  destfile = "inst/extdata/llid_lad.csv",
                  method = "wget")
  }

  llid_lad <- readr::read_csv("inst/extdata/llid_lad.csv") %>%
    select(GEOGRAPHY_CODE, GEOGRAPHY_NAME, C_DISABILITY_NAME, OBS_VALUE) %>%
    spread(C_DISABILITY_NAME, OBS_VALUE) %>%
    rename("code"   = GEOGRAPHY_CODE,
           "name"   = GEOGRAPHY_NAME,
           "lim_little" = `Day-to-day activities limited a little`,
           "lim_lot"    = `Day-to-day activities limited a lot`,
           "lim_not"    = `Day-to-day activities not limited`) %>%
    arrange(code)

  # IMD 2015
  # https://www.gov.uk/government/statistics/english-indices-of-deprivation-2015
  if (!file.exists("inst/extdata/imd_2015.xlsx")) {
    download.file(
      paste0("https://www.gov.uk/government/uploads/system/uploads/",
             "attachment_data/file/464464/File_10_ID2015_Local_Authority_",
             "District_Summaries.xlsx"),
      destfile = "inst/extdata/imd_2015.xlsx")
  }

  imd <- readxl::read_excel("inst/extdata/imd_2015.xlsx", sheet = "IMD") %>%
    select("code"     = `Local Authority District code (2013)`,
           "name"     = `Local Authority District name (2013)`,
           "imd"      = `IMD - Average rank`,
           "imd_rank" = `IMD - Rank of average rank`)

  # Economically active unemployed (census)
  if (!file.exists("inst/extdata/lad_unemp.csv")) {
    download.file(
      paste0("https://www.nomisweb.co.uk/api/v01/dataset/NM_1511_1.data.csv?",
             "date=latest&geography=1946157057...1946157462&cell=4&measures=",
             "20100&signature=NPK-0c73734c0f725c979cee3a:",
             "0x3cd93b1823ea76fcf8520be889c16fc555cc0acb"),
      destfile = "inst/extdata/lad_unemp.csv")
  }

  unemp <- readr::read_csv("inst/extdata/lad_unemp.csv") %>%
    select(
      "code" = GEOGRAPHY_CODE,
      "name" = GEOGRAPHY_NAME,
      "unem" = OBS_VALUE) %>%
    filter(str_detect(code, "E[0-9]|W[0-9]")) %>%
    filter(name != "Isles of Scilly") %>%
    filter(name != "Westminster")

  # Correct unmatched LAD codes
  unmatched <- c("St Albans", "Welwyn Hatfield", "City of London",
                 "Northumberland", "Stevenage", "Cornwall", "Gateshead",
                 "East Hertfordshire")
  for (i in unmatched) {
    area_class$code[grep(i, area_class$name)] <-
      lads@data$code[grep(i, lads@data$name)]
  }
  for (i in unmatched) {
    le_f$code[grep(i, le_f$name)] <-
      lads@data$code[grep(i, lads@data$name)]
  }
  for (i in unmatched) {
    le_m$code[grep(i, le_m$name)] <-
      lads@data$code[grep(i, lads@data$name)]
  }
  for (i in unmatched) {
    llid_lad$code[grep(i, llid_lad$name)] <-
      lads@data$code[grep(i, lads@data$name)]
  }
  for (i in unmatched) {
    srgh_lad$code[grep(i, srgh_lad$name)] <-
      lads@data$code[grep(i, lads@data$name)]
  }
  for (i in unmatched) {
    imd$code[grep(i, imd$name)] <-
      lads@data$code[grep(i, lads@data$name)]
  }
  for (i in unmatched) {
    unemp$code[grep(i, unemp$name)] <-
      lads@data$code[grep(i, lads@data$name)]
  }
  rm(i, unmatched)

  lads@data <- lads@data %>%
    inner_join(
      area_class[, c("code", "region", "supergroup", "group", "subgroup")],
      by = "code") %>%
    inner_join(le_f[, c("code", "lexp_female")], by = "code") %>%
    inner_join(le_m[, c("code", "lexp_male")], by = "code") %>%
    inner_join(llid_lad[, c("code", "lim_little", "lim_lot", "lim_not")],
               by = "code") %>%
    inner_join(srgh_lad[, c("code", "v_bad", "bad", "fair", "good", "v_good")],
               by = "code") %>%
    left_join(imd[, c("code", "imd", "imd_rank")], by = "code") %>%
    inner_join(unemp[, c("code", "unem")], by = "code") %>%
    mutate(
      pop_1000  = (v_bad + bad + fair + good + v_good) / 1000,
      bad_over  = v_bad + bad,
      good_over = good + v_good) %>%
    mutate(
      p_unem = unem / (pop_1000 * 1000)
    )

  stopifnot(
    all.equal(nrow(lads@data), 346)
    # Isles of Scilly and Westminster grouped with Cornwall and City of London
    # respectively in lads@data
  )

  # County/South Yorkshire labels
  lads@data$label <- NA
  lads@data$label[lads@data$name == "Doncaster"] <- "Doncaster"
  lads@data$label[lads@data$name == "Barnsley"  |
                    lads@data$name == "Rotherham" |
                    lads@data$name == "Sheffield" ] <- "South Yorkshire"

  rm(area_class, le_f, le_m, llid_lad, srgh_lad, imd, unemp)

  save(lads, file = "data/lads.RData", compress = "xz")

}
rm_shapes("inst/extdata/shapefiles/lads/")


# Doncaster LAD outline ====
if (!file.exists("data/don_outline.RData")) {

  load("data/lads.RData")

  don_outline <- lads[lads@data$name == "Doncaster", ]

  save(don_outline, file = "data/don_outline.RData", compress = "xz")
  rm(lads, don_outline)

}


# Doncaster context map ====
# Download OS's strategi vector maps
# https://www.ordnancesurvey.co.uk/business-and-government/products/strategi.html
# You need to sign up and request the download; you're then send a download
# link by email so I can't automate this step!
# Once you've downloaded the archive, place it in
# inst/extdata/
if (!file.exists("data/don_context.RData")) {
  dir.create("inst/extdata/shapefiles/don_context", showWarnings = FALSE,
             recursive = TRUE)
  unzip("inst/extdata/strtgi_essh_gb.zip",
        exdir = "inst/extdata/shapefiles/don_context")

  mways <- rgdal::readOGR(
    "inst/extdata/shapefiles/don_context/strtgi_essh_gb/data",
    "motorway",
    stringsAsFactors = FALSE
  )
  proj4string(mways) <- bng_crs

  a_rds <- rgdal::readOGR(
    "inst/extdata/shapefiles/don_context/strtgi_essh_gb/data",
    "a_road",
    stringsAsFactors = FALSE
  )
  proj4string(a_rds) <- bng_crs

  p_rds <- rgdal::readOGR(
    "inst/extdata/shapefiles/don_context/strtgi_essh_gb/data",
    "primary_road",
    stringsAsFactors = FALSE
  )
  proj4string(p_rds) <- bng_crs

  urban <- rgdal::readOGR(
    "inst/extdata/shapefiles/don_context/strtgi_essh_gb/data",
    "urban_region",
    stringsAsFactors = FALSE
  )
  proj4string(urban) <- bng_crs

  load("data/don_outline.RData")

  don_context <- list(mways, a_rds, p_rds, urban)
  don_context <- lapply(don_context, function(x) {
    x <- x[don_outline, ]
    x <- rmapshaper::ms_simplify(x)
    x
  })

  save(don_context, file = "data/don_context.RData", compress = "xz")

}


# Doncaster OAs ====
if (!file.exists("data/don_oa.RData")) {

  dir.create("inst/extdata/shapefiles/don_oa", showWarnings = FALSE)

  if (!file.exists("inst/extdata/shapefiles/don_oa/don_oa.zip")) {

    don_oa <- paste0("http://census.edina.ac.uk/ukborders/easy_download/",
                     "prebuilt/shape/England_oa_2011.zip")

    utils::download.file(don_oa, method = "wget", quiet = TRUE,
                         destfile = "inst/extdata/shapefiles/don_oa/don_oa.zip")

  }

  utils::unzip("inst/extdata/shapefiles/don_oa/don_oa.zip",
               exdir = "inst/extdata/shapefiles/don_oa/",
               overwrite = TRUE)

  if (!file.exists("inst/extdata/shapefiles/don_oa/oa_codes.csv")) {

    utils::download.file(paste0("http://geoportal.statistics.gov.uk/datasets/",
                                "09b8a48426e3482ebbc0b0c49985c0fb_1.csv"),
                         destfile = "inst/extdata/shapefiles/don_oa/oa_codes.csv")

  }

  don_oa <- rgdal::readOGR("inst/extdata/shapefiles/don_oa", "england_oa_2011",
                           stringsAsFactors = FALSE)

  oa_codes <- readr::read_csv("inst/extdata/shapefiles/don_oa/oa_codes.csv")

  oa_codes <- oa_codes[oa_codes$lad11cd == "E08000017", ]

  don_oa <- don_oa[don_oa@data$code %in% oa_codes$oa11cd, ]

  stopifnot(
    all.equal(nrow(oa_codes), 978),
    all.equal(nrow(don_oa@data), 978)
  )
  rm(oa_codes)

  don_oa <- rmapshaper::ms_simplify(don_oa, keep = 0.03)

  don_oa <- don_oa[, 1]

  # Insert output area classifications
  if (!file.exists("inst/extdata/shapefiles/don_oa/oa_class.zip")) {

    oa_class <- paste0("http://www.ons.gov.uk/ons/guide-method/geography/",
                       "products/area-classifications/ns-area-classifications/",
                       "ns-2011-area-classifications/datasets/2011-oac-",
                       "clusters-and-names-csv.zip")

    utils::download.file(oa_class, quiet = TRUE,
                         destfile = "inst/extdata/shapefiles/don_oa/oa_class.zip")

  }

  utils::unzip("inst/extdata/shapefiles/don_oa/oa_class.zip",
               exdir = "inst/extdata/shapefiles/don_oa/")

  oa_class <- suppressWarnings(  # Warning 'X12' suppressed; fixed below
    readr::read_csv(paste0("inst/extdata/shapefiles/don_oa/",
                           "2011 OAC Clusters and Names.csv"))
  )

  oa_class <- oa_class %>%
    select(-X12) %>%
    filter(`Local Authority Name` == "Doncaster") %>%
    select(`Output Area Code`, `Supergroup Code`, `Supergroup Name`,
           `Group Code`, `Group Name`, `Subgroup Code`, `Subgroup Name`)

  colnames(oa_class) <- c("code", "spg_code", "spg_name", "g_code", "g_name",
                          "sb_code", "sb_name")

  don_oa@data[] <- lapply(don_oa@data, as.character)
  oa_class[]    <- lapply(oa_class,    as.character)

  don_oa@data <- dplyr::inner_join(don_oa@data, oa_class, by = "code")

  stopifnot(
    all.equal(nrow(don_oa@data), nrow(oa_class))
  )
  rm(oa_class)

  # Order supergroup names for plotting
  don_oa@data$spg_name <- factor(don_oa@data$spg_name,
                                 levels = c("Cosmopolitans",
                                            "Rural Residents",
                                            "Suburbanites",
                                            "Urbanites",
                                            "Multicultural Metropolitans",
                                            "Ethnicity Central",
                                            "Constrained City Dwellers",
                                            "Hard-Pressed Living"),
                                 ordered = TRUE)

  # Add urban-rural classification
  if (!file.exists("inst/extdata/oa_urban_rural.csv")) {
    download.file(paste0("https://www.nomisweb.co.uk/api/v01/dataset/",
                         "NM_145_1.data.csv?date=latest&geography=",
                         "1254133554...1254134501,1254264241...1254264270&",
                         "rural_urban=2...4,1,8,5,9,6,10,7&cell=0&measures=",
                         "20100&signature=NPK-0c73734c0f725c979cee3a:",
                         "0x2d3a6d405b305b1d9d27ead609da55fe41e9a8c1"),
                  destfile = "inst/extdata/oa_urban_rural.csv")
  }

  urb_rur <- readr::read_csv("inst/extdata/oa_urban_rural.csv") %>%
    filter(OBS_VALUE != 0) %>%
    select(GEOGRAPHY_CODE, RURAL_URBAN_NAME) %>%
    rename(code        = GEOGRAPHY_CODE,
           rural_urban = RURAL_URBAN_NAME)

  stopifnot(
    all.equal(nrow(urb_rur), 978)
  )

  don_oa@data <- inner_join(don_oa@data, urb_rur, by = "code")

  stopifnot(
    all.equal(nrow(don_oa@data), 978),
    all.equal(length(!is.na(don_oa@data$rural_urban)), nrow(don_oa@data))
  )

  # Add OA population
  if (!file.exists("inst/extdata/shapefiles/don_oa/oa_pop.csv")) {
    utils::download.file(
      paste0("https://www.nomisweb.co.uk/api/v01/dataset/",
             "NM_145_1.data.csv?date=latest&geography=1254133554...",
             "1254134501,1254264241...1254264270&rural_urban=0&cell=6...",
             "16&measures=20100&signature=NPK-0c73734c0f725c979cee3a:",
             "0xbf6102aae09f8f0b74789acdc8339441aed0bffc"),
      destfile = "inst/extdata/shapefiles/don_oa/oa_pop.csv")
  }

  pop <- readr::read_csv("inst/extdata/shapefiles/don_oa/oa_pop.csv") %>%
    select(GEOGRAPHY_CODE, CELL_NAME, OBS_VALUE) %>%
    tidyr::spread(CELL_NAME, OBS_VALUE)

  pop <- pop %>%
    mutate(pop_16_plus = rowSums(pop[2:ncol(pop)])) %>%
    mutate(pop_65_plus = rowSums(pop[9:ncol(pop)])) %>%
    select(GEOGRAPHY_CODE, pop_16_plus, pop_65_plus) %>%
    rename(code = GEOGRAPHY_CODE)

  don_oa@data <- inner_join(don_oa@data, pop, by = "code")

  stopifnot(
    all.equal(nrow(don_oa@data), nrow(pop))
  )
  rm(pop)

  # Add young people (<= 16) population
  url = paste0("https://www.nomisweb.co.uk/api/v01/dataset/",
               "NM_145_1.data.csv?date=latest&geography=1254133554...",
               "1254134501,1254264241...1254264270&rural_urban=0&cell=1...",
               "6&measures=20100&signature=NPK-0c73734c0f725c979cee3a:",
               "0x1c2822d322d003eb614a59e298f23fed11002d9f")
  yp_pop <- readr::read_csv(url) %>%
    select("GEOGRAPHY_CODE", "CELL_NAME", "OBS_VALUE") %>%
    tidyr::spread(key = CELL_NAME, value = OBS_VALUE) %>%
    mutate(yp_pop = `Age 0 to 4` + `Age 5 to 7` + `Age 8 to 9` +
             `Age 10 to 14` + `Age 15` + `Age 16 to 17`) %>%
    rename(code = GEOGRAPHY_CODE) %>%
    select(code, yp_pop)

  don_oa@data <- don_oa@data %>%
    inner_join(yp_pop, by = "code")

  # Prison populations from 2011 Census (nomis2013a; @census)
  don_oa@data$prison_pop <- NA
  don_oa@data$prison_pop[don_oa@data$code == "E00038161"] <- 599
  don_oa@data$prison_pop[don_oa@data$code == "E00038290"] <- 221
  don_oa@data$prison_pop[don_oa@data$code == "E00172382"] <- 1702

  stopifnot(
    all.equal(nrow(don_oa@data[!is.na(don_oa@data$prison_pop), ]), 3)
  )

  # Add limiting long-term illness or disability
  if (!file.exists("inst/extdata/llid_cen.csv")) {
    download.file(paste0(
      "https://www.nomisweb.co.uk/api/v01/dataset/NM_827_1.data.csv?date=latest&",
      "geography=1254133554...1254134501,1254264241...1254264270&c_sex=0&c_age=2",
      "...4&c_disability=1...3&c_relpuk11=0&measures=20100&signature=NPK-",
      "0c73734c0f725c979cee3a:0xd8cbac10870224cd7d71034a29464737751d5248"),
      destfile = "inst/extdata/llid_cen.csv")
  }

  llid_cen <- readr::read_csv("inst/extdata/llid_cen.csv") %>%
    select(GEOGRAPHY_CODE, C_DISABILITY_NAME, OBS_VALUE) %>%
    group_by(GEOGRAPHY_CODE, C_DISABILITY_NAME) %>%
    summarise(sum(OBS_VALUE)) %>%
    rename(
      code = GEOGRAPHY_CODE,
      llid = C_DISABILITY_NAME,
      freq = `sum(OBS_VALUE)`
    ) %>%
    tidyr::spread(llid, freq) %>%
    rename(cen_llid_little = `Day-to-day activities limited a little`,
           cen_llid_lot    = `Day-to-day activities limited a lot`,
           cen_llid_not    = `Day-to-day activities not limited`) %>%
    mutate(cen_llid_yes    = cen_llid_little + cen_llid_lot,
           cen_llid_yes_p  = cen_llid_yes /
             (cen_llid_little + cen_llid_lot + cen_llid_not))

  stopifnot(
    all.equal(nrow(llid_cen), nrow(don_oa@data))
  )

  don_oa@data <- inner_join(don_oa@data, llid_cen, by = "code")
  rm(llid_cen)

  # Economically active unemployed
  if (!file.exists("inst/extdata/oa_unemp.csv")) {
    download.file(
      paste0("https://www.nomisweb.co.uk/api/v01/dataset/NM_1511_1.data.csv?",
             "date=latest&geography=1254133554...1254134501,1254264241...",
             "1254264270&cell=4&measures=20100&signature=",
             "NPK-0c73734c0f725c979cee3a:",
             "0xb3ef0267ffc7b28505c49e94d5b562243d7a814e"),
      destfile = "inst/extdata/oa_unemp.csv")
  }

  oa_unemp <- readr::read_csv("inst/extdata/oa_unemp.csv") %>%
    select("code" = GEOGRAPHY_CODE,
           "unem" = OBS_VALUE)

  don_oa@data <- don_oa@data %>%
    inner_join(oa_unemp, by = "code") %>%
    mutate(p_unem = unem / pop_16_plus)

  # NS-SEC
  if (!file.exists("inst/extdata/oa_nssec.csv")) {
    download.file(paste0(
      "https://www.nomisweb.co.uk/api/v01/dataset/NM_1521_1.data.csv?date=",
      "latest&geography=1254133554...1254134501,1254264241...1254264270&cell=",
      "1,4...10&measures=20100&signature=NPK-0c73734c0f725c979cee3a:",
      "0xbfd24509c67f98db921c45280bdb3371788a2a49"),
      destfile = "inst/extdata/oa_nssec.csv")
  }

  oa_nssec <- readr::read_csv("inst/extdata/oa_nssec.csv") %>%
    select("code"  = GEOGRAPHY_CODE,
           "nssec" = CELL_NAME,
           "freq"  = OBS_VALUE) %>%
    spread(nssec, freq)
  colnames(oa_nssec) <- c("code",
                          "higher_man_1", "lower_man_2", "intermediate_3",
                          "self_emp_4", "lower_sup_5", "semi_routine_6",
                          "routine_7", "lt_unem_8")

  don_oa@data <- don_oa@data %>%
    inner_join(oa_nssec, by = "code")

  # add community area lookup
  load("data/oa_comm_2011_lookup.RData")

  don_oa@data <- don_oa@data %>%
    inner_join(oa_comm_2011_lookup, by = c("code" = "oacode"))

  stopifnot(
    all.equal(nrow(don_oa@data), 978)
  )

  save(don_oa, file = "data/don_oa.RData", compress = "xz")
  rm(don_oa)

}
rm_shapes("inst/extdata/shapefiles/don_oa/")

oa_class <- "inst/extdata/shapefiles/don_oa/2011 OAC Clusters and Names.csv"
if (file.exists(oa_class)) {
  file.remove(oa_class)
}
rm(oa_class)


# Doncaster OA centroids ====
if (!file.exists("data/don_oa_cent.RData")) {
  if (!exists("don_oa")) {
    load("data/don_oa.RData")
  }

  don_oa_cent <- rgeos::gCentroid(don_oa, byid = TRUE)
  stopifnot(
    all.equal(nrow(don_oa@data), length(don_oa_cent))
  )
  don_oa_cent <- SpatialPointsDataFrame(don_oa_cent,
                                        don_oa@data[, "code", drop = FALSE])

  save(don_oa_cent, file = "data/don_oa_cent.RData", compress = "xz")
}


# Doncaster Community Areas ====
if (!file.exists("data/don_comm.RData")) {

  load("data/don_oa.RData")

  stopifnot(
    all.equal(nrow(don_oa@data), 978),
    all.equal(length(unique(don_oa@data$codecomm)), 88)
  )

  don_comm_data <- don_oa@data %>%
    select(
      pop_16_plus, pop_65_plus,
      cen_llid_little, cen_llid_lot, cen_llid_not,
      unem,
      higher_man_1, lower_man_2, intermediate_3, self_emp_4,
      lower_sup_5, semi_routine_6, routine_7, lt_unem_8,
      codecomm, namecomm
    ) %>%

    group_by(codecomm, namecomm) %>%
    summarise_all(sum) %>%
    ungroup() %>%
    mutate(p_unem = unem / pop_16_plus) %>%
    arrange(codecomm)

  stopifnot(
    all.equal(nrow(don_comm_data), 88),
    all.equal(nrow(don_comm_data), unique(nrow(don_comm_data))),
    all.equal(sum(don_oa@data$pop_16_plus), sum(don_comm_data$pop_16_plus)),
    all.equal(sum(don_oa@data$pop_65_plus), sum(don_comm_data$pop_65_plus))
  )

  # Dissolve (gUnaryUnion())
  don_oa <- don_oa[order(don_oa@data$codecomm), ]
  don_comm <- rgeos::gUnaryUnion(don_oa, id = don_oa@data$codecomm)

  stopifnot(
    all.equal(sapply(don_comm@polygons, function(x) slot(x, "ID")),
              row.names(don_comm)),
    all.equal(length(don_comm), 88)
  )

  # Recreate spatialPolygonsDataFrame object
  don_comm_data <- as.data.frame(don_comm_data)  # can't set row names on tibble
  row.names(don_comm_data) <- don_comm_data$codecomm
  don_comm <- SpatialPolygonsDataFrame(don_comm, don_comm_data)

  stopifnot(
    all.equal(row.names(don_comm_data), row.names(don_comm)),
    all.equal(length(unique(don_oa@data$codecomm)),
              length(don_comm_data$codecomm))
  )
  rm(don_oa)

  stopifnot(
    all.equal(nrow(don_comm@data), length(don_comm)),
    all.equal(don_comm@data$codecomm,
              sapply(don_comm@polygons, function(x) slot(x, "ID")))
  )
  rm(don_comm_data)

  don_comm@data <- don_comm@data %>%
    rename(comm_code = codecomm,
           comm_name = namecomm)

  save(don_comm, file = "data/don_comm.RData", compress = "xz")
  rm(don_comm)

}


# Care homes and GP surgeries ====
if (!file.exists("inst/extdata/cqc.zip")) {
  utils::download.file(paste0("http://www.cqc.org.uk/sites/default/files/",
                              "07_June_2017_CQC_directory.zip"),
                       destfile = "inst/extdata/cqc.zip")
}

if (!file.exists("data/care_homes.RData") ||
    !file.exists("data/doctors.RData")) {

  # Unzip master cqc file and read
  # filter on residential homes or nursing homes or doctor's surgeries
  # replace " " with "+" in postcode
  # geocode postcode
  # switch lat/long for long/lat

  unzip("inst/extdata/cqc.zip", exdir = "inst/extdata/")

  cqc <-
    list.files("inst/extdata",
               pattern = "CQC_directory.csv",
               full.names = TRUE) %>%
    readr::read_csv(skip = 4) %>%
    filter(`Local Authority` == "Doncaster") %>%
    rename(name = Name,
           postcode = Postcode,
           type     = `Service types`) %>%
    select(name, postcode, type) %>%
    filter(grepl("Nursing homes|Residential homes|Doctors/GPs", type))

  # Google geocode can't handle spaces in URL; expects '+'
  cqc$postcode <- stringr::str_replace(cqc$postcode, " ", "+")

  if (!exists("geocode")) {
    source("R/geocode.R")
  }
  cqc_gcoded <- geocode(cqc$postcode, "data-raw/google-geocode-api.txt")
  stopifnot(
    all.equal(nrow(cqc), nrow(cqc_gcoded))
  )

  # Remove any outside of UK bounds
  cqc <- dplyr::bind_cols(cqc, cqc_gcoded)
  cqc$is_uk <- TRUE
  cqc$is_uk[cqc$long < uk_min_lng |
              cqc$long > uk_max_lng |
              cqc$lat < uk_min_lat |
              cqc$lat > uk_max_lat] <- FALSE
  cqc <- cqc[cqc$is_uk, ]

  # Convert to spDataFrame and transform to BNG
  cqc <- sp::SpatialPointsDataFrame(cqc[, c("long", "lat")], cqc,
                                    proj4string = CRS(wgs84_crs))
  # Convert to easting/northing (EPSG:27700)
  cqc <- sp::spTransform(cqc, CRSobj = bng_crs)

  # Remove coords columns from @data
  cqc@data <- select(cqc@data, -long, -lat, -is_uk)

  # Remove any points outside Doncaster
  if (!exists("don_outline")) {
    load("data/don_outline.RData")
  }
  cqc <- cqc[don_outline, ]

  # Care homes
  care_homes <- cqc[grepl("Nursing|Residential", cqc@data$type), ]
  save(care_homes, file = "data/care_homes.RData", compress = "xz")

  # Doctor's surgeries
  doctors <- cqc[grepl("Doctors", cqc@data$type), ]
  save(doctors, file = "data/doctors.RData", compress = "xz")

}


# Leisure centres ====
if (!file.exists("data/leisure_centres.RData")) {
  places_key <- readLines("data-raw/google-places-api.txt")
  location   <- "53.523122,-1.134414"
  radius     <- 20000
  keyword    <- "leisure+centre"

  url = paste0("https://maps.googleapis.com/maps/api/place/nearbysearch/",
               "json?",
               "location=", location,
               "&radius=", radius,
               "&keyword=", keyword,
               "&key=", places_key)

  leisure_centres <- jsonlite::fromJSON(url)
  leisure_centres <- data.frame(
    name = leisure_centres$results$name,
    lng  = leisure_centres$results$geometry$location$lng,
    lat  = leisure_centres$results$geometry$location$lat
  )
  leisure_centres <-
    sp::SpatialPointsDataFrame(leisure_centres[, c("lng", "lat")],
                               leisure_centres,
                               proj4string = sp::CRS(wgs84_crs))
  leisure_centres <- sp::spTransform(leisure_centres, sp::CRS(bng_crs))
  leisure_centres@data <- leisure_centres@data %>%
    select(-lng, -lat)

  save(leisure_centres, file = "data/leisure_centres.RData", compress = "xz")

}


# Doncaster green space ====
# Download the full GB version of OS's Open Greenspace and place in
# inst/extdata
if (!file.exists("data/gs.RData")) {
  unzip("inst/extdata/opgrsp_essh_gb.zip",
        exdir = "inst/extdata/shapefiles/greenspace/")

  gs <-
    suppressWarnings(
      rgdal::readOGR(paste0("inst/extdata/shapefiles/greenspace/",
                            "OS Open Greenspace (ESRI Shape File) GB/data"),
                     "GB_GreenspaceSite",
                     stringsAsFactors = FALSE))
  gs <- rmapshaper::ms_simplify(gs, keep = 0.1)

  load("data/don_outline.RData")
  gs <- gs[don_outline, ]


  gs@data <- gs@data %>%
    rename(type = `function.`) %>%
    select(id, type)

  save(gs, file = "data/gs.RData", compress = "xz")

}


# Doncaster LSOAs ====
if (!file.exists("data/don_lsoa.RData")) {

  load("data/don_oa.RData")

  don_lsoa <- don_oa

  oa_lsoa <- geolookup::oa_lsoa_msoa_lad

  don_lsoa_data <- don_lsoa@data %>%
    dplyr::select(-spg_code, -spg_name, -g_code, -g_name, -sb_code, -sb_name,
                  -prison_pop,
                  -codecomm, -namecomm) %>%
    dplyr::inner_join(oa_lsoa[, c("oa_cd", "lsoa_cd")],
                      by = c("code" = "oa_cd")) %>%
    dplyr::select(-code) %>%
    dplyr::rename(code = lsoa_cd) %>%
    dplyr::group_by(code) %>%
    dplyr::summarise_if(is.numeric, sum)

  don_lsoa_data <- as.data.frame(don_lsoa_data)  # row.names don't work with tbl
  row.names(don_lsoa_data) <- don_lsoa_data$code

  don_lsoa@data <- dplyr::inner_join(don_lsoa@data,
                                     oa_lsoa[, c("oa_cd", "lsoa_cd")],
                                     by = c("code" = "oa_cd"))

  don_lsoa <- rgeos::gUnaryUnion(don_lsoa, id = don_lsoa@data$lsoa_cd)

  don_lsoa <- sp::SpatialPolygonsDataFrame(don_lsoa, don_lsoa_data,
                                           match.ID = TRUE)

  stopifnot(
    all.equal(sum(don_oa$llid_cen),   sum(don_lsoa$llid_cen)),
    all.equal(sum(don_oa$cen_llid_yes_p), sum(don_lsoa$cen_llid_yes_p))
  )

  # IMD 2015
  # https://www.gov.uk/government/statistics/english-indices-of-deprivation-2015
  if (!file.exists("inst/extdata/imd-lsoa.xlsx")) {
    download.file(
      paste0("https://www.gov.uk/government/uploads/system/uploads/",
             "attachment_data/file/467764/File_1_ID_2015_Index_of_Multiple_",
             "Deprivation.xlsx"),
      destfile = "inst/extdata/imd-lsoa.xlsx")
  }

  imd_lsoa <- readxl::read_excel("inst/extdata/imd-lsoa.xlsx",
                                 sheet = "IMD 2015") %>%
    select(
      "code" = `LSOA code (2011)`,
      "imd_rank" = `Index of Multiple Deprivation (IMD) Rank (where 1 is most deprived)`,
      "imd_dec"  = `Index of Multiple Deprivation (IMD) Decile (where 1 is most deprived 10% of LSOAs)`
    )

  don_lsoa@data <- don_lsoa@data %>%
    left_join(imd_lsoa, by = "code")

  save(don_lsoa, file = "data/don_lsoa.RData", compress = "xz")
  rm(don_lsoa_data, oa_lsoa, don_lsoa)

}


# Doncaster MSOAs ====
if (!file.exists("data/don_msoa.RData")) {

  load("data/don_oa.RData")

  don_msoa <- don_oa

  oa_msoa <- geolookup::oa_lsoa_msoa_lad

  don_msoa_data <- don_msoa@data %>%
    dplyr::select(-spg_code, -spg_name, -g_code, -g_name, -sb_code, -sb_name,
                  -prison_pop,
                  -codecomm, -namecomm) %>%
    dplyr::inner_join(oa_msoa[, c("oa_cd", "msoa_cd")],
                      by = c("code" = "oa_cd")) %>%
    dplyr::select(-code) %>%
    dplyr::rename(code = msoa_cd) %>%
    dplyr::group_by(code) %>%
    dplyr::summarise_all(sum)

  don_msoa_data <- as.data.frame(don_msoa_data)  # row.names don't work with tbl
  row.names(don_msoa_data) <- don_msoa_data$code

  don_msoa@data <- dplyr::inner_join(don_msoa@data,
                                     oa_msoa[, c("oa_cd", "msoa_cd")],
                                     by = c("code" = "oa_cd"))

  don_msoa <- rgeos::gUnaryUnion(don_msoa, id = don_msoa@data$msoa_cd)

  don_msoa <- sp::SpatialPolygonsDataFrame(don_msoa, don_msoa_data,
                                           match.ID = TRUE)

  stopifnot(
    all.equal(sum(don_oa$llid_cen),   sum(don_msoa$llid_cen)),
    all.equal(sum(don_oa$cen_llid_yes_p), sum(don_msoa$cen_llid_yes_p))
  )

  save(don_msoa, file = "data/don_msoa.RData", compress = "xz")
  rm(don_msoa_data, oa_msoa, don_msoa)

}


# 2001 Westminster Parliamentary Constituencies ====
if (!file.exists("data/bem.RData")) {
  dir.create("inst/extdata/shapefiles/wpc2001/",
             showWarnings = FALSE, recursive = TRUE)

  if (!file.exists("inst/extdata/shapefiles/wpc2001/wpc.zip")) {
    download.file(paste0(
      "https://borders.ukdataservice.ac.uk/ukborders/easy_download/prebuilt/",
      "shape/England_wminsterparl_2001.zip"),
      destfile = "inst/extdata/shapefiles/wpc2001/wpc.zip", method = "wget")
  }

  unzip("inst/extdata/shapefiles/wpc2001/wpc.zip",
        exdir = "inst/extdata/shapefiles/wpc2001/")

  wpc <- rgdal::readOGR("inst/extdata/shapefiles/wpc2001",
                        "england_wminsterparl_2001")

  bem <- wpc[grep("Mexborough", wpc@data$name), ]

  bem <- rmapshaper::ms_simplify(bem, keep = 0.04)
  bem@data$rmapshaperid <- NULL

  save(bem, file = "data/bem.RData", compress = "xz")

}
