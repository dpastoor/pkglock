set_default_repos <- function() {
  repos <- getOption("repos")
  if (repos["CRAN"] == "@CRAN@") {
    options(repos=list(CRAN="https://cran.rstudio.org"))
  }
}