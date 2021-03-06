
# Sys.setenv("NOT_CRAN" = "false")
# if (!identical(Sys.getenv("NOT_CRAN"), "false")) {

context("Set up test environment")

activate_environments()
googledrive::drive_rm("earthEngineGrabR-tmp", verbose = F)

# test_that("activate test environment",{
#   skip_on_cran()
#   # skip_if_not_installed("sf")
# })

#test_that("Test that required credentials exist", {
  credentials_test <- try(earthEngineGrabR:::test_credentials(), silent = T)
  expect_true(credentials_test)
#})


#test_that("Test that required python modules can be loaded", {
  #skip_on_cran()
  earthEngineGrabR:::activate_environments()
  
  module_test_ee <- py_module_available("ee")
  expect_true(module_test_ee)

#})

#test_that("Test that required testing files on google drive exist", {
  #skip_on_cran()
  #earthEngineGrabR:::activate_environments()
  
  # if test-download data not on google drive upload it.
  try(earthEngineGrabR:::gd_auth(), silent = T)
  test <- googledrive::drive_find("CGIAR-SRTM90_V4_s-mean.geojson", verbose = F)
  environment_test <- try(nrow(test) > 0, silent = T)
  if (!environment_test) stop(paste("Testing is not possible. \n", "files on google drive: ", environment_test))
#})



#test_that("upload files", {
  #skip_on_cran()
  #earthEngineGrabR:::activate_environments()
  
# build environment
# remove upload files if still present
#googledrive::drive_rm("test-upload", verbose = F)

# upload test data for download test


# if tmp dir exists delete it
#})


#}
