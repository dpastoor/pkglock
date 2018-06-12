library(fs)
tars <- normalizePath(dir_ls("pkglock_snapshot_largecran/pkglib/packrat/src", recursive = T, glob = "*.gz"))


tar_config <- lapply(tars, function(.t) {
  # packrat/src/yaml/yaml_2.1.19.tar.gz
  # packrat/src/withr/dbcd7cd61967a7413540bc1f1ae350ecef97dc89.tar.gz
  list(
    path = .t,
    pkg = basename(dirname(.t))
  )
})
CHECK_PKGS <- c(
  "purrr",
  "forcats",
  "PKPDmisc"
)
fs::dir_create("pkglock_snapshot_largecran/tarballs")
d__ <- lapply(tar_config, function(.tc) {
  if (.tc$pkg %in% CHECK_PKGS) {
    new_path <- file.path("pkglock_snapshot_largecran", "tarballs", paste0(.tc$pkg, ".tar.gz"))
    if (!fs::file_exists(new_path)) {
      
      message("copying ", .tc$pkg)
      fs::file_copy(.tc$path, 
                    new_path)
    } else {
      message("file already exists at: ", new_path)
    }
  }
})