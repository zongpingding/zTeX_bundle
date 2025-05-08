
\ProvidesExplClass{test}
  {2023/10/01}
  {0.1}
  {Test class for expl3}

\cs_new:Npn \aaa_bbb:n #1 
  { HELLO~#1 }

\aaa_bbb:N {#1}
% \def\aaa#1{\aaa_bbb_ccc:n { #1 }}
\ExplSyntaxOff