% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/test_assoc.R
\name{test_assoc}
\alias{test_assoc}
\title{test_assoc}
\usage{
test_assoc(x, y)
}
\arguments{
\item{x}{a vector to compare to `y`}

\item{y}{a vector to compare to `x`}
}
\value{
Either a Fisher exact test if any cells n < 1 or more than 20% cells < 5.
Else returns a chi-squared (parametric test).
}
\description{
test_assoc
}
