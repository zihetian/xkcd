test_that("xkcd objects have 11 elements", {
  expect_equal(length(xkcd(1)), 11)
})

test_that("xkcd objects are lists",{
  expect_true(is.list(xkcd(1)))
})

test_that("xkcd_objects have class xkcd",{
  expect_equal(class(xkcd(1)), "xkcd")
})

library(vdiffr)

test_that("plotting the first xkcd comic works", {
  expect_doppelganger(
    title = "xkcd 1",
    fig = plot(xkcd(1))
  )
})
