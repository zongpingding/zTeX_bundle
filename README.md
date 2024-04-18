# ZLaTeX_ZTikZ
A LaTeX template for writing notes, books, drawing diagrams, and interactive work with Python, gnuplot, and Mathematica. Enjoy it~


# set up
The document class `zlatex` and package `ztikz` can be used on Windows and Linux (consider TeXLive >= 2023)


More infomation please refer document `zlatex_ztikz_doc.pdf`.

# optional packages 
``` latex
% after `minted` package
\usepackage{anyfontsize}
\usepackage{csquotes}
```

you may like to change the style of the `\maketitle`, use the following command 
``` latex
\renewcommand{\maketitle}{
  \begin{titlepage}
  \vfill\vspace*{40pt}
  \noindent\hspace*{134pt}\rule[-75pt]{6pt}{95pt}{\hspace*{10pt}\leavevmode\parbox
  [t]{25em}{\fontsize{25}{25}\selectfont\bfseries\@title}}\par
  \vspace*{-15pt}
  \noindent\hspace*{150pt}{\leavevmode\parbox[t]{20em}{\Large\bfseries\@author}}\p
  ar
  \vfill
  \noindent\hspace*{150pt}{\Large\textcolor{gray}{\@date}}
  \end{titlepage}}
```


# Need help
we need someone to translate the zlatex document into English or any other language, thanks.
