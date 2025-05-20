SOURCE = ztool_interface
TARGET = ztool_interface

# source
MODULES = ../../zlatex/code/module/
LIBS    = ../../zlatex/code/library/
CLASS   = ../../zlatex/code/ztex
PKG     = ../code/ztool
SOURCE_FILES  = $(shell find $(MODULES) -name '*.tex') \
				$(shell find $(LIBS) -name '*.tex') \
				$(SOURCE).tex \
				$(PKG).sty \
				$(CLASS).cls

# build doc
$(TARGET).pdf: $(SOURCE_FILES)
	xelatex $(SOURCE).tex
	makeindex -s gind.ist $(SOURCE) 
	xelatex $(SOURCE).tex
	xelatex $(SOURCE).tex
	rm -rf ./*.hd

