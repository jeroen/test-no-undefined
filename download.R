# Test set of interesting packages
pkgs <- c("antiword", "archive", "arrangements", "arrow", "av", "brotli",
"Cairo", "cld2", "curl", "data.table", "duckdb", "fftw", "fftwtools",
"gam", "gdtools", "gert", "git2r", "glmnet", "gmp", "httpgd", "httpuv",
"hunspell", "igraph", "image.textlinedetector", "imager", "jqr",
"lwgeom", "magick", "Matrix", "mongolite", "odbc", "opencv",
"openssl", "pdftools", "proj4", "protolite", "ragg", "RcppAlgos",
"RcppParallel", "redux", "RMariaDB", "RMySQL", "RPostgres", "rsvg",
"rzmq", "sf", "shiny", "sodium", "sparsenet", "ssh", "stars",
"stringi", "terra", "tesseract", "tidyverse", "tiledb", "unrtf",
"V8", "webp", "writexl")

# Install binaries + dependencies
cat("::group::Installing host dependencies\n")
install.packages(pkgs, repos = 'https://cloud.r-project.org')
cat("::endgroup::\n")

# Get all the sources
cat("::group::Downloading sources\n")
deps <- unname(unlist(tools::package_dependencies(pkgs, recursive = TRUE)))
allpkgs <- sort(unique(c(pkgs, deps)))
dir.create('sources')
download.packages(allpkgs, 'sources', repos = 'https://cloud.r-project.org')
cat("::endgroup::\n")
