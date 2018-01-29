context("Check population functions")

input = data.frame(
  "sex_female" = sample(1:100, 20),
  "sex_male"   = sample(1:100, 20),
  "characters" = sample(letters, 20),
  stringsAsFactors = FALSE
)

output = hrsim::sum_con_rows(input)

test_that("output is a numeric vector", {
  expect_true(is.atomic(output) || is.list(output))
})

test_that("output is correct length", {
  expect_equal(nrow(input), length(output))
})

test_that("output is bigger than either input$sex_ column", {
  expect_gt(sum(output), sum(input$sex_female),
            sum(output), sum(input$sex_female))
})
