# change log
## build status
Till now, add tests for these 4 modules: `cache`, `gnuplot`, `python`, `wolfram`. Test status is as follows: 
```shell
ztikz-cmd-Polygon (1/37)
ztikz-cmd-ShowAxis (2/37)
ztikz-cmd-ShowGrid (3/37)
ztikz-cmd-ShowIntersection (4/37)
ztikz-cmd-ShowPoint (5/37)
ztikz-cmd-xAxis (6/37)
ztikz-cmd-yAxis (7/37)
ztikz-cmd-ztikzLoadModule (8/37)
ztikz-module-cache-cmd-sympy (9/37)
ztikz-module-cache-cmd-wolfram (10/37)
ztikz-module-cache-cmd-wolframDSolve (11/37)
ztikz-module-cache-cmd-wolframResult (12/37)
ztikz-module-cache-cmd-wolframSolve (13/37)
ztikz-module-cache-env-pyfig (14/37)
ztikz-module-cache-env-tikz (15/37)
system returned with code 256
system returned with code 256
        --> failed

ztikz-module-cache-env-wolframGraphics (16/37)
ztikz-module-gnuplot-BarPlot (17/37)
ztikz-module-gnuplot-ContourPlot (18/37)
ztikz-module-gnuplot-ListPlot (19/37)
ztikz-module-gnuplot-ParamPlot (20/37)
ztikz-module-gnuplot-Plot (21/37)
ztikz-module-gnuplot-PlotPrecise (22/37)
ztikz-module-gnuplot-Plotz (23/37)
ztikz-module-gnuplot-PolarPlot (24/37)
ztikz-module-gnuplot-StairsPlot (25/37)
ztikz-module-gnuplot-StemPlot (26/37)
ztikz-module-python-py (27/37)
ztikz-module-python-pycode (28/37)
ztikz-module-python-pyfig (29/37)
ztikz-module-python-sympy (30/37)
ztikz-module-wolfram-wolfram (31/37)
ztikz-module-wolfram-wolframDSolve (32/37)
ztikz-module-wolfram-wolframGraphics (33/37)
ztikz-module-wolfram-wolframResult (34/37)
ztikz-module-wolfram-wolframSolve (35/37)
ztikz-module-zdraw-zplot (36/37)
ztikz-module-zdraw-zrule (37/37)
```

At first run (`checkruns  = 2`) Test 34 `ztikz-module-wolfram-wolframResult` will fail, set `checkruns = 1` will pass all tests. `ztikz-cmd-ztikzLoadModule` and `ztikz-module-cache-cmd-wolframResult` may fail as well. Please chech these 2 test again.

**`ztikz-module-cache-env-tikz` test can be passed, need further imporvement.**

> [!CAUTION]
> The Test for `cache` module will change the later.

## time cost
```shell 
% 1. build from scratch
142 page: about 7mins


% 2. using cache module the second time
142 page: about 20s


% 3. using cache module the third time
142 page: about 20s
```

## Test on: 2024-11-23
### compile log
Compile log on linux:
```shell 
current hash is A971992BDCA77B96EC48462220903BB3
skip recompile by wolframscript, using the cache picture 1
current hash is 21544943C4661BB5D6A5516F3E5B0551
skip recompile, using the cache wolframscript result 1
current hash is C8533FB3A6813DA337D27C2682BD064F
skip recompile, using the cache wolframscript result 2
current hash is 9A449F25A5140ED225568DB4D60CCEF9
skip recompile, using the cache wolframscript result 3
===== Image 'ztikz_output/tikz_data/debug-figure0' is up-to-date. ======
===== Image 'ztikz_output/tikz_data/debug-figure1' is up-to-date. ======

Overfull \hbox (53.7989pt too wide) in paragraph at lines 68--81
 [] 

[1{/var/lib/texmf/fonts/map/pdftex/updmap/pdftex.map} <./ztikz_output/mma_data/
mma_1.wls.pdf> <./ztikz_output/tikz_data/debug-figure0.pdf>]
current hash is 69B6C9CA9B8E58DF9E9089165B7DB3F5
(./ztikz_output/python_data/sympy_1.out)
skip recompile, using the cache sympy result 1

[2 <./ztikz_output/tikz_data/debug-figure1.pdf> <./ztikz_output/gnuplot_data/pl
ot_3d_1.pdf>]
using python float module calculating...
clear ztikz hash successfully ...
```

Compile log on windows:
```shell 
(c:/texlive/2024/texmf-dist/tex/generic/pgf/frontendlayer/tikz/libraries/tikzex
ternalshared.code.tex)))
(c:/Users/PC/texmf/tex/latex/ztikz/library/ztikz.library.wolfram.tex
(c:/texlive/2024/texmf-dist/tex/latex/xsim/xsimverb.sty
(c:/texlive/2024/texmf-dist/tex/latex/l3packages/l3keys2e/l3keys2e.sty)))
(c:/Users/PC/texmf/tex/latex/ztikz/library/ztikz.library.gnuplot.tex
(c:/Users/PC/texmf/tex/latex/ztikz/library/ztikz.library.gnuscript.tex

LaTeX Info: Writing file `./ztikz_output/scripts/plot_plot.gp'.



LaTeX Info: Writing file `./ztikz_output/scripts/contour_plot.gp'.



LaTeX Info: Writing file `./ztikz_output/scripts/param_plot.gp'.



LaTeX Info: Writing file `./ztikz_output/scripts/polar_plot.gp'.



LaTeX Info: Writing file `./ztikz_output/scripts/3d_plot.gp'.


)) (c:/Users/PC/texmf/tex/latex/ztikz/library/ztikz.library.python.tex
(c:/Users/PC/texmf/tex/latex/ztikz/library/ztikz.library.pyscript.texA subdirectory or file ztikz_output\scripts\ already exists.
system returned with code 1


LaTeX Info: Writing file `./ztikz_output/scripts/python_script.py'.



LaTeX Info: Writing file `./ztikz_output/scripts/sympy_script.py'.


)) (c:/Users/PC/texmf/tex/latex/ztikz/library/ztikz.library.zdraw.tex
(c:/texlive/2024/texmf-dist/tex/latex/l3experimental/l3draw/l3draw.sty))
(c:/texlive/2024/texmf-dist/tex/latex/amsmath/amsmath.sty
For additional information on amsmath, use the `?' option.
(c:/texlive/2024/texmf-dist/tex/latex/amsmath/amstext.sty
(c:/texlive/2024/texmf-dist/tex/latex/amsmath/amsgen.sty))
(c:/texlive/2024/texmf-dist/tex/latex/amsmath/amsbsy.sty)
(c:/texlive/2024/texmf-dist/tex/latex/amsmath/amsopn.sty))
No file main.aux.
(c:/texlive/2024/texmf-dist/tex/context/base/mkii/supp-pdf.mkii
[Loading MPS to PDF converter (version 2006.09.02).]
) (c:/texlive/2024/texmf-dist/tex/latex/epstopdf-pkg/epstopdf-base.sty
(c:/texlive/2024/texmf-dist/tex/latex/grfext/grfext.sty
(c:/texlive/2024/texmf-dist/tex/generic/kvdefinekeys/kvdefinekeys.sty))
(c:/texlive/2024/texmf-dist/tex/latex/kvoptions/kvoptions.sty
(c:/texlive/2024/texmf-dist/tex/latex/kvsetkeys/kvsetkeys.sty))
(c:/texlive/2024/texmf-dist/tex/latex/latexconfig/epstopdf-sys.cfg))
current hash is A971992BDCA77B96EC48462220903BB3
current hash is unique --> recorded
Writing 'mmafig' environment source to ztikz_output/mma_data/mma_1.wls
current hash is 21544943C4661BB5D6A5516F3E5B0551
current hash is unique --> recorded
using wolframscript calculating question 1...
current hash is C8533FB3A6813DA337D27C2682BD064F
current hash is unique --> recorded
using wolframscript calculating question 2...
current hash is 9A449F25A5140ED225568DB4D60CCEF9
current hash is unique --> recorded
using wolframscript calculating question 3...
===== 'mode=convert with system call': Invoking 'pdflatex -shell-escape -halt-o
n-error -interaction=batchmode -jobname "ztikz_output/tikz_data/main-figure0" "
\def\tikzexternalrealjob{main}\input{main}"' ========
This is pdfTeX, Version 3.141592653-2.6-1.40.26 (TeX Live 2024) (preloaded format=pdflatex)
 \write18 enabled.
entering extended mode
A subdirectory or file ztikz_output\ already exists.
system returned with code 1
A subdirectory or file ztikz_output\tikz_data\ already exists.
system returned with code 1
A subdirectory or file ztikz_output\mma_data\ already exists.
system returned with code 1
A subdirectory or file ztikz_output\gnuplot_data\ already exists.
system returned with code 1
A subdirectory or file ztikz_output\python_data\ already exists.
system returned with code 1
        1 file(s) copied.
        1 file(s) copied.
        1 file(s) copied.
===== 'mode=convert with system call': Invoking 'pdflatex -shell-escape -halt-o
n-error -interaction=batchmode -jobname "ztikz_output/tikz_data/main-figure1" "
\def\tikzexternalrealjob{main}\input{main}"' ========
This is pdfTeX, Version 3.141592653-2.6-1.40.26 (TeX Live 2024) (preloaded format=pdflatex)
 \write18 enabled.
entering extended mode
A subdirectory or file ztikz_output\ already exists.
system returned with code 1
A subdirectory or file ztikz_output\tikz_data\ already exists.
system returned with code 1
A subdirectory or file ztikz_output\mma_data\ already exists.
system returned with code 1
A subdirectory or file ztikz_output\gnuplot_data\ already exists.
system returned with code 1
A subdirectory or file ztikz_output\python_data\ already exists.
system returned with code 1
        1 file(s) copied.
        1 file(s) copied.
        1 file(s) copied.
        1 file(s) copied.
        1 file(s) copied.

Overfull \hbox (53.7989pt too wide) in paragraph at lines 68--81
 []

[1{c:/texlive/2024/texmf-var/fonts/map/pdftex/updmap/pdftex.map} <./ztikz_outpu
t/mma_data/mma_1.wls.pdf> <./ztikz_output/tikz_data/main-figure0.pdf>]        1 file(s) copied.

current hash is F29F6A3BC2FEE14A658851EE9CE7F1D4
current hash is unique --> recorded
        1 file(s) copied.
using python sympy calculating question 1...
(./ztikz_output/python_data/sympy_1.out)
[2 <./ztikz_output/tikz_data/main-figure1.pdf> <./ztikz_output/gnuplot_data/plo
t_3d_1.pdf>]
using python float module calculating...
clear ztikz hash successfully ...
```

### new feature
add functions:
* `\ztikzHashCurrent[<seperator>]`: get current cached hash 
* `\ztikzHashClean`: clear all cached hash
* implement all functions in `gnuplot` library with key-value syntax.

## project re-orignization
Rename `modules` directory to `library`, related control sequences are renamed as well
