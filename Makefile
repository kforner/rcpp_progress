R=R
RSCRIPT=Rscript
VERSION=0.4
RCHECKER=rcpp-rdevel
NCPUS=4


.PHONY: tests vignettes

clean:
	rm -f  src/*.o src/*.so */*~ *~ src/*.rds manual.pdf
	#rm -rf lib
	$(shell bash -c "shopt -s globstar && rm -f **/*.o **/*.so")

lib:
	mkdir -p $@

install: lib
	$(R) -e 'pkg=devtools::build(".", "lib");install.packages(pkg, "lib", INSTALL_opts = "--install-tests")'

coverage:
	$(R) -e 'covr::package_coverage()'

# tests require an installed package
tests: clean rox install
	R_LIBS=lib $(RSCRIPT) -e 'devtools::test()'

test-RcppProgressArmadillo: install
	R CMD INSTALL inst/examples/RcppProgressArmadillo/
	Rscript test_rcpp_armadillo_example.R

### useful to troubleshoot compilation problems inside the example packages
debug-RcppProgressExample: install
	R_LIBS=lib $(RSCRIPT) -e 'devtools::load_all("inst/examples/RcppProgressExample", recompile = TRUE); RcppProgressExample:::test_multithreaded(1000);'

debug-RcppProgressETA: install
	R_LIBS=lib $(RSCRIPT) -e 'devtools::load_all("inst/examples/RcppProgressETA", recompile = TRUE); RcppProgressETA:::test_multithreaded(1000);'

debug-RcppProgressArmadillo: install
	R_LIBS=lib $(RSCRIPT) -e 'devtools::load_all("inst/examples/RcppProgressArmadillo", recompile = TRUE); RcppProgressArmadillo:::test_multithreaded(1000);'

build:
	$(R) CMD build .

rox: 
	$(R) -q -e 'roxygen2::roxygenise(load = "source")'

check: clean
	$(R) -q -e 'devtools::check()'

# check with Rdevel
check-rdev: clean
	$(R) -q -e 'devtools::check()'

doc:
	@rm -f manual.pdf
	$(R) CMD Rd2pdf -o manual.pdf .

pkgdown: rox
	Rscript --no-save -e 'pkgdown::build_site()'

vignettes:
	Rscript --no-save -e 'devtools::build_vignettes()'

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

docker/run/root: 
	#@-docker rm  $(RCHECKER)
	docker run --rm -ti -u root $(RCHECKER) bash

docker/tests: 
	#@-docker rm  $(RCHECKER)
	$(DOCKER_RUN) make tests

test-r-devel: 
	-docker rm  $(RCHECKER)
	$(DOCKER_RUN) make tests


check_rhub_windows: 
	XDG_DATA_HOME=$(PWD) $(RSCRIPT) -e 'rhub::check_on_windows()'


win-builder-upload: build
	lftp  -u anonymous,karl.forner@gmail.com -e "set ftp:passive-mode true; cd R-release; mput *.tar.gz; cd ../R-devel;  mput *.tar.gz; bye" ftp://win-builder.r-project.org



