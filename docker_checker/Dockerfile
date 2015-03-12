FROM rocker/r-devel
MAINTAINER karl.forner@quartzbio.com


RUN  Rscript -e 'install.packages("Rcpp")'

RUN apt-get update && apt-get install -y libcurl4-openssl-dev sudo nano

RUN  Rscript -e 'install.packages("devtools")'
RUN  Rscript -e 'install.packages("bit")'
# to check DNAprofiles
RUN  Rscript -e 'install.packages("DNAtools")'
RUN  Rscript -e 'install.packages(c("RcppArmadillo", "BH"))'
#RUN wget http://cran.r-project.org/src/contrib/DNAprofiles_0.2.tar.gz
