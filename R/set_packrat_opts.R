#' packrat settings 
#' @param use.cache use packrat cache when installing packages
#' @param external.packages packages to consider external to packrat
#' @param local.repos local cranlike repos to install from
#' @param ignored.packages packages to not snapshot
#' @param snapshot.fields which fields to capture in lockfile
#' @export
packrat_settings <- function(
  use.cache = TRUE,
  external.packages = NULL,
  local.repos = NULL,
  ignored.packages = "internal",
  snapshot.fields = c(
    "Imports",
    "Depends",
    "LinkingTo", 
    "Suggests"
  )
  ) {
  defaults <- list(
    auto.snapshot = FALSE,
    print.banner.on.startup = "auto",
    vcs.ignore.lib = TRUE,
    vcs.ignore.src = FALSE,
    snapshot.recommended.packages = FALSE,
    quiet.package.installation = TRUE,
    ignored.directories = c("data", "inst"),
    load.external.packages.on.startup = TRUE
  )
  settings <- list(
    use.cache = use.cache,
    external.packages = external.packages %||% "",
    local.repos = local.repos %||% "",
    ignored.packages = ignored.packages %||% "",
    snapshot.fields = snapshot.fields
  )
  return(modifyList(defaults, settings))
}