-- module info
bundle = "zTeX"
module = "ztikz"
maindir = ".."
projectdir = maindir.."/ztikz"


-- package source
sourcefiledir = projectdir.."/code"
sourcefiles   = {"*.sty"}


-- doc print
docfiledir = projectdir.."/doc"
typesetdeps = { 
  maindir.."/zlatex/",
  maindir.."/ztikz/"
}
typesetfiles = { "ztikz_manual.tex" }
supportdir = projectdir
typesetsuppfiles = {
  "/doc/support/pics/*", 
  "/doc/support/data/*",
  "/doc/support/gallery/*",
  "/code/modules/ztikz-library.cache.tex",
  "/code/modules/ztikz-library.gnuplot.tex",
  "/code/modules/ztikz-library.python.tex",
  "/code/modules/ztikz-library.wolfram.tex",
  "/code/modules/ztikz-library.zdraw.tex"
}
typesetruns = 3
typesetexe  = "xelatex"
typesetopts = "-interaction=nonstopmode --shell-escape"


-- test
checkruns    = 2
-- includetests = {"ztikz-cmd-ShowAxis"}
testsuppdir  = projectdir.."/code"
checkopts    = "-interaction=nonstopmode --shell-escape"
checkengines = {"pdftex"}
checkconfigs = {"build"}