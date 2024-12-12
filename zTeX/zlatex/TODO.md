# TODO LIST
## project overview
- [ ] Test system for the whole project: 
    - [ ] update the test files to the current version
    - [ ] run latest test.
- [x] split this class to `library`(optional) and `module`(kernel)
- [x] add `\@onlypreamble` modifier to some `zlatex` commands
- [ ] message system:
    - [x] Redesign message system that in a mess.
    - [ ] add `\MessageBreak` command to break the message box.
- [x] implement the `package-option` interface;
- [x] Handle warning about `csquote` with `babel` and `minted`.
- [ ] learn the breakable-box mechanism, provide such an interface to declare such box
- [ ] `graphics` module, use `l3graphics`? (To be considering)
- [x] re-write `alias` commands
  - [x] fixed wrong space before `\dd` in different math mode: text, display, script, scriptscript.
  - [x] Bug: command `\FF` conflicting with `\FF` command in `ascii` package.
  - [x] How to choose appropriate command names for these alias? (package `bm` has been removed from zlatex)
  - [x] fixed wrong space after these new math operator and before a binary symbol, such as `\grad`
- [ ] consider to remove `indextools` or add a hook for `\indexsetup{}` ? Or add a hook `\zlatex_hook_preamble_first:n` to load `indextools`?
- [ ] replace `\str_...` functions with `\tl_...` for catcode reasons.
- [ ] support language: france
- [ ] Hook Managment:
    - [x] find out if `\zlatex_hook_preamble_last` is a reverse hook ? (It is NOT a reverse hook)
    - [ ] Is there a way to prevent using this hook ?
- [ ] add functions to change the enumerate number style by redefine the `\p@enumii` etc. commands:
- [ ] limit the scope of keys by `.usage:n`
- [ ] replace the traditional mark system by New Mark mechanism introduced In June 2022.
- [ ] add a entry `.color_set:n` in l3keys.
- [ ] add `+=` keys assignment method.

## `indexref` module 
- [x] Set default `hyperref` and `biblatex` a group, Don't loading them by default
- [ ] replace `\cref` command in package cleverref by `\autoref` provided by hyperref.
- [ ] replace `\cref` or `\Cref` commands in package cleverref by `\autoref` command


## `theme` module
- [x] add a new processor for l3keys like `% axiom .excute:n = { [HTML][000000] },` to handle the color setup.


## `secformat` module
- [ ] more(fancy) style for cover page
- [ ] add fancy `\section`, `\subsection` etc. styles in `fancy` library.
- [ ] sec-item(different when loading `titlesec`), after-item(use the same mechanism as toc generating in LaTeX2e) collection interface. (this will be useful to `UR` content in `slide` mode)
- [x] Bug: for `\maketitle`
    - [x] fixed horizontal align, Probably by the longest line in the `title`, `author` to set the box width
    - [x] fixed bug in top and bottom align
- [x] Bug: can not print right title, author and date in the cover page in doc mode, but it is working in slide mode. (catcode error of `@`, fxied)
- [ ] How to limit the keys assign in a group for `\zlatex_title_format:nn` for a single title command. (current: within group -> does not work outside; not within -> inferea other commands.)
- [ ] localize the label and title format range. It is imposiible either `l3keys` or `xtemplate`, Maybe make these commands from scratch and localize these keys-setup and instance declaring in such command is the only solution ???

## `thm` module
- [x] find out hyperref mechanism and remove `amsthm` package, for that the internal thm-env `zlatextheorem` is somehow additional.
- [x] add `tcb-title` key to `thm` module to create ElegantBook-like theorem box (add a macro `\zlatexThmTitleSwitch`)
- [x] add `\listoftheorems` command to list all the theorems in the document
- [ ] add `store` key in `thm` module to store the theorem content and use it later
- [ ] math theorem-like and proof-like envs icon setting up interface.
- [x] re-write the `theorem-like-env-name` interface by `l3-prop` module instead of the original `l3keys` module.
- [x] add more hooks to `thm` env: before code and after code, etc. to control the env font, ...
- [x] add interface for add new theorem-like or proof-like environments.
    - [x] Implement this feature by `l3keys` ? Maybe it is better to import l3keys after removing `amsthm` package.
- [x] add theorem and proof environments in France.
- [x] Support `{HTML}{0f78x3}`, `{RGB}{15,120,255}` color setup in `thm` module.
- [x] Add a interface to custom Math envs title, current relies on `amsthm` package like `\thmname{#1}~ \thmnumber{#2}~ \thmnote{(#3)}`.
- [x] thm env counter sharing and parent counter config.
- [x] add a key in `\zlatexThmCnt` to avoid thm counter reset when parent counter increase. 
- [x] Bug: wrong page break when use `elegant` thm warper in slide mode.
- [x] Bug: wrong `\cref` name and linked target for proof-like envs in `thm` module. (Proof like env is not a theorem-like env, so it should not be numbered or linked ?) (fixed, this is not a bug, for that there is not `\refstepcounter` command in proof-like env declaration)
- [x] re-write the pre-defined thm style, eg. `plain`, `fancy`, `paris`, ... by the newly added hooks. Is that right ??? (implemented by l3keys)
- [x] Color set unsuccessfully for syntax: `\zlatexThmColorSetup{theorem=purple!50}`.
- [x] fixed THM note expansion bug;
- [x] toc thm toc line stretch
- [x] add thm toc symbol and prefix interface.


## `slide` library
- [ ] implement the `slide` mode part as a package ?
- [x] improve `slide` mode:maybe by Hooking shipout process ?
- [x] remove `fancyhdr` dependency in slide metadata part, use `\AddToHook{shipout/background}` instead
- [x] fixed warning about the default slide theme name.
- [ ] Slide mode top space changes when set up `lang=cn`:
    - [x] metadata `UL` vspace changes (fixed by using Hook to add `UL`)
    - [ ] Frame top space changes
- [x] set background color and main text color in zlatex slide mode.
- [x] create a slide theme creating interface, like `zslideThemeCreate` 
- [ ] consider add a slide theme like `metropolis` in beamer, not only the color, but also the page layout and section style. (a status bar interface may require ?)
- [x] fixed the bug of wrong `\thesubsection` counter with `shipout` in `slide` mode
- [x] a error whill be throw out if `\author` not given
- [x] graphics dimension related:
    - [x] Bug:Infinitive loop when including pictures that has huge size(picture size larger than paper dimension) in slide mode.
    - [x] Auto scale graphics that too large for current paper size. (**deprecated**)
- [x] add navigat bar: like balls, or other symbols.
- [x] add hyperref support.
- [x] fixed bug: annotations added by `\zlatexPageMask` are invisible.
- [x] Unified color scheme for `UR` and `BR` text.
- [x] provide an `\zslidelogo` command for slide mode.


## `toc` module
- [ ] add `toc-setup` interface, that do not dependent on any existing packages, like `tocloft`, `titletoc`. (then a lot of work to do, emmm ...)
- [x] ambiguious about `redef`-key in `toc`, considering change it to `toc={style={\latge\bfseries}}`
- [x] use `multicols` packages for multi-columns toc
- [ ] make `\part`, `\chapter` etc. a single line(cross columns) in multi-columns toc. See `toc_interface` folder in `New_feature` dir.
- [x] weired vspace in  `\partialToC`. Consider add a `\stopcontents` before the next chapter automatically (or set up this function for `section` counter). Add this function to doc. 
- [ ] use the internal macro `\@writefile{toc}{< token list >}` to write to toc file or use `l3-file-system` related functions ?



## `pageinfo` module
- [x] make layout spec more flexible, pre-defined some layouts in class ?
- [x] when to use `\pagestyle{}` in `book/article` class
- [ ] Remove `fancyhdr` package, make a more flexible(which means add page info any where) `page-info` interface. Probably by LaTeX hooks ?


## `font` module 
- [ ] set up an interface for text font switch in different system or different engine ?
- [ ] pre-define some existing fonts in TeXLive 
- [ ] Math font setup interface ? make it easy to create a new symbol from font package, such as `amsfonts`, `stix`, `mathdesign` etc.
- [ ] `unicode-math` package support ?


> Font is too hard, to be continued ...