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
  pkg_resolution <- tryCatch({
    resolve_pkgs(pkgs)
  }, error = function(e) {
    e
  })
  if (inherits(class(pkg_resolution), "error")) {
    stop("package resolution failed with message: ", pkg_resolution$message)
  }
  
  rtd <- gen_runtime_description(pkgs = pkg_resolution$pkg,
                          github = pkg_resolution$github)
  
  snapshot_info <- install_from_desc(rtd, .dir = .dir) 
 
  return(snapshot_info)
}