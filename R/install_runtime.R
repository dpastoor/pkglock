#' install from a runtime description
#' @param .d description file
#' @param .dir directory to install pkgs from description
#' @param snapshot_sources snapshot the library source tarballs
#' @param threads threads during install 
#' @param repos repositories to check for available packages
#' @details 
#' .install should almost always be set to true, the time to set to false
#' is if a full install was completed, however some tweak to the snapshot
#' generation needed to be re-run.
#' @export
install_from_desc <- function(.d, 
                              .dir = fs::path_temp(), 
                              snapshot_sources = TRUE,
                              threads = parallel::detectCores(),
                              repos = getOption("repos")
) {
  working_dir <- fs::dir_create(file.path(.dir, "pkglock_snapshot"))
  pkg_dir <- fs::dir_create(file.path(working_dir, "runtime_pkg"))
  pkglibs <- fs::dir_create(file.path(working_dir, "pkglib"))
  .d$write(file.path(pkg_dir, "DESCRIPTION")) 
  
  pkgs_to_snapshot <- .d$get_deps()$package
  callr::r(function(tmppkg, .pkgdir, pkgs_to_snapshot, snapshot_sources, threads) {
    setwd(tmppkg)
    packrat::init(options = list(snapshot.fields = c("Imports", "Depends", "Suggests", "LinkingTo")), restart = TRUE)
    # packages needed to do devtools install
    libs <- c("jsonlite", 
              "withr", 
              "devtools", 
              "httr", 
              "curl", 
              "git2r", 
              "desc", 
              "pkgbuild")
    packrat::extlib(libs)
    if (!requireNamespace("devtools")) {
      warning("devtools not installed on the host system...installing, this could take longer to snapshot...")
      install.packages("devtools")
    }
    devtools::install_deps(.pkgdir, threads = threads, force_deps = TRUE)
    pkgtext <- sprintf("library(%s)", pkgs_to_snapshot)
    writeLines(pkgtext, "packages.R")
    snapshot <- packrat::snapshot(snapshot.sources = snapshot_sources, 
                                  prompt = FALSE, 
                                  infer.dependencies = FALSE)
    return(.libPaths())
  }, show = TRUE,
  args = list(
    tmppkg = pkglibs,
    pkgs_to_snapshot = pkgs_to_snapshot,
    .pkgdir = normalizePath(pkg_dir),
    snapshot_sources = snapshot_sources,
    threads = threads
  ), repos = repos)
  
  return(list(
    working_dir = normalizePath(working_dir),
    pkg_dir = normalizePath(pkg_dir),
    pkg_libs = normalizePath(pkglibs)
  ))
}
