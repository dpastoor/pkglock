#' create a pkgcheck config file
#' @param libpaths vector of library paths
#' @param output output directory
#' @param loglevel log level
#' @param .start_config_file existing yaml configuration file
#' @param .overwrite whether to overwrite existing settings or just add new
#' @details 
#' log levels: debug, info, warn, fatal
#' 
#' if overwrite is false, any settings present in the pkgcheck.yml file
#' will be retained, and the parameter value will be ignored. 
#' @export
create_pkgcheck_config <- function(
  libpaths = NULL,
  output = "output",
  loglevel = "info",
  .start_config_file = NULL,
  .overwrite = TRUE 
) {
  start_config <- if (!is.null(.start_config_file)) {
    yaml::read_yaml(.start_config_file)
  } else {
    list()
  }
  config <- list()
  if (!is.null(libpaths)) {
    config$libpaths <- paste0(libpaths, collapse = ':')
  }
  config$output <- output
  return(modifyList(start_config, config))
}

#' write out a yaml config from a configuration list
#' @param .config configuration
#' @param .file yaml file, should be named pkgcheck.yaml
#' @export
write_config <- function(.config, .file) {
  yaml::write_yaml(.config, .file) 
}
