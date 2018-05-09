library(miniCRAN)
pkgs <- c("ggplot2", "dplyr", "purrr", "stringr", "lubridate", "shiny", "shinydashboard",
          "usethis", "shinyjs", "devtools", "remotes", "PKPDmisc", "tidyverse", "broom",
            "haven", "fs")
pkgList <- pkgDep(pkgs, type = "source",
                  availPkgs = available.packages())

pkgList

dir.create("~/minicran/20180508", recursive = TRUE)

mcdir <- "~/minicran/20180508"
# Make repo for source and win.binary
repo__ <- makeRepo(pkgList, path = mcdir, type = c("source", "mac.binary", "win.binary"))
