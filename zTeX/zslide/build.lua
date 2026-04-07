bundle = "zTeX"
module = "zslide"
maindir = ".."
projectdir = maindir.."/zslide"


sourcefiledir = projectdir.."/code"
sourcefiles   = {"*.cls"}
docfiledir    = projectdir.."/doc"
typesetfiles  = {"*.tex"}
testsuppdir   = projectdir.."/code"


checkruns    = 3
checkopts    = "-interaction=nonstopmode --shell-escape"
checkengines = {"pdftex"}
checkconfigs = {"build"}