#!/bin/bash

# (C) 2010 Asheesh Laroia, find-out-of-date-wordpress@asheesh.org
# Have at it. Re-use permitted under the WTFPL.

set -e # explode on failure

## Strategy:

# use "locate" to find readme.html files since WordPress bundles one
# Use a heuristic to check that it's the WordPress readme.html
# If so, use a heuristic to get its version number

function find_readme_html_files() {
    locate readme.html | grep -v [.]svn
}

function looks_like_wordpress_readme_html() {
    grep -qi '<title>wordpress.*readme' "$1"
}

function grab_version_number() {
    grep 'Version ' "$1" | sed 's/.*Version //' | sed -r 's/(.*)[^0-9.]/$1/'
}

function write_report_line() {
    version=$(grab_version_number "$1")
    if $(dpkg --compare-versions "$version" lt "$latest_version"); then
        owner=$(stat "$1" -c "%U")
        path=$(dirname "$1")
        echo "$owner has WordPress $version in $path"
    fi
}

latest_version=$(python latest_version.py)

TMPFILE=$(mktemp)

# For each WordPress-like readme.html,
for file in $(find_readme_html_files); do
    if looks_like_wordpress_readme_html "$file"; then
        write_report_line "$file" >> "$TMPFILE"
    fi
done

if [ $(wc -l < "$TMPFILE") -eq 0 ]; then
    # the file is empty. we can quit now.
    exit 0
else
    # the file has lines
    # print the current WordPress version, then the report we generated
    echo "Current version of WordPress: $latest_version"
    echo ""
    cat "$TMPFILE"
    rm -f "$TMPFILE"
fi

# FIXME: Handle spaces in filenames better. Use locate --null, and do the
# rest of this null-terminated.

# FIXME: Provide a mechanism for white-listing paths.
