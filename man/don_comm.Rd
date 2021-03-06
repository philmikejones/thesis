% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{don_comm}
\alias{don_comm}
\title{sp object to plot Doncaster community areas}
\format{The @data contains the following variables:
\describe{
  \item{comm_code}{Community area code}
  \item{comm_name}{Community area name}
  \item{pop_16_plus}{Population aged 16 and over at 2011 Census}
  \item{pop_65_plus}{Population aged 65 and over at 2011 Census}
  \item{llid}{Limiting long-term illness or disability}
  \item{unem}{Economically active unemployed}
  \item{higher_man_1}{NS-SEC: higher managerial}
  \item{lower_man_2}{NS-SEC: lower managerial}
  \item{intermediate_3}{NS-SEC: intermediate occupations}
  \item{self_emp_4}{NS-SEC: small employers and own-account}
  \item{lower_sup_5}{NS-SEC: lower supervisory and technical}
  \item{semi_routine_6}{NS-SEC: Semi-routine occupations}
  \item{routine_7}{NS-SEC: routine occupations}
  \item{lt_unem_8}{NS-SEC: Never worked and long-term unemployed}
}}
\source{
\itemize{
  \item Lookup table private communication from Doncaster council.
  \item LLID from 2011 Census
  \item Economically active unemployed from Census 2011
  \item NS-SEC from 2011 Census
}
}
\usage{
don_comm
}
\description{
A spatialPolygonsDataFrame object of Doncaster community areas.
Simplified with rmapshaper::ms_simplify().
Obtained by dissolving output areas using 2011 OA > comm lookup table
}
\keyword{datasets}
