
test_sequential <- function(max=100, nb=1000, display_progress=TRUE) {
	.Call("test_sequential_wrapper", max, nb, display_progress, PACKAGE = "RcppProgressExample")
}

test_multithreaded <- function(max=100, nb=1000, threads=0, display_progress=TRUE) {
	.Call("test_multithreaded_wrapper", max, nb, threads, display_progress, PACKAGE = "RcppProgressExample")
}