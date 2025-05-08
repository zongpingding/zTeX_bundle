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
\foo{\zlatexVerb{⟨ARGUMENT⟩}}
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


### thm title hook
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

**This feature has been implemented, see `thm` section for more info.**


### page mask 
There is a command `\zlatexPageMask`, syntax as follows:
```latex 
\zlatexPageMask*[
  layer=⟨foreground/background⟩,
  label=⟨label⟩,
  anchor=⟨combinatrics of 't,b' and 'l,c,r'⟩,
  position=⟨dim1, dim2⟩
]
\zlatexPagaMask[
  % similar to the above, but ⟨label⟩ is not allowed.
]{}
\zlatexPageMaskRemove{⟨foreground/background>}{<label⟩}
```

Star Version command will leave content to all of the rest page, while the other only to current page. Hook rule of `pgfrcs` and `⟨zlatexPagemask⟩` has been fixed.

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

#### one-time labeled-hook 
How to make a once hook with label, current survey about this feature:
```latex 
%%%%  LaTeX3  INTERNAL  %%%%
\cs_new_protected:Npn \hook_gput_code:nnn #1 #2 #3
  {
    \__hook_replacing_args_false:
    \__hook_normalize_hook_args:Nnn \__hook_gput_code:nnn {#1} {#2} {#3}
    \__hook_replacing_args_reset:
  }

\cs_new_protected:Npn \hook_gput_next_code:nn #1#2
  {
    \__hook_replacing_args_false:
    \__hook_normalize_hook_args:Nn \__hook_gput_next_code:nn {#1} {#2}
    \__hook_replacing_args_reset:
  }

% \__hook_gput_code:nnn V.S. \__hook_gput_next_code:nn
\cs_new_protected:Npn \__hook_gput_code:nnn #1 #2 #3
  {
    \__hook_chk_args_allowed:nn {#1} { AddToHook }
    \__hook_if_execute_immediately:nTF {#1}
      {
        \__hook_if_replacing_args:TF
          {
            \msg_error:nnnn { hooks } { one-time-args }
              {#1} { AddToHook }
          }
          { }
        \use:n
      }
      { \__hook_gput_code_store:nnn {#1} {#2} }
      { #3 }
  }
\cs_new_protected:Npn \__hook_gput_next_code:nn #1 #2
  {
    \__hook_if_disabled:nTF {#1}
      { \msg_error:nnn { hooks } { hook-disabled } {#1} }
      {
        \__hook_if_structure_exist:nTF {#1}
          { \__hook_gput_next_do:nn }
          { \__hook_try_declaring_generic_next_hook:nn }
            {#1} {#2}
      }
  }
```

It seems that there is no need to make such hook command ???

### key-value level
Implement most commands with key-value interface, also re-orginiseed some key-value interface level.
* reset the class k-v interface `XX` from `zlatex / XX` to `zlatex / option / XX`.
* reset the keys in `zlatex / option / toc` to `column(⟨int>:1), title(⟨str⟩:\contentsname), title-vspace(<dim⟩:-2em)`.
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

#### reference
The original source code in `ctexart.cls` as below:
```latex 
\cs_new_protected:Npn \__ctex_def_heading_keys:n #1
  {
    \exp_args:NNe \tl_put_right:Nn \l__ctex_tmp_tl
      {
        #1                  .meta:nn = { ctex / #1 } { ##1 } ,
        #1 / name            .code:n =
          { \ctex_assign_heading_name:nn {#1} { ##1 } } ,
        #1 / number        .tl_set:N = \exp_not:c { CTEX@the#1 } ,
        #1 / beforeskip    .tl_set:N = \exp_not:c { CTEX@#1@beforeskip } ,
        #1 / afterskip     .tl_set:N = \exp_not:c { CTEX@#1@afterskip} ,
        #1 / indent        .tl_set:N = \exp_not:c { CTEX@#1@indent } ,
        #1 / numbering   .bool_set:N = \exp_not:c { CTEX@#1@numbering } ,
        #1 / numbering    .initial:n = true ,
        #1 / beforeskip   .initial:n = \c_zero_skip ,
        #1 / afterskip    .initial:n = \c_zero_skip ,
        #1 / indent       .initial:n = \c_zero_dim ,
        #1 / beforeskip   .value_required:n = true ,
        #1 / afterskip    .value_required:n = true ,
        #1 / indent       .value_required:n = true ,
        #1 / afterindent .bool_set:N = \exp_not:c { CTEX@#1@afterindent } ,
        #1 / fixskip     .bool_set:N = \exp_not:c { CTEX@#1@fixskip } ,
        #1 / hang        .bool_set:N = \exp_not:c { CTEX@#1@hang } ,
        #1 / hang         .initial:n = true ,
        #1 / runin       .bool_set:N = \exp_not:c { CTEX@#1@runin } ,
        #1 / tocline      .cs_set:Np = \exp_not:c { CTEX@#1@tocline } ##1##2 ,
        \__ctex_plus_key_aux:nn {#1} { break } ,
        \__ctex_plus_key_aux:nn {#1} { format } ,
        \__ctex_plus_key_aux:nn {#1} { nameformat } ,
        \__ctex_plus_key_aux:nn {#1} { numberformat } ,
        \__ctex_plus_key_aux:nn {#1} { titleformat } ,
        \__ctex_plus_key_aux:nn {#1} { aftername } ,
        \__ctex_plus_key_aux:nn {#1} { aftertitle } ,
      }
  }
\cs_new:Npn \__ctex_plus_key_aux:nn #1#2
  {
    #1 / #2   .tl_set:N = \exp_not:c { CTEX@#1@#2 } ,
    #1 / #2 +   .code:n =
      { \tl_put_right:Nn \exp_not:c { CTEX@#1@#2 } { ##1 } } ,
    #1 / #2 ~ + .code:n =
      { \tl_put_right:Nn \exp_not:c { CTEX@#1@#2 } { ##1 } }
  }
```

#### implement
zlatex has added this feature, an minimal example as below:
```latex 
% zlatex.cls 
\cs_new:Npn \__zlatex_plus_key_aux:nnn #1#2#3
  {% #1:var; #2:p-key; #3:s-key
    #2 / #3     .tl_set:N = \exp_not:c { #1 } ,
    #2 / #3 +   .code:n   = { \tl_put_right:Nn \exp_not:c { #1 } { ##1 } } ,
    #2 / #3 ~ + .code:n   = { \tl_put_right:Nn \exp_not:c { #1 } { ##1 } }
  }

% debug.tex
\InputIfFileExists{zlatex-cfg.tex}{}{}
\documentclass{../code/zlatex}
\parindent=0pt

\begin{document}
\ExplSyntaxOn
\keys_define:ne {test}{
  % simple key
  keyA    .tl_set:N = \exp_not:c {l__test_keyA_tl},
  keyA+   .code:n   = \tl_put_right:Nn \exp_not:c {l__test_keyA_tl} {#1},
  keyA~+  .code:n   = \tl_put_right:Nn \exp_not:c {l__test_keyA_tl} {#1},
  % zlatex internal
  keyB    .meta:nn  = { text / keyB }{#1},
  \__zlatex_plus_key_aux:nnn {l__test_keyB_tl}{keyB}{keyB-x},
  \__zlatex_plus_key_aux:nnn {l__test_keyB_tl}{keyB}{keyB-y},
}
\NewDocumentCommand{\testPlusKeyA}{m}{
  \keys_set:nn {test}{#1}
  \tl_use:N \l__test_keyA_tl\par
}
\NewDocumentCommand{\testPlusKeyB}{m}{
  \keys_set:nn {test}{#1}
  \tl_use:N \l__test_keyB_tl\par
}

\ExplSyntaxOff
\section{Simple}
\testPlusKeyA{keyA = AA}
\testPlusKeyA{keyA+ = aa} 
\testPlusKeyA{keyA += xx} 
\testPlusKeyA{keyA=zz}

\section{Internal}
\testPlusKeyB{keyB/keyB-x = BB}
\testPlusKeyB{keyB/keyB-x+ = bb}
\testPlusKeyB{keyB/keyB-x += xx}
\testPlusKeyB{keyB/keyB-x = zz}

\dotfill\par
\testPlusKeyB{keyB/keyB-y = BBYY}
\testPlusKeyB{keyB/keyB-y+ = bbyy}
\end{document}
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
(zlatex)              classOption(⟨clist⟩), toc(⟨key-value⟩),
(zlatex)              font(⟨key-value⟩), layout(⟨key-value⟩),
(zlatex)              section(⟨key-value⟩), mathSpec(⟨key-value⟩),
(zlatex)              bib_index(⟨key-value⟩). Assignment Ignored and LaTeX
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
  config              .bool_gset:N  = \g__ztex_font_cfg_bool,
  config              .initial:n    = { false }, 
  unknown             .code:n       = { \zlatex_metakey_warning_msg:nn {font}{config(⟨bool⟩:false)} }
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
(zlatex)              are:alias(⟨bool⟩:false),envStyle,font(⟨choice⟩:newtx,mtpr
o2,euler,mathpazo);
(zlatex)              Assignment Ignored and LaTeX default mathSpec settings
(zlatex)              substitute.


Class zlatex Warning: You use an invalid key "openAll" or key assign for it in
(zlatex)              the meta key "layout", Valid options
(zlatex)              are:margin(⟨bool⟩:false),slide,aspect; Assignment
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
(zlatex)              are:sec(⟨key-value⟩:prefix,suffix,bg,fg),
(zlatex)              UL(⟨key-value⟩:text,bg,fg),UR(⟨key-value⟩:text,bg,fg),
(zlatex)              BL(⟨key-value⟩:text,bg,fg),BC(⟨key-value⟩:text,bg,fg),
(zlatex)              BR(⟨key-value⟩:text,bg,fg); Assignment Ignored and
(zlatex)              zLaTeX default "slide" settings of this key substitute.


Class zlatex Warning: You use an invalid key "zlatex/slide/toc/hello" or key
(zlatex)              assign for it in the meta key "slide/toc", Valid options
(zlatex)              are:leftmargin(⟨key-value⟩:chapter[⟨dim⟩:2em],section[<di
m>:4em],subsection[⟨dim⟩:6em]),
(zlatex)              label(⟨key-value⟩:chapter[⟨tl⟩:thechapter;hbox:1em],secti
on[⟨tl⟩:thesection;hbox:1em],subsection[⟨tl⟩:thesubsection;hbox:2em]),
(zlatex)              after(⟨key-value⟩:chapter[tl:⟨empty⟩],section[tl:⟨empty⟩]
,subsection[tl:⟨empty⟩]);
(zlatex)              Assignment Ignored and zLaTeX default "slide-toc"
(zlatex)              settings of this key substitute.
```

## class option interface
### introduction
Change meta-key level in class option interface, now theese meta key is:
```latex
\zlatex_define:nn { option / font }{
config              .bool_gset:N  = \g__ztex_font_cfg_bool,
config              .initial:n    = { false }, 
unknown             .code:n       = { \zlatex_metakey_warning_msg:nn {font}{config(⟨bool⟩:false)} }
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
  \bool_if:NTF \g__ztex_font_cfg_bool {
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
\zslideThemeCreate{⟨theme-name⟩}{⟨key-value-list⟩}
\zslideThemeUse[⟨overwrite-keys-assign⟩]{⟨theme-name⟩}
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
\zslideSetup[⟨sub-key⟩]{⟨key-value list⟩}
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
\includegraphics[max width=\linewidth]{⟨image file name⟩}
```

Then i WON'T Implement this feature. For more detail, see: [Scale (resize) large images (graphics) that exceed page margins](https://tex.stackexchange.com/q/6073/294585)

### hyperref support
Hyperref is support now, such anchors are available:
* `page.⟨page num⟩`: link to abusolute page index `⟨page num⟩`
* `zslide@\FirstMark{zslide-left}.⟨frame index⟩`: link to frame indexd at `⟨frame index⟩` in section `\FirstMark{zslide-left}` (roughly equals to current section).

A users' interface `\_zslide_navigate_symbol:nnnn` have been created, syntax as follows:
```latex
\_zslide_navigate_symbol:nnnn 
    {⟨total frame num⟩}
    {⟨current frame index⟩}
    {⟨current frame symbol⟩}
    {⟨other frame symbols⟩}
```

You can access the total frame num by macro: `\zslideFrame{⟨Roman number⟩}`, `I`, `II`, `\Roman{section}` and so forth, which will return the total frames the current section has. Current frame number can be retrived by command `\zslideFrameIndex`.

> In the future, command `\zslideFrame` maybe extends to `chapter` or `subsection`, not just counting `section`'s frame total number.

Add one function `\zslideIfPageTF{}{}{}` to check page number, syntax as follows:
```latex
\zslideIfPageTF{⟨operators⟩⟨num⟩}{⟨True Branch⟩}{⟨False Branch⟩}
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
\NewDocumentCommand{\zslideNavigateSymbol}{O{\(\bullet\)}O{\(\circ\)}}{
  \cs_if_exist:cTF {zsec@\Roman{section}@cnt}
    {\_zslide_navigate_symbol:nnnn 
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
    {\hbox:n {\ztool_set_to_wd:nn 
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
- [x] Provide an `\zslideLogo` command for slide mode.
- [x] fixed warning: dupicate hyper target when use `\tableofcontents`.

Syntax of command: `\zslideLogo` (only accessiable in preamble):
```latex 
\zslideLogo[
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
    column=⟨int⟩,
    title=⟨title⟩,
    title-vspace=⟨dim⟩,
    stretch=⟨float⟩
  }
}
```

### new interface 
#### l3keys
There was once a trial, which makes it easy to use by `l3keys`, see below:
```latex 
\ProvidesExplFile{zlatex.module.secformat.tex}{2024/10/24}{1.0.0}{secformat~module~for~zlatex}
%%%%%     sec format module for zlatex     %%%%%
% ==> title class interface
% ⟨begin-shape⟩ 
%     ⟨format⟩⟨label⟩
%     ⟨sep⟩     % \vskip or \hskip
%     ⟨before-code⟩
%     ⟨text⟩
%     ⟨after-code⟩
% ⟨end-shape⟩
\RequirePackage{titlesec}
% custom title format 
% TODO: add label-align, title-align keys 
\zlatex_keys_define:nn { title/style }
  {
    shape           .tl_set:N  = \l__zlatex_title_shape_tl,
    shape           .initial:n = {hang},
    align           .tl_set:N  = \l__zlatex_title_align_tl,
    align           .choice:,
    align / center  .code:n    = { \tl_set:Nn \l__zlatex_title_align_tl {\centering} },
    align / left    .code:n    = { \tl_set:Nn \l__zlatex_title_align_tl {\raggedright} },
    align / right   .code:n    = { \tl_set:Nn \l__zlatex_title_align_tl {\raggedleft} },
    align           .initial:n = {left},
    titlecmd        .tl_set:N  = \l__zlatex_title_titlecmd_tl,
    titlecmd        .initial:n = {},
    format          .tl_set:N  = \l__zlatex_title_format_tl,
    format          .initial:n = {},
    titleformat     .tl_set:N  = \l__zlatex_title_titleformat_tl,
    titleformat     .initial:n = {},
    label           .tl_set:N  = \l__zlatex_title_label_tl,
    label           .initial:n = {},
    labelformat     .tl_set:N  = \l__zlatex_title_labelformat_tl,
    labelformat     .initial:n = {},
    sep             .dim_set:N = \l__zlatex_title_sep_dim,
    sep             .initial:n = {0pt},
    before          .tl_set:N  = \l__zlatex_title_before_tl,
    before          .initial:n = {},
    after           .tl_set:N  = \l__zlatex_title_after_tl,
    after           .initial:n = {},
  }
\tl_new:N \c__zlatex_title_format_initial_tl 
\keys_precompile:nnN { zlatex/title/style }
  {} \c__zlatex_title_format_initial_tl 
% \tl_show:N \c__zlatex_title_format_initial_tl
\cs_new:Nn \__zlatex_title_format_copy:nnnnnnn 
  {
    \titleformat{#1}[#2]{#3}{#4}{#5}{#6}[#7]
  }
\cs_generate_variant:Nn \__zlatex_title_format_copy:nnnnnnn { ooffofo }
\cs_new:Npn \zlatex_title_format:nn #1#2 
  {
    \zlatex_keys_set:nn { title/style } {#2}
    \__zlatex_title_format_copy:ooffofo
      {\cs:w #1\cs_end:}
      { \l__zlatex_title_shape_tl }
      {
        \l__zlatex_title_align_tl
        \l__zlatex_title_format_tl
      }
      { \group_begin: 
        \l__zlatex_title_labelformat_tl 
        \l__zlatex_title_label_tl 
        \group_end:
      }
      { \l__zlatex_title_sep_dim }
      { 
        \l__zlatex_title_before_tl 
        \l__zlatex_title_titleformat_tl
        \l__zlatex_title_titlecmd_tl
      }
      { \l__zlatex_title_after_tl }
    % restore initial value ---> bug !!!
    \tl_use:N \c__zlatex_title_format_initial_tl
  }
\NewDocumentCommand{\zlatexTitleStyle}{mm}
  {
    \zlatex_title_format:nn {#1}{#2} 
  }
\@onlypreamble\zlatexTitleStyle
% create new title
\cs_new:Npn \zlatex_title_new:nnn #1#2#3 
  { % #1: class; #2: name; #3: format
    \exp_args:Noo \titleclass{\cs:w #2\cs_end:}{#1}
    \zlatex_title_format:nn {#2}{#3}
  }
\NewDocumentCommand{\zlatexTitleNew}{omm}
  {% #1: format; #2: class; #3: name
    \IfValueTF {#1}
      {\zlatex_title_new:nnn {#2}{#3}{#1}}
      {\zlatex_title_new:nnn {#2}{#3}{}}
  }
% ==> predefined title format
% numbered chapter format
\zlatex_title_format:nn {chapter}
  {
    shape = display,
    align = right,
    sep = 10pt,
    label = {
      \MakeUppercase{\chaptertitlename}
      \hspace{1ex}\scalebox{2.5}{\thechapter}
    },
    format = {\bfseries},
    labelformat = {
      \Large
      \color{\tl_use:N \l__zlatex_chapter_color_tl}
    },
    titleformat = {
      \raggedright\bfseries\huge\color{black}
    },
    before = {
      \color{\tl_use:N \l__zlatex_chapter_rule_color_tl}
      \titlerule\vspace{15pt}
    }
  }
% unnumbered chapter format
\titleformat{name=\chapter, numberless}
  {\bfseries\Huge}
  {}{0pt}{}
% chapter space
\titlespacing{\chapter}{0pt}{-30pt}{40pt}
```

#### xtemplate
A trial that use `xtemplate` as below:
```latex 
\DeclareObjectType{title}{1}
\DeclareTemplateInterface{title}{default}{1}
  {
    shape:tokenlist       = hang,
    titlecmd:function 1   = \textbf{#1},
    format:tokenlist      = ,
    titleformat:tokenlist = ,
    label:tokenlist       = ,
    labelformat:tokenlist = ,
    sep:length            = 0pt,
    before:tokenlist      = ,
    after:tokenlist       = ,
    align:choice{center, left, right} = left,
  }
\DeclareTemplateCode{title}{default}{1}
  {
    shape       = \l_shape_tl,
    titlecmd    = \title_cmd:n,
    format      = \l_format_tl,
    titleformat = \l_titleformat_tl,
    label       = \l_label_tl,
    labelformat = \l_labelformat_tl,
    sep         = \l_sep_dim,
    before      = \l_before_tl,
    after       = \l_after_tl,
    align       = {
      left   = \raggedright,
      center = \centering,
      right  = \raggedleft,
    },
  }{
    \__zlatex_titlesec_copy:ooffofo
      {\cs:w #1\cs_end:}
      { \l_shape_tl }
      {
        % \KeyValue{align} % --> How to get the value of align key?
        \raggedleft
        \l_format_tl
      }
      { \group_begin: 
        \l_labelformat_tl 
        \l_label_tl 
        \group_end:
      }
      { \l_sep_dim }
      { 
        \l_before_tl 
        \l_titleformat_tl
        \title_cmd:n {#1} % this argument is redundant ???
      }
      { \l_after_tl }
  }
\def\testcmd#1{\textbf{(#1]}}
\DeclareInstance{title}{chapter}{default}
  {
    shape       = display,
    format      = \bfseries,
    % align     = left,
    titlecmd    = \testcmd,
    sep         = 10pt,
    label       = \MakeUppercase{\chaptertitlename}\hspace{1ex}\scalebox{2.5}{\thechapter},
    labelformat = \Large\color{\tl_use:N \l__zlatex_chapter_color_tl},
    titleformat = \raggedright\bfseries\huge\color{black},
    before      = \color{\tl_use:N \l__zlatex_chapter_rule_color_tl}\titlerule\vspace{15pt},
    after       = \vspace{15pt}
  }
\DeclareInstance{title}{section}{default}
  {
    shape       = hang,
    % titlecmd  = \testcmd, % --> BUG
  }
\UseInstance{title}{section}{section}
\UseInstance{title}{chapter}{chapter}
```

#### future plan
Maybe i will refer to `xcontents` in the offical LaTeX repo or use `cus-struct` from `CUS` repo.

What features we need to implement ? see Problem: [thoughts about wrting a package like titlesec and titletoc](https://tex.stackexchange.com/q/731231/294585).


**WARN**: I may drop the dependency: `titlesec` and `titletoc` in the future.

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
\zlatexThmTitleFormat{⟨format⟩, ⟨content, such as:\zlatexThmNumber, \zlatexThmName, \zlatexThmNote⟩}
\zlatexThmTitleFormat*{⟨format⟩, ⟨content, such as:\zlatexThmNumber, \zlatexThmName, \zlatexThmNote⟩}
\zlatexThmCnt{share, parent=⟨counter name:section, subsection, ...⟩}


% 3. change the style of theorem-like envs
\zlatexThmStyle{elegant}
\zlatexThmColorSetup{⟨theorem/proof-like envs' name⟩=⟨color⟩}


% 4. custom the warper of each theorem-like envs
\zlatexThmStyleNew{⟨style⟩={begin=⟨.⟩, end=⟨.⟩, option=⟨.⟩}}


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
\zlatexThmHook{⟨next hook⟩}
\zlatexThmHook*{⟨next all hook⟩}
\zlatexThmBefore{⟨code⟩}


% 7. list of theorems
\zlatexThmToc[
  title-vspace=⟨dim⟩, 
  title=⟨title⟩,
  after-vspace=⟨dim⟩,
  stretch=⟨float⟩
]
\zlatexThmTocPrefix{⟨prefix⟩}
\zlatexThmTocSymbol{
  lemma=⟨lemma symbol⟩,
  definition=⟨definition symbol⟩,
  ....
}
% clear all predefined thm toc symbol
\zlatexThmTocSymbolClear 
\zlatexThmTocAdd[name=⟨toc name⟩]{⟨toc level:chapter, section, etc.⟩}
```

### bug fixed 
Fixed bug: optional braces, brackets around `\zlatexThmNote` when it is empty. Now the syntax is:
```latex 
\zlatexThmNote{⟨before⟩}{⟨end⟩}
% --> output:
% ⟨before⟩⟨Thm-Note⟩⟨end⟩
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
(zlatex/thm/before) --> (warper begin) 
--> (thm-title) --> (zlatex/thm/begin) --> (thm-content) --> (zlatex/thm/end) --> 
(warper end) --> (zlatex/thm/after)
```

The implementation as below:
```latex
\NewDocumentEnvironment{#1}{O{}}{
  \refstepcounter{#1}
  \UseHook{zlatex/thm/before}
  \__zlatex_thm_warp_start:nnnn {#1}{##1}{\bfseries}{\ }
  \__zlatex_thm_title:                                  
  \UseHook{zlatex/thm/begin}
}{
  \UseHook{zlatex/thm/end}
  \__zlatex_thm_warp_end:
  \UseHook{zlatex/thm/after}
}
```

Command `\zlatexThmHook` is used to add your own code chunks to these places, syntax:
```latex 
% only add to the next one
\zlatexThmHook{
    before=⟨BEFORE code⟩, 
    begin=⟨BEGIN code⟩, 
    end=⟨END code⟩, 
    after=⟨AFTER code⟩
}

% add to all thm ebv below
\zlatexThmHook*{
    before=⟨BEFORE code⟩, 
    begin=⟨BEGIN code⟩, 
    end=⟨END code⟩, 
    after=⟨AFTER code⟩
}
```

Remark:
* the function `\zlatexThmStyleNew`(this function can be only used in preamble) are based on these hooks.
* the macro `\zlatexThmTitle` and `\zlatexThmTitleSwitch` may be useful for you to custom the title format of theorem-like envs.
* The hooks `zlatex/thm/end` and `zlatex/thm/after` are reverse hook.
* the default code chunk in `zlatex/thm/before` is `\par`.


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
  \AddToHook{zlatex/thm/begin}{#1}
  \AddToHook{zlatex/thm/end}{#2}
  \ActivateGenericHook{zlatex/thm/begin}
  \ActivateGenericHook{zlatex/thm/end}
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

> * In the future, this function maybe be changed, i will use this function to add more `thm` style like the `\_zslide_theme_create:nn` function in `slide` library plays on.
> * please use this command with `*` in the preamble, or some unexpected error may occur.

To change the default before code chunk in hook `zlatex/thm/before`, you can use command `\zlatexThmBefore`, an simple example maybe:
```latex 
\zlatexThmBefore{\par\noindent\dotfill\par}
```

Implementation of this command is:
```latex 
\hook_gput_code:nnn {zlatex/thm/before}{thm-before-par}{\par}
\NewDocumentCommand{\zlatexThmBefore}{+m}
  {
    \hook_gremove_code:nn {zlatex/thm/before}{thm-before-par}
    \hook_gput_code:nnn {zlatex/thm/before}{thm-before-par}{#1}
  }
```

### Update:2024-11-13
Now the command `\zlatexThmStyleNew` is implemented by `l3keys`, then you could add your own thm style freely. The Syntax of this function as follows:
```latex 
\zlatexThmStyleNew {
  ⟨thm style name⟩ = {
    begin  = ⟨env begin code⟩, 
    end    = ⟨env end code⟩, 
    option = ⟨env begin option⟩
  },
}
```

What you need pay attention to is `⟨env begin option⟩`, in this part, you can specify whether to display `thm title` inline or hang on the top like in tcolorbox. Use function:
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
\zlatexThmToc[vspace=⟨dim⟩, title=⟨title⟩]
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

Update: when there is no `\tableofcontents` before, stretch for thm toc will lose. The new implement is:

```latex 
\zlatex_keys_define:nn {thm/toc}
  {
    title         .tl_gset:N  = \g__zlatex_thm_toc_title_tl,
    title         .initial:n  = { \Large\bfseries List\ of\ Theorems },
    title-vspace  .dim_gset:N = \g__zlatex_thm_toc_title_vspace_dim,
    title-vspace  .initial:n  = { 0pt },
    after-vspace  .dim_gset:N = \g__zlatex_thm_toc_after_vspace_dim,
    after-vspace  .initial:n  = { 0pt },
    stretch       .fp_gset:N  = \g__zlatex_thm_toc_stretch_fp,
    stretch       .initial:n  = { 1 },
  }

\NewDocumentCommand{\zlatexThmToc}{o}
  {
    \bool_gset_true:N \g__zlatex_thm_toc_bool
    \group_begin:
    \IfValueT {#1}{\zlatex_keys_set:nn {thm/toc}{#1}}
    \legacy_if_set_false:n { @filesw }  
    {\par\noindent\tl_use:c {g__zlatex_thm_toc_title_tl}}
    \addvspace{\g__zlatex_thm_toc_title_vspace_dim}
    \addvspace{-\fp_to_dim:n {\g__zlatex_thm_toc_stretch_fp*\baselineskip}+\baselineskip}
    {
      \renewcommand{\baselinestretch}{\fp_use:N \g__zlatex_thm_toc_stretch_fp}\normalsize 
      \@input{\jobname.thlist}
    }
    \addvspace{\g__zlatex_thm_toc_after_vspace_dim}
    \group_end:
  }
```

But this new implementation still has been deprecated. I remove `title` part. This part will be controled be the users.

### theme library
#### predefined thm theme
zlatex `thm` module and `theme` library contains many predefined thm themes that can be used out of box. List of predefined themes in `thm` module are:
* plain (default theme)
* background
* leftbar 
* fancy

To use these themes, an example is:
```latex 
\zlatexThmStyle{fancy}
```

themes in `theme` library are:
* shadow
* paris 
* elegant
* obsidian
* lapsis

To use these them , the syntax is simple:
```latex 
\zlatexloadlibrary{theme}
\zlatexThmStyle{lapsis}
```

> In thm them `lapsis`, there is a new feature, the command -- `\tcblower`, which is used to split current thm env into 2 parts, each of which has a different style. Have a try immediately to see how it actually looks like. 

When you load `theme` library, `tikz` and `tcolorbox` will be loaded, so do these many libraries belong to them. Up to now, the optioanl preamble commands are:
```latex 
\RequirePackage[many]{tcolorbox}
\RequirePackage{adjustbox}
\RequirePackage{tikz}
\RequirePackage{etoolbox}
\patchcmd{\pgfutil@InputIfFileExists}{\input #1}{
  \@pushfilename
  \xdef\@currname{#1}
  \input #1
  \@popfilename
}{}{}
\usetikzlibrary{fadings, calc}
\RequirePackage{pifont}
```


#### create new thm theme
Users can create new thm themes easily based on the interface thm module provides. 

To create a new theme, you can use the commands decribed in section `thm:main commands`. What need to be decribed here are two internal macros:
* `\thm@temp@color`: temp name for each thm env, such as `red, blue, zlatex@thm@theorem`, etc
* `\thm@temp@name`: temp name for each thm, such as `theorem, definition, axiom`, etc.

These 2 macros will NOT be exposed to normal users, for advanced users, you can use theme. Besides, original definitions of these 2 comamnds are:
```latex 
% \cs_new:Npn \__zlatex_thm_warp_start:nnnn #1#2#3#4 {
  ...
  \def\thm@temp@color{\tl_use:c {l__zlatex_#1_color_tl}}
  \def\thm@temp@name{#1}
  ..
% }
```

An simple example of creating a new them(also the implementation of `lapsis` theme):
```latex 
\zlatexThmStyleNew{
  % lapsis theme from: Foundation Mathematics for the Physical Sciences
  lapsis = {
    begin = {
      \begin{tcolorbox}[
        enhanced,  breakable,
        top=1.5pt, bottom=1.5pt,
        left=2pt,  leftlower=-3pt,
        right=3pt, arc=0pt, frame~hidden,
        bicolor,   colback=\thm@temp@color!60,
        opacitybacklower=0,
        frame~code~app={
          \draw[color=\thm@temp@color, thick] 
            (frame.north~west)++(-5cm, -1pt)--($(frame.north~east)+(5cm, 0pt)$);
          \draw[color=\thm@temp@color, thick] 
            (frame.south~west)++(-5cm, -1pt)--($(frame.south~east)+(5cm, 0pt)$);
          \fill[color=\thm@temp@color!50, path~fading=east] 
            (frame.north~west)++(-5cm, -1pt) rectangle ($(frame.south~east)+(5cm, 0pt)$);
        },
      ]\zlatex@llapnote{\zlatexThmTitle}
    },
    end = {\hfill$\mathcolor{\thm@temp@color}{\blacktriangleleft}$\end{tcolorbox}},
    option = {
      \__zlatex_thm_title_inline:n {F}
      \__zlatex_thm_tcolorbox_warning:
    },
    preamble = {
      \DeclareMathSymbol{\blacktriangleleft}{\mathrel}{AMSa}{"4A}
      \zlatexThmTitleFormat*{\sffamily\bfseries
        \zlatexThmName\ \zlatexThmNumber
        \zlatexThmNoteEmptyTF{}{\\}
        \zlatexThmNote{}{}
      }
      \newcommand{\zlatex@llapnote}[1]{
        \mbox{}\llap{
        \adjustbox{set~height=0pt, set~depth=0pt}{
          \parbox[t]{2.85cm}{\raggedleft #1}}\hspace*{.75em}}
      }
    }
  },
}
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