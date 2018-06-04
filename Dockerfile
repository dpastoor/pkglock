FROM rocker/verse:latest

RUN R -e "remotes::install_github('r-infra/pkglock#2')"