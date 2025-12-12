## code to prepare `renv.lock` dataset goes here

renv_lock <- renv::lockfile_read("data-raw/renv.lock")
renv_lock$Packages <- renv_lock$Packages[1:5]

usethis::use_data(renv_lock, overwrite = TRUE)
