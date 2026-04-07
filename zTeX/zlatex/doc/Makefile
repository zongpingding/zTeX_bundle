# Script Usage
# build all of the docs: make doc example
# build interface doc: make doc
# build example doc: make example


# main target
SOURCE = ztex_interface
TARGET = ztex_interface

# source denpendency
MODULES = ../code/module
LIBS    = ../code/library
CLASS   = ../code/ztex
FIG_DIR = ./support/pics
ENGINE  = xelatex
DOC_SOURCE    = ./doc_source/
SHELL_ESCAPE  = --shell-escape
SOURCE_FILES  = $(shell find $(MODULES) -name '*.tex') \
                $(shell find $(LIBS) -name '*.tex') \
                $(shell find $(DOC_SOURCE) -name '*.tex') \
                $(SOURCE).tex \
                $(CLASS).cls


## main doc
# build interface doc('toctree.pdf' is a Circular Dependency)
doc: $(TARGET).pdf
$(TARGET).pdf: $(SOURCE_FILES)
	$(ENGINE) $(SHELL_ESCAPE) $(SOURCE).tex
	@echo "start compiling standalone figures ..."
	$(MAKE) fig # <----- generte standalone figures here. 
	makeindex -s gind.ist $(SOURCE)
	$(ENGINE) $(SHELL_ESCAPE) $(SOURCE).tex
	$(ENGINE) $(SHELL_ESCAPE) $(SOURCE).tex

# build slide
slide: $(TARGET)_slide.pdf
$(TARGET)_slide.pdf: $(SOURCE_FILES)
	$(ENGINE) $(SHELL_ESCAPE) $(SOURCE).tex
	$(MAKE) fig # <----- generte standalone figures here. 
	makeindex -s gind.ist $(SOURCE)
	(ENGINE) $(SHELL_ESCAPE) $(SOURCE).tex
	$(ENGINE) $(SHELL_ESCAPE) $(SOURCE).tex
	mv $(SOURCE).pdf $(TARGET)_slide.pdf

# build example doc
example: ztex_toc_example.pdf
ztex_toc_example.pdf: $(SOURCE_FILES) $(FIG_DIR)/toctree.pdf ztex_interface.toc
	@echo "compiling toc examples ..."
	$(ENGINE) $(SHELL_ESCAPE) ztex_toc_example.tex
	$(ENGINE) $(SHELL_ESCAPE) ztex_toc_example.tex
	$(ENGINE) $(SHELL_ESCAPE) ztex_toc_example.tex


## standalone figures
fig: $(FIG_DIR)/toctree.pdf $(FIG_DIR)/toclevel.pdf

$(FIG_DIR)/toctree.pdf: $(SOURCE_FILES) ./support/pics/toctree.tex
	@echo "compiling figures:toctree ..."
	cd ./support/pics && xelatex toctree.tex
	cd ./support/pics && xelatex toctree.tex

$(FIG_DIR)/toclevel.pdf: $(SOURCE_FILES) ./support/pics/toclevel.tex
	@echo "compiling figures:toclevel ..."
	cd ./support/pics && xelatex toclevel.tex
	cd ./support/pics && xelatex toclevel.tex


## clean aux and log files
clean:
	latexmk -c && rm -rf ./*.hd ./*.lom ./*.glo ./*.verb ./*.listing
	cd $(FIG_DIR) && latexmk -c && rm -rf ./*.hd ./*.lom ./*.glo ./*.verb ./*.listing

Clean:
	latexmk -C && rm -rf ./*.hd ./*.lom ./*.glo ./*.verb ./*.listing
	cd $(FIG_DIR) && latexmk -c && rm -rf ./*.hd ./*.lom ./*.glo ./*.verb ./*.listing
