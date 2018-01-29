context("Check test_assoc function output")

set.seed(42)
x <- sample(1:100, size = 20, replace = TRUE)
y <- sample(1:100, size = 20, replace = TRUE)

test_that("test_assoc output is correct", {
  expect_equal(suppressWarnings(test_assoc(x, y)[["p.value"]]), 1)
})

x <- sample(1:100, size = 20, replace = TRUE)
y <- sample(1:100, size = 19, replace = TRUE)

test_that("function stops as vector lengths not equal", {
  expect_error(test_assoc(x, y))
})
