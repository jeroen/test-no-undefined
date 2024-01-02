# Get popular CRAN packages
options(repos = c(CRAN='https://cloud.r-project.org'))
deps <- tools::package_dependencies(reverse = TRUE)
popular <- names(deps)[order(sapply(deps, length), decreasing = TRUE)]
avail <- as.data.frame(available.packages())
srcpkgs <- avail[avail$NeedsCompilation == 'yes', 'Package']
pkgs <- sort(intersect(srcpkgs, head(popular, 1000)))

# Allow bioc dependencies
setRepositories(ind=1:4)

# Install binaries + dependencies
cat("::group::Installing host dependencies\n")
Sys.setenv(R_COMPILE_AND_INSTALL_PACKAGES='never')
install.packages(pkgs, type = 'binary', quiet = TRUE)
cat("::endgroup::\n")

# Get all the sources
cat("::group::Downloading sources\n")
dir.create('sources')
download.packages(pkgs, 'sources', quiet = TRUE)
cat("::endgroup::\n")
