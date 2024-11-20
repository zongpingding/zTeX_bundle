-- module info
bundle = "zTeX"
module = "zlatex"
maindir = ".."
projectdir = maindir.."/zlatex"


-- package source
sourcefiledir = projectdir.."/code"
sourcefiles   = {"*.cls"}


-- doc print
docfiledir = projectdir.."/doc"
typesetdeps = { maindir.."/zlatex/" }
typesetfiles = { "zlatex_manual.tex" }
supportdir = docfiledir.."/support"
typesetsuppfiles = {
  "/Fonts/*.ttf",
  "/pics/*", 
  "ref.bib"
}
typesetruns = 3
typesetexe = "xelatex"
typesetopts = "-interaction=nonstopmode --shell-escape"


-- test
testsuppdir  = projectdir.."/code"
checkruns    = 3
checkengines = {"pdftex"}
checkconfigs = {"build"}
