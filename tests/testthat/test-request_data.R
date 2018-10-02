library(earthEngineGrabR)

context("Test EE request functionality")


test_that("test that get_data processes data on earth engine and exports it to drive while returning status of process", {
  skip_test_if_not_possible()
  activate_environments()
  
  df <- create_image_product(
        productID = "CGIAR/SRTM90_V4",
        productName = "test_SRTM"
        )

  df$ft_id = get_ft_id_gd("test-data")
  delete_on_drive(df$productNameFull)

  status <- get_data(df)
  expect_named(status, c("creation_timestamp_ms", "state", "task_type", "description", "id", "update_timestamp_ms"))
  test <- wait_for_file_on_drive(df$productNameFull, verbose = F)
  expect_true(test)
})


test_that("test that reguest_data processes multiple data products on earth engine and exports it to drive while returning status of process", {
  skip_test_if_not_possible()
  activate_environments()

  df <- list(
    create_image_product(
      productID = "CGIAR/SRTM90_V4",
      productName = "test_SRTM"),
    create_collection_product(
      timeStart = "2017-01-01", 
      timeEnd = "2017-01-20")
  )
  
  ft_id = get_ft_id_gd("test-data")

  delete_on_drive(df[[1]]$productNameFull)
  delete_on_drive(df[[2]]$productNameFull)
  status <- request_data(df, ft_id)
  
  test_1 <- wait_for_file_on_drive(df[[1]]$productNameFull, verbose = F)
  test_2 <- wait_for_file_on_drive(df[[2]]$productNameFull, verbose = F)
  
  expect_true(test_1 & test_2)
  expect_length(status, 2)
})


test_that("test that get_data raises a meaninfull message whitout crashing", {
  skip_test_if_not_possible()
  activate_environments()
  
  # wrong product ID
  df <- create_image_product(
    productID = "CGIAR/wrong",
    productName = "test_SRTM"
  )
  df$ft_id = get_ft_id_gd("test-data")

  status <- get_data(df)
  expect_match(status, "Error")  
  expect_match(status, "Image asset 'CGIAR/wrong' not found")  
  
  # wrong product ID
  df <- create_collection_product(
    productName = "test_chirps", 
    timeStart = "1950-01-01",
    timeEnd = "1955-01-01"
    )
  
  df$ft_id = get_ft_id_gd("test-data")

  status <- get_data(df)
  expect_match(status, "Error")  
  expect_match(status, "No images found with the given daterange")  
})


test_that("test that request_data return anly the valid exports and gives warings no errors with wrong input", {
  skip_test_if_not_possible()
  activate_environments()
  df <- list(
    create_image_product(
      productID = "CGIAR/SRTM90_V4",
      productName = "test_SRTM"),
    create_collection_product(
      timeStart = "2050-01-01", 
      timeEnd = "2051-01-20"),
    create_image_product(
      productID = "CGIAR/SRTM90_V4",
      productName = "test_SRTM_2")
  )
  
  ft_id = get_ft_id_gd("test-data")
  
  status <- expect_warning(request_data(df, ft_id))

  expect_true(sum(is.na(status)) == 0)
  expect_length(status, 2)
  
})


googledrive::drive_rm("earthEngineGrabR-tmp", verbose = F)





