# read and parse the dcf file to give back list elements as vectors
# rather than a single string
# copied from packrat:::readOptsFile and modified to also parse the resulting
# list for boolean and NA values, eg: "TRUE" --> TRUE
read_opts_file <- function(path) {
  content <- readLines(path)
  namesRegex <- "^[[:alnum:]\\_\\.]*:"
  namesIndices <- grep(namesRegex, content, perl = TRUE)
  if (!length(namesIndices)) 
    return(list())
  contentIndices <- mapply(seq, namesIndices, c(namesIndices[-1] - 
                                                  1, length(content)), SIMPLIFY = FALSE)
  if (!length(contentIndices)) 
    return(list())
  result <- lapply(contentIndices, function(x) {
    if (length(x) == 1) {
      result <- sub(".*:\\s*", "", content[[x]], perl = TRUE)
    }
    else {
      first <- sub(".*:\\s*", "", content[[x[1]]])
      if (first == "") 
        first <- NULL
      rest <- gsub("^\\s*", "", content[x[2:length(x)]], 
                   perl = TRUE)
      result <- c(first, rest)
    }
    result[result != ""]
  })
  names(result) <- unlist(lapply(strsplit(content[namesIndices], 
                                          ":", fixed = TRUE), `[[`, 1))
  return(lapply(result, function(x) {
    if (identical(x, "TRUE")) {
      return(TRUE)
    }
    else if (identical(x, "FALSE")) {
      return(FALSE)
    }
    else if (identical(x, "NA")) {
      return(NA)
    }
    else {
      x
    }
  }))
}