#!/bin/bash

PARENT_FOLDER=".."
INSTALL_FOLDER="ZTEX_INSTALL"
EXTRACT_FOLDER="$PARENT_FOLDER/$INSTALL_FOLDER"
TARGET_FOLDER="/mnt/c/Users/PC/texmf/tex/latex/ztex"

usage() {
    echo "Usage: $0 [-h] [-d] [-i]"
    echo "Options:"
    echo "  -h  Show this help message"
    echo "  -d  Delete previous extract folder: '$EXTRACT_FOLDER'"
    echo "  -i  Copy '$EXTRACT_FOLDER' to '$TARGET_FOLDER'"
    exit 1
}

# extract source code and doc from zTeX
extrac_source () {
    # mkdir
    mkdir -p "$EXTRACT_FOLDER"/zlatex/code
    mkdir -p "$EXTRACT_FOLDER"/ztikz/code
    mkdir -p "$EXTRACT_FOLDER"/ztool/code
    mkdir -p "$EXTRACT_FOLDER"/zslide/code
    mkdir -p "$EXTRACT_FOLDER"/zlatex/doc
    mkdir -p "$EXTRACT_FOLDER"/ztikz/doc
    mkdir -p "$EXTRACT_FOLDER"/ztool/doc
    mkdir -p "$EXTRACT_FOLDER"/zslide/doc

    # copy source and doc files
    cp -r ./zlatex/code/* "$EXTRACT_FOLDER"/zlatex/code
    cp -r ./ztikz/code/* "$EXTRACT_FOLDER"/ztikz/code
    cp -r ./ztool/code/* "$EXTRACT_FOLDER"/ztool/code
    cp -r ./zslide/code/* "$EXTRACT_FOLDER"/zslide/code
    cp ./zlatex/doc/ztex_interface.pdf "$EXTRACT_FOLDER"/zlatex/doc/
    cp ./ztikz/doc/ztikz_interface.pdf "$EXTRACT_FOLDER"/ztikz/doc/
    cp ./ztool/doc/ztool_interface.pdf "$EXTRACT_FOLDER"/ztool/doc/
    cp ./zslide/doc/zslide_manual.pdf "$EXTRACT_FOLDER"/zslide/doc/

    echo "Extract success, see folder: $EXTRACT_FOLDER"
}

# handle command line arguments
while getopts "dih" opt; do
    case $opt in
        h)
            usage
            ;;
        d)
            echo "Remove folder: $EXTRACT_FOLDER"
            rm -rf "$EXTRACT_FOLDER"
            exit 0
            ;;
        i)
            if [ ! -d "$EXTRACT_FOLDER" ]; then
                echo "ERROR: '$EXTRACT_FOLDER' do NOT exsit, run './extract.sh' to extract zTeX first!"
                exit 1
            fi
            if [ -d "$TARGET_FOLDER" ]; then 
                rm -rf "$TARGET_FOLDER"
                echo "Remove previous zTeX installing folder: '$TARGET_FOLDER'"
            fi
            echo "Installing zTeX to: '$TARGET_FOLDER'"
            mkdir -p "$TARGET_FOLDER"
            cp -r "$EXTRACT_FOLDER"/* "$TARGET_FOLDER"/
            echo "zTeX install successfully!"
            exit 0
            ;;
        \?)
            usage
            ;;
    esac
done

extrac_source