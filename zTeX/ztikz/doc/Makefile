SOURCE = ztikz_interface
TARGET = ztikz_interface

# source
MODULES  = ../../zlatex/code/module/
LIBS     = ../../zlatex/code/library/
ZTIKZLIB = ../code/library/
CLASS    = ../../zlatex/code/ztex
PKG      = ../code/ztikz
SOURCE_FILES  = $(shell find $(MODULES) -name '*.tex') \
				$(shell find $(LIBS) -name '*.tex') \
				$(shell find $(ZTIKZLIB) -name '*.tex') \
				$(SOURCE).tex \
				$(PKG).sty \
				$(CLASS).cls

# build doc
$(TARGET).pdf: $(SOURCE_FILES)
	xelatex --shell-escape $(SOURCE).tex
	makeindex -s gind.ist $(SOURCE) 
	xelatex --shell-escape $(SOURCE).tex
	xelatex --shell-escape $(SOURCE).tex
	rm -rf ./*.hd

