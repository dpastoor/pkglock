#' Wrapper function to help generate a packrat lockfile
#'
#' @param ...      the arguments to pass to gen_runtime_description
#' @param .workdir directory to pass to install_from_desc
#' @export
gen_packrat_lockfile <- function(..., .workdir = file.path( getwd(),"work")){
  
  runtime_desc <- pkglock::gen_runtime_description(...)
  install <- pkglock::install_from_desc(runtime_desc, .dir = .workdir)
  lockfile <- install$snapshot$lockfile
  
  return (lockfile)
}

#' Build a string suitable for passing to gen_runtime_description
#' @param .libdir the library directory to scan
#' @export
#' @importFrom utils installed.packages
gen_pkg_desc_from_libdir <- function(.libdir, .addversion=FALSE){
  out <- ''

  pkglist <- utils::installed.packages(lib.loc = .libdir)
  add <- FALSE
  for( row in 1:nrow(pkglist)){
    out <- sprintf(
      "%s%s'%s%s'",
      out,
      if(add) ",\n\t  " else "",
      pkglist[row,'Package'],
      if(.addversion) paste0(" (==",pkglist[row,'Version'],")") else ""
    )
    add <- TRUE
  }
  
  return (paste0("pkgs <- c(",out,")"))
}

#' Save the Packrat Lockfile data to disk so that if can be reloaded later
#'   from say, a docker file
#' @param .packratLockFile the output from gen_packrat_lockfile()
#' @param .filepath the filepath to save the data to
#' @export
save_packrat_lockfile <- function(.packratLockFile, .filepath){
  writeLines(.packratLockFile, .filepath)
}

#' Load the Packrat Lockfile data from disk so that it can be restored
#' @param .filepath the filepath to load the data from
#' @export
load_packrat_lockfile <- function(.filepath){
  lockfile <- readLines(.filepath)

  return (lockfile)
}

