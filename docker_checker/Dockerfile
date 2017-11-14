FROM rocker/r-devel
MAINTAINER karl.forner@quartzbio.com

# fix a problem in rocker/r-devel ?
RUN rm -rf /var/lib/apt/lists/*


RUN apt-get update && apt-get install -y \
	libcurl4-openssl-dev libssl-dev libxml2-dev sudo nano pandoc

## make Rdevel the default R
RUN cd  /usr/local/bin/ && mv Rdevel R && mv Rscriptdevel Rscript
RUN cd  /usr/bin/ && mv R Rbase && mv Rscript Rscriptbase
RUN echo "R_LIBS=\${R_LIBS-'/usr/local/lib/R/site-library:/usr/local/lib/R/library'}" >> /usr/local/lib/R/etc/Renviron

# there are R-base packages already installed, remove them
RUN rm -rf /usr/local/lib/R/site-library/*
# do not use install2.r, which uses r, which uses R base
RUN Rscript -e 'install.packages(c("covr", "devtools", "RcppArmadillo" , "roxygen2", "testthat"), Ncpus = 8)'
#RUN install2.r BH bit covr devtools DNAtools RcppArmadillo roxygen2 testthat

# install rhub, for testing package on rhub builder
RUN Rscript -e 'devtools::install_github("r-hub/rhub")'

