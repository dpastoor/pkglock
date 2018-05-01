
#' install from a runtime description
#' @param .d description file
#' @param .dir directory to install pkgs from description
#' @export
install_from_desc <- function(.d, .dir = fs::path_temp()) {
  # random folder so won't clash if installing multiple descs
  working_dir <- fs::dir_create(file.path(.dir, paste0(
    "runtime_pkg", round(runif(1, 10000, 100000), 0)))
    )
  pkg_dir <- fs::dir_create(file.path(working_dir, "runtime_pkg"))
  pkglibs <- fs::dir_create(file.path(working_dir, "pkglib"))
  .d$write(file.path(pkg_dir, "DESCRIPTION")) 
  snapshot <- withr::with_libpaths(
    pkglibs,
    {
      remotes::install_deps(pkgdir = pkg_dir)
      gen_snapshot(.d$get_deps()$package, .dir=.dir)
    }
  )
  return(list(
    snapshot = snapshot,
    pkglibpath = pkglibs
       ))
}

#' setup a runtime template
#' @param .ll lockfile lines
#' @param .dir dir to create the runtime template
#' @export
setup_runtime_template <- function(.ll, .dir = fs::path_temp()) {
  working_dir <- fs::dir_create(file.path(.dir, round(runif(1, 10000, 100000))))
  runtime_template_dir <- file.path(working_dir, "gen-runtime")
  fs::dir_copy(system.file("gen-runtime", package = "pkglock"), working_dir)
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
      packrat::restore(.rt)
    })
  } else {
    # this is not suggested as can cause incomplete runtimes to be generated
    # by other packages already installed in other libpaths than those
    # explicitly specified
    packrat::restore(runtime)
  }
  normalizePath(file.path(.rt, 
                          "packrat", 
                          "lib", 
                          R.version$platform, 
                          getRversion())
                )
}