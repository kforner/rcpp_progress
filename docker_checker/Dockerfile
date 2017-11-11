FROM rocker/r-devel
MAINTAINER karl.forner@quartzbio.com

# fix a problem in rocker/r-devel ?
RUN rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
	libcurl4-openssl-dev libssl-dev libxml2-dev sudo nano pandoc

RUN install2.r BH bit covr devtools DNAtools RcppArmadillo roxygen2 testthat

RUN Rscript -e 'devtools::install_github("r-hub/rhub")'
