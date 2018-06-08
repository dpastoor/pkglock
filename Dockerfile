FROM rocker/verse:latest

# needed for new version of ggplot2 dependency chain with sf/udunits
RUN apt-get update \
&&  apt-get install -y libudunits2-dev \
&&  apt-get install -y glpk-utils

RUN R -e "remotes::install_github('r-infra/pkglock#2')"