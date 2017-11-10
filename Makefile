R=R
VERSION=0.4
RCHECKER=rcpp-rdevel
NCPUS=4


.PHONY: tests

clean:
	rm -f  src/*.o src/*.so */*~ *~ src/*.rds manual.pdf
	rm -rf lib
	$(shell bash -c "shopt -s globstar && rm -f **/*.o **/*.so")

lib:
	mkdir -p $@
	
install: lib
	$(R) -e 'pkg=devtools::build(".", "lib");install.packages(pkg, "lib")'

# tests require an installed package
tests: clean install
	R_LIBS=lib Rscript -e 'devtools::test()'

test-RcppProgressArmadillo: install
	R CMD INSTALL inst/examples/RcppProgressArmadillo/
	Rscript test_rcpp_armadillo_example.R

debug-RcppProgressExample: install
	R_LIBS=lib Rscript -e 'devtools::load_all("inst/examples/RcppProgressExample", recompile = TRUE); RcppProgressExample:::test_multithreaded();'

debug-RcppProgressETA: install
	R_LIBS=lib Rscript -e 'devtools::load_all("inst/examples/RcppProgressETA", recompile = TRUE); RcppProgressETA:::test_sequential();'


	#Rscript test_rcpp_example.R


check: clean
	R -q -e 'devtools::check()'

# check with Rdevel
check-rdev: clean
	Rdevel -q -e 'devtools::check()'

doc:
	$(R) CMD Rd2pdf -o manual.pdf .



################## docker checker ##################################
# directory in which the local dir is mounted inside the container
DIR=/root/rcpp_progress
DOCKER_RUN=docker run --rm -ti -v $(PWD):$(PWD) -w $(PWD) -u $$(id -u):$$(id -g) $(RCHECKER) 

docker/build:
	docker build -t $(RCHECKER) docker_checker

# check with r-base
docker/check: 
	#-docker rm  $(RCHECKER)
	$(DOCKER_RUN) make check

# check with r-devel
docker/check-rdev: docker/build
	#-docker rm  $(RCHECKER)
	$(DOCKER_RUN) make check-rdev

docker/run: 
	#@-docker rm  $(RCHECKER)
	$(DOCKER_RUN) bash

docker/tests: 
	#@-docker rm  $(RCHECKER)
	$(DOCKER_RUN) make tests

test-r-devel: 
	-docker rm  $(RCHECKER)
	$(DOCKER_RUN) make tests


check_rhub_windows: build
	Rscript -e 'rhub::check_on_windows("$(TARBALL)")'



win-builder-upload: build
	lftp  -u anonymous,karl.forner@gmail.com -e "set ftp:passive-mode true; cd R-release; put $(TARBALL); cd ../R-devel;  put $(TARBALL); bye" ftp://win-builder.r-project.org



