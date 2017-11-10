R=R
VERSION=0.4
RCHECKER=rcpp-rdevel
NCPUS=4


clean:
	rm -f  src/*.o src/*.so */*~ *~ src/*.rds manual.pdf
	rm -rf *.Rcheck/ checks .Rd2pdf*
#	rm -f RcppProgress_$(VERSION).tar.gz
	$(shell bash -c "shopt -s globstar && rm -f **/*.o **/*.so")

build:
	rm -f RcppProgress_*.tar.gz
	Rscript -e 'devtools::build(".", "/tmp")'
	
install: build
	$(R) CMD INSTALL /tmp/RcppProgress_*.tar.gz

test-RcppProgressArmadillo: install
	R CMD INSTALL inst/examples/RcppProgressArmadillo/
	Rscript test_rcpp_armadillo_example.R

test-RcppProgressExample: install
	R CMD INSTALL inst/examples/RcppProgressExample/
	Rscript test_rcpp_example.R

tests: test-RcppProgressExample test-RcppProgressArmadillo



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

docker/build:
	docker build -t $(RCHECKER) docker_checker

# check with r-base
docker/check: docker/build
	-docker rm  $(RCHECKER)
	docker run --name $(RCHECKER) -ti -v $(PWD):$(DIR) -w $(DIR) $(RCHECKER) make check

# check with r-devel
docker/check-rdev: docker/build
	-docker rm  $(RCHECKER)
	docker run --name $(RCHECKER) -ti -v $(PWD):$(DIR) -w $(DIR) $(RCHECKER) make check-rdev

docker/run: docker/build
	@-docker rm  $(RCHECKER)
	docker run --name $(RCHECKER) -ti -v $(PWD):/root/ -w /root  $(RCHECKER) bash

docker/tests: docker/build
	@-docker rm  $(RCHECKER)
	docker run --name $(RCHECKER) -ti -v $(PWD):/root/ -w /root  $(RCHECKER) make tests



test-r-devel: 
	-docker rm  $(RCHECKER)
	docker run --name $(RCHECKER) -ti -v $(PWD):$(DIR) -w $(DIR) $(RCHECKER) make tests


check_rhub_windows: build
	Rscript -e 'rhub::check_on_windows("$(TARBALL)")'



win-builder-upload: build
	lftp  -u anonymous,karl.forner@gmail.com -e "set ftp:passive-mode true; cd R-release; put $(TARBALL); cd ../R-devel;  put $(TARBALL); bye" ftp://win-builder.r-project.org



