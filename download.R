# Get popular CRAN packages
options(repos = c(CRAN='https://cloud.r-project.org'))
install.packages("jsonlite", quiet = TRUE)
owner <- Sys.getenv("owner")
pkgs <- if(owner == 'popular'){
	deps <- tools::package_dependencies(reverse = TRUE)
	head(names(deps)[order(sapply(deps, length), decreasing = TRUE)], 1000)
} else {
	url <- sprintf('https://%s.r-universe.dev/api/packages?all=1', owner)
	jsonlite::fromJSON(url)$Package
}

avail <- as.data.frame(available.packages())
srcpkgs <- avail[avail$NeedsCompilation == 'yes', 'Package']
pkgs <- sort(intersect(srcpkgs, pkgs))

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
