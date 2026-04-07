#!/usr/bin/env zsh

# NOTE:
# 1. This script require: 'awk' and 'pdftk';
# 2. This script use zsh syntax.

pages=1
bookmarks="bookmarks.txt"

# script argument parse:
output_pdf="$1"
shift # remove the first argument
pdfs=("$@")
if [[ ${#pdfs[@]} -eq 0 ]]; then
    echo "Usage: $0 <output_pdf> <pdf1> <pdf2> ..."
    exit 1
fi

# bookmarks data collect
rm -f "$bookmarks"
for pdf in "${pdfs[@]}"; do
    # 1. add file name as top bookmarks
    cat <<EOF >> "$bookmarks"
BookmarkBegin
BookmarkTitle: ${pdf:t:r}
BookmarkLevel: 1
BookmarkPageNumber: $pages
EOF

    # 2. read the original bookmarks
    pdftk "$pdf" dump_data |
    awk -v offset=$((pages-1)) '
        /BookmarkBegin/ {print; next}
        /BookmarkTitle/ {print; next}
        /BookmarkLevel/ {print "BookmarkLevel: " $2+1; next}
        /BookmarkPageNumber/ {print "BookmarkPageNumber: " $2+offset; next}
    ' >> "$bookmarks"

    # 3. calculate page offset
    page_number=$(pdftk "$pdf" dump_data | awk '/NumberOfPages/ {print $2}')
    pages=$((pages + page_number))
done

# start merge PDFs
pdftk "${pdfs[@]}" cat output "final_tmp.pdf"
# update bookmarks
pdftk "final_tmp.pdf" update_info "$bookmarks" output "$output_pdf"

# clean aux files
rm -f final_tmp.pdf
rm -f "$bookmarks"
