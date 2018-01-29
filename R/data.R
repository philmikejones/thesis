#' sp object of Barnsley East and Mexborough parliamentary constituency
#'
#' A spatialPolygonsDataFrame object with outline of Barnsley East and
#' Mexborough Westminster Parliamentary Constituency based on 2001 boundaries.
#'
#' @format The @data contains the following variables:
#' \describe{
#'   \item{name}{Name of parliamentary constituency}
#'   \item{label}{Label of parliamentary constituency}
#' }
#' @source \url{https://borders.ukdataservice.ac.uk/ukborders/easy_download/prebuilt/}
"bem"

#' sp object to plot Doncaster care homes
#'
#' A spatialPointsDataFrame object of Doncaster care homes, including nursing
#' homes and residential homes (residential homes have no nursing facilities),
#' in British National Grid projection (EPSG:27700).
#'
#' @format The @data contains the following variables:
#' \describe{
#'   \item{name}{Care home name}
#'   \item{postcode}{Postcode of care home}
#'   \item{type}{Type of care home: residential, nursing, or both}
#' }
#' @source Care Quality Commission,
#' (\url{http://www.cqc.org.uk/content/using-cqc-data#directory}),
#' geocoding performed with Google Geocoding API
"care_homes"


#' sp object to plot Doncaster care homes
#'
#' A spatialPointsDataFrame object of Doncaster care homes, including nursing
#' homes and residential homes (residential homes have no nursing facilities),
#' in British National Grid projection (EPSG:27700).
#'
#' @format The @data contains the following variables:
#' \describe{
#'   \item{name}{Doctors surgery name}
#'   \item{postcode}{Postcode of doctor surgery}
#'   \item{type}{Type (used to filter from master cqc file)}
#' }
#' @source Care Quality Commission,
#' (\url{http://www.cqc.org.uk/content/using-cqc-data#directory}),
#' geocoding performed with Google Geocoding API
"doctors"


#' sp object to plot Doncaster community areas
#'
#' A spatialPolygonsDataFrame object of Doncaster community areas.
#' Simplified with rmapshaper::ms_simplify().
#' Obtained by dissolving output areas using 2011 OA > comm lookup table
#'
#' @format The @data contains the following variables:
#' \describe{
#'   \item{comm_code}{Community area code}
#'   \item{comm_name}{Community area name}
#'   \item{pop_16_plus}{Population aged 16 and over at 2011 Census}
#'   \item{pop_65_plus}{Population aged 65 and over at 2011 Census}
#'   \item{llid}{Limiting long-term illness or disability}
#'   \item{unem}{Economically active unemployed}
#'   \item{higher_man_1}{NS-SEC: higher managerial}
#'   \item{lower_man_2}{NS-SEC: lower managerial}
#'   \item{intermediate_3}{NS-SEC: intermediate occupations}
#'   \item{self_emp_4}{NS-SEC: small employers and own-account}
#'   \item{lower_sup_5}{NS-SEC: lower supervisory and technical}
#'   \item{semi_routine_6}{NS-SEC: Semi-routine occupations}
#'   \item{routine_7}{NS-SEC: routine occupations}
#'   \item{lt_unem_8}{NS-SEC: Never worked and long-term unemployed}
#' }
#'
#' @source
#' \itemize{
#'   \item Lookup table private communication from Doncaster council.
#'   \item LLID from 2011 Census
#'   \item Economically active unemployed from Census 2011
#'   \item NS-SEC from 2011 Census
#' }
"don_comm"


#' A list of 4 sp objects containing geographical context for don_outline
#'
#' The 4 shapefiles are:
#'
#' \itemize{
#'   \item don_context[[1]]: mways - motorways - line
#'   \item don_context[[2]]: a_rds - 'A' roads - line
#'   \item don_context[[3]]: p_rds - Primary roads - line
#'   \item don_context[[4]]: urban - urban areas - polygons
#' }
#'
#' @source Ordnance Survey Strategi
#' \url{https://www.ordnancesurvey.co.uk/business-and-government/products/strategi.html}
"don_context"


#' sp object to plot Doncaster LSOAs
#'
#' A spatialPolygonsDataFrame object of Doncaster lower layer super output areas
#' (LSOAs).
#' Simplified with rmapshaper::ms_simplify().
#' Subset from England and Wales output areas obtained from
#' \url{http://geoportal.statistics.gov.uk/datasets/}
#'
#' @format The @data contains the following variables:
#' \describe{
#'   \item{code}{output area code}
#'   \item{pop_16_plus}{Population aged 16 and above at 2011 Census}
#'   \item{pop_65_plus}{Population aged 65 and above at 2011 Census}
#'   \item{llid_cen}{Number of people with a limiting long--term illness or disability taken from 2011 Census, either day--to--day activities limited a lot or a little.}
#'   \item{cen_llid_yes_p}{Proportion (0 <= x <= 1) llid_cen}
#'   \item{imd_rank}{Indices of multiple deprivation 2015 rank (1 is most deprived)}
#'   \item{imd_dec}{Indices of multiple deprivation 2015 decile (1 is most deprived decile)}
#' }
#' @source Output area shapefile from \url{https://census.edina.ac.uk/easy_download_data.html?data=England_oa_2011}.
#' OA to LSOA lookup from ONS using geolookup package (\url{https://github.com/philmikejones/geolookup})
#' IMD from Department for Communities and Local Government English indices of deprivation 2015
"don_lsoa"


#' sp object to plot Doncaster MSOAs
#'
#' A spatialPolygonsDataFrame object of Doncaster middle layer super output
#' areas LSOAs).
#' Simplified with rmapshaper::ms_simplify().
#' Subset from England and Wales output areas obtained from
#' \url{http://geoportal.statistics.gov.uk/datasets/}
#'
#' @format The @data contains the following variables:
#' \describe{
#'   \item{code}{output area code}
#'   \item{pop_16_plus}{Population aged 16 and above at 2011 Census}
#'   \item{pop_65_plus}{Population aged 65 and above at 2011 Census}
#'   \item{llid_cen}{Number of people with a limiting long--term illness or disability taken from 2011 Census, either day--to--day activities limited a lot or a little.}
#'   \item{cen_llid_yes_p}{Proportion (0 <= x <= 1) llid_cen}
#' }
#' @source Output area shapefile from \url{https://census.edina.ac.uk/easy_download_data.html?data=England_oa_2011}.
#' OA to MSOA lookup from ONS using geolookup package (\url{https://github.com/philmikejones/geolookup})
"don_msoa"


#' sp object to plot Doncaster output areas
#'
#' A spatialPolygonsDataFrame object of Doncaster output areas.
#' Simplified with rmapshaper::ms_simplify().
#' Subset from England and Wales output areas obtained from
#' \url{http://geoportal.statistics.gov.uk/datasets/}
#'
#' @format The @data contains the following variables:
#' \describe{
#'   \item{code}{output area code}
#'   \item{spg_code}{Output area classification supergroup code}
#'   \item{spg_name}{Output area classification supergroup name}
#'   \item{g_code}{Output area classification group code}
#'   \item{g_name}{Output area classification group name}
#'   \item{sb_code}{Output area classification subgroup code}
#'   \item{sb_name}{Output area classification subgroup name}
#'   \item{pop_16_plus}{Population aged 16 and above at 2011 Census}
#'   \item{pop_65_plus}{Population aged 65 and above at 2011 Census}
#'   \item{yp_pop}{Population of young people (aged <18)}
#'   \item{prison_pop}{Prisoner population for that output area, NA if no prison (source: Census 2011 obtained from Nomisweb)}
#'   \item{llid_cen}{Number of people with a limiting long--term illness or disability taken from 2011 Census, either day--to--day activities limited a lot or a little.}
#'   \item{cen_llid_yes_p}{Proportion (0 <= x <= 1) llid_cen}
#'   \item{unem}{Number of economically active unemployed}
#'   \item{higher_man_1}{NS-SEC: higher managerial}
#'   \item{lower_man_2}{NS-SEC: lower managerial}
#'   \item{intermediate_3}{NS-SEC: intermediate occupations}
#'   \item{self_emp_4}{NS-SEC: small employers and own-account}
#'   \item{lower_sup_5}{NS-SEC: lower supervisory and technical}
#'   \item{semi_routine_6}{NS-SEC: Semi-routine occupations}
#'   \item{routine_7}{NS-SEC: routine occupations}
#'   \item{lt_unem_8}{NS-SEC: Never worked and long-term unemployed}
#'   \item{codecomm}{Community area code for joining}
#'   \item{namecomm}{Community area name for joining}
#' }
#' @source \itemize{
#'   \item Output area shapefile from \url{https://census.edina.ac.uk/easy_download_data.html?data=England_oa_2011}.
#'   \item Output area classifications from \url{http://webarchive.nationalarchives.gov.uk/20160105160709/http://www.ons.gov.uk/ons/guide-method/geography/products/area-classifications/ns-area-classifications/ns-2011-area-classifications/datasets/index.html}.
#'   \item Prison locations obtained from geocoding postcodes.
#'   \item Economically active unemployed from 2011 Census
#'   \item NS-SEC from 2011 Census
#' }
"don_oa"


#' sp object of Doncaster OA centroids
#'
#' A spatialPointsDataFrame object of Doncaster output area centroids.
#'
#' @format The @data contains the following variables:
#' \describe{
#'   \item{code}{output area code}
#' }
#' @source \itemize{
#'   \item Output area shapefile from \url{https://census.edina.ac.uk/easy_download_data.html?data=England_oa_2011}
#' }
"don_oa_cent"


#' sp object of Doncaster local authority district (LAD)
#'
#' Doncaster local authority district (LADs) saved as a polygon spatial object,
#' including area classifications.
#'
#' @format The @data contains the following variables:
#' \describe{
#'   \item{code}{Local authority district (LAD) code}
#'   \item{name}{LAD name}
#'   \item{region}{Government office region}
#'   \item{supergroup}{Supergroup area classification of the LAD}
#'   \item{group}{Group area classification of the LAD}
#'   \item{subgroup}{Subgroup classification of the LAD}
#' }
#' @source \itemize{
#'   \item Boundary data: \url{https://census.edina.ac.uk/easy_download_data.html?data=infuse_dist_lyr_2011}
#'   \item Area classification: \url{http://www.ons.gov.uk/ons/guide-method/geography/products/area-classifications/ns-area-classifications/ns-2011-area-classifications/datasets/2011-census-data.xls}
#' }
"don_outline"


#' sp object to plot the outline of Great Britain
#'
#' A spatialPolygonsDataFrame object to plot an outline of Great Britain.
#'
#' @format The @data contains the following variables:
#' \describe{
#'   \item{geo_code}{Geography code}
#'   \item{geo_label}{Name or label of the geography}
#'   \item{geo_labelw}{Name or label of the geography in Welsh}
#'   \item{label}{Geography code}
#'   \item{name}{Name of the geography}
#' }
#' @source \url{https://census.edina.ac.uk/easy_download_data.html?data=infuse_gb_2011}
"gb_outline"


#' sp polygons with green spaces
#'
#' A sptialPolygonsDataFrame object with green space in Doncaster
#'
#' @format The @data contains the following variables:
#' \describe{
#'   \item{id}{Unique polygon ID}
#'   \item{type}{Type of green space}
#' }
"gs"


#' sp object to plot Hawaiian archipelago
#'
#' A spatialPolygonsDataFrame object to plot the Hawaiian archipelago.
#'
#' @format The @data contains the following variables:
#' \describe{
#'   \item{ID_1}{State ID}
#'   \item{NAME_1}{State name}
#' }
#' @source \url{http://biogeo.ucdavis.edu/data/diva/adm/USA_adm.zip}
"hawaii"


#' sp object to plot Kauai
#'
#' A spatialPolygonsDataFrame object of Kauai, Hawaii.
#'
#' @format The @data contains the following variables:
#' \itemize{
#'   \item{ID_1}{State ID}
#'   \item{NAME_1}{State name}
#'   \item{ID_2}{County ID}
#'   \item{NAME_2}{County name}
#' }
#' @source Subset from \url{http://biogeo.ucdavis.edu/data/diva/adm/USA_adm.zip}
"kauai"


#' sp object of local authority districts (LADs) in England and Wales
#'
#' Local authority districts (LADs) in England and Wales saved as a polygons
#' spatial object, including area classifications.
#'
#' @format The @data contains the following variables:
#' \describe{
#'   \item{code}{Local authority district (LAD) code}
#'   \item{name}{LAD name}
#'   \item{region}{Government office region}
#'   \item{supergroup}{Supergroup area classification of the LAD}
#'   \item{group}{Group area classification of the LAD}
#'   \item{subgroup}{Subgroup classification of the LAD}
#'   \item{lexp_female}{Life expectancy, females}
#'   \item{lexp_male}{Life expectancy, males}
#'   \item{lim_little}{Day-to-day activities limited a little}
#'   \item{lim_lot}{Day-to-day activities limited a lot}
#'   \item{lim_not}{Day-to-day activities not limited}
#'   \item{v_bad}{Self-reported general health very bad}
#'   \item{bad}{Self-reported general health bad}
#'   \item{fair}{Self-reported general health fair}
#'   \item{good}{Self-reported general health good}
#'   \item{v_good}{Self-reported general health very good}
#'   \item{imd}{Index of multiple deprivation (average for LAD)}
#'   \item{imd_rank}{Rank of index of multiple deprivation (average for LAD)}
#'   \item{unem}{Number of economically active unemployed people at census day 2011}
#'   \item{pop_1000}{Population of LADs in 1,000s (based on srgh)}
#'   \item{bad_over}{Self-reported general health bad overall (bad + v_bad)}
#'   \item{good_over}{SRGH good overall (good + v_good)}
#' }
#' @source \itemize{
#'   \item Boundary data: \url{https://census.edina.ac.uk/easy_download_data.html?data=infuse_dist_lyr_2011}
#'   \item Area classification: \url{http://www.ons.gov.uk/ons/guide-method/geography/products/area-classifications/ns-area-classifications/ns-2011-area-classifications/datasets/2011-census-data.xls}
#'   \item Life expectancy: ONS; Public Health England
#'   \item Limiting long-term illness or disability: Census (Nomis)
#'   \item Self-reported general health: Census (Nomis)
#'   \item IMD: Dept. for Communities and Local Government
#'   \item Economically active unemployed from the census 2011 (Nomis)
#'   \item Population: calculated from census (2011)
#' }
"lads"


#' sp object containing locations of Doncaster leisure centres in BNG
#'
#' sp spatialPointsDataFrame object of leisure centres in Doncaster in
#' British National Grid projection
#' @format The @data slot contains the following variables:
#' \describe{
#'   \item{name}{Leisure centre name}
#' }
#' @source Google Places API
"leisure_centres"


#' Data frame containing lookups between OAs and COMM areas for 2001
#'
#' Data frame containing lookups between output areas and community areas
#' for Doncaster for 2001 geographies
#' @format The data frame containts the following variables:
#' \describe{
#'   \item{oacode}{Output area code}
#'   \item{codecomm}{Community area code}
#'   \item{namecomm}{Community area name}
#' }
"oa_comm_2001_lookup"


#' Data frame containing lookups between OAs and COMM areas for 2011
#'
#' Data frame containing lookups between output areas and community areas
#' for Doncaster for 2011 geographies
#' @format The data frame containts the following variables:
#' \describe{
#'   \item{oacode}{Output area code}
#'   \item{codecomm}{Community area code}
#'   \item{namecomm}{Community area name}
#' }
"oa_comm_2011_lookup"


#' Data frame containing constraints for pilot microsimulation at OA level
#'
#' Data frame containing constraints for pilot microsimulation.
#' Tables are for output areas in Doncaster (978).
#' First column contain the zone (OA) codes, all subsequent columns contain
#' counts.
#'
#' @format The data frame contains the following variables:
#' \describe{
#'   \item{code}{Output area code}
#'   \item{sex_female}{count by sex}
#'   \item{sex_male}{count by sex}
#'   \item{qual_0}{count by highest qualification}
#'   \item{qual_2}{count by highest qualification}
#'   \item{qual_3}{count by highest qualification}
#'   \item{qual_4_plus}{count by highest qualification}
#'   \item{qual_other}{count by highest qualification}
#'   \item{eth_british}{count by ethnicity}
#'   \item{eth_irish}{count by ethnicity}
#'   \item{eth_other_white}{count by ethnicity}
#'   \item{eth_mixed_multiple_ethnic}{count by ethnicity}
#'   \item{eth_asian_asian_british}{count by ethnicity}
#'   \item{eth_black_african_caribbean_british}{count by ethnicity}
#'   \item{eth_other_ethnicity}{count by ethnicity}
#'   \item{ten_owned_outright}{count by tenure}
#'   \item{ten_owned_mortgage_shared}{count by tenure}
#'   \item{ten_rented}{count by tenure}
#'   \item{car_0}{count by car ownership}
#'   \item{car_1}{count by car ownership}
#'   \item{car_2_plus}{count by car ownership}
#'   \item{age_16_17}{count by age}
#'   \item{age_18_19}{count by age}
#'   \item{age_20_24}{count by age}
#'   \item{age_25_29}{count by age}
#'   \item{age_30_44}{count by age}
#'   \item{age_45_59}{count by age}
#'   \item{age_60_64}{count by age}
#'   \item{age_65_74}{count by age}
#'   \item{age_75_84}{count by age}
#'   \item{age_85_89}{count by age}
#'   \item{age_90_plus}{count by age}
#' }
#' @source 2011 Census Tables from Nomisweb
"pilot_con"


#' Data frame containing constraints for pilot microsimulation at LSOA level
#'
#' Data frame containing constraints for pilot microsimulation.
#' Tables are for lower layer super output areas (LSOAs) in Doncaster (194).
#' First column contain the zone (LSOA) codes, all subsequent columns contain
#' counts.
#'
#' @format The data frame contains the following variables:
#' \describe{
#'   \item{code}{LSOA code}
#'   \item{sex_female}{count by sex}
#'   \item{sex_male}{count by sex}
#'   \item{qual_0}{count by highest qualification}
#'   \item{qual_2}{count by highest qualification}
#'   \item{qual_3}{count by highest qualification}
#'   \item{qual_4_plus}{count by highest qualification}
#'   \item{qual_other}{count by highest qualification}
#'   \item{eth_british}{count by ethnicity}
#'   \item{eth_irish}{count by ethnicity}
#'   \item{eth_other_white}{count by ethnicity}
#'   \item{eth_mixed_multiple_ethnic}{count by ethnicity}
#'   \item{eth_asian_asian_british}{count by ethnicity}
#'   \item{eth_black_african_caribbean_british}{count by ethnicity}
#'   \item{eth_other_ethnicity}{count by ethnicity}
#'   \item{ten_owned_outright}{count by tenure}
#'   \item{ten_owned_mortgage_shared}{count by tenure}
#'   \item{ten_rented}{count by tenure}
#'   \item{car_0}{count by car ownership}
#'   \item{car_1}{count by car ownership}
#'   \item{car_2_plus}{count by car ownership}
#'   \item{age_16_17}{count by age}
#'   \item{age_18_19}{count by age}
#'   \item{age_20_24}{count by age}
#'   \item{age_25_29}{count by age}
#'   \item{age_30_44}{count by age}
#'   \item{age_45_59}{count by age}
#'   \item{age_60_64}{count by age}
#'   \item{age_65_74}{count by age}
#'   \item{age_75_84}{count by age}
#'   \item{age_85_89}{count by age}
#'   \item{age_90_plus}{count by age}
#' }
#' @source 2011 Census Tables from Nomisweb
"pilot_con_lsoa"


#' Data frame containing constraints for pilot microsimulation at MSOA level
#'
#' Data frame containing constraints for pilot microsimulation.
#' Tables are for middle layer super output areas (MSOAs) in Doncaster (39).
#' First column contain the zone (MSOA) codes, all subsequent columns contain
#' counts.
#'
#' @format The data frame contains the following variables:
#' \describe{
#'   \item{code}{MSOA code}
#'   \item{sex_female}{count by sex}
#'   \item{sex_male}{count by sex}
#'   \item{qual_0}{count by highest qualification}
#'   \item{qual_2}{count by highest qualification}
#'   \item{qual_3}{count by highest qualification}
#'   \item{qual_4_plus}{count by highest qualification}
#'   \item{qual_other}{count by highest qualification}
#'   \item{eth_british}{count by ethnicity}
#'   \item{eth_irish}{count by ethnicity}
#'   \item{eth_other_white}{count by ethnicity}
#'   \item{eth_mixed_multiple_ethnic}{count by ethnicity}
#'   \item{eth_asian_asian_british}{count by ethnicity}
#'   \item{eth_black_african_caribbean_british}{count by ethnicity}
#'   \item{eth_other_ethnicity}{count by ethnicity}
#'   \item{ten_owned_outright}{count by tenure}
#'   \item{ten_owned_mortgage_shared}{count by tenure}
#'   \item{ten_rented}{count by tenure}
#'   \item{car_0}{count by car ownership}
#'   \item{car_1}{count by car ownership}
#'   \item{car_2_plus}{count by car ownership}
#'   \item{age_16_17}{count by age}
#'   \item{age_18_19}{count by age}
#'   \item{age_20_24}{count by age}
#'   \item{age_25_29}{count by age}
#'   \item{age_30_44}{count by age}
#'   \item{age_45_59}{count by age}
#'   \item{age_60_64}{count by age}
#'   \item{age_65_74}{count by age}
#'   \item{age_75_84}{count by age}
#'   \item{age_85_89}{count by age}
#'   \item{age_90_plus}{count by age}
#' }
#' @source 2011 Census Tables from Nomisweb
"pilot_con_msoa"


#' Pilot individual level (survey) data
#'
#' Individual level survey data from Understanding Society for pilot simulation.
#'
#' @format The data frame contains the following variables:
#' \describe{
#'   \item{pidp}{Unique person ID}
#'   \item{sex}{Sex at most recent wave}
#'   \item{qual}{Highest qualification at most recent wave}
#'   \item{eth}{Ethnic group}
#'   \item{ten}{Tenure at most recent wave}
#'   \item{car}{Number of cars at most recent wave}
#'   \item{age}{Age at most recent wave}
#'   \item{llid}{Limiting long--term illness or disability at most recent wave}
#' }
#'
#' @source \url{https://discover.ukdataservice.ac.uk/catalogue/?sn=6614\&type=Data\%20catalogue}
#'
"pilot_ind"


#' Pilot simulation extracted weights of health conditions at LSOA level.
#'
#' Data frame of results of pilot spatial microsimulation for health conditions
#' at lower layer super ouput area (LSOA) level.
#'
#' @format The data frame contains the following variables:
#' \describe{
#'   \item{code}{Doncaster LSOA code}
#'   \item{total}{Simulated total population}
#'   \item{sex_female}{count by sex}
#'   \item{sex_male}{count by sex}
#'   \item{qual_0}{count by highest qualification}
#'   \item{qual_2}{count by highest qualification}
#'   \item{qual_3}{count by highest qualification}
#'   \item{qual_4_plus}{count by highest qualification}
#'   \item{qual_other}{count by highest qualification}
#'   \item{eth_british}{count by ethnicity}
#'   \item{eth_irish}{count by ethnicity}
#'   \item{eth_other_white}{count by ethnicity}
#'   \item{eth_mixed_multiple_ethnic}{count by ethnicity}
#'   \item{eth_asian_asian_british}{count by ethnicity}
#'   \item{eth_black_african_caribbean_british}{count by ethnicity}
#'   \item{eth_other_ethnicity}{count by ethnicity}
#'   \item{ten_owned_outright}{count by tenure}
#'   \item{ten_owned_mortgage_shared}{count by tenure}
#'   \item{ten_rented}{count by tenure}
#'   \item{car_0}{count by car ownership}
#'   \item{car_1}{count by car ownership}
#'   \item{car_2_plus}{count by car ownership}
#'   \item{age_16_17}{count by age}
#'   \item{age_18_19}{count by age}
#'   \item{age_20_24}{count by age}
#'   \item{age_25_29}{count by age}
#'   \item{age_30_44}{count by age}
#'   \item{age_45_59}{count by age}
#'   \item{age_60_64}{count by age}
#'   \item{age_65_74}{count by age}
#'   \item{age_75_84}{count by age}
#'   \item{age_85_89}{count by age}
#'   \item{age_90_plus}{count by age}
#'   \item{llid_no}{simulated count with LLID}
#'   \item{llid_yes}{simulated count with LLID}
#' }
#' @source 2011 Census Tables from Nomisweb; Understanding Society.
"pilot_lsoa_ext"


#' Pilot simulation extracted weights of health conditions at MSOA level.
#'
#' Data frame of results of pilot spatial microsimulation for health conditions
#' at middle layer super ouput area (MSOA) level.
#'
#' @format The data frame contains the following variables:
#' \describe{
#'   \item{code}{Doncaster LSOA code}
#'   \item{total}{Simulated total population}
#'   \item{sex_female}{count by sex}
#'   \item{sex_male}{count by sex}
#'   \item{qual_0}{count by highest qualification}
#'   \item{qual_2}{count by highest qualification}
#'   \item{qual_3}{count by highest qualification}
#'   \item{qual_4_plus}{count by highest qualification}
#'   \item{qual_other}{count by highest qualification}
#'   \item{eth_british}{count by ethnicity}
#'   \item{eth_irish}{count by ethnicity}
#'   \item{eth_other_white}{count by ethnicity}
#'   \item{eth_mixed_multiple_ethnic}{count by ethnicity}
#'   \item{eth_asian_asian_british}{count by ethnicity}
#'   \item{eth_black_african_caribbean_british}{count by ethnicity}
#'   \item{eth_other_ethnicity}{count by ethnicity}
#'   \item{ten_owned_outright}{count by tenure}
#'   \item{ten_owned_mortgage_shared}{count by tenure}
#'   \item{ten_rented}{count by tenure}
#'   \item{car_0}{count by car ownership}
#'   \item{car_1}{count by car ownership}
#'   \item{car_2_plus}{count by car ownership}
#'   \item{age_16_17}{count by age}
#'   \item{age_18_19}{count by age}
#'   \item{age_20_24}{count by age}
#'   \item{age_25_29}{count by age}
#'   \item{age_30_44}{count by age}
#'   \item{age_45_59}{count by age}
#'   \item{age_60_64}{count by age}
#'   \item{age_65_74}{count by age}
#'   \item{age_75_84}{count by age}
#'   \item{age_85_89}{count by age}
#'   \item{age_90_plus}{count by age}
#'   \item{llid_no}{simulated count with LLID}
#'   \item{llid_yes}{simulated count with LLID}
#' }
#' @source 2011 Census Tables from Nomisweb; Understanding Society.
"pilot_msoa_ext"


#' Pilot simulation (fractional weights) results of health conditions at output
#' area level.
#'
#' Data frame of fractional weights from pilot spatial microsimulation for
#' health conditions at ouput area level.
#'
#' @format The data frame contains the following variables:
#' \describe{
#'   \item{code}{Doncaster output area code}
#'   \item{total}{Simulated total population}
#'   \item{sex_female}{count by sex}
#'   \item{sex_male}{count by sex}
#'   \item{qual_0}{count by highest qualification}
#'   \item{qual_2}{count by highest qualification}
#'   \item{qual_3}{count by highest qualification}
#'   \item{qual_4_plus}{count by highest qualification}
#'   \item{qual_other}{count by highest qualification}
#'   \item{eth_british}{count by ethnicity}
#'   \item{eth_irish}{count by ethnicity}
#'   \item{eth_other_white}{count by ethnicity}
#'   \item{eth_mixed_multiple_ethnic}{count by ethnicity}
#'   \item{eth_asian_asian_british}{count by ethnicity}
#'   \item{eth_black_african_caribbean_british}{count by ethnicity}
#'   \item{eth_other_ethnicity}{count by ethnicity}
#'   \item{ten_owned_outright}{count by tenure}
#'   \item{ten_owned_mortgage_shared}{count by tenure}
#'   \item{ten_rented}{count by tenure}
#'   \item{car_0}{count by car ownership}
#'   \item{car_1}{count by car ownership}
#'   \item{car_2_plus}{count by car ownership}
#'   \item{age_16_17}{count by age}
#'   \item{age_18_19}{count by age}
#'   \item{age_20_24}{count by age}
#'   \item{age_25_29}{count by age}
#'   \item{age_30_44}{count by age}
#'   \item{age_45_59}{count by age}
#'   \item{age_60_64}{count by age}
#'   \item{age_65_74}{count by age}
#'   \item{age_75_84}{count by age}
#'   \item{age_85_89}{count by age}
#'   \item{age_90_plus}{count by age}
#'   \item{llid_no}{simulated count with LLID}
#'   \item{llid_yes}{simulated count with LLID}
#' }
#' @source Spatial microsimulation from 2011 Census Tables from Nomisweb and
#' Understanding Society.
"pilot_oa_ext"


#' Pilot simulation integerised results of health conditions at output area
#' level.
#'
#' Data frame of results of pilot spatial microsimulation for health conditions
#' at ouput area level.
#'
#' @format The data frame contains the following variables:
#' \describe{
#'   \item{pidp}{ID from Understanding Society}
#'   \item{sex}{Sex (male or female)}
#'   \item{qual}{Highest qualification}
#'   \item{eth}{Ethnicity (reduced categories)}
#'   \item{ten}{Housing tenure}
#'   \item{car}{Car ownership}
#'   \item{age}{Age (banded categories)}
#'   \item{llid}{Limiting long--term illness or disability}
#'   \item{zone}{Output area}
#' }
#' @source 2011 Census Tables from Nomisweb; Understanding Society.
"pilot_oa_int"


#' Data frame containing individual-level data for resilience simulation.
#'
#' Data frame containing individual-level survery data for resilience
#' simulation.
#'
#' @format The data frame contains the following variables:
#' \describe{
#'   \item{pidp}{Unique person ID}
#'   \item{car}{Number of cars at most recent wave}
#'   \item{ten}{Tenure at most recent wave}
#'   \item{qual}{Highest qualification at most recent wave}
#'   \item{mar}{Marital status}
#'   \item{eca}{Economic activity}
#'   \item{sex}{Sex at most recent wave}
#'   \item{eth}{Ethnic group}
#'   \item{age}{Age at most recent wave}
#'   \item{depress}{Clinical depression self-reported}
#'   \item{nhood_coh}{Neighbourhood cohesion (similar to others in neighbourhood)}
#'   \item{nhood_trust}{Neighbourhood trust}
#'   \item{nhood_belong}{Belong to neighbourhood}
#'   \item{fin_sit}{Subjective current financial situation}
#'   \item{ghq_conc}{GHQ: concentration}
#'   \item{ghq_sleep}{GHQ: sleep loss}
#'   \item{ghq_useful}{GHQ: felt useful}
#'   \item{ghq_decision}{GHQ: can make decisions}
#'   \item{ghq_strain}{GHQ: Under strain}
#'   \item{ghq_diff}{GHQ: Problems overcoming difficulties}
#'   \item{ghq_enjoy}{GHQ: enjoy day-to-day activities}
#'   \item{ghq_face}{GHQ: able to face problems}
#'   \item{ghq_unhappy}{GHQ: unhappy or depressed}
#'   \item{ghq_confid}{GHQ: losing confidence}
#'   \item{ghq_worth}{GHQ: believe worthless}
#'   \item{ghq_happy}{GHQ: general happiness}
#'   \item{kids}{Number of children aged 0-15 in household}
#'   \item{hh_income}{Gross household income month before interview}
#'   \item{poverty}{Is household in poverty (less than 60\% median income)?}
#'   \item{alcohol}{Alcohol consumption}
#' }
#'
#' @source \url{https://discover.ukdataservice.ac.uk/catalogue/?sn=6614\&type=Data\%20catalogue}
#'
"res_ind"


#' Data frame containing constraints for microsimulation at OA level
#'
#' Data frame containing constraints for microsimulation.
#' Tables are for output areas in Doncaster (978).
#' First column contain the zone (OA) codes, all subsequent columns contain
#' counts.
#'
#' @format The data frame contains the following variables:
#' \describe{
#'   \item{code}{Output area code}
#'   \item{sex_female}{count by sex}
#'   \item{sex_male}{count by sex}
#'   \item{qual_0}{count by highest qualification}
#'   \item{qual_2}{count by highest qualification}
#'   \item{qual_3}{count by highest qualification}
#'   \item{qual_4_plus}{count by highest qualification}
#'   \item{qual_other}{count by highest qualification}
#'   \item{eth_british}{count by ethnicity}
#'   \item{eth_irish}{count by ethnicity}
#'   \item{eth_other_white}{count by ethnicity}
#'   \item{eth_mixed_multiple_ethnic}{count by ethnicity}
#'   \item{eth_asian_asian_british}{count by ethnicity}
#'   \item{eth_black_african_caribbean_british}{count by ethnicity}
#'   \item{eth_other_ethnicity}{count by ethnicity}
#'   \item{ten_owned_outright}{count by tenure}
#'   \item{ten_owned_mortgage_shared}{count by tenure}
#'   \item{ten_rented}{count by tenure}
#'   \item{car_0}{count by car ownership}
#'   \item{car_1}{count by car ownership}
#'   \item{car_2_plus}{count by car ownership}
#'   \item{age_16_17}{count by age}
#'   \item{age_18_19}{count by age}
#'   \item{age_20_24}{count by age}
#'   \item{age_25_29}{count by age}
#'   \item{age_30_44}{count by age}
#'   \item{age_45_59}{count by age}
#'   \item{age_60_64}{count by age}
#'   \item{age_65_74}{count by age}
#'   \item{age_75_84}{count by age}
#'   \item{age_85_89}{count by age}
#'   \item{age_90_plus}{count by age}
#'   \item{eca_emp}{Economic activity: Employed (full-time or part-time)}
#'   \item{eca_homefam}{Economic activity: looking after home or family}
#'   \item{eca_ltsick}{Economic activity: long-term sick}
#'   \item{eca_other}{Economic activity: other}
#'   \item{eca_retired}{Economic activity: retired}
#'   \item{eca_selfemp}{Economic activity: self-employed}
#'   \item{eca_student}{Economic activity: student}
#'   \item{eca_unemp}{Economic activity: unemployed}
#'   \item{mar_civil_part}{Civil partnership}
#'   \item{mar_divorced}{Divorced}
#'   \item{mar_married}{Married}
#'   \item{mar_separated}{Separated (still legally married/civil partnership)}
#'   \item{mar_single}{Single (never married)}
#'   \item{mar_widowed}{Widowed}
#' }
#' @source 2011 Census Tables from Nomisweb
"res_con"


#' Simulation (fractional weight) results of health resilience at output
#' area level.
#'
#' Data frame of fractional weights from resilience spatial microsimulation for
#' health conditions at ouput area level.
#'
#' @format The data frame contains the following variables:
#' \describe{
#'   \item{code}{Doncaster output area code}
#'   \item{total}{Simulated total population}
#'   \item{car_0}{count by car ownership}
#'   \item{car_1}{count by car ownership}
#'   \item{car_2_plus}{count by car ownership}
#'   \item{ten_owned_outright}{count by tenure}
#'   \item{ten_owned_mortgage_shared}{count by tenure}
#'   \item{ten_rented}{count by tenure}
#'   \item{qual_0}{count by highest qualification}
#'   \item{qual_2}{count by highest qualification}
#'   \item{qual_3}{count by highest qualification}
#'   \item{qual_4_plus}{count by highest qualification}
#'   \item{qual_other}{count by highest qualification}
#'   \item{mar_civil_part}{Marital status: civil partnership}
#'   \item{mar_divorced}{Marital status: divorced}
#'   \item{mar_married}{Marital status: married}
#'   \item{mar_separated}{Marital status: separated}
#'   \item{mar_single}{Marital status: single (never married)}
#'   \item{mar_widowed}{Marital status: Widowed or widower}
#'   \item{eca_emp}{Employed}
#'   \item{eca_homefam}{Looking after home or family}
#'   \item{eca_ltsick}{Long-term sick or disabled}
#'   \item{eca_other}{Other economic activity}
#'   \item{eca_retired}{Retired}
#'   \item{eca_selfemp}{Self-employed}
#'   \item{eca_student}{Student}
#'   \item{eca_unemp}{Unemployed (looking for work or ready to start job)}
#'   \item{sex_female}{count by sex}
#'   \item{sex_male}{count by sex}
#'   \item{eth_asian_asian_british}{count by ethnicity}
#'   \item{eth_black_african_caribbean_british}{count by ethnicity}
#'   \item{eth_british}{count by ethnicity}
#'   \item{eth_irish}{count by ethnicity}
#'   \item{eth_mixed_multiple_ethnic}{count by ethnicity}
#'   \item{eth_other_ethnicity}{count by ethnicity}
#'   \item{eth_other_white}{count by ethnicity}
#'   \item{age_16_17}{count by age}
#'   \item{age_18_19}{count by age}
#'   \item{age_20_24}{count by age}
#'   \item{age_25_29}{count by age}
#'   \item{age_30_44}{count by age}
#'   \item{age_45_59}{count by age}
#'   \item{age_60_64}{count by age}
#'   \item{age_65_74}{count by age}
#'   \item{age_75_84}{count by age}
#'   \item{age_85_89}{count by age}
#'   \item{age_90_plus}{count by age}
#'   \item{depress_no}{No depression}
#'   \item{depress_yes}{Clinical depression}
#'   \item{ncoh_no}{Neighbourhood cohesion: no}
#'   \item{ncoh_yes}{Neighbourhood cohesion}
#'   \item{trust_no}{Neighbourhood trust: no}
#'   \item{trust_yes}{Neighbourhood trust}
#'   \item{belong_no}{Do not belong to neighbourhood}
#'   \item{belong_yes}{Belong to neighbourhood}
#'   \item{fin_bad}{Subjective financial situation: not good}
#'   \item{fin_good}{Subjective financial situation: managing or comfortable}
#'   \item{ghq_conc_bad}{GHQ concentration: bad}
#'   \item{ghq_conc_good}{GHQ concentration: good}
#'   \item{ghq_sleep_bad}{GHQ sleep loss: bad}
#'   \item{ghq_sleep_good}{GHQ sleep loss: good}
#'   \item{ghq_useful_bad}{GHQ play useful role: bad}
#'   \item{ghq_useful_good}{GHQ play useful role: good}
#'   \item{ghq_decision_bad}{GHQ can make decisions: bad}
#'   \item{ghq_decision_good}{GHQ can make decisions: good}
#'   \item{ghq_strain_bad}{GHQ constantly under strain: bad}
#'   \item{ghq_strain_good}{GHQ constantly under strain: good}
#'   \item{ghq_diff_bad}{GHQ problems overcoming difficulties: bad}
#'   \item{ghq_diff_good}{GHQ problems overcoming difficulties: good}
#'   \item{ghq_enjoy_bad}{GHQ enjoy day-to-day activities: bad}
#'   \item{ghq_enjoy_good}{GHQ enjoy day-to-day activities: good}
#'   \item{ghq_face_bad}{GHQ able to face problems: bad}
#'   \item{ghq_face_good}{GHQ able to face problems: good}
#'   \item{ghq_unhappy_bad}{GHQ unhappy or depressed: bad}
#'   \item{ghq_unhappy_good}{GHQ unhappy or depressed: good}
#'   \item{ghq_confid_bad}{GHQ losing confidence: bad}
#'   \item{ghq_confid_good}{GHQ losing confidence: good}
#'   \item{ghq_worth_bad}{GHQ believe worthless: bad}
#'   \item{ghq_worth_good}{GHQ believe worthless: good}
#'   \item{ghq_happy_bad}{GHQ general happiness: bad}
#'   \item{ghq_happy_good}{GHQ general happiness: good}
#'   \item{alcohol_high}{Alcohol consumption: high risk(>14 units/week)}
#'   \item{alcohol_low}{Alcohol consumption: low risk (<=14 units/week)}
#' }
#' @source Spatial microsimulation from 2011 Census Tables from Nomisweb and
#' Understanding Society.
"res_weights_ext"


#' sp object to plot South Yorkshire
#'
#' A spatialPolygons object (i.e. no DataFrame) to plot the boundary of the
#' historic county of South Yorkshire to show Doncaster in context
#'
#' @source \url{https://census.edina.ac.uk/easy_download_data.html?data=England_ct_2011}
"sy_county"


#' Understanding Society data set
#'
#' Understanding Society data frame
#'
#' @format The data frame contains the following variables:
#' \describe{
#'   \item{pidp}{Unique person ID}
#'   \item{f_hidp}{f_ household id}
#'   \item{e_hidp}{e_ household id}
#'   \item{d_hidp}{d_ household id}
#'   \item{c_hidp}{c_ household id}
#'   \item{b_hidp}{b_ household id}
#'   \item{a_hidp}{a_ household id}
#'   \item{region}{Government Office Region at latest wave}
#'   \item{age_full}{Age (individual years)}
#'   \item{age}{Age at most recent wave, cut into bands to match census tables}
#'   \item{sex}{Sex at most recent wave}
#'   \item{eth_full}{Ethnic group}
#'   \item{eth_minority}{Is respondent White British or minority (TRUE)}
#'   \item{eth}{Ethnicity, reduced categories to match census}
#'   \item{qual}{Highest qualification at most recent wave}
#'   \item{car}{Number of cars at most recent wave}
#'   \item{heat}{Central heating at most recent wave}
#'   \item{ten_full}{Tenure at most recent wave}
#'   \item{ten}{Housing tenure at most recent wave, reduced categories to match census}
#'   \item{econ_act}{Economic activity}
#'   \item{ocrowd}{Live in overcrowded house (more than one person per room)?}
#'   \item{llid}{Limiting long--term illness or disability at most recent wave}
#'   \item{srgh}{Self--reported general health at most recent wave}
#'   \item{class8}{Class (NS--SEC 8) at most recent wave}
#'   \item{marital}{Marital status}
#'   \item{couple}{Cohabiting as part of a couple (married or otherwise)?}
#'   \item{nhood_coh}{Neighbourhood cohesion (similar to others in neighbourhood)}
#'   \item{nhood_trust}{Neighbourhood trust}
#'   \item{nhood_belong}{Belong to neighbourhood}
#'   \item{civic}{Civic participation (active in community org)}
#'   \item{social_coh}{Social cohesion (people get along)}
#'   \item{safe_alone}{Feel safe going out alone at night}
#'   \item{sim_inc}{Proportion friends similar income}
#'   \item{sim_eth}{Proportion friends similar ethnicity}
#'   \item{pol_eff}{Political efficacy: make a difference}
#'   \item{fin_sit}{Subjective current financial situation}
#'   \item{soc_isol}{Socially isolated}
#'   \item{ghq_conc}{GHQ: concentration}
#'   \item{ghq_sleep_loss}{GHQ: sleep loss}
#'   \item{ghq_useful}{GHQ: felt useful}
#'   \item{ghq_decision}{GHQ: can make decisions}
#'   \item{ghq_strain}{GHQ: Under strain}
#'   \item{ghq_difficult}{GHQ: Problems overcoming difficulties}
#'   \item{ghq_enjoy}{GHQ: enjoy day-to-day activities}
#'   \item{ghq_face}{GHQ: able to face problems}
#'   \item{ghq_unhappy}{GHQ: unhappy or depressed}
#'   \item{ghq_confidence}{GHQ: losing confidence}
#'   \item{ghq_selfworth}{GHQ: believe worthless}
#'   \item{ghq_happiness}{GHQ: general happiness}
#'   \item{cig}{Smoke cigarettes: yes or no}
#'   \item{alcohol}{Alcohol consumption}
#'   \item{bf_dist}{Distance to closest friend (<1 mile)}
#'   \item{bf_often}{Frequency see best friend {>1/week}}
#'   \item{save}{Save money?}
#'   \item{nkids}{Number of children aged <16 in the household (integer)}
#'   \item{kids}{Number of children aged <16 in the household (factor)}
#'   \item{hh_income}{Gross household income month before interview (top-coded
#'   to £20,000 per month)}
#'   \item{cohab}{Number of cohabitants (i.e. hhsize - respondent)}
#'   \item{depress}{Clinical depression}
#'   \item{ihd}{Ischemic heart disease or stroke (air pollution marker)}
#'   \item{prob_pay}{Problems paying housing costs (rent/mortgage)}
#'   \item{hh_cost}{Monthly housing cost (rent/mortgage)}
#'   \item{uc_replace}{Receives benefit being replaced by Universal Credit
#'   (JSA, income support, ESA, tax credits)?}
#' }
#'
#' @source \url{https://discover.ukdataservice.ac.uk/catalogue/?sn=6614\&type=Data\%20catalogue}
#'
"us"


#' sp object outline of the Yorkshire and The Humber region
#'
#' A spatialPolygonsDataFrame object of the outline of the Yorkshire and The
#' Humber region, subset from all English government office regions (GOR).
#'
#' @format The @data contains the following variables:
#' \describe{
#'   \item{code}{Geography code}
#'   \item{name}{Name or label of the geography}
#'   \item{label}{Geography code}
#' }
#' @source \url{https://census.edina.ac.uk/easy_download_data.html?data=England_gor_2011}
"yh_region"
