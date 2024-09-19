# change log
## l3build stautus
### zlatex
The build test is splited into 3 parts:
* `class-option-XX`: test the class option setup
* `class-cmd-XX`: test the class command setup
* `doc-XX-output`: test the (PDF) document output


Now, the test status is:
```shell 
$ l3build check
Running l3build with target "check" and configuration "build"
Running checks on
  class-cmd-zlatexColorSetup (1/12)
  class-cmd-zlatexFramed (2/12)
  class-cmd-zlatexSetup (3/12)
  class-cmd-zslideSetup (4/12)
  class-option-bib_index (5/12)
  class-option-common (6/12)
  class-option-layout (7/12)
  class-option-mathSpec (8/12)
  class-option-toc (9/12)
  doc-article-output (10/12)
  doc-book-output (11/12)
  doc-slide-output (12/12)

  All checks passed

Running l3build with target "check" and configuration "testfiles-font"
Running checks on
  class-option-font (1/1)

  All checks passed
```

### zslide
not set test yet


### zslide 
not set test yet


## package dependency
add package 
* `anyfontsize`: fixed font scale 
* `multicols`: multi-cols toc support

remove
* `multitoc` in multi-cols toc support
- [ ] consider to remove `indextools` or add a hook for `\indexsetup{}` ? Or add a hook `\zlatex_hook_preamble_first:n` to load `indextools`?


> The package `microtype` and `csquotes` will automatically load `etoolbox`


## Class Tools 
Create a new group name `Class Tools`, Now, this group consist of the following series of functions:
```latex 
% ----------------------------------------------------------------------
%                              Class Tools
% ----------------------------------------------------------------------
% zlatex dim tools
\box_new:N \l_zlatex_measure_box
\cs_new_protected:Npn \zlatex_box_set_to:NNn #1#2#3 {
  \hbox_set:Nn \l_zlatex_measure_box {#3}
  \dim_set:Nn #2 {#1 \l_zlatex_measure_box}
  \box_set_eq:NN \l_zlatex_measure_box \c_empty_box
}
\cs_new_protected:Npn \zlatex_set_to_height:Nn { \zlatex_box_set_to:NNn \box_ht:N }
\cs_new_protected:Npn \zlatex_set_to_width:Nn  { \zlatex_box_set_to:NNn \box_wd:N }
\cs_new_protected:Npn \zlatex_set_to_depth:Nn  { \zlatex_box_set_to:NNn \box_dp:N }

% zlatex hook tools
\cs_new_protected:Npn \zlatex_hook_preamble_last:n #1
  { \AddToHook{env/document/before}{#1} }
\cs_new_protected:Npn \zlatex_hook_doc_begin:n #1
  { \AddToHook{begindocument}{#1} }
\cs_new_protected:Npn \zlatex_hook_doc_end:n #1
  { \AddToHook{enddocument}{#1} }

% zlatex key-value setup interface
\cs_new_protected:Npn \zlatex_option_keys_define:n
  { \keys_define:nn { zlatex / option } }
\cs_new_protected:Npn \zlatex_keys_define:nn #1
  { \keys_define:nn { zlatex / #1} }
\cs_new_protected:Npn \zlatex_keys_set:nn #1
  { \keys_set:nn { zlatex / #1 } }
```


## hook interface
### introduction
zLaTeX now provides these hooks for users to use:
```latex
% zlatex hook tools
\cs_new_protected:Npn \zlatex_hook_preamble_last:n #1
  { \AddToHook{env/document/before}{#1} }
\cs_new_protected:Npn \zlatex_hook_doc_begin:n #1
  { \AddToHook{begindocument}{#1} }
\cs_new_protected:Npn \zlatex_hook_doc_end:n #1
  { \AddToHook{enddocument}{#1} }
```

> These functions now belongs to the group `Class Tools`.


## key-value interface
### setup functions
Now the key-value setup functions are:
```latex
\RequirePackage {l3keys2e}
% zlatex key-value setup interface
\cs_new_protected:Npn \zlatex_option_keys_define:n
  { \keys_define:nn { zlatex / option } }
\cs_new_protected:Npn \zlatex_keys_define:nn #1
  { \keys_define:nn { zlatex / #1} }
\cs_new_protected:Npn \zlatex_keys_set:nn #1
  { \keys_set:nn { zlatex / #1 } }
```

> These functions now belongs to the group `Class Tools`.


### key-value level
Implement most commands with key-value interface, also re-orginiseed some key-value interface level.
* reset the class k-v interface `XX` from `zlatex / XX` to `zlatex / option / XX`.
* reset the keys in `zlatex / option / toc` to `column(<int>:1), title(<str>:\contentsname), title-vspace(<dim>:-2em)`.
* add `packageOption` k-v interface at k-v level `zlatex / option /`.

Consider move `color` k-v interface to `zlatex / color`.


## message system
### group name 
The message system related tools are moved to a new group `message system`.
```latex 
% ----------------------------------------------------------------------
%                   zlatex message system
% ----------------------------------------------------------------------    
```


### introduction
Add 3 function for message setup and usage:
```latex
\prop_gput:Nnn \g_msg_module_type_prop { zlatex } { Class }
\cs_new_protected:Npn \zlatex_msg_set:nn #1#2 { 
  \msg_if_exist:nnTF { zlatex }{#1} 
    { \msg_set:nnn { zlatex }{#1}{#2} }
    { \msg_new:nnn { zlatex }{#1}{#2} }
}
\cs_new_protected:Npn \zlatex_msg_warn:n #1 { 
  \msg_warning:nn { zlatex }{#1} 
}
\cs_new_protected:Npn \zlatex_msg_error:n #1 { 
  \msg_error:nn { zlatex }{#1} 
}
```

### readable log
People always complain about the compile log LaTeX given, think it hard to read and understand. To this reason, zLaTeX makes the warning or error message more readable, an example messages made by zLaTeX for `class option`:
```shell
# 1. class option warning
Class zlatex Warning: You use an unknown class option key:'startPage'. Valid
(zlatex)              options are:lang, hyper, fancy, class,
(zlatex)              classOption(<clist>), toc(<key-value>),
(zlatex)              font(<key-value>), layout(<key-value>),
(zlatex)              section(<key-value>), mathSpec(<key-value>),
(zlatex)              bib_index(<key-value>). Assignment Ignored and LaTeX
(zlatex)              default settings substitute.
```

Set an user-friendly interface to handle the exception of these class meta key:
```latex
\cs_new_protected:Npn \zlatex_metakey_msg_warning:nn #1#2 {
  \zlatex_msg_new:nn {option-meta-key}
    {You~use~an~invalid~key~"\l_keys_key_str"~or~key~assign~for~it~in~the~meta~key~"#1",~
    Valid~options~are:#2;~Assignment~Ignored~this~assign~and~LaTeX~default~#1~settings~substitute.}
  \zlatex_msg_warn:n {option-meta-key}
}
\zlatex_define:nn { option / font }{
  config              .bool_gset:N  = \g__zlatex_font_config_bool,
  config              .initial:n    = { false }, 
  unknown             .code:n       = { \zlatex_metakey_warning_msg:nn {font}{config(<bool>:false)} }
}
```

Then the message are something like:
```shell
# 2. class meta key warning
Class zlatex Warning: You use an invalid key "font" or key assign for it in
(zlatex)              the meta key "mathSpec", Valid options
(zlatex)              are:newtx,mtpro2,euler,mathpazo; Assignment Ignored and
(zlatex)              LaTeX default mathSpec settings substitute.


Class zlatex Warning: You use an invalid key "counter" or key assign for it in
(zlatex)              the meta key "mathSpec", Valid options
(zlatex)              are:alias(<bool>:false),envStyle,font(<choice>:newtx,mtpr
o2,euler,mathpazo);
(zlatex)              Assignment Ignored and LaTeX default mathSpec settings
(zlatex)              substitute.


Class zlatex Warning: You use an invalid key "openAll" or key assign for it in
(zlatex)              the meta key "layout", Valid options
(zlatex)              are:margin(<bool>:false),slide,aspect; Assignment
(zlatex)              Ignored and LaTeX default layout settings substitute.
```

### auto correct error 
After updating the message system, it will automatically correct some errors users make.
Below is an example about MathEnv style set error:
```shell 
Class zlatex Warning: MathEnv style:'paris' requires package 'tcolorbox' and
(zlatex)              'tikz', But either of them hasn't been loaded in your
(zlatex)              preamble. Reset to default 'plain' style now.
```


### test source
Here is the source for message system debug:
```latex
\documentclass[
  fancy,
  hyper,
  class=hello,
  classOption={12pt},
  layout={margin, slide, aspect=16|9},
  font=config,
  toc={titlee=CONTENTS},
  mathSpec={
    font=eulerr, 
    counter=world
  },
  font=lm,
  layout=openAll,
  bib_index={Notload},
  % lang=cn,
  hello=world,
]{zlatex}
```

## class option interface
### introduction
Change meta-key level in class option interface, now theese meta key is:
```latex
\zlatex_define:nn { option / font }{
config              .bool_gset:N  = \g__zlatex_font_config_bool,
config              .initial:n    = { false }, 
unknown             .code:n       = { \zlatex_metakey_warning_msg:nn {font}{config(<bool>:false)} }
}
```


### \zlatexSetup Vs class option
In class option setup, you can't using `\` in the value, that means you can use any command during the options passing. Thus the following code will cause error:
```latex
\documentclass[
  toc={title=\textbf{CONTENTS}},
]{zlatex}
```

while in the preamble ~~or after `\begin{document}`~~ you can use command `\zlatexSetup` to setup your you options with `\` and so on, like the following:
```latex 
\zlatexSetup{
  toc={
        title=\hfill\large\normalfont CONTENTS {\sffamily\small NEW}\hfill
    }
}
```

> * `\zlatexSetup` can be only used in preamble now

Some tips:
* Some options can only be declared in preamble, like: `fancy`, `class`


|        Option      | class option | \zlatexSetup |
| :----------------: | :----------: | :----------: |
| lang               | :white_check_mark: | :x: |
| hyper              | :white_check_mark: | :x: |
| fancy              | :white_check_mark: | :x: |
| class              | :white_check_mark: | :x: |
| classOption        | :white_check_mark: | :x: |
| packageOption      | :white_check_mark: | :x: |
| toc                | :white_check_mark: | :white_check_mark: |
| font               | :white_check_mark: | :white_check_mark: |
| layout             | :white_check_mark: | :x: |
| section            | :white_check_mark: | :white_check_mark: |
| mathSpec           | :white_check_mark: | :white_check_mark: |
| bib_index          | :white_check_mark: | :white_check_mark: |

> See below `\zslideSetup` for more info.


## slide mode
zLaTeX now provides command `\zslideSetup` for slide mode setup, command args spec:
```latex
\zslideSetup[<sub-key>]{<key-value list>}
```

### basic settings
For common item setup, like `slide theme`, `slide metadata`, an simple example:
```latex
\usepackage{pifont}
\definecolor{ColorA}{HTML}{1abc9c}
\definecolor{ColorB}{HTML}{8e44ad}
\definecolor{ColorC}{HTML}{341f97}
\zslideSetup{
  sec = {bg=ColorC, fg=white, prefix=\ding{73}\ },
  UL = {bg = ColorA, text=UL-TEXT\textcolor{white}{WHITE}, fg=ColorB},
  BC = {text={\hyperlink{zslide-title-page}{\zslideTitle}}},
}
```

Update to default `UR` content according to the beamer theme  `AnnArbor`:
```latex 
UR / text      .initial:n = { {\ifnum\arabic{subsection}=0\else Subsection\ \thesubsection\fi} },
```

### ToC settings
For toc setup, a example like:
```latex
\setcounter{tocdepth}{3}
\zslideSetup[toc]{
  leftmargin = {
    chapter=2em,
    section=4em, 
  },
  suffix = {
    section=\dotfill\textcolor{blue}{\textbf{\zslideTocPage}}
  },
  label = {
    chapter=\contentslabel{8em}, 
    section=\zslideToclabelSet[3em]{\color{green}\thecontentslabel},
    subsection=\zslideToclabelSet{\thecontentslabel}
  },
}
```


## title format
### chapter
Scale the `\thechapter` to 2.5 instead of the original 4. Remove the additional `\makeatlette`, `\makeatother` commands


### ToC 
Add `title`, `column` and `title-vspace` options to toc setting interface. The original `\contentname` lies the `\section*{}`, definition as below:
```latex 
\renewcommand\tableofcontents {
  \if@twocolumn\@restonecoltrue\onecolumn\else\@restonecolfalse\fi
  \section*{\contentsname\@mkboth{\MakeUppercase\contentsname}{\MakeUppercase\contentsname}}
  \begin{multicols}{3}
  \@starttoc{toc}
  \end{multicols}
  \if@restonecol\twocolumn\fi
  \setcounter{page}{1}
}
```