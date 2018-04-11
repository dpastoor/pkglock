#' generate a lockfile from a requested set of packages
#' @param pkgs packages to install
#' @param snapshot_tars snapshot the tars 
#' @export
#' @details 
#' generate a packrat snapshot from a requested set of
#' packages by mocking a project folder and letting
#' packrat scan and generate a lockfile
gen_snapshot <- function(pkgs, .dir = tempdir(), snapshot_tars = FALSE) {
  if (!length(pkgs)) {
    stop("must define at least one package to snapshot")
  }
  tmppkg <- file.path(.dir, "pkglock_gen")
  if (!dir.exists(tmppkg)) {
    dir.create(tmppkg, recursive = TRUE)
  }
  
  pkgtext <- sprintf("library(%s)", pkgs)
  writeLines(pkgtext, file.path(tmppkg, "packages.R"))
  # will eventually need to wrap this in a try block
  # snapshot will track the metadata about what the lockfile results found
  snapshot <- packrat::.snapshotImpl(tmppkg, snapshot.sources = snapshot_tars)
  
  # packrat will have created a new dir called packrat with a packrat.lock
  # file
  lockfile <- readLines(file.path(tmppkg, "packrat", "packrat.lock"))
  
  return(list(metadata = snapshot,
              lockfile = lockfile))
}