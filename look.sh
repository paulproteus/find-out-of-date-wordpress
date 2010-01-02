#!/bin/bash
## Strategy:

# use "locate" to find readme.html files since WordPress bundles one
# Use a heuristic to check that it's the WordPress readme.html
# If so, use a heuristic to get its version number

function find_readme_html_files() {
#    locate readme.html
    echo /home/skyfaller/web/wrongsideofdawn.com/wordpress/readme.html
    echo /home/skyfaller/web/wrongsideofdawn.com/wordpress/license.txt
}

function looks_like_wordpress_readme_html() {
    grep -qi wordpress.*readme "$1"
}


   
 

for file in $(find_readme_html_files); do
    if looks_like_wordpress_readme_html "$file"; then
        echo "$file"
    fi
done
