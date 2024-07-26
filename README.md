# pre-release
see doc for more info. 



# TODO List

## zlatex class

- [ ] more style for cover page
- [x] a error whill be throw out if `\author` not given
- [ ] ambiguious about `redef`-key in `toc`, considering change it to `toc={style={\latge\bfseries}}`
- [x] weired indent in  `\partialToC`. Consider add a `\stopcontents` before the next chapter automatically (or set up this function for `section` counter). Add this function to doc. 
- [x] make layout spec more flexible, pre-defined some layouts in class ?
- [ ] learn the breakable-box mechanism, provide such an interface to declear such box
- [ ] when to use `\pagestyle{}` in `book/article` class
- [ ] improve `slide` mode:maybe by Hooking shipout process ?
- [x] fixed typo in document 


## ztikz package

- [x] support `\py` in \newcommand
- [x] add `pycode` environment for writing tabel and other loop-like things
- [x] `\ior_str_get:NN` and `\ior_get:NN` for reading contents from externel file
- [ ] fixed the bug of hash-recover
- [ ] access varible decleared in Python before
- [ ] can't use `''` in sed command under windows, but works fine on Linux
- [ ] line cache for `\pyfp{}` command
- [x] split `cache/wolfram/python/matlab/gnuplot/zdraw` into modules, load them by command like `\ztikzload{matlab}`. Set a uniformal interface to handle these `--shell-escape` activities
- [x] add `l3draw` module to `ztikz`
- [ ] create a layer like tikz based on `l3draw`, which support `opacity, path/region gradient, clip, 3d-prejection` etc, add this module to `ztikz`
- [x] add `\plotz` to plot function $z=f(x,y)$ using gnuplot 
- [x] fixed typo in document

> **3d-prejection** is such a priority


## new package - `ztool`

- [ ] add a new module `ztool`
- [ ] add `shipout` related interface to `ztool`
- [ ] create a `\NewKeyCommand` interface
- [ ] add box-align interface (instead of using package `xcoffin`)
- [ ] load `l3graphics` to replace the old package `graphicx`
- [ ] add a patch command interface like `xpatch`
