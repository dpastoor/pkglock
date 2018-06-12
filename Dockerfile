FROM rocker/verse:latest

RUN R -e "remotes::install_github('r-infra/pkglock#2')"

# can run with, for example:
# docker run -dt --rm -p 8788:8787 -e USERID=(id -u) -v (pwd):/home/rstudio dpastoor/pkglock:latest
