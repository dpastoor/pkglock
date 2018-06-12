#' get the libpaths associated with a project that uses packrat
#' @param .pdir packrat directory
#' @export
get_packrat_libpaths <- function(.pdir) {
  withr::with_dir(.pdir, {
    if (!fs::dir_exists("packrat")) {
      stop("directory does not seem to be a packrat directory, aborting...")
    }
    callr::r(function() {
      source(".Rprofile")
      .libPaths()
    })
  })
}
