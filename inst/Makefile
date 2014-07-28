
PKG=${shell pwd}
PKGNAME=${shell basename ${PKG}}
R=R
RSCRIPT=Rscript

R_SOURCES := $(wildcard R/*.[R|r])
TEST_SOURCES := $(wildcard tests/*.[R|r])
NAMESPACE = NAMESPACE
DESCRIPTION = DESCRIPTION

.PHONY: example 

all: ${NAMESPACE}

# generates the manual in pdf: Rd2.pdf

pdf: Rd2.pdf

pdfclean: 
	rm -rf .Rd2dvi*

Rd2.pdf: ${NAMESPACE} ${DESCRIPTION} ${R_SOURCES}
	rm -f Rd2.pdf
	$R CMD Rd2pdf man/


	
example:
	mkdir -p .install
	R CMD build .
	R CMD INSTALL -l .install RcppProgress_0.2.tar.gz
	R CMD build inst/examples/RcppProgressExample
	R CMD INSTALL -l .install RcppProgressExample_0.2.tar.gz
	
# run R CMD check
check: ${NAMESPACE} ${DESCRIPTION} clean
	$R CMD build .
	$R CMD check --as-cran RcppProgress_0.2.tar.gz

clean: pdfclean
	rm -f  src/*.o src/*.so src/libsrc/*.o */*~ *~
	rm -f config.log config.status *.tar.gz Rd2.pdf
	rm -rf .install RcppProgress.Rcheck
	
	

	
