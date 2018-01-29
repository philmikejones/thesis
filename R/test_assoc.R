#' test_assoc
#'
#' @param x a vector to compare to `y`
#' @param y a vector to compare to `x`
#'
#' @return Either a Fisher exact test if any cells n < 1 or more than 20% cells < 5.
#' Else returns a chi-squared (parametric test).
#'
#' @export
#'
test_assoc <- function (x, y) {

  if (length(x) != length(y)) {

    stop("x and y vector not equal length")

  }

  if (any(is.na(x)) | any(is.na(y))) {

    stop("NA values present. Remove?")

  }

  # Tabulate results

  tab <- table(x, y, useNA = "no")

  # Check expected counts

  expected <- stats::chisq.test(tab)

  if (any(expected$expected < 5)) {

    fisher_test = TRUE

  } else if ((length(expected$expected < 5) /
              length(expected$expected)) >= 0.2) {

    fisher_test = TRUE

  } else {

    fisher_test = FALSE

  }

  # Carry out appropriate test

  if (fisher_test) {

    result <- stats::fisher.test(tab, simulate.p.value = TRUE)

  } else {

    result <- stats::chisq.test(tab)

  }

  result

}
