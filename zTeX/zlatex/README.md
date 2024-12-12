# change log
## l3build stautus
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

A new debug folder added to this project, a useful file `zlatex-cfg.tex`:
```latex 
\makeatletter
\def\input@path{{../code/}{../code/module/}{../code/library/}}
\makeatother
```

when running frequent debug.


## split zlatex class to modules and libraries
Class `zlatex` has been split into 3 parts:
* `zlatex.cls`: the main class file
* `module`: the neccessary files(functions) for zlatex 
* `library`: the optional files(functions) for zlatex

> Additional `\makeatlette` and `\makeatother` has been removed from these modules and libraries by adding `\makeatlette` in front of the inputing command `\file_input:n {#1/zlatex.#1.##1.tex}`


## package dependency
add package 
* `anyfontsize`: fixed font scale 
* `multicols`: multi-cols toc support

remove
* `multitoc` in multi-cols toc support


> The package `microtype` and `csquotes` will automatically load `etoolbox`


## Class Tools 
### overview
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

update `\zlatexverb`, now the definition is:
```latex    
\NewDocumentCommand\zlatexVerb{O{\texttt}v}{#1{#2}}
```

This command act as an argument in another command, like:
```latex
\foo{\zlatexVerb{<ARGUMENT>}}
```

### ztool package
Update: 2024-11-27
These box related functions has moved to module `ztool`. Besides these box-related function, these functions have been implemented:
* shell escape replated, copy from the original `l3sys-shell` package plus some modification.
* IO: add a function `\ztool_append_to_file:nn {file}{content}` to append content to a exsiting file.
* box-related: get box content dimension, resize box content to a pre-defined dimension.

> The way(`\RequirePackage{../../ztool/code/ztool}`) i call this package in `zlatex.cls` does not seems to be appropriate.

## hyperref 
### example
Some commands maybe useful for hyperref setup:
```latex
\@currentHref .hint

\hyper@link { link }

\Hy@raisedlink { \hyper@anchor {#1} }
```

use example of these commands:
```latex
\cs_new_protected:Npn \@@_problem_label_aux:n #1
  {
    \refstepcounter { problem }
    \set@display@protect
    \tl_gset:Nx \g_@@_curr_item_tl
      { \c_backslash_str item [ {#1} { \@currentHref } ] }
    \set@typeset@protect
    \exp_args:No \@@_hyper_link:nn
      { \@currentHref .hint }
      { \@@_label_format:n {#1} }
  }
\cs_new_protected:Npn \@@_hint_label:n #1
  { \@@_label:nnnn { .hint } { .solution } #1 }
\cs_new_protected:Npn \@@_solution_label:n #1
  { \@@_label:nnnn { .solution } { } #1 }
\cs_new_protected:Npn \@@_label:nnnn #1#2#3#4
  {
    \cs_set_eq:NN \prefix \@@_label_prefix:nn
    \@@_hyper_anchor:n { #4#1 }
    \@@_hyper_link:nn
      { #4#2 }
      { \@@_label_format:n {#3} }
  }
\tl_new:N \g_@@_curr_item_tl
\cs_new_protected:Npn \@@_label_format:n #1
  { \normalfont \bfseries #1 }
\cs_new_protected_nopar:Npn \@@_hyper_link:nn
  { \hyper@link { link } }
\cs_new_protected_nopar:Npn \@@_hyper_anchor:n #1
  { \Hy@raisedlink { \hyper@anchor {#1} } }
```

### cref
Bug of `cleveref`? see mwe below:
```latex 
\documentclass{article}
\usepackage[nameinlink]{cleveref}


\newcounter{THM}[section]
\crefname{THM}{aaa}{bbb} % aaa --> aa, works right
\NewDocumentEnvironment{THM}{o}{
  \refstepcounter{THM}
}{}
\begin{document}
\begin{THM}[TEST]\label{thm:1}
  Hello world: $a^2+b^2=c^2$.
\end{THM}

BBB: \cref{thm:1}
\end{document}
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


### thm title hook (TODO)
There are 2 ways to set the title format of theorem-like envs:
* hook with args:
```latex
\documentclass{article}
\usepackage{amsmath, amsthm}
% preamble
\NewHookWithArguments{zlatex/thm/titleformat}{3}
\newtheoremstyle{zlatexMathEnv}
  {2pt}{2pt}{}
  {0pt}{\bfseries}{}
  {.25em}
  {
    \UseHookWithArguments{zlatex/thm/titleformat}{3}{#1}{#2}{#3}
  }
\theoremstyle{zlatexMathEnv}

\newcommand{\zlatexThmTitleFormat}[1]{
  \IfHookEmptyTF{zlatex/thm/titleformat}{}
    {\RemoveFromHook{zlatex/thm/titleformat}[once]}
  \AddToHookWithArguments{zlatex/thm/titleformat}[once]{#1}
}

% main document
\begin{document}
\newtheorem{aaa}{AAA}
\zlatexThmTitleFormat{\thmname{#1}. \thmnumber{#2} \thmnote{(#3]}}
\begin{aaa}[SECOND]
  ENV-CONTENT-SECOND
\end{aaa}
\end{document}
```

* hook without args:
```latex
\documentclass{article}
\usepackage{amsmath, amsthm}


% preamble
\ExplSyntaxOn
\NewHook{zlatex/thm/titleformat}
\newtheoremstyle{zlatexMathEnv}
  {2pt}{2pt}{}
  {0pt}{\bfseries}{}
  {.25em}
  {
    \cs_set:Npn \ThmName { \thmname{#1} }
    \cs_set:Npn \ThmNumber { \thmnumber{#2} }
    \cs_set:Npn \ThmNote { \thmnote{#3} }
    \UseHook{zlatex/thm/titleformat}
  }
\theoremstyle{zlatexMathEnv}

\newcommand{\zlatexThmTitleFormat}[1]{
  \IfHookEmptyTF{zlatex/thm/titleformat}{}
    {\RemoveFromHook{zlatex/thm/titleformat}[once]}
  \AddToHook{zlatex/thm/titleformat}[once]{#1}
}
\ExplSyntaxOff


% main document
\begin{document}
\newtheorem{aaa}{AAA}
\zlatexThmTitleFormat{\ThmName. \ThmNumber [\ThmNote)}
\begin{aaa}[SECOND]
  ENV-CONTENT-SECOND
\end{aaa}
\end{document}
```

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


### package Option 
The `packageOption` interface is available now in zLaTeX. Implement the `package-option` interface by `l3keys`; Now this interface has been implemented, a example usage:
```latex
\documentclass[
    lang=cn,
    packageOption={
        fontspec=quiet, 
        ctex={scheme=plain, punct=quanjiao}
    },
]{zlatex}
```

### color setup
#### feature 
now you can use the following syntax to setup your color:
```latex
\zlatexThmCreate{theorem}{Ztheorem=THM|{HTML}{8e44ad}, Zproposition} 

\zlatexColorSetup{
  definition=blue,
  theorem={HTML}{007175},
  Ztheorem={RGB}{219,48,122}
}
```

You do NOT need to use `\definecolor` command to setup your color, just use the `zlatexColorSetup` command to setup your color. 

> All color mode that xcolor support is valid in `zlatex`, eg, `RGB`, `cmyk`, ...

#### bug
Current you can only use a specific color that pre-defined before in `.initial:n`. Can NOT create these colors dynamiclly. 

There is a simple mwe provides different ways to dynamiclly setup colors:

```latex
\documentclass{article}
\usepackage{xcolor}


\begin{document}
\ExplSyntaxOn\makeatletter
\regex_new:N \l__color_mode_regex
\regex_set:Nn \l__color_mode_regex {(\cB..{1,}\cE.){2}}
\cs_new:Npn \test__color_set:n #1 {
  \regex_match:NnTF \l__color_mode_regex {#1}{
    \typeout{---->~ \use_ii:nn #1}
    \typeout{---->~ def}
    \definecolor{Test@\l_keys_key_str}#1
    \tl_set:ce {l_test_\l_keys_key_str _tl}{Test@\l_keys_key_str}
  }{
    \@ifundefined{\string\color@#1}{
      \msg_new:nnn {color} {undefined} {--->~Color~`#1'~undefined}
      \msg_error:nn {color} {undefined}
    }{
      \tl_set:ce {l_test_\l_keys_key_str _tl}{#1}
    }
  }
}
\keys_define:nn {test}{
  keyA  .tl_set:N  = \l_test_keyA_tl,
  keyA  .initial:n = {green},
  keyA  .code:n    = {\test__color_set:n {#1}},
  keyB  .tl_set:N  = \l_test_keyB_tl,
  keyB  .initial:n = {black},
  keyB  .code:n    = {\test__color_set:n {#1}},
}

% EXAMPLES
\textcolor{\l_test_keyA_tl}{TEXT-keyA}\par
\textcolor{\l_test_keyB_tl}{TEXT-keyB}\par

\keys_set:nn {test}{keyA={HTML}{0f45f3}}
\textcolor{\l_test_keyA_tl}{TEXT-keyA}\par

\keys_set:nn {test}{keyA={HTML}{8975f3}}
\textcolor{\l_test_keyA_tl}{TEXT-keyA}\par

\keys_set:nn {test}{keyB=orange}
\textcolor{\l_test_keyB_tl}{TEXT-keyB}\par

% \keys_set:nn {test}{keyB=orangee}
% \textcolor{\l_test_keyB_tl}{TEXT-keyA}\par
\makeatother\ExplSyntaxOff
\end{document}
```

But currently, there are some problem in `.initial:n`, the following initial color will NOT work.

```latex   
\cs_new:Npn \__test_color_cmd:n #1 {
  \regex_match:nnTF {#1}{ab}{green}{red}
}

\cs_new:Npn \test__color_set:nn #1#2 {
  % \typeout{#2} % #2 = {HTML}{0f45f3}
  \regex_match:NnTF \l__color_mode_regex {#1}{
    \typeout{---->~ \use_ii:nn #1}
    \typeout{---->~ def}
    \definecolor{Test@\l_keys_key_str}#1
    \tl_set:ce {l_test_\l_keys_key_str _tl}{Test@\l_keys_key_str}
    % \tl_if_empty:nTF {#2}
    %   {\tl_set:cn {l_test_\l_keys_key_str _tl}{Test@\l_keys_key_str}}
    %   {Test@\l_keys_key_str}
  }{
    \typeout{---->~ #1}
    \typeout{---->~ use}
    \@ifundefined{\string\color@#1}{
      \msg_new:nnn {color} {undefined} {--->~Color~`#1'~undefined}
      \msg_error:nn {color} {undefined}
    }{
      \tl_set:ce {l_test_\l_keys_key_str _tl}{#1}
      % \tl_if_empty:nTF {#2}
      %   {\tl_set:cn {l_test_\l_keys_key_str _tl}{#1}}
      %   {#1}
    }
  }
  \tl_if_empty:nF {#2}
    {\use:c {l_test_\l_keys_key_str _tl}}
}

\keys_define:nn {test}{
    ...
    keyB  .initial:n = {\__test_color_cmd:n {ab}},
    keyB  .initial:n = {\test__color_set:nn {orange}{init}},
    keyB  .initial:e = {\test__color_set:nn {{HTML}{0f45f3}}{init}},
    ...
}
```

Some code for debugging:
```latex 
\documentclass{article}
\usepackage[T1]{fontenc}
\usepackage{xcolor}


\begin{document}
\ExplSyntaxOn\makeatletter
\cs_new:Npn \__other_color_cmd:nn #1#2 {
  % \tl_if_empty:NF {#2}{
  %   \definecolor{Test@\l_keys_key_str}{#1}{#2}
  % }
  \tl_if_empty:NTF {#2}{#1}{
    Test@\l_keys_key_str
  }
}
\cs_new:Npn \__test_color_cmd:n #1 {
  \regex_match:nnTF {ab}{#1}{green}{red}
  % \tl_if_in:nnTF {abc}{#1}{green}{red}
  % \typeout{#1}
  % \tl_if_empty:nTF {#1}{EMPTY}{FILLED}
}
\keys_define:nn {test}{
  keyA  .tl_set:N  = \l_test_keyA_tl,
  keyB  .tl_set:N  = \l_test_keyB_tl,
  % keyB  .initial:e = {\__test_color_cmd:n {ab}},
  % keyB  .initial:e = {\__other_color_cmd:nn {HTML}{0f45f3}},
  keyB  .initial:e = {\__other_color_cmd:nn {red}{}},
}
% \keys_precompile:nnN {test}{keyB=\__test_color_cmd:n {ab}}\l_tmpa_tl
% \tl_use:N \l_tmpa_tl
% \__test_color_cmd:n {c}\par % success
% \__test_color_cmd:n {abc}\par % success


% \vskip4em
\keys_set:nn {test}{keyA=AAA}
\cs_meaning:N \l_test_keyB_tl\par
% \tl_use:N \l_test_keyB_tl\par
% \exp_args:Nee \textcolor{\l_test_keyB_tl}{TEXT-BBB}
\makeatother\ExplSyntaxOff
\end{document}


% ===> DEBUG SECTION <=== %
\test__color_set:nn {red}{init}\par
\test__color_set:nn {{HTML}{0f45f3}}{init}
\tl_use:N \l_test_keyB_tl\par
\tl_show:N \l_test_keyB_tl % > \l_test_keyB_tl=\test__color_set:nn {orange}{init}.
\textcolor{\l_test_keyA_tl}{TEXT-keyA}\par
% ===> DEBUG SECTION <=== %
```
Remark:
* The main reason is that some functions can NOT be fully exapnded in `e`-type, eg. `\regex_match:NnTF`.
* A weird synomyms of `\textcolor{\l_test_keyA_tl}{TEXT-keyA}`: only when there is a `\tl_use:N \l_test_keyB_tl` before it, the color will be set correctly.

### `+=` keys assign
A new feature like this need to be added, similar to what `ctex` do:
```latex 
\ctexset{
  chapter/format     = \sffamily\raggedright,
  section/format    += \sffamily,
  subsection/format += \fbox,
}
```

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


### Test source I
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

### Test source II
```latex 
\documentclass{article}

\begin{document}
\ExplSyntaxOn
\keys_define:nn {test}{
key-a  .code:n = {key-a:~#1},
key-b  .code:n = {key-b:~#1},
m-key / mkey-a  .code:n = {mkey-a:~#1},
m-key / mkey-b  .code:n = {mkey-b:~#1},
m-key / unknown .code:n = {
    \msg_new:nnn {text/m-key}{unknown-mkey}{Unknown~key:\l_keys_path_str}
    \msg_warning:nn {text/m-key}{unknown-mkey}
},
unknown .code:n = {
    \msg_new:nnn {text}{unknown-key}{Unknown~key:\l_keys_path_str}
    \msg_warning:nn {text}{unknown-key}
}
}

\keys_set:nn {test}{
key-a = 1,
key-c = 3,
m-key/mkey-a = 4,
m-key/mkey-c = 6,
}
\ExplSyntaxOff

% WRONG WARNINGs
% Package slide/sec Warning: KEY:zlatex/slide/hello
% Package slide Warning: KEY:zlatex/slide/hello

% EXPECTED WARNINGs
% Package text Warning: Unknown key:test/key-c
% Package text/m-key Warning: Unknown key:test/m-key/mkey-c
\end{document}
```

Now the message looks like:
```shell
Class zlatex Warning: You use an invalid key "zlatex/slide/world" or key
(zlatex)              assign for it in the meta key "slide", Valid options
(zlatex)              are:sec(<key-value>:prefix,suffix,bg,fg),
(zlatex)              UL(<key-value>:text,bg,fg),UR(<key-value>:text,bg,fg),
(zlatex)              BL(<key-value>:text,bg,fg),BC(<key-value>:text,bg,fg),
(zlatex)              BR(<key-value>:text,bg,fg); Assignment Ignored and
(zlatex)              zLaTeX default "slide" settings of this key substitute.


Class zlatex Warning: You use an invalid key "zlatex/slide/toc/hello" or key
(zlatex)              assign for it in the meta key "slide/toc", Valid options
(zlatex)              are:leftmargin(<key-value>:chapter[<dim>:2em],section[<di
m>:4em],subsection[<dim>:6em]),
(zlatex)              label(<key-value>:chapter[<tl>:thechapter;hbox:1em],secti
on[<tl>:thesection;hbox:1em],subsection[<tl>:thesubsection;hbox:2em]),
(zlatex)              after(<key-value>:chapter[tl:<empty>],section[tl:<empty>]
,subsection[tl:<empty>]);
(zlatex)              Assignment Ignored and zLaTeX default "slide-toc"
(zlatex)              settings of this key substitute.
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

Some tips: Some options can only be declared in preamble, like: `fancy`, `class` while some can be used both preamble and after `\begin{document}`.


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

## font module 
Now, only some simple configurations have been added to this module, total content till now is:
```latex
\ProvidesExplFile{zlatex.module.fontcfg.tex}{2024/10/24}{1.0.0}{fontcfg~module~for~zlatex}


%%%%%     font config module for zlatex     %%%%%
% ==> math font
\DeclareMathSymbol{\blacktriangleright}{\mathrel}{AMSa}{"49}


% ==> text font
\cs_new:Nn \__zlatex_text_symbol_patch: 
  {
    \let\oldtextbullet\textbullet
    \DeclareTextFontCommand{\zslideCmsyOms}
      {\fontfamily{cmsy}\fontencoding{OMS}\selectfont}
    \DeclareRobustCommand{\textbullet}
      {\zslideCmsyOms\oldtextbullet}
  }
% cinel font
\zlatex_hook_preamble_last:n {
  \bool_if:NTF \g__zlatex_font_config_bool {
    \RequirePackage{fontspec}
    \newfontfamily{\Cinzel}{CinzelRegular.ttf}[
      BoldFont=CinzelBold.ttf,
      ItalicFont=SabonItalic.ttf
    ]
  }{\def\Cinzel{\relax}}
}
% Source Han Serif SC ???
```

## slide mode
### Update: 2024-09-20
Now zlatex provide 2 functions for users to costum the slide theme:
```latex
\zslideThemeCreate{<theme-name>}{<key-value-list>}
\zslideThemeUse[<overwrite-keys-assign>]{<theme-name>}
```

both all these 2 commands can be only used in preamble. To create a simple color scheme, something like the below:
```latex 
\zslideThemeCreate{test}{
  UL={text=UL-TEXT},
  UR={text=UR-TEXT},
  sec={bg=black, fg=white, prefix=\ding{100}}
  % toc setting
  toc={
    leftmargin = {section=10em, subsection=15em},
  }
}
\zslideThemeUse{test}
```

Add a new key to meta key `slide`:
```latex 
...
aspect          .initial:n    = { 12|9 },
theme           .str_gset:N   = \g__zlatex_slide_theme_str,
theme           .initial:n    = { AnnArborDefault },
...
```

Theme selection only available in `class options`, and the default theme is `AnnArborDefault`. The theme list is:
* AnnArborDefault
* AnnArborBeaver
* AnnArborAlbatross
* AnnArborSeahorse

You can change some properties of the loaded theme by command `\zslideThemeUse` like that:
```latex
\zslideThemeUse[doc={text-style=\rmdefault, text-color=red}]{AnnArborBeaver}
```

### Update: 2024-09-17
zLaTeX now provides command `\zslideSetup` for slide mode setup, command args spec:
```latex
\zslideSetup[<sub-key>]{<key-value list>}
```

### Update 2024-10-24
Command `\FF` conflicting with `\FF` command in `ascii` package:
```latex 
% ascii package
\def\FF{{\asciifamily\char"0C}\xspace}
% zlatex class
\newcommand{\FF}[1]{\ensuremath{\mathbf{#1}}}
```

Just let a alias `\let\asciiFF\FF` when loading `ascii` package, see below:
```latex
\@ifpackageloaded{ascii}
    {\let\asciiFF\FF\renewcommand{\FF}[1]{\ensuremath{\mathbf{#1}}}}
    {\newcommand{\FF}[1]{\ensuremath{\mathbf{#1}}}}
```

### auto scale graphics
A simple solution may be:
```latex
\makeatletter
\def\rubberPicHeight{%
  \ifdim\Gin@nat@height>\paperheight
    .5\paperheight
  \else\Gin@nat@height\fi
}
\let\oldincludegraphics\includegraphics
\setkeys{Gin}{height=\rubberPicHeight}
\renewcommand\includegraphics[2][]{%
  \oldincludegraphics{#2}%
}
\makeatother


\includegraphics{Epmmy.jpg}
```

But this method is NOT too reflexiable. The better method may be use package `adjustbox` as:
```latex
\includegraphics[max width=\linewidth]{<image file name>}
```

Then i WON'T Implement this feature. For more detail, see: [Scale (resize) large images (graphics) that exceed page margins](https://tex.stackexchange.com/q/6073/294585)

### hyperref support
Hyperref is support now, such anchors are available:
* `page.<page num>`: link to abusolute page index `<page num>`
* `zslide@\FirstMark{zslide-left}.<frame index>`: link to frame indexd at `<frame index>` in section `\FirstMark{zslide-left}` (roughly equals to current section).

A users' interface `\zslide@navigate:nnnn` have been created, syntax as follows:
```latex
\zslide@navigate:nnnn 
    {<total frame num>}
    {<current frame index>}
    {<current frame symbol>}
    {<other frame symbols>}
```

You can access the total frame num by macro: `\zslideFrame{<Roman number>}`, `I`, `II`, `\Roman{section}` and so forth, which will return the total frames the current section has. Current frame number can be retrived by command `\zslideFrameIndex`.

> In the future, command `\zslideFrame` maybe extends to `chapter` or `subsection`, not just counting `section`'s frame total number.

Add one function `\zslideIfPageTF{}{}{}` to check page number, syntax as follows:
```latex
\zslideIfPageTF{<operators><num>}{<True Branch>}{<False Branch>}
```

#### basic settings
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

#### Navigate symbols 
Update the Navigate ball color to the `UR Foreground` color, 
i.e., `\l__zlatex_slide_UR_fg_tl`. See current definition below:

```latex
\NewDocumentCommand{\zslideNavigateBall}{O{\(\bullet\)}O{\(\circ\)}}{
  \cs_if_exist:cTF {zsec@\Roman{section}@cnt}
    {\zslide@navigate:nnnn 
      {\zslideFrame{\Roman{section}}}
      {\zslideFrameIndex}
      {\textcolor{\l__zlatex_slide_UR_fg_tl}{#1}}
      {\textcolor{\l__zlatex_slide_UR_fg_tl}{#2}}
    }{??}
}
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

Remove dependency: `ascii` package, use the existing `AMSb` symbols font to declare such `\DLE` macro, original definition:

```latex 
% in 'fontcfg' module
\DeclareMathSymbol{\blacktriangleright}{\mathrel}{AMSa}{"49}


% in 'slide' library 
\gdef\zslidesecIcon
  {\box_move_up:nn {2pt}
    {\hbox:n {\ztool_resize_to_wd:nn 
      {6pt}{\(\blacktriangleright\)}}
    }
  }
\gdef\zslidesubsecIcon{\rule[1.5pt]{3pt}{3pt}}
```

### font family patch 
When switch to text family `\sfdefault`, the `\textbullet` will become a square. I have do a patch to revert it to original shape:
```latex 
% in 'fontcfg' module
\cs_new:Nn \__zlatex_text_symbol_patch: 
  {
    \let\oldtextbullet\textbullet
    \DeclareTextFontCommand{\zslideCmsyOms}
      {\fontfamily{cmsy}\fontencoding{OMS}\selectfont}
    \DeclareRobustCommand{\textbullet}
      {\zslideCmsyOms\oldtextbullet}
  }

% in 'slide' library 
\zlatex_hook_preamble_last:n 
  { 
    \pagestyle{empty} 
    \__zlatex_text_symbol_patch:
  }
```

### themes 
Add a new theme: `AnnArborSpruce`,which is based on `green`. For more color themes, you can refer to [A New Beamer Theme Matrix](https://mpetroff.net/files/beamer-theme-matrix/).

- [x] fixed bug: annotations added by `\zlatexPageMask` are invisible.
- [x] Unified color scheme for `UR` and `BR` text.
- [x] Provide an `\zslidelogo` command for slide mode.
- [x] fixed warning: dupicate hyper target when use `\tableofcontents`.

Syntax of command: `\zslidelogo` (only accessiable in preamble):
```latex 
\zslidelogo[
  width=3em, 
  exclude={0, 1},
  position={(20pt, 30pt)}
]{Epmmy.jpg}
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

Now the toc interface syntax is:
```latex
\zlatexSetup{
  toc={
    column=<int>,
    title=<title>,
    title-vspace=<dim>,
    stretch=<float>
  }
}
```

## thm module
### intro 
Now this thm module can do these things, especially that: `thm` module now provides a user-friendly interface to create new theorem/proof-like envs, the commands are:
* manually create new theorem/proof-like envs
* set the title format of theorem-like envs
* change the style of theorem-like envs: colors, titlebar
* custom the warper of each theorem-like envs
* thm envs names setup interface of different languages, i implemented the `fr` and `cn` languages, you can add more languages by yourself.


### main commands
The main commands of this module are:
```latex
% 1. create new theorem/proof-like envs
\zlatexThmCreate{theorem}{Zaxiom, Ztheorem=Thm|green, Zproposition=Prop|orange}
\zlatexThmCreate{proof}{Zproof, Zexample=Example|red, Zsolution=Solution|}


% 2. set the title format of theorem-like envs
% NOTE: This command will overwrite the existing environments
\zlatexThmTitle % thm title content
\zlatexThmTitleSwitch % thm title inline or not
\zlatexThmTitleFormat{<format>, <content, such as:\zlatexThmNumber, \zlatexThmName, \zlatexThmNote>}
\zlatexThmTitleFormat*{<format>, <content, such as:\zlatexThmNumber, \zlatexThmName, \zlatexThmNote>}
\zlatexThmCnt{share, parent=<counter name:section, subsection, ...>}


% 3. change the style of theorem-like envs
\zlatexThmStyle{elegant}
\zlatexThmColorSetup{<theorem/proof-like envs' name>=<color>}


% 4. custom the warper of each theorem-like envs
\zlatexThmStyleNew{<style>={begin=<.>, end=<.>, option=<.>}}


% 5. thm envs names setup interface of different languages
\zlatexThmLang{fr}
\zlatex_math_env_name_set:nn {fr}{
  axiom       = Axiome, 
  definition  = Définition, 
  theorem     = Théorème, 
  lemma       = Lemme, 
  corollary   = Corollaire, 
  proposition = Proposition, 
  remark      = Remarque, 
  proof       = Preuve, 
  exercise    = Exercice, 
  example     = Exemple, 
  solution    = Solution, 
  problem     = Problème,
}


% 6. thm hooks
\zlatexThmHook{<next hook>}
\zlatexThmHook*{<next all hook>}


% 7. list of theorems
\zlatexThmToc[
  title-vspace=<dim>, 
  title=<title>,
  after-vspace=<dim>,
  stretch=<float>
]
\zlatexThmTocPrefix{<prefix>}
\zlatexThmTocSymbol{
  lemma=<lemma symbol>,
  definition=<definition symbol>,
  ....
}
% clear all predefined thm toc symbol
\zlatexThmTocSymbolClear 
\zlatexThmSecAdd[name=<toc name>]{<toc level:chapter, section, etc.>}
```

### bug fixed 
Fixed bug: optional braces, brackets around `\zlatexThmNote` when it is empty. Now the syntax is:
```latex 
\zlatexThmNote{<before>}{<end>}
% --> output:
% <before><Thm-Note><end>
```

To define a complex Thm title format, users may use command `\zlatexThmNoteEmptyTF`, which is provided by `thm` module in zlatex, to check whether it's empty or not, definition of this command as below:
```latex 
\NewDocumentCommand{\zlatexThmNoteEmptyTF}{mm}
  {
    \tl_if_empty:eTF {\zlatexThmNote{}{}}
      {#1}
      {#2}
  }
```

The corresponding format in List of Theorem command `\zlatexThmToc` fixed as well.

### Set color spec 
color spec is very simple now, see below:
```latex 
% way 1
\zlatexThmCreate{theorem}{Ztheorem=THM|{HTML}{8e44ad}, Zproposition} 

% way 2
\zlatexColorSetup{
  definition=blue,
  theorem={HTML}{007175},
  Ztheorem={RGB}{219,48,122}
}
```

Command `\zlatexColorSetup` is only available in preamble. Though, I do NOT recommend using too much color in your script, you can change color temporarily using command such as the following:
```latex 
% users' interface
\zlatexThmColorSetup{
  definition={HTML}{22b8cf},
}

% the implementation of the above command
\ExplSyntaxOn
\zlatex_keys_set:nn {color}{
  definition  = {RGB}{219,48,122},
}
\ExplSyntaxOff
```

### thm hooks 
Now the `thm` module provides 4 hooks for users to custom the theorem-like envs. The places of these hooks are:
```latex
(zlatex/thmstyle/before) --> (warper begin) 
--> (thm-title) --> (zlatex/thmstyle/begin) --> (thm-content) --> (zlatex/thmstyle/end) --> 
(warper end) --> (zlatex/thmstyle/after)
```

The implementation as below:
```latex
\NewDocumentEnvironment{#1}{O{}}{
  \refstepcounter{#1}
  \UseHook{zlatex/thmstyle/before}
  \__zlatex_thm_warp_start:nnnn {#1}{##1}{\bfseries}{\ }
  \__zlatex_thm_title:                                  
  \UseHook{zlatex/thmstyle/begin}
}{
  \UseHook{zlatex/thmstyle/end}
  \__zlatex_thm_warp_end:
  \UseHook{zlatex/thmstyle/after}
}
```

Command `\zlatexThmHook` is used to add your own code chunks to these places, syntax:
```latex 
% only add to the next one
\zlatexThmHook{
    before=<BEFORE code>, 
    begin=<BEGIN code>, 
    end=<END code>, 
    after=<AFTER code>
}

% add to all thm ebv below
\zlatexThmHook*{
    before=<BEFORE code>, 
    begin=<BEGIN code>, 
    end=<END code>, 
    after=<AFTER code>
}
```

Remark:
* the function `\zlatexThmStyleNew`(this function can be only used in preamble) are based on these hooks.
* the macro `\zlatexThmTitle` and `\zlatexThmTitleSwitch` may be useful for you to custom the title format of theorem-like envs.
* The hooks `zlatex/thmstyle/end` and `zlatex/thmstyle/after` are reversed.

For that the original `HOOK` thm style is removed, thus the original definition of `\zlatexThmStyleNew`:
```latex 
% dependency of this command:
\DeclareDocumentEnvironment{zlatexTheoremWarper}{O{axiom}}{{
    ...
    {HOOK}{\UseHook{zlatex/math/envstyle/begin}}
    ...
    }{
    ...
    {HOOK}{\UseHook{zlatex/math/envstyle/end}}
    ... 
    }
}

% definition
\NewDocumentCommand{\zlatexThmStyleNew}{mm}{
  \AddToHook{zlatex/thmstyle/begin}{#1}
  \AddToHook{zlatex/thmstyle/end}{#2}
  \ActivateGenericHook{zlatex/thmstyle/begin}
  \ActivateGenericHook{zlatex/thmstyle/end}
  \tl_gset:Nn \g__zlatex_thm_style_tl {HOOK}
}
\@onlypreamble\zlatexThmStyleNew
```

Now the implementation is:
```latex 
\NewDocumentCommand{\zlatexThmStyleNew}{smm}{
  \IfBooleanTF{#1}
    {\zlatexThmHook*{#2}{#3}}
    {\zlatexThmHook{#2}{#3}}
}
```

> In the future, this function maybe be changed, i will use this function to add more `thm` style like the `\_zslide_theme_create:nn` function in `slide` library plays on.
> please use this command with `*` in the preamble, or some unexpected error may occur.

Update: 2024-11-13
Now the command `\zlatexThmStyleNew` is implemented by `l3keys`, then you could add your own thm style freely. The Syntax of this function as follows:
```latex 
\zlatexThmStyleNew {
  <thm style name> = {
    begin  = <env begin code>, 
    end    = <env end code>, 
    option = <env begin option>
  },
}
```

What you need pay attention to is `<env begin option>`, in this part, you can specify whether to display `thm title` inline or hang on the top like in tcolorbox. Use function:
```latex
\__zlatex_thm_title_inline:n {T}
% T: inline 
% F: on the top
```

Or you can set the thm envs colors, see the `elegant` thm-style for reference:
```latex
\zlatexThmStyleNew {
  elegant = {
    begin = {
      \begin{tcolorbox}[
        enhanced,   breakable,
        top=8pt,    bottom=1.5pt,
        left=3pt,   right=3pt,
        arc=3pt,    boxrule=0.5pt,
        before~upper*={\setlength{\parindent}{1em}},
        fontupper=\rmfamily,   fonttitle=\bfseries,
        lower~separated=false, separator~sign={.},
        attach~ boxed~ title~ to~ top~ left={yshift=-0.11in, xshift=0.15in},
        boxed~ title~ style={boxrule=0pt, colframe=white, arc=0pt, outer~arc=0pt},
        title=\zlatexThmTitle,
        colback  = \thm@temp@color!5, colframe = \thm@temp@color,
        coltitle = white,        colbacktitle = \thm@temp@color,
      ]
    },
    end = {\end{tcolorbox}},
    option = {
      \__zlatex_thm_title_inline:n {F}
      \__zlatex_thm_tcolorbox_warning:
      \zlatex_keys_set:nn {color}{
        axiom       = {HTML}{2c3e50},
        definition  = {RGB}{0, 166, 82},
        theorem     = {RGB}{255, 134, 23},
        lemma       = {RGB}{255, 134, 23},
        corollary   = {RGB}{255, 134, 23},
        proposition = {RGB}{0, 173, 247},
      }
    }
  },
}
```

###  mechanism
A simple analysis of the mechanism of this module:
```latex
% For command:
\zlatexThmCreate{theorem}{Ztheorem=THM|orange}

% ANALYSIS
\__zlatex_math_env_create__:nnn {theorem}{Ztheorem}{THM|orange}
	\zlatex_math_env_create:ne {theorem}{Ztheorem} 
		% the theorem-like clist add a new item "Ztheorem"
	\__zlatex_color_keyval_add:n {Ztheorem}    
		% created a key named "Ztheorem"
	\__zlatex_math_env_color_set:w {Ztheorem}\q_stop THM|orange\q_stop
		% create a new tl "\l__zlatex_Ztheorem_color_tl" and set it to "orange"
    \prop_gput:cee {g__zlatex_math_env_name_prop}
       {#2}{\exp_last_unbraced:Ne \__zlatex_mid_first:w #3\q_stop}
        % add a new key-value pair to the prop for thm title, in this case it is "Ztheorem=THM"
```

The key command is `\__zlatex_color_set:n`, see below:
```latex 
% ==> color setup
\regex_new:N \l__zlatex_color_mode_regex
\regex_set:Nn \l__zlatex_color_mode_regex {(\cB..{1,}\cE.){2}}
\cs_new:Npn \__zlatex_color_set:n #1 {
  \regex_match:NnTF \l__zlatex_color_mode_regex {#1}{
    \definecolor{zlatex@color@\l_keys_key_str}#1
    \tl_set:ce {l__zlatex_\l_keys_key_str _color_tl}{zlatex@color@\l_keys_key_str}
  }{
    \@ifundefined{\string\color@#1}{
      \msg_new:nnn {color} {undefined} {--->~Color~`#1'~undefined}
      \msg_error:nn {color} {undefined}
    }{
      \tl_set:cn {l__zlatex_\l_keys_key_str _color_tl}{#1}
    }
  }
}
```

This function will check your color spec is valid or not, if not, it will throw an error message. If so, it will create a color and set the color tl to the color name dynamiclly. 

### remark
**Remark**: In `fancy` math EnvStyle, you can use command:
```latex 
\setlength{\fboxsep}{0pt}
```
to cancle the color box padding. 

`elegant` thm style page break issue in slide mode, warning message:
```shell
Package tcolorbox Warning: Using nobreak failed. Try to enlarge `lines before break' or set page breaks manually on input line 216.
```

### list of theorem 
Now you can use command `\zlatexThmToc` to create a table of the previous theorem-like env. You can use it for proof-like environments. Once this command is invoke in your source, there will be a file named `\jobname.thlist` occurs in your working dir. This command takes 1 option argument, in form of key-value, syntax as follows:

```latex 
\zlatexThmToc[vspace=<dim>, title=<title>]
```

Additionally, you can use command `\zlatexThmTocLevel` to change the default thm entry level, a simple example:

```latex 
\zlatexThmTocLevel{section}
```

This table of theorems shares the same format as the main table of contents.

Now the syntax is as follows, a simple example:
```latex 
\zlatexThmToc[
  title={\textsc{List of Theorems}},
  stretch=1.5, 
  title-vspace=-10pt, 
  after-vspace=20pt
]
```

### source file backup
The test files is as below:
```latex
\InputIfFileExists{zlatex-cfg.tex}{}{}
\documentclass[
  fancy,
  % hyper,
  % lang=cn,
  % class=book,
  % font={config},
  % layout={margin},
  % layout={slide, theme=AnnArborSeahorse, aspect=16|9},
  % classOption={12pt}
]{../code/zlatex}
\zlatexThmLang{fr}
\zlatexloadlibrary{mathalias}
\zlatexSetup{mathSpec={envStyle=fancy}}
% \zlatexColorSetup{theorem=orange}
\zlatexThmCreate{theorem}{Zaxiom, Ztheorem=Thm|green, Zproposition=Prop|orange}
\zlatexThmCreate{proof}{Zproof, Zexample=Example|red, Zsolution=Solution|}


\def\boomen{As any dedicated reader can clearly see, the Ideal of practical
reason is a representation of, as far as I know, the things in themselves; 
\begin{align}
\underset{}{\mathbf{v} \bigotimes \mathbf{w}} 
  & = \underset{}{\mathbf{v} \otimes \mathbf{w}}
      = \sum_{i=1}^3\sum_{j=1}^3a_{ij}u^iv^j \\[-.75em]
  & = \sum_{i=1}^3\left(a_{i1}u^iv^1+a_{i2}u^iv^2+a_{i3}u^iv^3\right) 
  \end{align}  
}

% \setlength{\fboxsep}{0pt}
\title{z\LaTeX{} Benchmark Test}
\author{Eureka}
\date{\today}
\begin{document}
\maketitle
% \chapter{Hello}
% \section{Py Fijw}
\section{FIRST}
Hello world; \meaning\FF


\begin{theorem}[Pythagorean theorem]\label{Pythagorean theorem}
This is a theorem:
  \begin{align}
    \R{d}^2x + \R{d}^2y = \R{d}^2z\\
    dx = 2
  \end{align}  
\end{theorem}


\section{Internal Math Env}
\begin{zlatexZtheorem}[internal Env]
  Hello Internal Ztheorem
\end{zlatexZtheorem}


\section{New Math Env}
\begin{Zaxiom}
Hello Zaxiom
\end{Zaxiom}

\begin{Ztheorem}[New Thm Users' ENV] % ---> inside thm source
\boomen
\end{Ztheorem}

\zlatexThmStyle{elegant}
\begin{Zproposition}[New Prop Users' ENV]\label{zprop-1}
\boomen

\boomen
\end{Zproposition}



\newpage
\section{Elegant Style Math Env}
\begin{axiom}[prime number]
  \boomen
\end{axiom}

\begin{definition}[prime number]
  \boomen
\end{definition}

\begin{theorem}[prime number]
  \boomen
\end{theorem}

\zlatexThmTitleFormat{\thmname{#1}:\thmnote{[#3]-}\thmnumber{#2}}
\begin{lemma}[prime number]
  \boomen
\end{lemma}

\zlatexThmStyle{plain}
\begin{corollary}[prime number]
  \boomen
\end{corollary}

\begin{proposition}
  \boomen
\end{proposition}


\section{New Proof Env}
\begin{Zproof}
Hello Zproof
\end{Zproof}

\begin{Zexample}
Hello Zexample
\end{Zexample}

\begin{Zsolution}\label{zsolu-1}
Hello Zsolution
\end{Zsolution}

% \href{http://www.google.com}{Google}

\newpage
Hello world:

\begin{itemize}
  \item \cref{Pythagorean theorem}
  \item \cref{zprop-1}
  \item \cref{zsolu-1}
\end{itemize}
\end{document}
```