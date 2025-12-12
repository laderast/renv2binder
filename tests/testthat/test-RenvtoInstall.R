test_that("Parse lockfile works", {

  data(renv_lock)
  package_frame <- parse_lockfile(renv_lock)
  expect_equal(nrow(package_frame), 5)
  expect_true("package" %in% colnames(package_frame))

})

