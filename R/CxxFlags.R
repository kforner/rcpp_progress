CxxFlags <- function() 
{
  path <- tools::file_path_as_absolute(base::system.file("include", package = "RcppProgress"))
  if (.Platform$OS.type == "windows") {
    path <- base::normalizePath(path)
    if (grepl(" ", path, fixed = TRUE)) 
      path <- utils::shortPathName(path)
    path <- gsub("\\\\", "/", path)
  }
  paste0("-I", path)
}