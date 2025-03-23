# Load testthat and your package

test_that("fetch_historic returns a valid data.frame", {
  skip_on_cran()  # Ignore ce test sur CRAN
  symbols <- c("VOLCAR-B.ST", "SAAB-B.ST")
  result <- fetch_historic(symbols)

  # Vérification que le résultat est bien un data.frame
  expect_s3_class(result, "data.frame")

  # Vérification des colonnes attendues
  expected_cols <- c("low", "high", "close", "open", "volume", "adjclose",
                     "timestamp", "date", "symbol", "shortname",
                     "exchangename", "fullexchangename", "timezone")
  expect_true(all(expected_cols %in% colnames(result)))
})

test_that("fetch_historic handles empty symbols input", {
  skip_on_cran()  # Ignore ce test sur CRAN
  result <- fetch_historic(symbols = character(0))

  # Vérifie que le résultat est vide
  expect_true(is.null(result))
})

test_that("fetch_historic handles non-existent symbols", {
  skip_on_cran()  # Ignore ce test sur CRAN
  result <- fetch_historic(symbols = c("INVALID-SYMBOL"))

  # Vérifie que la réponse est vide ou une structure connue en cas d'erreur
  expect_true(is.na(result)|| is.null(result))
})

test_that("fetch_historic respects .verbose parameter", {
  skip_on_cran()  # Ignore ce test sur CRAN
  expect_silent(fetch_historic(symbols = c("SAAB-B.ST"), .verbose = FALSE))
})

test_that("fetch_historic handles wait.time correctly", {
  skip_on_cran()  # Ignore ce test sur CRAN
  start_time <- Sys.time()
  fetch_historic(symbols = c("SAAB-B.ST"), wait.time = 2)
  end_time <- Sys.time()

  # Vérifie que la fonction a bien attendu environ 2 secondes
  expect_gte(as.numeric(difftime(end_time, start_time, units = "secs")), 2)
})
