#!/bin/sh
set -e
echo "::group::Prepare: download sources"
Rscript download.R "$1"
echo "::endgroup::"

# Build from source
for pkg in sources/*.tar.gz; do
	FAIL="OK"
	pkg_name=$(basename $pkg | cut -d '_' -f1)
	R CMD INSTALL $pkg > out.log 2>&1 || FAIL="FAILED";
	echo "::group::${pkg_name} $FAIL"
	if [ "$FAIL" = "FAILED" ]; then
		tail -n100 out.log
	else
		tail -n1 out.log
	fi
	echo "::endgroup::"
done
