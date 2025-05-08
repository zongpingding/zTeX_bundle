# script Usage
# doc: make
# slide:make ztex_l3_manual_slide.pdf


SOURCE = ztex_l3doc
TARGET = ztex_l3_manual

# source
MODULES = ../code/module/
LIBS    = ../code/library/
CLASS   = ../code/ztex
SOURCE_FILES =  $(shell find $(MODULES) -name '*.tex') \
				$(shell find $(LIBS) -name '*.tex') \
				$(SOURCE).tex \
				$(CLASS).cls

# build
$(TARGET).pdf: $(SOURCE_FILES)
	lualatex --shell-escape $(SOURCE).tex
	makeindex -s gind.ist   $(SOURCE) 
	lualatex --shell-escape $(SOURCE).tex
	lualatex --shell-escape $(SOURCE).tex
	lualatex --shell-escape $(SOURCE).tex
	mv $(SOURCE).pdf $(TARGET).pdf
	rm -rf ./*.hd

$(TARGET)_slide.pdf: $(SOURCE_FILES)
	lualatex --shell-escape $(SOURCE).tex
	makeindex -s gind.ist   $(SOURCE) 
	lualatex --shell-escape $(SOURCE).tex
	lualatex --shell-escape $(SOURCE).tex
	lualatex --shell-escape $(SOURCE).tex
	mv $(SOURCE).pdf $(TARGET)_slide.pdf

