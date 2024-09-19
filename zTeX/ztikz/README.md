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