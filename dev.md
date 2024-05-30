For developers
================

## How to build

Prerequisites:

- OpenMP support to use the multithreaded parallelized version. OpenMP is available in GCC >= 4.2

Just install it the usual way.

If you want more control, unarchive it, cd to the source directory, then type
R CMD INSTALL . in the console.

## Feedback

Please use github issues to provide feedback, report bugs and propose new features.

## Contribute

Contributions are welcome!
The proposed process is:

- open an issue and propose your changes
- fork the project
- do a merge request
- code review
- merge into master

New code must be tested and documented, and also come with an example.


## For developers

## VS Code devcontainer

This repository has a devcontainer configured. So that if you open it in vscode, 
it will prompt you to reopen it in the container. From that you do not need to install anything, 
and you can directly run make tests/check/...
You can also run the project inside github codespaces, that will use the devcontainer.


### tests and check

If you have all the RcppProgress dependencies (and suggests) installed:

type:
 - `make tests`: to run the tests
 - `make check`: to check the package

### docker-checker

N.B: this is somewhat deprecated by the vscode devcontainer (see above).

A Dockerfile (<docker_checker/Dockerfile>) is provided to help building the
dev environment (built on rocker/r-devel) in which to develop
and test RcppProgress.

type:

 - `make docker/build`: to build the docker
 - `make docker/run`: to run a shell in the docker with the current dir mounted
 	inside
 - `make docker/check`: to check the package inside the docker
 - `make docker/tests`: to run test tests of the package inside the docker

### test on windows using rhub

```
make docker/run
make check_rhub_windows
```


