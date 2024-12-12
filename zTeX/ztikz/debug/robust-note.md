# external details
You can use one of the following method to do a `up to date check`:
* `simple`: just check if the file is exists 
* `md5`: check the MD5 of the output pdf using `\pdfmdfivesum`
* `diff`: check the picture content only Instead of the pdf.

You can change the default check method (`md5`) to `diff` using command:
```latex 
\tikzset{external/up to date check={diff}}
```

Some NOTE:
> The picture content. Here, “picture content” only includes the **top–level tokens; no expansion is applied** and no included files are part of the strategies. If you change preamble styles, you have to rebuild the figures manually (for example by deleting the generated graphics files). If you have include files, consider using \tikzpicturedependsonfile and its variants. Since this key provides heuristics, you should always remake your figures before you finally publish your document. Example: Suppose we have the following picture which depends on a command \mycommand
> ```latex 
> \def\mycommand{My comment}
> \begin{tikzpicture}
> \node at (0,0) {\mycommand};
> \end{tikzpicture}
> ```
> What happens if you change “My comment” to “My super comment”? Well, external will not pick it up; you will need to handle this manually. 

use `pdf`-based hash check seems to be an ideal method, syntax for xetex and pdftex:
```latex
% REF: https://tex.stackexchange.com/a/313702/294585
\documentclass{article}
\usepackage{ifxetex}

\begin{document}

%for text
\ifxetex
  \mdfivesum{Hello World!}
\else
  \pdfmdfivesum{Hello World!}
\fi

%for file (content)
\ifxetex
  \mdfivesum file {\jobname.tex}
  \typeout{ xetex \mdfivesum file {\jobname.tex}}
\else
  \pdfmdfivesum file {\jobname.tex}
  \typeout{pdftex \pdfmdfivesum file {\jobname.tex}}
\fi

\end{document}
```

No matter which method you use, it seems to be of no-use:
* use `diff`: can NOT forward macros in this env.
* use `md5`: you need to compile this snippets fisrt, thus it is ridiculus to compile it again(even the hash not changed) and then check the md5. (You can skip it when hash not change)

Then the valid method maybe `diff` + `forward` handle.



# robustExternalize details
The command implement as below:
```latex 
% Not really made for the end user
% It assumes that __ROBEXT_COMPILATION_COMMAND__ and __ROBEXT_TEMPLATE__ is set
\NewDocumentCommand{\robExtEvaluateCompileAndInclude}{}{%
  \ifdefined\robExtDisableExternalization%
    \pgfkeys{%
      /robExt/.cd,
      command if no externalization,
    }%
  \else%
    \pgfkeys{%
      /robExt/.cd,
      command if externalization,
    }%
    \ifdefined\robExtExecuteBefore\robExtExecuteBefore\fi%
    \robExtWriteFile{}%
    \robExtCompileFile{}%
    \robExtIncludeFile{}%
    \ifdefined\robExtExecuteNamedOutput\robExtExecuteNamedOutput\fi%
    \ifdefined\robExtExecuteAfter\robExtExecuteAfter\fi%
  \fi%
  \robExtDebugInfo{Finished to include the file.}%
}


%% #1: Arguments, #2: content to externalize
\NewDocumentCommand{\robExtCacheMe}{O{}+m}{%
  {% Group
    %% We store the input in a non-string element for efficiently implementing "auto forward"
    \edef\robExtUserInputCacheMe{\unexpanded{#2}}% \unexpanded is needed if the macro contains a #1
    \pgfkeys{%
      /robExt/.cd,%
      %% This is needed notably if the cached elements are nested, like the include command uses itself a tikz
      %% picture etc cached via \cacheTikz... It it hard to reset everything efficiently (like we might not
      %% want to reset all compilation commands etc), so you can add here stuff that might need to be restored
      %% later.
      reset,
      set placeholder={__ROBEXT_MAIN_CONTENT_ORIG__}{#2},%
      default style,%
      #1,
    }%
    \robExtEvaluateCompileAndInclude%
  }%
}
\let\cacheMe\robExtCacheMe


%% Usage: \robExtCacheEnvironment{myenv}
\NewDocumentCommand{\robExtCacheEnvironment}{O{<>}mm}{%
  %% We need to save the original environment to avoid infinite recursion if we disable externalization
  %% https://tex.stackexchange.com/questions/695391/why-isnt-my-environment-restored/695398
  \ifcsname robExtEnvironmentOrig#2\endcsname\PackageWarning{Your are trying to cache an environment #2 that seems to be already cached... Expect weird things to happen.}{}\fi
  \DeclareEnvironmentCopy{robExtEnvironmentOrig#2}{#2}%
  \robExtAddToEnvironmentResetList{#2}%
  \DeclareDocumentEnvironment{#2}{D#1{}}{%
    \def\robExtEnvironmentOrigName{#2}%
    \CacheMe{%
      #3,%
      set placeholder no import={__ROBEXT_MAIN_CONTENT__}{\begin{#2}__ROBEXT_MAIN_CONTENT_ORIG__\end{#2}},%
      ##1%
    }%
  }{\endCacheMe}%
}
\let\cacheEnvironment\robExtCacheEnvironment
```



# Mechnism
All related files, file name format: `robExt-<hash>` , file extention list:

## files in folder `robustExternalize`:
1. `.out` file:
```latex
\def\robExtWidth{62.37161pt}\def\robExtHeight{10.4774pt}\def\robExtDepth{3.53297pt}
```

2. `.aux` file:
```latex 
\relax 
\gdef \@abspage@last{1}
```

3. `.dep` file:
```shell 
command,pdflatex -halt-on-error "__ROBEXT_SOURCE_FILE__"
BE48EE11EB3245716A740E3AAE3343E7,
```

4. `.tex` file:
```latex 
\documentclass[,margin=30cm]{standalone}
 \usepackage {tikz}
% most packages must be loaded before hyperref
% so we typically want to load hyperref here

% some packages must be loaded after hyperref

\begin{document}%
%% We save the height/depth of the content by using a savebox:
\newwrite\writeRobExt%
\immediate\openout\writeRobExt=\jobname-out.tex%

%
\newsavebox\boxRobExt%
\begin{lrbox}{\boxRobExt}%
  \begin {tikzpicture}[baseline=(A.base)] \node [draw,rounded corners,fill=teal!50](A){Hello World!};\end {tikzpicture}%
\end{lrbox}%
\usebox{\boxRobExt}%
\immediate\write\writeRobExt{%
  \string\def\string\robExtWidth{\the\wd\boxRobExt}%
  \string\def\string\robExtHeight{\the\ht\boxRobExt}%
  \string\def\string\robExtDepth{\the\dp\boxRobExt}%
}%

%


\end{document}
```

### files in root dir:
1. `.txt` file:
```latex
robExt-AC09F82239176844CE993D03F62934B4.tex
```

2. `.sh` file:
```latex 
<empty>
```

3. `.tmp` file:
```shell 
# Quit if there is an error
set -e
outputTxt="__ROBEXT_OUTPUT_PREFIX__-out.txt"
outputTex="__ROBEXT_OUTPUT_PREFIX__-out.tex"
outputPdf="__ROBEXT_OUTPUT_PDF__"
__ROBEXT_MAIN_CONTENT__
# Create the pdf file to certify that no compilation error occured
echo "ok" > "${outputPdf}"
```

4. `robExt-remove-old-figures.py`:
```python
#!/usr/bin/env python3
## This file is automatically generated, so do not change that file directly
## Instead, if you need to change it, copy it with a different name and edit the copy
import os
import re
import glob
# Just run this script in order to remove all old figures not listed in robExt-all-figures.txt.

# Note that this part is not extracted from the pdf file since it might be different on a previous run. You can however hardcode
# it here, your updated script will not be overriden unless you remove it yourself.
prefixes = [ "robExt-" ]
folders  = [ "robustExternalize" ]

def main():
    imagesToKeep = dict()
    list_all_figures_file = glob.glob('*robExt-all-figures.txt')
    for filename in list_all_figures_file:
        with open(filename) as f:
            for line in f:
                line = line.strip()
                if line.endswith('.tex'):
                    imagesToKeep[line[:-4]] = True # The exact value is not important, we mostly use dict to get ~O(1) access

    listOfFilesToRemove = []
    # We are looking for images in the folders
    for folder in folders:
        for root, dirs, files in os.walk(folder):
            for f in files:
                for prefix in prefixes: # Not the most efficient, but anyway we typically have a single prefix
                    # In case prefix contains weird caracters that collide with regexps:
                    prefixEsc = re.escape(prefix)
                    # result_search = re.search(rf"^({prefixEsc}[A-F0-1]{32}).*", f)
                    result_search = re.search(rf"^(.*[A-F0-9]{{32}}).*", f)
                    if result_search:
                        if result_search.group(1) not in imagesToKeep:
                            listOfFilesToRemove.append(os.path.join(root,f))
    for f in listOfFilesToRemove:
        print(f"-- {f}")
    print(f"Above are the files to remove, are you sure you want to proceed? [y/N] (based on prefixes {prefixes})")
    x = input().strip()
    if x not in ["y", "Y"]:
        print("All right, we abort.")
        exit(1)
    for f in listOfFilesToRemove:
        os.remove(f)
        print(f"Removed {f}")

if __name__ == '__main__':
    main()
```


5. `robExt-prepare-for-arxiv.py`:
```python
#!/usr/bin/env python3
## This file is automatically generated, so do not change that file directly
## Instead, if you need to change it, copy it with a different name and edit the copy

## This file must be called when sending stuff to the arxiv website, that would otherwise remove the .pdf
## in presence of a .tex.
## This script will simply rename the .tex files in robustExternalize into .tex-backup.
## Then, you should call "rename backup files for arxiv" to rename back the files.
import os
import re
import glob
# Just run this script in order to remove all old figures not listed in robExt-all-figures.txt.

# Note that this part is not extracted from the pdf file since it might be different on a previous run. You can however hardcode
# it here, your updated script will not be overriden unless you remove it yourself.
prefixes = [ "robExt-" ]
folders  = [ "robustExternalize" ]

def main():
    listOfFilesToMove = []
    listOfFilesAlreadyAdded = set()
    for folder in folders:
        for root, dirs, files in os.walk(folder):
            for f in files:
                if f.endswith(".tex"):
                    pdf = os.path.splitext(f)[0] + ".pdf"
                    if os.path.exists(os.path.join(root,pdf)):
                        listOfFilesToMove.append((os.path.join(root,f), os.path.join(root,f + "-backup")))
                if f.endswith(".tex-backup"):
                    tex = os.path.splitext(f)[0] + ".tex"
                    listOfFilesAlreadyAdded.add(os.path.join(root,tex))
    for (f,f2) in listOfFilesToMove:
        print(f"-- {f} moved to {f2}")
        listOfFilesAlreadyAdded.discard(f)
    for f in listOfFilesAlreadyAdded:
        print(f"-- {f} already moved")
    print(f"Above are the files to move or already moved, are you sure you want to proceed? [y/N] (based on prefixes {prefixes})")
    x = input().strip()
    if x not in ["y", "Y"]:
        print("All right, we abort.")
        exit(1)
    for (f,f2) in listOfFilesToMove:
        os.replace(f, f2)
        print(f"Moved {f} to {f2}")
    with open('robExt-arxiv-files-to-rename.txt', 'w') as fd:
        for (f,f2) in listOfFilesToMove:
            fd.write(f'{f}\n')
        for f in listOfFilesAlreadyAdded:
            fd.write(f'{f}\n')
    print('The files have been written to robExt-arxiv-files-to-rename.txt.')
    print('Add \\robExtConfigure{rename backup files for arxiv} in your tex file.')

if __name__ == '__main__':
    main()
```

## compile log
### FIRST RUN
```shell
Source saved in robustExternalize/robExt-AC09F82239176844CE993D03F62934B4.tex.
[robExt]We will start the compilation using: cd robustExternalize/ && pdflatex 
-halt-on-error "robExt-AC09F82239176844CE993D03F62934B4.tex".
(./robustExternalize/robExt-AC09F82239176844CE993D03F62934B4-out.tex)
Finished to include the file.
```

### SECOND RUN
```shell
The file robustExternalize/robExt-AC09F82239176844CE993D03F62934B4.tex already 
exists.
No need to recompile robustExternalize/robExt-AC09F82239176844CE993D03F62934B4.
pdf
(./robustExternalize/robExt-AC09F82239176844CE993D03F62934B4-out.tex)
Finished to include the file.
```

## handle macros in cached env
If there are some macros in a cached environment, then you should decalre it with `<forward=<Macro>>`, 
see below:

```latex
\def\AAA{AAA-aba}

I am a cached picture: \begin{tikzpicture}<forward=\AAA>
\node[draw,rounded corners,fill=teal!50](A){BBB \AAA{} bbb.};
\end{tikzpicture}.

% content in '.tex'
\begin{lrbox}{\boxRobExt}%
  \def\AAA{AAA-aba}\begin {tikzpicture}\node [draw,rounded corners,fill=teal!50](A){BBB \AAA {} bbb.};\end {tikzpicture}%
\end{lrbox}%
```

There are some alterneltives as below:
```latex
\cacheTikz
\robExtConfigure{add to preset={tikz}{auto forward}}
\newcommandAutoForward{\MyNode}[2][draw,thick]{\node[rounded corners,fill=red,#1]{#2};}
\newcommandAutoForward{\MyGreenNode}[2][draw,thick]{\node[rounded corners,fill=green,#1]{#2};}
\begin{tikzpicture}
  \MyNode{Recompiled only if MyNode is changed}
  \MyNode[xshift=8cm]{but not if the (unused) MyGreenNode is changed.}
\end{tikzpicture}\\
\begin{tikzpicture}
  \MyGreenNode{Recompiled only if MyGreenNode is changed}
  \MyGreenNode[xshift=8cm]{but not if the (unused) MyNode is changed.}
\end{tikzpicture}
```


# backup
source backup 

```latex 
% ==> roboust externalize test
\InputIfFileExists{ztikz-cfg.tex}{}{}
\documentclass{article}
% \usepackage{robust-externalize}
% \cacheEnvironment{tikzpicture}{tikzpicture}
\usepackage{xcolor}
\usepackage{tikz}
\usepackage{xsimverb}
\usepackage{ztool}
\usepackage{xparse}
% \usepackage{ztikz}
% \usetikzlibrary{external}
% \tikzset{external/up to date check={diff}}
% \tikzexternalize[prefix=tikz-cache/]

\makeatletter
\ExplSyntaxOn
% NOT compatible with 'external' library
\tl_new:N \l_ztikz_cache_forward_value_tl
\str_new:N \l_ztikz_cache_forward_name_str
\keys_define:nn {ztikz/cache}
  {
    arg-spec   .tl_set:N    = \l_ztikz_cache_arg_format_tl,
    arg-spec   .initial:n   = { },
    arg-detail .tl_set:N    = \l_ztikz_cache_arg_spec_tl,
    arg-detail .initial:n   = { },
    forward    .clist_set:N = \l_ztikz_cache_forward_clist,
    forward    .initial:n   = { \empty },
  }
\cs_new:Npn \__ztikz_cache_deps:n #1 
  {
    \c_percent_str\exp_not:n {#1}:=~#1^^J
  }
\NewDocumentCommand{\ztikzCacheEnv}{om}
  {% #1: ori-env arg-format; #2:ori-env name
    \DeclareEnvironmentCopy{ztikz@cached@#2}{#2}
    \IfValueT{#1}{ \keys_set:nn {ztikz/cache}{#1} }
    \exp_args:Nnf \DeclareDocumentEnvironment{#2}{\l_ztikz_cache_arg_format_tl}
      {% No arg: line content locates at '\begin{<ENV>}' will be gobbled
        \typeout{--->##1} % --->Mand
        \typeout{--->##2} % --->HHJKHJKHJ
        \GetDocumentEnvironmentArgSpec {#2}
        \typeout{--->\ArgumentSpecification} % --->mm
        \tl_if_empty:VTF \l_ztikz_cache_arg_format_tl
          { \xsim_file_write_start:nn {\c_true_bool}{ZZZ.tex}\typeout{-->empty~arg} }
          { \xsim_file_write_start:nn {\c_false_bool}{ZZZ.tex} }
      }{
        \xsim_file_write_stop:
        \ztool_insert_to_file:nnn {ZZZ.tex}{1}
          {
            \clist_map_function:NN 
              \l_ztikz_cache_forward_clist 
              \__ztikz_cache_deps:n 
            \exp_not:N\begin{ztikz@cached@#2}
          }
        \ztool_append_to_file:nn {ZZZ.tex}
          { \exp_not:N \end{ztikz@cached@#2} }
        % \exp_args:No \begin{ztikz@cached@#2} 
        % \end{ztikz@cached@#2}
      }
  }

% \ztool_insert_to_file:nnn {temp-w.txt}{3}{NEW-LINE}
\ExplSyntaxOff
\ztikzCacheEnv[arg-spec=O{HELLO}mm, forward={\AAA,\empty}]{tikzpicture}


\begin{document}
\def\AAA{AAA-aba}

BBB \AAA{} bbb.

% I am a cached picture: \begin{tikzpicture}<forward=\AAA>
% \node[draw,rounded corners,fill=teal!50](A){BBB \AAA{} bbb.};
% \end{tikzpicture}.

% \begin{tikzpicture}
%   \node[draw,rounded corners,fill=teal!50](A){BBB \AAA{} bbb.};
% \end{tikzpicture}

% \pdfmdfivesum file {XXX.tex}
% AAA-aaa. 8CFC240350E96BB198E39BF0C450A522
% AAA-aba. 1425867299391550907B35C5C8C66BD8
% comment check 1: 3CA4F9C40B4A161FDB92DA4E0FD7B89C
% comment check 2: D0B16CF7620A6B4EF806FB3C8228C55B

% \begin{tikzpicture}
%   \node[draw,rounded corners,fill=teal!50](A){BBB \AAA{} bbb.};
% \end{tikzpicture}

\def\BBB{BBB-bbb}
\begin{tikzpicture}{Mand}{HHJKHJKHJ}
  \node[draw,rounded corners,fill=orange!50](A){BBB \AAA{} bbb.};
  \draw[->] (0, 0) -- (1, 1)node {\BBB};
\end{tikzpicture}

% \ShowDocumentEnvironmentArgSpec {tikzpicture}
% \typeout{--->\ArgumentSpecification} % --->mm

% \input{ZZZ.tex}
\end{document}
```

extract preamble:
```latex
% --> extract preable on the fly
\ExplSyntaxOn
\ztool_gread_file_as_seq:nnN {\c_true_bool}{debug.tex}{\l_tmpa_seq}
% \seq_show:N \l_tmpa_seq
\prg_generate_conditional_variant:Nnn \str_if_eq:nn { ne } { TF }
\prg_generate_conditional_variant:Nnn \str_if_empty:n { e } { F }
\str_set:Nn \l_tmpa_str {\begin{document}}
\iow_open:Nn \g_ztool_file_append_iow {extract-preamble.tex}
\seq_map_inline:Nn \l_tmpa_seq 
  {
    \str_if_eq:neTF {#1}{\l_tmpa_str}
      { 
        \seq_map_break: 
        \iow_close:N \g_ztool_file_append_iow
      }
      % { \seq_put_right:Nn \l_tmpb_seq {#1} }
      { 
        \str_if_empty:eF {\tl_trim_spaces:n {#1}}{
        \iow_now:Ne \g_ztool_file_append_iow 
          { \exp_not:n {#1}}
        }
      }
  }
% \seq_show:N \l_tmpb_seq
\ExplSyntaxOff
```

output result:
```latex 
\InputIfFileExists {ztikz-cfg.tex}{}{}
\documentclass {article}
\usepackage {xcolor}
\usepackage {tikz}
\usepackage {xsimverb}
\usepackage {ztool}
\usepackage {xparse}
\makeatletter 
\ExplSyntaxOn 
\tl_new:N \l_ztikz_cache_forward_value_tl 
\str_new:N \l_ztikz_cache_forward_name_str 
\keys_define:nn {ztikz/cache}
{delimiter.tl_set:N=\l_ztikz_cache_arg_delimiter_tl ,delimiter.initial:n={[]},forward.clist_set:N=\l_ztikz_cache_forward_clist ,forward.initial:n={\empty },}
\cs_new:Npn \__ztikz_cache_deps:n ##1
{\c_percent_str \exp_not:n {##1}:= ##1
}
\NewDocumentCommand {\ztikzCacheEnv }{om}
{\DeclareEnvironmentCopy {ztikz@cached@##2}{##2}\IfValueT {##1}{\keys_set:nn {ztikz/cache}{##1}}\exp_args:Nne \DeclareDocumentEnvironment {##2}{D\l_ztikz_cache_arg_delimiter_tl {}}{\tl_if_empty:VTF \l_ztikz_cache_arg_delimiter_tl {\xsim_file_write_start:nn {\c_true_bool }{ZZZ.tex}\typeout {-->empty arg}}{\xsim_file_write_start:nn {\c_false_bool }{ZZZ.tex}}}{\xsim_file_write_stop: \ztool_insert_to_file:nnn {ZZZ.tex}{1}{\clist_map_function:NN \l_ztikz_cache_forward_clist \__ztikz_cache_deps:n \exp_not:N \begin {ztikz@cached@##2}\tl_item:Nn \l_ztikz_cache_arg_delimiter_tl {1}####1\tl_item:Nn \l_ztikz_cache_arg_delimiter_tl {-1}}\ztool_append_to_file:nn {ZZZ.tex}{\exp_not:N \end {ztikz@cached@##2}}}}
\ExplSyntaxOff 
\ztikzCacheEnv [delimiter=[],forward={\AAA ,\empty }]{tikzpicture}
```

If you add your main part to this file, the compile output will be wrong.