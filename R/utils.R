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

#' Scan a library folder and build a package list
#' @param .libdir the library directory to scan
#' @export
build_package_list_from_library_dir <- function(.libdir){
  
  pkgs <- list();
  for( file in list.files(.libdir)){
    version <-  packageDescription(file, lib.loc = .libdir)$Version
    pkgs[file] <- version
  }
  
  return (pkgs)
}


#' Build a string suitable for passing to gen_runtime_description
#' @param .pkglist the output from build_package_list_from_library_dir
#' @param .addversion  TRUE to lock package to version, FALSE to get latest
#' @export
gen_pkg_desc_from_package_list <- function(.pkglist, .addversion=FALSE){
  out <- ''
  
  pkgnames <- names(.pkglist)
  add <- FALSE
  for( name in pkgnames){
    out <- sprintf(
      "%s%s'%s%s'",
      out,
      if(add) ",\n\t  " else "",
      name,
      if(.addversion) paste0(" (==",.pkglist[name],")") else ""
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
  fileConn<-file(.filepath)
  writeLines(.packratLockFile, fileConn)
  close(fileConn)
}

#' Load the Packrat Lockfile data from disk so that it can be restored
#' @param .filepath the filepath to load the data from
#' @export
load_packrat_lockfile <- function(.filepath){
  fileConn<-file(.filepath)
  lockfile <- readLines(fileConn)
  close(fileConn)
  
  return (lockfile)
}

