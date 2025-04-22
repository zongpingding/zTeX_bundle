\NeedsTeXFormat{LaTeX2e}
\ProvidesExplClass{cusdoc}{2024-04-16}{0.0.5}{cus doc class}

\keys_define:nn { cusdoc } 
  {
    tcbxample .bool_set:N = \l__cusdoc_tcbxample_bool , 
    unknown .code:n = \PassOptionsToClass{#1}{book} 
  }
\ExplSyntaxOff

\ProcessKeyOptions
\LoadClass{book}

\PassOptionsToPackage{silent}{xeCJK}
\RequirePackage{ctex}

\InputIfFileExists{cusdoc.cfg}{}{}
\RequirePackage{cus}
\CUSDependency{library={doc,box,bnf,ref,counter,pgf}}
\SetKeys[updatemarks]{multicol}

\RequirePackage{graphicx}
\setgraphicspath{./cus-doc, ./cus-doc-aux}
\RequirePackage{xcolor}

%region math & fonts
\RequirePackage{amsmath,amsfonts}
\RequirePackage{unicode-math}
% \setmainfont{texgyrepagella}[
%   Extension      = .otf,
%   UprightFont    = *-regular,
%   BoldFont       = *-bold,
%   ItalicFont     = *-italic,
%   BoldItalicFont = *-bolditalic]
\setmainfont{TeXGyreTermesX}[
  Extension      = .otf,
  UprightFont    = *-Regular,
  BoldFont       = *-Bold,
  ItalicFont     = *-Italic,
  BoldItalicFont = *-BoldItalic,
  SlantedFont    = *-Slanted,
  BoldSlantedFont= *-BoldSlanted]
\setsansfont{texgyreheros}[
  Extension      = .otf,
  UprightFont    = *-regular,
  BoldFont       = *-bold,
  ItalicFont     = *-italic,
  BoldItalicFont = *-bolditalic]
\setmonofont{cmun}[
  Extension      = .otf,
  UprightFont    = *btl,
  BoldFont       = *tb,
  ItalicFont     = *bto,
  BoldItalicFont = *st,
  HyphenChar     = None]
\setmathfont{texgyrepagella-math.otf}
%endregion


\RequirePackage{lineno}
\RequirePackage{fontawesome5}
\RequirePackage{caption}
% \expandafter\let\csname caption@ifoddpage\endcsname\IfPageOdd
\RequirePackage{floatrow}
\RequirePackage{tikz}
\usetikzlibrary{shadings}
\RequirePackage[many]{tcolorbox}
\RequirePackage{listings}
% \RequirePackage{siunitx}
\RequirePackage{adjustbox}
\RequirePackage[strict]{changepage}
\renewcommand{\cplabel}{@}
\RequirePackage{array,booktabs,tabularx,makecell}
\RequirePackage{tabularray}

\floatsetup{captionskip=5pt,facing=yes}

%region shorthands
\newcommand{\hook}{\cmd[module=hook point,type=hook point]}
\newcommand{\colna}{\key[module=color name,type=color name]}

\RequirePackage{marginnote}
\newcommand{\sdanger}[1][1]{\par\medskip\noindent
  \@@line{\hss\Replicate{#1}{\textdbend}\hss}\par}
\newcommand{\mdanger}[1][1]{\marginnote{\Replicate{#1}{\textdbend}}}
\newcommand{\pkgdoc}[1]{\pkg{#1} 宏包文档}
\newcommand*{\TODO}{\textcolor{red!90!black}{\bfseries[TODO]}}
%endregion


\setuplayout*[balance]{hmargin=1.7cm,top=2.3cm,bottom=2.5cm,
  hfoffset=0pt,nomarginpar,
  columnsep=35pt,headsep=10pt,footskip=30pt,}
\setuplayout[main]{paper=a4,
  marginparsep=10pt,marginparwidth=15\ccwd,
  textwidth=35\ccwd,inner=1.7cm,top=2.3cm,bottom=2.5cm,
  headsep=10pt,footskip=30pt,
  hfoffset={[OR,EL]168.1pt},
}

\RequirePackage{enumitem}
\setlist{nosep}
\setlist[itemize,1]{label=\textbullet}
\setlist[itemize,2]{label=$\smwhtcircle$}


\RequirePackage{hyperref}
\hypersetup{colorlinks}
\RequirePackage{nameref,varioref}
\ExpandArgs{c}\let{ver@listings.sty}\@undefined % emergency fix for cleveref
\RequirePackage{cleveref}
\RequirePackage[numbered,open,openlevel=1]{bookmark}
\RequirePackage{glossaries}
\RequirePackage{zhlipsum}


%region header footer
%% 空 mark 实际上保存为了 \prg_do_nothing:，这里并不直接检测，而利用一个空的 mark
\NewMarkClass{totalempty}
\InsertMark{totalempty}{}
\NewMarkClass{chapter/head}
\NewMarkClass{section/head}
\long\def\chaptermark#1{%
  \InsertMark{chapter/head}{\protect\hyperlink{\@currentHref}{#1}}%
  \InsertMark{section/head}{}}
\long\def\sectionmark#1{%
  \InsertMark{section/head}{\protect\hyperlink{\@currentHref}{#1}}}
\def\@chaptosec{\;\texttt{>\kern-.1em >}\;}
\def\@splitrange{\ \texttt{=\kern-.1em =\kern-.2em >}\ }
\def\head@ifempty#1{\ifthenelse{\equal{#1}{}\OR\equal{#1}{\TopMark{totalempty}}}}
\def\head@hifeq#1{\IfMarksEqualTF{#1/head}}
\def\head@ifeq#1#2{\ifthenelse{\equal{#1}{#2}}}
\def\head@ct{\TopMark{chapter/head}} \def\head@st{\TopMark{section/head}}
\def\head@cf{\FirstMark{chapter/head}} \def\head@sf{\FirstMark{section/head}}
\def\head@cl{\LastMark{chapter/head}} \def\head@sl{\LastMark{section/head}}
\def\head@fc#1{{\bfseries #1}} \def\head@fs#1{{#1}}
\newcommand\marked@title{%
  \head@hifeq{chapter}{first}{last}{%
    \head@ifempty\head@cf{}
      {\head@ifempty\head@ct
        {\head@fc\head@cf\head@ifempty\head@sl{}{\@chaptosec
          \head@ifeq\head@sf\head@sl{\head@fs\head@sf}{\head@fs\head@sf
            \head@ifempty\head@sl{}{\@splitrange\head@fs\head@sl}}}}
        {\head@ifeq\head@ct\head@cf
          {\head@fc\head@ct\head@ifempty\head@sf{}
            {\@chaptosec\head@ifeq\head@sf\head@sl
              {\head@fs\head@sf}{\head@fs\head@sf\@chaptosec\head@fs\head@sl}}}
          {\head@fc\head@ct\head@ifempty\head@st{}{\@chaptosec\head@fs\head@st}\@splitrange
            \head@fc\head@cl\head@ifempty\head@sl{}{\@chaptosec\head@fs\head@sl}}}}%
  }{\head@fc\head@cf\@splitrange\head@fc\head@cl}}

\providecommand\headlink@warp[1]{#1}
\setpagestyle{plain}[totalempty]{}
%endregion

\@secpenalty-\@m 
\setuptitle[chapter]{pagestyle=fancy, 
  fixskip, break=\needspace{100pt}, 
  beforeskip=30pt, afterskip=25pt, format=\zihao{-2}\bfseries\centering,}
\setuptitle[section]{fixskip, break=\addpenalty{-5000},
  name={\texorpdfstring{\S~}{\S}},
  beforeskip=20pt plus 5pt minus 5pt, afterskip=15pt plus 2pt minus 2pt,
  format=\zihao{-3}\bfseries\raggedright,}
\setuptitle[subsection]{fixskip,
  beforeskip=10pt plus 3pt minus 3pt,
  afterskip=10pt plus 3pt minus 3pt,
  format=\zihao{-4}\bfseries\raggedright,}

%region doc settings
\protected\def\cusdoc@externallink{\raisebox{-.8ex}[0pt][0pt]{\hi{\faIcon{external-link-alt}}}}
\protected\def\cusdoc@linkpage{\raisebox{.8ex}[0pt][0pt]{\lo{P.\labelinfo{page}{\cus@doc@thelabel}}}}
\protected\def\cusdoc@linkinfo{\lohi{\,\rmfamily\cusdoc@linkpage}{\,\cusdoc@externallink}}
\def\cus@doc@basic@format{\ifx\cus@doc@thelabel\@empty \cus@doc@thetext
  \else \hyperref[\cus@doc@thelabel]{\cus@doc@thetext\cusdoc@linkinfo}\!\fi}
\def\cus@doc@cs@format#1{\hypersetup{linkcolor=cus/color/doc cs}\cus@doc@basic@format}
\let\cus@doc@cmd@format\cus@doc@cs@format
\let\cus@doc@tn@format\cus@doc@cs@format
\def\cus@doc@key@format#1{\hypersetup{linkcolor=cus/color/doc key}\cus@doc@basic@format}
\def\cus@doc@csref@format#1{\cus@doc@basic@format}
\def\cus@doc@envref@format#1{\cus@doc@basic@format}
\def\cus@doc@keyref@format#1{\cus@doc@basic@format}
\setfontface\cus@doc@itfont{texgyrepagella-italic}[Extension=.otf,BoldFont=texgyrepagella-bolditalic]
\definecolor{cus/color/doc cs}{RGB}{180,116,107}
\definecolor{cus/color/doc env}{RGB}{216,156,122}
\definecolor{cus/color/doc key}{RGB}{138,149,169}
%endregion


\lstdefinelanguage[BNF]{TeX}[common]{TeX}{
  texcs=[1]{BNFItem}, texcs=[2]{BNFN}, texcs=[3]{BNFT}, 
  texcs=[4]{BNFI,is}, texcs=[5]{BNFO,alt},
  moredelim=[s][{\color{blue}}]{<}{>},
  moredelim=[s][{\color{red!70}}]{"}{"},
  literate={{:}{{\bfseries\color{green!50!black}:}}1 {::=}{{\bfseries\color{green!50!black}::=}}3 {|}{{\bfseries\color{cyan}\string|}}1},
  texcsstyle={[1]{\color{purple}}}, texcsstyle={[2]{\color{blue}}}, 
  texcsstyle={[3]{\color{red!70}}}, texcsstyle={[4]{\bfseries\color{green!50!black}}},
  texcsstyle={[5]{\bfseries\color{cyan}}}}

\crefformat{figure}{#2图#1#3}
\crefformat{table}{#2表#1#3}
\crefformat{example}{#2例#1#3}
\crefformat{part}{#2第\zhnumber{#1}部分#3}
\crefformat{chapter}{#2第\zhnumber{#1}章#3}
\crefformat{section}{第 #2#1#3 节}
\crefformat{subsection}{第 #2#1#3 小节}


%region xample env
\NewDocumentCommand\xamplecodefile{+m+m+m}{\lstinputlisting[#1,#2]{#3}}
\DeclareNewFloatType{example}{fileext=example,name=例}
\lstdefinestyle{xamplestyle}{language={[LaTeX]TeX},
  basicstyle=\small\linespread{1.1}\ttfamily,
  aboveskip=\smallskipamount,belowskip=-\medskipamount,
  % aboveskip={0\p@ \@plus 6\p@}, belowskip={0\p@ \@plus 6\p@},
  columns=fullflexible, keepspaces=true,
  breaklines=true, breakatwhitespace=true, 
  breakindent=0pt, 
  postbreak={\hb@xt@1.5em{\hss{\transparent{.3}$\hookrightarrow$}\hss}},
  extendedchars=true, nolol,
  numberstyle=\tiny,numbersep=8pt,
  commentstyle=\color{green!55!black}}
\definebufferpair [ __process_line=standard-not-nest,
  save-mode=write, write=\jobname.exambuff, blank=space] 
  \startxamplecode \stopxamplecode {} 
  {\edef\xamplecode{%
    \noexpand\xamplecodefile
      {style=xamplestyle}
      {\unexpanded\expandafter{\xampleOPTlst}}
      {\jobname.exambuff}}%
    \def\xcaption{\setcaptiontype{example}\caption}%
    \xample@hango\begin{longfbox}[]\xample@hangi}
\protected\def\xample@hango{%
  \par\refstepcounter{example}%
  \edef\xample@test{\noexpand\ifnum\the\c@example>\c@example 
    \global\advance\c@example\@ne\noexpand\fi}}
\protected\def\xample@hangi{%
  \setbox\z@\hb@xt@\textwidth{\hss{\color{red!80!black}\bfseries 例\theexample}}%
  \global\advance\c@example -\@ne
  \vspace*{-\dimexpr\option{/fbox/padding-top}+\parskip}\par
  \edef\xample@tmp{\vskip-\the\dimexpr\ht\z@+\dp\z@+.3333em+\parskip\relax\par}%
  \box\z@ \xample@tmp}
\protected\def\xampleline{\noindent \kern-\dimexpr\option{/fbox/padding-left}\relax
  \cleaders\hb@xt@.2em{\hss.\hss}\hfill 
  \kern\dimexpr-\option{/fbox/padding-right}\relax \par}
\def\xampletext{\par\input{\jobname.exambuff}}
\def\xampleprint{\xamplecode \xampleline \xampletext}

\NewDocumentEnvironment {xample} { O{} O{} }
  {\penalty-1000 \def\xampleOPTlst{#1}%
    \fboxset{breakable=true,#2}%
    \expandafter\expandafter\expandafter\startxamplecode
      \expandafter\string\@firstofone}
  {\end{longfbox}\xample@test\goodbreak}


\ExplSyntaxOn

\msg_redirect_name:nnn { tabularray } { table-width-too-small } { log }


\tl_const:Nn \cusdoctoc
  {
    \setpagestyle+{fancy.contents}[fancy]{}
    \setuptitle[chapter]{numbering=false,pagestyle=}
    \def\contentsname{总目录}
    {% \tableofcontents[ragged,outer-sep=0pt,sep=1.5em,2]
      \ekeysdeclarecmd\fixedwidthtext{smm}{\leavevmode@ifvmode
        \setbox\z@\hbox{{#3}}%
        \ifdim\dimeval{#2}>\wd\z@ 
          \hbox to\dimeval{#2}{\IfBooleanTF{#1}{\spreadtext*{#2}{#3}}{#3\hfill}}
        \else
          \resizebox{\dimeval{#2}}{\height}{#3}
        \fi}
      \definecolor{toccol1}{HTML}{006DAA}
      \definecolor{toccol2}{HTML}{C4D4E3}
      \newcommand*{\zhphantom}{\vphantom{好hig}}
      \tocsetstyle{chapter}{}
        {}
        {\begingroup\noindent \bfseries\large \fboxrule\z@ 
          \fcolorbox{toccol1}{toccol1}{\zhphantom\color{white}%
            \tocifnamed{\fixedwidthtext*{4\ccwd}{\tocthename\unskip}}
              {\fixedwidthtext*{4\ccwd}{\tocthetitle}}}%
          \toclinkbox{\fcolorbox{toccol2}{toccol2}{\zhphantom
            \fixedwidthtext{\linewidth-4\ccwd-4\fboxsep-1.3em}
              {\tocifnamed{\tocthetitle}{}}%
            \makebox[1.3em][r]{\tocthepage}}}
          \endgroup\par \medskip}
        {\bigskip}{}
      \tocsetstyle{section}{}{}
        {\@dottedtocline{\tocthelevel}{1.5em}{2.3em}{\tocthename\enskip\tocthetitle}
          {\hss\toclink{\tocthepage}\hspace{\fboxsep}}}
        {}{}
      \tocsetstyle{subsection}{}{}
        {\@dottedtocline{\tocthelevel}{3.8em}{3.2em}{\tocthename\enskip\tocthetitle}
          {\hss\toclink{\tocthepage}\hspace{\fboxsep}}}
        {}{}
      \startmulticolumns[ragged,outer-sep=0pt,column-sep=1.5em, 
        heading=\chapter\contentsname]
      \specifiedtoc 
      \stopmulticolumns}
  }