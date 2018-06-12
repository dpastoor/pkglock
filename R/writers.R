# modified from packrat:::write_opts
write_packrat_opts <- function (options, path) {
  if (!is.list(options)) 
    stop("Expecting options as an R list of values")
  
  labels <- names(options)
  if ("external.packages" %in% names(options)) {
    oep <- as.character(options$external.packages)
    options$external.packages <- as.character(unlist(strsplit(oep, 
                                                              "\\s*,\\s*", perl = TRUE)))
  }
  
  sep <- ifelse(unlist(lapply(options, length)) > 1, ":\n", 
                ": ")
  options[] <- lapply(options, function(x) {
    if (length(x) == 0) 
      ""
    else if (length(x) == 1) 
      as.character(x)
    else paste("    ", x, sep = "", collapse = "\n")
  })
  output <- character(length(labels))
  for (i in seq_along(labels)) {
    output[[i]] <- paste(labels[[i]], options[[i]], sep = sep[[i]])
  }
  cat(output, file = path, sep = "\n")
}