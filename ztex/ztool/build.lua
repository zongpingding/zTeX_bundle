-- module info
bundle = "zTeX"
module = "ztool"
maindir = ".."
projectdir = maindir.."/ztool"


-- package source
sourcefiledir = projectdir.."/code"
sourcefiles   = {"ztool.sty"}


-- doc print
docfiledir    = projectdir.."/doc"
typesetdeps   = {maindir.."/zlatex/"}
typesetfiles  = {"*.tex"}


-- test
testsuppdir   = projectdir.."/code"