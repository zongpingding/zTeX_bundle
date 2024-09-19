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
  "/code/modules/ztikzmodule.cache.tex",
  "/code/modules/ztikzmodule.gnuplot.tex",
  "/code/modules/ztikzmodule.python.tex",
  "/code/modules/ztikzmodule.wolfram.tex",
  "/code/modules/ztikzmodule.zdraw.tex"
}
typesetruns = 3
typesetexe  = "xelatex"
typesetopts = "-interaction=nonstopmode --shell-escape"


-- test
checkruns    = 2
testsuppdir  = projectdir.."/code"
checkopts    = "-interaction=nonstopmode --shell-escape"
checkengines = {"pdftex"}
checkconfigs = {"build"}