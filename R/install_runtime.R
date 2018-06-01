
#' install from a runtime description
#' @param .d description file
#' @param .dir directory to install pkgs from description
#' @param snapshot_sources snapshot the library source tarballs
#' @param threads threads during install 
#' @details 
#' .install should almost always be set to true, the time to set to false
#' is if a full install was completed, however some tweak to the snapshot
#' generation needed to be re-run.
#' @export
install_from_desc <- function(.d, 
                              .dir = fs::path_temp(), 
                              snapshot_sources = TRUE,
                              threads = parallel::detectCores()
                              ) {
  working_dir <- fs::dir_create(file.path(.dir, "pkglock_snapshot"))
  pkg_dir <- fs::dir_create(file.path(working_dir, "runtime_pkg"))
  pkglibs <- fs::dir_create(file.path(working_dir, "pkglib"))
  .d$write(file.path(pkg_dir, "DESCRIPTION")) 
 
  pkgs_to_snapshot <- .d$get_deps()$package
  libs <- callr::r(function(tmppkg, .pkgdir, pkgs_to_snapshot, snapshot_sources, threads) {
    setwd(tmppkg)
    packrat::init(options = list(snapshot.fields = c("Imports", "Depends", "Suggests", "LinkingTo")), restart = TRUE)
    
    install.packages("remotes")
    remotes::install_deps(.pkgdir, threads = threads)
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
  ))
  
  return(list(
    working_dir = normalizePath(working_dir),
    pkg_dir = normalizePath(pkg_dir),
    pkg_libs = normalizePath(pkglibs)
  ))
}

#' setup a runtime template
#' @param .ll lockfile lines
#' @param .dir dir to create the runtime template
#' @param ... parameters to pass to `packrat_settings()`
#' @export
setup_runtime_template <- function(.ll, .dir = fs::path_temp(), ...) {
  runtime_template_dir <- file.path(.dir, "gen-runtime")
  fs::dir_copy(system.file("gen-runtime", package = "pkglock"), .dir)
  write_packrat_opts(packrat_settings(...), 
                     fs::path(.dir, "gen-runtime", "packrat", "packrat.opts"))
  # these folders are required by packrat, but are empty so not included in 
  # template
  fs::dir_create(
    file.path(runtime_template_dir, "packrat", c("lib", "lib-ext", "lib-R", "src"))
  )
  writeLines(.ll, file.path(runtime_template_dir, "packrat", "packrat.lock"))
  return(runtime_template_dir) 
}

#' install a runtime from a given packrat lockfile
#' @param .rt location of a runtime template
#' @param .libs library locations to use when installing the runtime in isolation
#' @return path to installed runtime packages
#' @export
install_runtime <- function(.rt, .libs = NULL) {
  if (!is.null(.libs)) {
    withr::with_libpaths(.libs, {
      packrat::restore(.rt, prompt = FALSE)
    })
  } else {
    # this is not suggested as can cause incomplete runtimes to be generated
    # by other packages already installed in other libpaths than those
    # explicitly specified
    packrat::restore(.rt)
  }
  normalizePath(file.path(.rt, 
                          "packrat", 
                          "lib", 
                          R.version$platform, 
                          getRversion())
                )
}