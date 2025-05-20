# change log
## build status
No tests written yet

## TODO LIST
- [ ] add a new module `ztool`
- [ ] add `shipout` related interface to `ztool`
- [ ] create a `\NewKeyCommand` interface
- [ ] add box-align interface (instead of using package `xcoffin`)
- [ ] load `l3graphics` to replace the old package `graphicx`
- [ ] add a patch command interface like `xpatch`


## append to file
Now the syntax is:
```latex
\ztool_append_to_file:nn {<file-name>}{<content>}
```

An simple example, for file `temp.txt`:
```latex 
\ztool_append_to_file:nn {temp-w.txt}{XXX-2}
\ztool_append_to_file:nn {temp-w.txt}{$#@$}
\ztool_append_to_file:nn {temp-w.txt}{\exp_not:N \hello~\iow_newline: \exp_not:N \world}
```

after appending, file content will be:
```txt 
XXX-2
$##@$
\hello 
\world 

```

That's to say, there is an optional empty line in the end of file.

## catcode 
Some variable retrive from external file has different catcode, for example, file hash variable: 
```latex 
\file_get_mdfive_hash:nN {#2} \l__ztikz_current_hash_tl
```

the catcode in variable `\l__ztikz_current_hash_tl` is `12(other)`, to use it in some comparison, you need rescan it to normal catcode, as below:
```latex 
\tl_set_rescan:Nne \l__ztikz_current_hash_tl
    { \cctab_select:N \c_initex_cctab } 
    { \l__ztikz_current_hash_tl }
```

How to check this ? You can use these functions:
```latex 
\tl_if_head_eq_catcode:nNTF
\tl_if_head_eq_meaning:nNTF
\tl_if_head_is_group:nTF
\tl_if_head_is_N_type:nTF
\tl_if_head_is_space:nTF
\token_to_catcode:N
% Or use the `peek` related tools
```

## expandable replace 
A attempte to make an expandable replace command:
```latex
\InputIfFileExists{ztikz-cfg.tex}{}{}
\documentclass{article}
\usepackage{ztool}


\begin{document}
\ExplSyntaxOn
\seq_new:N \g_tmp_seq
% ==> io write
% \ior_open:Nn \g_ztool_file_append_ior {temp.txt}
% \ior_map_inline:Nn \g_ztool_file_append_ior
%   {
%     \seq_gput_right:Ne \g_tmp_seq {\tl_to_str:n {#1}}
%   }
% \seq_show:N \g_tmp_seq
% \tex_immediate:D \tex_write:D <Stream> { \exp_not:n {<content>} }


% ==> sed file
% \ztool_gread_file_as_seq:nnN {\c_true_bool}{temp.txt} \g_tmp_seq
% \seq_show:N \g_tmp_seq
% \seq_set_item:Nnn \g_tmp_seq {2} {XXX-NEW}
% \seq_show:N \g_tmp_seq
% The sequence \g_tmp_seq contains the items (without outer braces):
% >  {ABCDEFG}
% >  {XXX-1}
% >  {XXX-[2]}
% >  {XXX-$2$}.
% <recently read> }
% The sequence \g_tmp_seq contains the items (without outer braces):
% >  {ABCDEFG}
% >  {XXX-NEW}
% >  {XXX-[2]}
% >  {XXX-$2$}.
% <recently read> }
% \ztool_sed_file:nnn {temp.txt}{2}{XXX-NEW}


% ==> expandable sed
% usefule functions:
% \int_step_function:nnN
% \str_if_eq:nnTF
% \str_range:Nnn
% \str_count:N
\str_set:Nn \l_tmpa_str {XXX-YYY}
\cs_new:Npn \__str_range:n #1 
  { 
    \iow_newline:
    \str_if_eq:eeTF {\str_range:nnn {abcdef}{1}{#1}} {ab}
      {AB}
      {\str_range:nnn {abcdef}{1}{#1}}
  }
\cs_set:Npn \__expandable_str_replace:nn #1#2 
  {
    \int_step_function:nnN {1}{\str_count:n {#1}}
      \__str_range:n
    % \prg_replicate:nn { \str_count:n {#1} }
    %   {
    %     \str_tail:n {#1}
    %   }

    % \str_if_empty:nTF {#1}{\prg_break:}{
    %   \exp_after:wN \__expandable_str_replace:nn 
    %     \exp_after:wN {\str_tail:n {#1}}{#2}
    % }
  }

\newwrite\tempWfile
\immediate\openout\tempWfile temp-w.txt\relax
\immediate\write\tempWfile { 
  % \str_replace_once:Nnn \l_tmpa_str {YYY}{ZZZ-NEW} 
  % \str_map_function:nN {aabaacaa\#} \__str_replace:nn 
  % \str_tail:n {xyzw}
  \__expandable_str_replace:nn {abcdef}{aa}
}
\immediate\closeout\tempWfile % failed with '\str_replace_once:Nnn
\ExplSyntaxOff
\end{document}
```