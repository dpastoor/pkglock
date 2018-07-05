library(pkglock)
local({r <- getOption("repos")
r["CRAN"] <- "https://cran.rstudio.com/" 
options(repos=r)
})
available.packages()

pkgs <- c(
  "PKPDmisc",
  "dplyr",
  "purrr",
  "forcats",
  "ggplot2",
  "shiny",
  "DT",
  "tidyr",
  "rlang",
  "lubridate",
  "fs",
  "pkgdown",
  "processx",
  "desc",
  "miniUI",
  "shinydashboard",
  "furrr",
  "future",
  "future.apply",
  "future.callr",
  "glue",
  "tidyverse",
  "forcats",
  "glue",
  "purrr",
  "covr",
  "dplyr",
  "knitr",
  "rmarkdown",
  "testthat",
  "debugme",
  "fs",
  "mockery",
  "pingr",
  "shiny",
  "shinyjs",
  "hms",
  "lubridate",
  "anytime",
  "RcppTOML",
  "pkgdown",
  "usethis",
  "processx",
  "withr",
  "desc",
  "callr",
  "future",
  "future.apply",
  "future.callr",
  "rmarkdown",
  "rstudioapi",
  "miniUI",
  "promises",
  "later",
  "rlang",
  "furrr",
  "knitr",
  "DBI"
)

pkgs <- c("R6", "r-lib/pillar")
install_dir <- "tmp"
#if (!fs::dir_exists(install_dir) || length(fs::dir_ls(install_dir))) {
#  stop("dir missing or files/folders present in dir: ", install_dir, " aborting attempt...") 
#}
res <- gen_snapshot(pkgs, .dir = install_dir)
