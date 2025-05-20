# script Usage
# doc: make
# slide:make ztex_interface_slide.pdf


SOURCE = ztex_interface
TARGET = ztex_interface

# source
MODULES = ../code/module/
LIBS    = ../code/library/
CLASS   = ../code/ztex
SOURCE_FILES  = $(shell find $(MODULES) -name '*.tex') \
				$(shell find $(LIBS) -name '*.tex') \
				$(SOURCE).tex \
				$(CLASS).cls

# build doc
$(TARGET).pdf: $(SOURCE_FILES)
	lualatex $(SOURCE).tex
	makeindex -s gind.ist $(SOURCE) 
	lualatex $(SOURCE).tex
	lualatex $(SOURCE).tex
	rm -rf ./*.hd

# build slide
$(TARGET)_slide.pdf: $(SOURCE_FILES)
	lualatex $(SOURCE).tex
	makeindex -s gind.ist $(SOURCE) 
	lualatex $(SOURCE).tex
	lualatex $(SOURCE).tex
	mv $(SOURCE).pdf $(TARGET)_slide.pdf

