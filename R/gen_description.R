#' create decription file for internal package
#' @param pkgs packages
#' @param github github packages
#' @param bioc bioconductor packages
#' @param git git packages
#' @param url url packages
#' @param name name
#' @param email author email
#' @param runtime runtime name
#' @param bootstrap add required elements to bootstrap with packrat
#' @return desc file
#' @importFrom utils as.person
#' @details
#' creates the desc object representation with the fields
#' needed to bootstrap an internal package description
#' 
#' bootstrapping adds devtools and packrat to imports. If refined version(s) or
#' other tweaks needed set bootstrap to false, and directly set.
#' @export
gen_runtime_description <- function(
  pkgs = NULL,
  github = NULL,
  bioc = NULL,
  git = NULL,
  url = NULL,
  name = NULL,
  email = NULL,
  runtime = paste0("runtime", gsub("-", "", as.Date.character(Sys.Date()))),
  bootstrap = TRUE
) {
  d <- desc::description$new("!new")
  d$set(Title = "runtime generator")
  d$set(Description = glue::glue("Bootstrapping package for {runtime}."))
  d$del(keys = c("Maintainer", "URL", "BugReports", "License"))
  d$set(Package = runtime)
  d$set_version(package_version("0.0.1"))
  
  if (!is.null(name)) {
    # will pass through if name is already a person object, else will convert
    p__ <- as.person(name)
    author <- utils::person(p__$given,
                            p__$family,
                            email = email,
                            role = c("aut", "cre"))
    d$set_authors(author)
  }
 
  if (bootstrap) {
    d$set_dep("packrat", type = "Imports")
    d$set_dep("devtools", type = "Imports")
    ## need callr for bootstrapping setting up and using packrat in isolated session
    d$set_dep("callr", type = "Imports")
  }
  if (!is.null(pkgs)) {
    for (pkg in pkgs) {
      d$set_dep(pkg, type = "Imports")
    }
  }
  remotes__ <- NULL
  if (!is.null(github)) {
    remotes__ <- c(remotes__, paste0("github::", github))
  }
  if (!is.null(bioc)) {
    # NOTE(devin): i'm less familiar with bioconductor installer automation
    # so this will need to be checked out more carefully if it's pulling from
    # the appropriate remotes
    remotes__ <- c(remotes__, paste0("bioc::", bioc))
  }
  if (!is.null(git)) {
    remotes__ <- c(remotes__, paste0("git::", git))
  }
  if (!is.null(url)) {
    remotes__ <- c(remotes__, paste0("url::", url))
  }
  if (!is.null(remotes__)) {
    d$set_remotes(remotes__)
  }
  
  return(d)
}