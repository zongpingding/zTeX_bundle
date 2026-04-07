-- info
bundle = "zTeX"
module = "ztex_intro"
maindir = ".."
projectdir = maindir.."/ztex_intro"


-- doc print
docfiledir    = projectdir.."/doc"
typesetdeps   = {maindir.."/zlatex/"}
typesetfiles  = {"*.tex"}
supportdir    = projectdir.."/doc/pics"
typesetsuppfiles = {"fgruler_1.pdf", "fgruler_2.pdf"}
typesetexe    = "xelatex"
typesetopts   = "-interaction=nonstopmode --shell-escape"