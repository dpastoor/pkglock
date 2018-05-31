resolve_pkgs <- function(top_pkgs) {
  
  rems <- pkgdepends::remotes$new(top_pkgs, 
                                  library = tempdir()
  )
  
  rems$resolve()
  soln <- rems$get_resolution()
  
  pkgs <- soln
  direct_pkgs <- pkgs[pkgs$direct, , drop = FALSE]
  
  direct_suggested_refs <- unlist(lapply(direct_pkgs$deps, function(df) {
    # can come back as either Suggests or suggests depending on 
    # whether from remote or cran
    df[tolower(df$type) == "suggests", , drop = FALSE]$ref
  }))
  
  all_pkgs <- unique(c(top_pkgs, direct_suggested_refs))
  
  rems_all <- pkgdepends::remotes$new(all_pkgs, library = tempdir())
  rems_all$resolve()
  all_pkg_data <- rems_all$get_resolution()
  
  #all_pkg_data[all_pkg_data$type != "standard", , drop = FALSE]$sources
  #  
  # this is currently bugged and won't download github deps
  # rems_all$download_solution()
  
  # don't need recommended packages
  top_lvl_pkg_meta <- all_pkg_data[all_pkg_data$ref %in% all_pkgs &
                                     is.na(all_pkg_data$priority), , drop = FALSE]
  
  pkgs <- with(top_lvl_pkg_meta, {
    pkgname <- package[tolower(type) == "standard"]
    pkgversion <- version[tolower(type) == "standard"]
    sprintf("%s (>= %s)", pkgname, pkgversion)
  })
  gh_pkgs <- with(top_lvl_pkg_meta, {
    ref[tolower(type) == "github"]
  })
  
  list(pkgs = pkgs,
       github = gh_pkgs
  )
  
}
