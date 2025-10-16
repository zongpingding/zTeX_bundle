%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ztex.cls                                                                   %
%% Copyright 2024, 2025 Zongping Ding.                                        %
%                                                                             %
% This work may be distributed and/or modified under the conditions of the    %
% LaTeX Project Public License, either version 1.3 of this license or any     %
% later version.                                                              %
% The latest version of this license is in                                    %
%                    http://www.latex-project.org/lppl.txt                    %
% and version 1.3 or later is part of all distributions of LaTeX              %
% version 2005/12/01 or later.                                                %
%                                                                             %
% This work has the LPPL maintenance status `maintained'.                     %
%                                                                             %
% The Current Maintainer of this work is Zongping Ding.                       %
%                                                                             %
% This work consists of the files ztex.cls,                                   %
%       the modules: ztex.module.box.tex,                                     %
%                    ztex.module.cmd.tex,                                     %
%                    ztex.module.color.tex,                                   %
%                    ztex.module.counter.tex,                                 %
%                    ztex.module.font.tex,                                    %
%                    ztex.module.graphics.tex,                                %
%                    ztex.module.item.tex,                                    %
%                    ztex.module.page.tex,                                    %
%                    ztex.module.ref.tex,                                     %
%                    ztex.module.sclist.tex,                                  %
%                    ztex.module.sect.tex,                                    %
%                    ztex.module.thm.tex,                                     %
% and the libraries: ztex.library.alias.tex,                                  %
%                    ztex.library.cmd.tex,                                    %
%                    ztex.library.slide.tex,                                  %
%                    ztex.library.thm.tex,                                    %
%                    ztex.library.primitive.tex,                              %
%                    ztex.library.fancy.tex.                                  %
%                    ztex.library.pratt.tex.                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\ExplSyntaxOn
\NeedsTeXFormat{LaTeX2e}
\gdef\ztex@d@te{2025/10/14}
\gdef\ztex@versi@n{1.1.3}
\tl_const:Nn \c__ztex_class_name_tl           {ztex}
\tl_const:Nn \c__ztex_class_version_tl        {\ztex@versi@n}
\tl_const:Nn \c__ztex_class_date_tl           {\ztex@d@te}
\clist_const:Nn \c__ztex_lang_support_clist   {en, cn}
\tl_const:Nn    \c__ztex_class_description_tl  
  {
    A~pre-release~universal~document~class~for~article,~book,~and~slides;~
    Support~languages:\clist_use:Nn \c__ztex_lang_support_clist{,~}
  }
\ProvidesExplClass{\c__ztex_class_name_tl}         % Class name
                  {\c__ztex_class_date_tl}         % Class Date updated
                  {\c__ztex_class_version_tl}      % Class Version latest
                  {\c__ztex_class_description_tl}  % Class Description



% ----------------------------------------------------------------------
%                         class module and library 
% ----------------------------------------------------------------------
\clist_new:N \g__ztex_module_library_loaded_clist
\clist_gclear:N \g__ztex_module_library_loaded_clist
\cs_new_nopar:Npn \__ztex_load_module_library:nn #1#2 
  {
    \clist_map_inline:nn {#2} 
      {
        \clist_if_in:NnTF \g__ztex_module_library_loaded_clist 
          { #1:##1 }
          {
            \msg_set:nnn {ztex} {#1-loaded}
              {
                ztex~#1~"##1"~already~loaded,give~
                up~loading~again.\msg_line_context:
              }
            \msg_warning:nnn {ztex} {#1-loaded} {##1}
          }{
            \file_if_exist:nTF {#1/ztex.#1.##1.tex}
              {
                \clist_gput_right:Nn 
                  \g__ztex_module_library_loaded_clist 
                  { #1:##1 }
                \makeatletter\file_input:n {#1/ztex.#1.##1.tex}
              }{
                \msg_set:nnn {ztex} {#1-not-found} 
                  { ztex~#1~`##1'~not~found. }
                \msg_error:nnn {ztex} {#1-not-found} 
                  { ##1 }
              }
          }
      }
  }
\NewDocumentCommand\ztexloadmod{m}
  {
    \__ztex_load_module_library:nn {module}{#1}
    \ExplSyntaxOff
  }
\NewDocumentCommand\ztexloadlib{m}
  {
    \__ztex_load_module_library:nn {library}{#1}
    \ExplSyntaxOff
  }



% ----------------------------------------------------------------------
%                             class tools
% ----------------------------------------------------------------------
% ztex hook interface
\RequirePackage[box]{ztool}
\cs_new_protected:Npn \ztex_hook_preamble_last:n #1
  { 
    \hook_gput_code:nnn {env/document/before}
      {ztex/preamble/last}{#1}
  }
\cs_new_protected:Npn \ztex_label_hook_preamble_last:nn #1#2
  {
    \hook_gput_code:nnn {env/document/before}
      {#1}{#2}
  }
\cs_new_protected:Npn \ztex_hook_doc_begin:n #1
  {
    \hook_gput_code:nnn {begindocument}
      {ztex/doc/begin}{#1}
  }
\cs_new_protected:Npn \ztex_hook_doc_end:n #1
  {
    \hook_gput_code:nnn {enddocument}
      {ztex/doc/end}{#1}
  }

% ztex key-value setup interface
\cs_new_protected:Npn \ztex_option_keys_define:n
  { \keys_define:nn { ztex / option } }
\cs_new_protected:Npn \ztex_keys_define:nn #1
  { \keys_define:nn { ztex / #1 } }
\cs_new_protected:Npn \ztex_keys_set:nn #1
  { \keys_set:nn { ztex / #1 } }
\cs_new:Npn \__ztex_plus_key_aux:nnn #1#2#3
  {% #1:var; #2:p-key; #3:s-key
    #2 / #3     .tl_set:N = \exp_not:c { #1 } ,
    #2 / #3 +   .code:n   = { \tl_put_right:Nn \exp_not:c { #1 } { ##1 } } ,
    #2 / #3 ~ + .code:n   = { \tl_put_right:Nn \exp_not:c { #1 } { ##1 } }
  }



% ----------------------------------------------------------------------
%                   ztex Message system
% ----------------------------------------------------------------------
\prop_gput:Nnn \g_msg_module_type_prop 
  { ztex } { Class }
\cs_new_protected:Npn \ztex_msg_set:nn #1#2
  {
    \msg_if_exist:nnTF { ztex }{ #1 } 
      { \msg_set:nnn { ztex }{#1}{#2} }
      { \msg_new:nnn { ztex }{#1}{#2} }
  }
\cs_new_protected:Npn \ztex_metakey_msg_warning:nn #1#2 
  {
    \ztex_msg_set:nn {#1}
      {
        You~use~an~invalid~key~"\l_keys_path_str"~or~key~
        assign~for~it~in~the~meta~key~"#1",~Valid~options~
        are:#2;~Assignment~Ignored~and~zLaTeX~default~"#1"~
        settings~of~this~key~substitute.
      }
    \ztex_msg_warn:n {#1}
  }
\prop_const_from_keyval:Nn \c__ztex_msg_type_prop
  {
    info  = info,
    warn  = warning,
    error = error,
    fatal = fatal,
  }
\prop_map_inline:Nn \c__ztex_msg_type_prop
  {
    \cs_new_protected:cpn { ztex_msg_#1:n } ##1
      {
        \use:c { msg_#2:nn }
          { ztex }{ ##1 }
      }
    \cs_new_protected:cpn { ztex_msg_#1:nn } ##1##2
      {
        \use:c { msg_#2:nnn }
          { ztex }{ ##1 }{ ##2 }
      }
    \cs_new_protected:cpn { ztex_msg_#1:nnn } ##1##2##3
      {
        \use:c { msg_#2:nnnn }
          { ztex }{ ##1 }{ ##2 }{ ##3 }
      }
  }

% ztex class options message
\ztex_msg_set:nn {option-unknown}
  {
    You~use~an~unknown~class~option~key:'\l_keys_path_str'.~
    Valid~options~are:lang,~hyper,~fancy,~class,~classOption(<clist>),~
    toc(<key-value>),~font(<key-value>),~layout(<key-value>),~
    section(<key-value>),~mathSpec(<key-value>),~bib_index(<key-value>).~
    Assignment~Ignored~and~LaTeX~default~settings~substitute.
  }
\ztex_msg_set:nn {option-language}
  {
    Current~invalid~language~option~is:~'\g__ztex_lang_str',~
    ztex~only~support~'en(english)',~and~'cn(chinese)'~till~now.
  }



% ----------------------------------------------------------------------
%                             class option 
% ----------------------------------------------------------------------
% package options passing
\cs_new:Npn \ztex_package_options_pass:nn #1#2
  {
    \PassOptionsToPackage{#2}{#1}
  }
\cs_new:Npn \ztex_package_options_pass_deprecate:n #1
  {
    \ztex_msg_set:nn {package-option}
      {
        No~options~were~passed~to~package:#1,~
        Deprecated~this~option(s)~for~package~#1.
      }
    \ztex_msg_warn:n {package-option}
  }
\ztex_msg_set:nn { metakey@file@missing }
  {
    file~'ztex.options.tex'~is~missing~
    from~the~ztex~bundle...
  }
% setup class options
\keys_define:nn { ztex }{
  % basic options
  lang            .str_gset:N   = \g__ztex_lang_str,
  lang            .initial:n    = { en },
  lang            .usage:n      = load,
  hyper           .bool_gset:N  = \g__ztex_hyperref_bool,
  hyper           .initial:n    = { false },
  hyper           .default:n    = { true },
  hyper           .usage:n      = load,
  hyper-suppress  .clist_gset:N = \g__ztex_hyper_suppress_clist,
  hyper-suppress  .initial:n    = { toc },
  hyper-suppress  .usage:n      = load,
  fancy           .bool_gset:N  = \g__ztex_fancy_bool,
  fancy           .initial:n    = { false },
  fancy           .default:n    = { true },
  fancy           .usage:n      = load,
  cref-backend    .str_gset:N   = \g__ztex_cref_backend_str,
  cref-backend    .initial:n    = { zref-clever },
  % sub class and meta key
  class           .str_gset:N   = \g__ztex_subclass_type_str,
  class           .initial:n    = { article },
  class           .usage:n      = load,
  classOption     .clist_gset:N = \g__ztex_subclass_option_clist,
  classOption     .initial:n    = { oneside, 12pt },
  classOption     .usage:n      = load,
  packageOption   .code:n       = { 
    \keyval_parse:NNn 
      \ztex_package_options_pass_deprecate:n 
      \ztex_package_options_pass:nn {#1} 
  },
  packageOption   .usage:n      = load,
  % ztex options meta key
  sect            .meta:nn      = { ztex / sect }{#1},
  sect            .usage:n      = load,
  font            .meta:nn      = { ztex / font  }{#1},
  layout          .meta:nn      = { ztex / layout}{#1},
  layout          .usage:n      = load,
  mathSpec        .meta:nn      = { ztex / mathSpec }{#1},
  bib_index       .meta:nn      = { ztex / bib_index}{#1},
  unknown         .code:n       = { 
    \ztex_msg_warn:n {option-unknown} 
  }
}
% sub(meta) key implementation
\file_if_exist_input:nF { ztex.options.tex }
  { \ztex_msg_fatal:n { metakey@file@missing } }

% ztex options setup
\ProcessKeyOptions [ ztex ]
\NewDocumentCommand{\ztexset}{m}
  { 
    \keys_set:nn {ztex}{#1} 
  }
\newcommand{\ztexoption}
  {
    \str_use:N \g__ztex_lang_str {~,~}
    \clist_use:Nn \g__ztex_subclass_option_clist
      { ~,~ }
  }



% ----------------------------------------------------------------------
%                          subClass and package Option 
% ----------------------------------------------------------------------
% pass clist options main subclass: 'article', 'book', 'ctexbook'
\ztex_msg_set:nn {option-subclass}
  {
    subclass~option:"\g__ztex_subclass_type_str"~is~
    not~accessible,~Valid~options~are:article,~book,~
    ctexbook,~l3doc~and~l3dox.
  }
\str_case:VnF \g__ztex_subclass_type_str 
  {
    {article}{
      \PassOptionsToClass{\g__ztex_subclass_option_clist}
        { article }
      \LoadClass{article}
    }
    {book}{
      \PassOptionsToClass{\g__ztex_subclass_option_clist}
        { book }
      \LoadClass{book}   
    }
    {ctexbook}{
      \str_set:Nn \g__ztex_lang_str {cn}
      \PassOptionsToClass{\g__ztex_subclass_option_clist}
        { ctexbook }
      \PassOptionsToPackage{quiet}{fontspec}
      \LoadClass{ctexbook}    
    }
    {l3doc}{
      \PassOptionsToClass{\g__ztex_subclass_option_clist}
        { l3doc }
      \LoadClass{l3doc}
    }
  }{
    \ztex_msg_error:n {option-subclass}
  }

% baisc document class and packages option
\tl_set_rescan:NnV \l_tmpa_tl 
  { \cctab_select:N \c_code_cctab }
  \g__ztex_lang_str
\clist_if_in:NVF \c__ztex_lang_support_clist \l_tmpa_tl
  { \ztex_msg_error:n {option-language} }
\str_case:VnF \g__ztex_lang_str 
  {
    {en} {
      \sys_if_engine_xetex:T 
        {
          \ztex_hook_preamble_last:n 
            {
              \bool_if:NF \g__ztex_sysfont_cfg_bool
                {
                  \ztex_msg_set:nn {compile-engine-pdftex}
                    {
                      Current~compile~engine~is~XETEX,~For~better~
                      output,~use~PDFTEX~instead.
                    }
                  \ztex_msg_warn:n {compile-engine-pdftex}
                }
            }
        }
      \RequirePackage[T1]{fontenc}
    }
    {cn} {
      \sys_if_engine_pdftex:T 
        {
          \ztex_msg_set:nn {compile-engine-xetex}
            {
              Current~compile~engine~is~PDFTEX,~For~
              chinese~material,~use~XETEX~instead.
            }
          \ztex_msg_error:n {compile-engine-xetex}
        }
      \PassOptionsToPackage{quiet}{fontspec}
      \PassOptionsToPackage{no-math}{fontspec}
      \str_if_eq:VnF \g__ztex_subclass_type_str 
        { ctexbook }
        {
          \RequirePackage[UTF8, scheme=plain]{ctex}
          \linespread{1.3}
        }
    }
  }{
    \ztex_msg_error:n {option-language}
  }



% ----------------------------------------------------------------------
%                             ztex module
% ----------------------------------------------------------------------
\__ztex_load_module_library:nn {module}{sclist}
\__ztex_load_module_library:nn {module}{cmd}
\__ztex_load_module_library:nn {module}{box}
\__ztex_load_module_library:nn {module}{page}
\__ztex_load_module_library:nn {module}{thm}
\__ztex_load_module_library:nn {module}{counter}
\__ztex_load_module_library:nn {module}{ref}
\__ztex_load_module_library:nn {module}{color}
\__ztex_load_module_library:nn {module}{font}
\__ztex_load_module_library:nn {module}{sect}
\__ztex_load_module_library:nn {module}{graphics}
\__ztex_load_module_library:nn {module}{item}



% ----------------------------------------------------------------------
%                             ztex  library
% ----------------------------------------------------------------------
\bool_if:NT \g__ztex_math_alias_bool 
  {
    \__ztex_load_module_library:nn {library}{alias}
  }
\bool_if:NTF \g__ztex_slide_bool 
  {
    \__ztex_load_module_library:nn {library}{slide}
  }{ \newcommand\zslideset[1]{} }
\bool_if:NT \g__ztex_fancy_bool 
  { \__ztex_load_module_library:nn {library}{fancy} }



% ----------------------------------------------------------------------
%                          module/library checker
% ----------------------------------------------------------------------
\bool_new:N \g__ztex_thm_lib_load_bool
\bool_gset_false:N \g__ztex_thm_lib_load_bool
\newcommand\ztexhyperTF[2]
  {
    \bool_if:NTF \g__ztex_hyperref_bool 
      { #1 }{ #2 }
  }
\newcommand\ztexfancyTF[2]
  {
    \bool_if:NTF \g__ztex_fancy_bool 
      { #1 }{ #2 }
  }
\newcommand\ztexmarginTF[2]
  {
    \bool_if:NTF \g__ztex_margin_bool 
      { #1 }{ #2 }
  }
\newcommand\ztexslideTF[2]
  {
    \bool_if:NTF \g__ztex_slide_bool 
      { #1 }{ #2 }
  }
\newcommand\ztexsysfontTF[2]
  {
    \bool_if:NTF \g__ztex_sysfont_cfg_bool 
      { #1 }{ #2 }
  }
\newcommand\ztexaliasTF[2]
  {
    \bool_if:NTF \g__ztex_math_alias_bool 
      { #1 }{ #2 }
  }
\newcommand\ztexbibindTF[2]
  {
    \bool_if:NTF \g__ztex_bib_index_load_bool 
      { #1 }{ #2 }
  }
\newcommand\ztethmlibTF[2]
  {
    \bool_if:NTF \g__ztex_thm_lib_load_bool 
      { #1 }{ #2 }
  }



% ----------------------------------------------------------------------
%                          ztex logo
% ----------------------------------------------------------------------
\NewDocumentCommand\zTeX{s}
  {
    \IfBooleanTF{#1}
      {
        \__ztool_leave_vmode:
        \raise0.0894ex\hbox{z}
        \kern-0.4645ex\hbox{\TeX}
      }{
        \ztool_scale_to_wd_and_ht:nnn 
          {.9ex}{1.3ex}
          {
            \ztool_rotate:nn {89}{\(\aleph\)}
          } \kern-0.3423ex\hbox{\TeX}
      }
  }
\NewDocumentCommand\zLaTeX{s}
  {
    \IfBooleanTF{#1}
    {
      \__ztool_leave_vmode:
      \raise0.1ex\hbox{z}
      \kern-0.3ex\hbox{\LaTeX}
    }{
      L\kern -.375em
        {
          \lower-.4ex \hbox {
            \ztool_scale_to_wd_and_ht:nnn 
              {.9ex}{1.3ex}
              {
                \ztool_rotate:nn {88}{\(\aleph\)}
              }
          }
        } \kern -.05em\TeX
    }
  }
\let\ztex\zTeX
\let\zlatex\zLaTeX
\protected\def\HoLogo@zTeX#1{\zTeX}
\protected\def\HoLogo@ztex#1{\zTeX}
\protected\def\HoLogo@zLaTeX#1{\zLaTeX}
\protected\def\HoLogo@zlatex#1{\zLaTeX}