FROM rocker/verse:latest

# needed for new version of ggplot2 dependency chain with sf/udunits
RUN apt-get update \
&&  apt-get install -y libudunits2-dev \
&&  apt-get install -y glpk-utils

RUN R -e "remotes::install_github('r-infra/pkglock#2')"

# can run with, for example:
# docker run -dt --rm -p 8788:8787 -e USERID=(id -u) -v (pwd):/home/rstudio dpastoor/pkglock:latest