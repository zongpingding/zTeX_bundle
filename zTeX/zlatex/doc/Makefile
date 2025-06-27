# script Usage
# doc: make
# slide:make ztex_interface_slide.pdf


SOURCE = ztex_interface
TARGET = ztex_interface

# source
MODULES = ../code/module/
LIBS    = ../code/library/
CLASS   = ../code/ztex
ENGINE  = xelatex
SHELL_ESCAPE  = --shell-escape
SOURCE_FILES  = $(shell find $(MODULES) -name '*.tex') \
				$(shell find $(LIBS) -name '*.tex') \
				$(SOURCE).tex \
				$(CLASS).cls

# build doc
$(TARGET).pdf: $(SOURCE_FILES)
	$(ENGINE) $(SHELL_ESCAPE) $(SOURCE).tex
	makeindex -s gind.ist $(SOURCE) 
	$(ENGINE) $(SHELL_ESCAPE) $(SOURCE).tex
	$(ENGINE) $(SHELL_ESCAPE) $(SOURCE).tex
	rm -rf ./*.hd

# build slide
$(TARGET)_slide.pdf: $(SOURCE_FILES)
	$(ENGINE) $(SHELL_ESCAPE) $(SOURCE).tex
	makeindex -s gind.ist $(SOURCE) 
	$(ENGINE) $(SHELL_ESCAPE) $(SOURCE).tex
	$(ENGINE) $(SHELL_ESCAPE) $(SOURCE).tex
	mv $(SOURCE).pdf $(TARGET)_slide.pdf

