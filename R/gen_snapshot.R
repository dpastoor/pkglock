#' generate a lockfile from a requested set of packages
#' @param pkgs packages to install
#' @param .dir directory to use when generating the snapshot details
#' @param snapshot_tars whether to snapshot the tars 
#' @param ... params for packrat settings
#' @importFrom fs dir_exists dir_create
#' @export
#' @details 
#' generate a packrat snapshot from a requested set of
#' packages by mocking a project folder and letting
#' packrat scan and generate a lockfile
gen_snapshot <- function(pkgs, .dir = tempdir(), snapshot_tars = TRUE, ...) {
  if (!length(pkgs)) {
    stop("must define at least one package to snapshot")
  }
  tmppkg <- file.path(.dir, "pkglock_gen")
  if (!dir_exists(tmppkg)) {
    dir_create(tmppkg, recursive = TRUE)
  }
  
  tardir <- if (snapshot_tars) {
    file.path(tmppkg, "packrat", "src")
  } else {
    NULL 
  } 
  pkgtext <- sprintf("library(%s)", pkgs)
  writeLines(pkgtext, file.path(tmppkg, "packages.R"))
  
  dir_create(fs::path(tmppkg, "packrat"), recursive = TRUE)
  write_packrat_opts(packrat_settings(...), 
                     fs::path(tmppkg, "packrat", "packrat.opts"))
  # will eventually need to wrap this in a try block
  # snapshot will track the metadata about what the lockfile results found
  snapshot <- packrat::snapshot(tmppkg, snapshot.sources = snapshot_tars, prompt = FALSE)
  
  # packrat will have created a new dir called packrat with a packrat.lock
  # file
  lockfile <- readLines(file.path(tmppkg, "packrat", "packrat.lock"))
  
  return(list(metadata = snapshot,
              lockfile = lockfile, 
              tardir = tardir))
}