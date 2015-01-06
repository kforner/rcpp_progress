R=R
VERSION=0.3
clean:
	rm -f  src/*.o src/*.so */*~ *~ src/*.rds
	rm -rf RcppProgress.Rcheck/
	rm -f RcppProgress_$(VERSION).tar.gz
	$(shell bash -c "shopt -s globstar && rm -f **/*.o **/*.so")

install:
	$(R) CMD INSTALL .

test-RcppProgressArmadillo: install
	R CMD INSTALL inst/examples/RcppProgressArmadillo/
	Rscript test_rcpp_armadillo_example.R

test-RcppProgressExample: install
	R CMD INSTALL inst/examples/RcppProgressExample/
	Rscript test_rcpp_example.R

tests: test-RcppProgressExample test-RcppProgressArmadillo

RcppProgress_$(VERSION).tar.gz: 
	$(R) CMD build .

check: clean
	$(R) CMD build .
	$(R) CMD check RcppProgress_$(VERSION).tar.gz

doc:
	$(R) CMD Rd2pdf .

RDEVEL=rocker/r-devel
RCHECKER=rcpp-rdevel

#build_rchecker:
#	docker pull $(RDEVEL)
#	docker run --name $(RCHECKER) -ti -v $(PWD):/tmp/ -w /tmp -u docker $(RDEVEL) Rscript -e 'install.packages("Rcpp")'

check-r-devel: RcppProgress_$(VERSION).tar.gz
	docker pull $(RDEVEL)
	-docker rm  $(RCHECKER)
	docker run --name $(RCHECKER) -ti -v $(PWD):/tmp/ -w /tmp -u docker $(RDEVEL) sh -c "Rscript -e 'install.packages(\"Rcpp\")' &&  R CMD check --as-cran RcppProgress_$(VERSION).tar.gz"


win-builder-upload: RcppProgress_$(VERSION).tar.gz
