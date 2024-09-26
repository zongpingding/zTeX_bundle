# TODO LIST

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
- [ ] Implement `3d-part` using `l3draw` ? using `pgf` ?