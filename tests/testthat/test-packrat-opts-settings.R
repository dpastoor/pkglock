context("test-packrat-opts-settings.R")

describe("packrat opts are set when written/read", {
  it("sets up defaults and ", {
   default_settings <- packrat_settings() 
   read_write_settings <- function() {
     con <- file()
     on.exit({
       close(con)
     })
     write_packrat_opts(packrat_settings(), con)
     read_in <- read_opts_file(con)
     return(read_in)
   } 
   read_write <- read_write_settings()
   read_write$snapshot.fields
   expect_equal(read_write$snapshot.fields, c("Imports", "Depends", "LinkingTo", "Suggests"))
   expect_equal(read_write$ignored.packages = "internal")
   expect_true(read_write$use.cache)
  })
})