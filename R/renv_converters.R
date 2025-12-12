
#' Title
#'
#' @param lockfile - must be a renv lockfile
#' @param file_out - path and file name
#'
#' @returns
#' Side effect: writes a install.R compatible with repo2docker
#' 
#' 
#' @export
#' @examples
renv_to_install_r <- function(lockfile, file_out="install.R") {

  if(!inherits(lockfile, "renv_lockfile")){
    cli::cli_abort("input is not a renv lockfile")
  }

  package_list <- parse_lockfile(lockfile)

  lines_to_write <- glue::glue("install.packages('{package_list$package}', version='{package_list$version}')")
  
  writeLines(lines_to_write, con=file_out)

  cli::cli_alert_success("File is created as {file_out}")
}


parse_lockfile <- function(lockfile) {

  packages <- lockfile$Packages

  version <- unlist(purrr::imap(packages, "Version"))
  packages <- names(version)

  package_frame = data.frame(version=version, package=packages)

  return(package_frame)
}

make_snapshot <- function(path="."){

  renv::snapshot(path)

}

load_renv_lockfile <- function(path="./renv.lock") {

  lockfile <- renv::lockfile_read(path)

  return(lockfile)
}


#' Converts a renv lockfile to a DESCRIPTION file
#'
#' @param lockfile - renv lockfile
#'
#' @returns
#'
#' Writes or appends to a DESCRIPTION file in the current project
#' 
#' @export
#' @examples
renv_to_description <- function(lockfile) {

    if(!inherits(lockfile, "renv_lockfile")){
    cli::cli_abort("input is not a renv lockfile")
  }

  if(!file.exists('DESCRIPTION')){
    usethis::use_description()
  }

  package_frame <- parse_lockfile(lockfile)

  purrr::pwalk(package_frame, add_to_description)

}

add_to_description <- function(package, version){

  usethis::use_package(package=package,
    min_version = version
    )
  cli::cli_alert_success("Package ({package}) (version {{version}}) added to DESCRIPTION")
}