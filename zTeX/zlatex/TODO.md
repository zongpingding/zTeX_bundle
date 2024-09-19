# TODO LIST

- [ ] more style for cover page
- [x] Handle warning about `csquote` with `babel` and `minted`.
- [x] Set default `hyperref` and `biblatex` a group, Don't loading them by default
- [x] remove `fancyhdr` dependency in slide mode, use `\AddToHook{shipout/background}` instead
- [ ] implement the `package-option` interface
- [ ] fixed the bug of wrong `\thesubsection` counter with `shipout` in `slide` mode
- [x] a error whill be throw out if `\author` not given
- [ ] ambiguious about `redef`-key in `toc`, considering change it to `toc={style={\latge\bfseries}}`
- [x] weired vspace in  `\partialToC`. Consider add a `\stopcontents` before the next chapter automatically (or set up this function for `section` counter). Add this function to doc. 
- [x] make layout spec more flexible, pre-defined some layouts in class ?
- [ ] learn the breakable-box mechanism, provide such an interface to declear such box
- [ ] when to use `\pagestyle{}` in `book/article` class
- [ ] improve `slide` mode:maybe by Hooking shipout process ?
- [x] fixed typo in document
- [ ] implement the `slide` mode part as a package 