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
%                    ztex.library.slide.tex,                                  %
%                    ztex.library.thm.tex,                                    %
%                    ztex.library.fancy.tex.                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\ExplSyntaxOn
\NeedsTeXFormat{LaTeX2e}
\tl_const:Nn \c__ztex_class_name_tl           {ztex}
\tl_const:Nn \c__ztex_class_version_tl        {1.0.1}
\tl_const:Nn \c__ztex_class_date_tl           {2025/07/06}
\clist_const:Nn \c__ztex_lang_support_clist   {en, cn}
\tl_const:Nn    \c__ztex_class_description_tl  
  {
    A~pre-release~latex3~document~class~for~article,~book,~or~slides;~
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
\cs_new_nopar:Npn \__ztex_load_module_library:nn #1#2 {
  \clist_map_inline:nn {#2} {
    \clist_if_in:NnTF \g__ztex_module_library_loaded_clist {#1:##1} {
      \msg_set:nnn {ztex} {#1-loaded} {
        ztex~#1~"##1"~already~loaded,ignored~loading
        ~\msg_line_context:
      }
      \msg_warning:nnn {ztex} {#1-loaded} {##1}
    }{
      \file_if_exist:nTF {#1/ztex.#1.##1.tex}{
        \clist_gput_right:Nn \g__ztex_module_library_loaded_clist {#1:##1}
        \makeatletter\file_input:n {#1/ztex.#1.##1.tex}
      }{
        \msg_set:nnn {ztex} {#1-not-found} {ztex~#1~`##1'~not~found.}
        \msg_error:nnn {ztex} {#1-not-found} {##1}
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
  { \AddToHook{env/document/before}{#1} }
\cs_new_protected:Npn \ztex_label_hook_preamble_last:nn #1#2
  { \AddToHook{env/document/before}[#1]{#2} }
\cs_new_protected:Npn \ztex_hook_doc_begin:n #1
  { \AddToHook{begindocument}{#1} }
\cs_new_protected:Npn \ztex_hook_doc_end:n #1
  { \AddToHook{enddocument}{#1} }

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
\prop_gput:Nnn \g_msg_module_type_prop { ztex } { Class }
\cs_new_protected:Npn \ztex_msg_set:nn #1#2 { 
  \msg_if_exist:nnTF { ztex }{#1} 
    { \msg_set:nnn { ztex }{#1}{#2} }
    { \msg_new:nnn { ztex }{#1}{#2} }
}
\cs_new_protected:Npn \ztex_msg_warn:n #1 { 
  \msg_warning:nn { ztex }{#1} 
}
\cs_new_protected:Npn \ztex_msg_error:n #1 { 
  \msg_error:nn { ztex }{#1} 
}
% meta key warning message
\cs_new_protected:Npn \ztex_metakey_msg_warning:nn #1#2 {
  \ztex_msg_set:nn {#1}
    {You~use~an~invalid~key~"\l_keys_path_str"~or~key~assign~for~it~in~the~meta~
    key~"#1",~Valid~options~are:#2;~Assignment~Ignored~and~zLaTeX~default~"#1"~
    settings~of~this~key~substitute.}
  \ztex_msg_warn:n {#1}
}

% ztex class options message
\ztex_msg_set:nn {option-unknown}{
  You~use~an~unknown~class~option~key:'\l_keys_path_str'.~Valid~options~are:lang,~
  hyper,~fancy,~class,~classOption(<clist>),~toc(<key-value>),~font(<key-value>),~
  layout(<key-value>),~section(<key-value>),~mathSpec(<key-value>),~bib_index(<key-value>).~
  Assignment~Ignored~and~LaTeX~default~settings~substitute.
}
\ztex_msg_set:nn {option-language} {
  Current~invalid~language~option~is:~'\g__ztex_lang_str',~ztex~only~
  support~'en(english)',~and~'cn(chinese)'~till~now.
}



% ----------------------------------------------------------------------
%                             class option 
% ----------------------------------------------------------------------
% package options passing
\cs_new:Npn \ztex_package_options_pass:nn #1#2 {
  \PassOptionsToPackage{#2}{#1}
}
\cs_new:Npn \ztex_package_options_pass_deprecate:n #1 {
  \ztex_msg_set:nn {package-option}{
    No~options~were~passed~to~package:#1,~Deprecated~this~option(s)~for~package~#1.
  }
  \ztex_msg_warn:n {package-option}
}
% setup class options
\keys_define:nn { ztex }{  
  % basic options
  lang            .str_gset:N   = \g__ztex_lang_str,
  lang            .initial:n    = { en },
  lang            .usage:n      = load,
  sect-load       .bool_gset:N  = \g__ztex_sect_load_bool,
  sect-load       .initial:n    = { true },
  sect-load       .usage:n      = load,
  hyper           .bool_gset:N  = \g__ztex_hyperref_bool,
  hyper           .initial:n    = { false },
  hyper           .usage:n      = load,
  hyper-suppress  .clist_gset:N = \g__ztex_hyper_suppress_clist,
  hyper-suppress  .initial:n    = { toc },
  hyper-suppress  .usage:n      = load,
  fancy           .bool_gset:N  = \g__ztex_fancy_bool,
  fancy           .initial:n    = { false },
  fancy           .usage:n      = load,
  cref-backend    .str_gset:N   = \g__ztex_cref_backend_str,
  cref-backend    .initial:n    = { zref-clever },
  % sub class and options
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
  font            .meta:nn      = { ztex / font }{#1},
  layout          .meta:nn      = { ztex / layout }{#1},
  layout          .usage:n      = load,
  mathSpec        .meta:nn      = { ztex / mathSpec }{#1},
  bib_index       .meta:nn      = { ztex / bib_index }{#1},
  unknown         .code:n       = { 
    \ztex_msg_warn:n {option-unknown} 
  }
}

% sub-key for each meta option
\ztex_keys_define:nn { font }{
  sysfont         .bool_gset:N  = \g__ztex_sysfont_cfg_bool,
  sysfont         .initial:n    = { false },
  doc             .choice:,
  doc / ptmx      .code:n       = {
    \RequirePackage{mathptmx}
    \RequirePackage{newtxtext}
    \DeclareSymbolFont{letters}{OML}{ntxmi}{m}{it}
    \DeclareMathAlphabet{\mathbf}{OT1}{ntxtlf}{b}{it}
    \DeclareSymbolFont{CMMletters}{OML}{cmm}{m}{it}
    \DeclareSymbolFont{CMMsymbols}{OMS}{cmsy}{m}{n}
    \DeclareSymbolFont{CMMlargesymbols}{OMX}{cmex}{m}{n}
    \DeclareMathSymbol{\new@pi}{0}{CMMletters}{"19}
    \DeclareMathSymbol{\new@jmath}{0}{CMMletters}{"7C}
    \DeclareMathSymbol{\new@amalg}{0}{CMMsymbols}{"71}
    \DeclareMathSymbol{\new@coprod}{1}{CMMlargesymbols}{"61}
    \AddToHook{begindocument}
      {
        \let\pi\new@pi
        \let\jmath\new@jmath
        \let\amalg\new@amalg
        \let\coprod\new@coprod
      }
  },
  doc / newtx    .code:n       = {
    \RequirePackage{newtxtext}
    \RequirePackage{newtxmath}
  },
  doc / lmm       .code:n      = {
    \sys_if_engine_pdftex:TF 
      { 
        \RequirePackage{lmodern}
        \RequirePackage{fixcmex} 
      }{ 
        \ztex_msg_set:nn {lmm-font-pdftex}
          {The~default~font~for~XeTeX/LuaTeX~is~latin~modern,~there~is~no~need~to~load~lmodern.}
        \ztex_msg_warn:n {lmm-font-pdftex} 
      }
  },
  text            .choice:,
  text / times    .code:n      = { \RequirePackage{newtxtext} },
  math            .choice:,
  math / newtx    .code:n       = { 
    \ztex_hook_preamble_last:n { \RequirePackage{newtxmath} } 
  },
  math / mtpro2   .code:n       = { 
    \ztex_hook_preamble_last:n { 
      \RequirePackage[lite, subscriptcorrection, slantedGreek, nofontinfo]{mtpro2} 
    } 
  },
  math / euler    .code:n       = { 
    \ztex_hook_preamble_last:n { \RequirePackage[OT1, euler-digits]{eulervm} } 
  },
  math / var-euler .code:n       = {
    \usepackage[OT1]{eulervm}
    \DeclareSymbolFont{cmmlargesymbols}{OMX}{cmex}{m}{n}
    \DeclareSymbolFont{greekletters}{OML}{cmm}{m}{it}
    \DeclareMathDelimiter{\new@int}{\mathop}{cmmlargesymbols}{"52}{cmmlargesymbols}{"5A}
    \DeclareMathDelimiter{\new@sum}{\mathop}{cmmlargesymbols}{"50}{cmmlargesymbols}{"58}
    \AddToHook{begindocument}
      {
        \renewcommand{\int}{\new@int\nolimits}
        \DeclareMathSymbol{\kappa}{\mathord}{greekletters}{"14}  
        \DeclareMathSymbol{\tau}{\mathord}{greekletters}{"1C}
        \DeclareMathSymbol{\omega}{\mathord}{greekletters}{"21}
      }
  },
  math / ptmx     .code:n       = { 
    \ztex_msg_set:nn {option-font-math}
      {To~use~ptmx~math~font,use~the~'doc=ptmx'~setting~instead.}
    \ztex_msg_warn:n {option-font-math}
  },
  math / mathpazo .code:n       = { 
    \let\rmbefore\rmdefault
    \ztex_hook_preamble_last:n { \RequirePackage{mathpazo} } 
    \let\rmdefault\rmbefore
  },
  math / unknown  .code:n       = { 
    \ztex_metakey_msg_warning:nn {option-mathSpec-font}{newtx, mtpro2, euler, mathpazo} 
  },
  unknown         .code:n      = { 
    \ztex_metakey_msg_warning:nn {option-font}
      {
        sysfont(<bool>:false), 
        doc(<choice>:newtx,ptmx), 
        text(<choice>:times), 
        math(<choice>:newtx,mtpro2,euler,mathpazo)
      }
  }
}
\ztex_keys_define:nn { layout }{
  margin          .bool_gset:N  = \g__ztex_margin_bool,
  margin          .initial:n    = { false },
  slide           .bool_gset:N  = \g__ztex_slide_bool,
  slide           .initial:n    = { false },
  aspect          .tl_gset:N    = \g__ztex_aspectratio_tl,
  aspect          .initial:n    = { 12|9 },
  theme           .str_gset:N   = \g__ztex_slide_theme_str,
  theme           .initial:n    = { AnnArborDefault },
  unknown         .code:n       = { 
    \ztex_metakey_msg_warning:nn {option-layout}
      {margin(<bool>:false), slide, aspect} 
  }
}
\ztex_keys_define:nn { mathSpec }{
  alias           .bool_gset:N  = \g__ztex_math_alias_bool,
  alias           .initial:n    = { false },
  envStyle        .tl_gset:N    = \g__ztex_thm_style_tl,
  envStyle        .initial:n    = { plain },
  font            .choice:,
  font / newtx    .meta:nn      = { ztex / font / math }{#1},
  font / mtpro2   .meta:nn      = { ztex / font / math }{#1},
  font / euler    .meta:nn      = { ztex / font / math }{#1},
  font / mathpazo .meta:nn      = { ztex / font / math }{#1},
  unknown         .code:n       = { 
    \ztex_metakey_msg_warning:nn {option-mathSpec}
      {alias(<bool>:false), envStyle, font(<choice>:newtx,mtpro2,euler,mathpazo)} 
  }
}
\ztex_keys_define:nn { bib_index }{
  load                .bool_gset:N  = \g__ztex_bib_index_load_bool,
  source              .str_gset:N   = \g__ztex_bib_source_str,
  source              .initial:n    = { ref.bib },
  backend             .str_gset:N   = \g__ztex_bib_backend_str,
  backend             .initial:n    = { biber },
  unknown             .code:n       = { 
    \ztex_metakey_msg_warning:nn {option-bib_index}
      {load(<bool>:false), source, backend} 
  } 
}

% option setup
\ProcessKeyOptions [ ztex ]
\NewDocumentCommand{\ztexset}{m}{ \keys_set:nn {ztex}{#1} }
\newcommand{\ztexoption}
  {
    \textbf{Class~Options:}~
    \str_use:N \g__ztex_lang_str {~-~}
    \clist_use:Nn \g__ztex_subclass_option_clist{~-~}\par
  }



% ----------------------------------------------------------------------
%                          subClass and package Option 
% ----------------------------------------------------------------------
% pass clist options main subclass: 'article', 'book', 'ctexbook'
\ztex_msg_set:nn {option-subclass}{
  subclass~option:"\g__ztex_subclass_type_str"~is~not~
  accessible,~Valid~options~are:article,~book,~ctexbook,~l3doc~and~l3dox.
}
\str_case:VnF \g__ztex_subclass_type_str {
  {article}{
    \PassOptionsToClass{\g__ztex_subclass_option_clist}{ article }
    \LoadClass{article}
  }
  {book}{
    \PassOptionsToClass{\g__ztex_subclass_option_clist}{ book }
    \LoadClass{book}   
  }
  {ctexbook}{
    \str_set:Nn \g__ztex_lang_str {cn}
    \PassOptionsToClass{\g__ztex_subclass_option_clist}{ ctexbook }
    \PassOptionsToPackage{quiet}{fontspec}
    \LoadClass{ctexbook}    
  }
  {l3doc}{
    \PassOptionsToClass{\g__ztex_subclass_option_clist}{ l3doc }
    \LoadClass{l3doc} 
  }
}{\ztex_msg_error:n {option-subclass}}

% baisc document class and packages option
\tl_set_rescan:NnV \l_tmpa_tl {\cctab_select:N \c_code_cctab} \g__ztex_lang_str
\clist_if_in:NVF \c__ztex_lang_support_clist \l_tmpa_tl
  {\ztex_msg_error:n {option-language}}
\str_case:VnF \g__ztex_lang_str {
  {en} { 
    \sys_if_engine_xetex:T 
      {
        \ztex_hook_preamble_last:n {
          \bool_if:NF \g__ztex_sysfont_cfg_bool {
            \ztex_msg_set:nn {compile-engine-pdftex}
              {Current~compile~engine~is~XETEX,~For~better~output,~use~PDFTEX~instead.}
            \ztex_msg_warn:n {compile-engine-pdftex}
          }
        }
      }
    \RequirePackage[T1]{fontenc}
  }
  {cn} {
    \sys_if_engine_pdftex:T {
      \ztex_msg_set:nn {compile-engine-xetex}
        {Current~compile~engine~is~PDFTEX,~For~chinese~material,~use~XETEX~instead.}
      \ztex_msg_error:n {compile-engine-xetex}
    }
    \PassOptionsToPackage{quiet}{fontspec}
    \PassOptionsToPackage{no-math}{fontspec}
    \str_if_eq:VnF \g__ztex_subclass_type_str {ctexbook}{
      \RequirePackage[UTF8, scheme=plain]{ctex}
      \linespread{1.3}
    }
  }
}{\ztex_msg_error:n {option-language}}   



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
\bool_new:N \g__ztex_theme_lib_load_bool
\bool_gset_false:N \g__ztex_theme_lib_load_bool
\newcommand\ztethmlibTF[2]
  {
    \bool_if:NTF \g__ztex_theme_lib_load_bool 
      { #1 }{ #2 }
  }



% ----------------------------------------------------------------------
%                          ztex logo
% ----------------------------------------------------------------------
% 4.30554pt = 1ex.
\NewDocumentCommand\zTeX{s}
  {
    \IfBooleanTF{#1}
      {
        \__ztool_leave_vmode:
        \raise0.0894ex\hbox{z}
        \kern-0.4645ex\hbox{\TeX}
      }{
        \ztool_scale_to_wd_and_ht:nnn {.9ex}{1.3ex}{
          \ztool_rotate:nn {89}{\(\aleph\)}
        }\kern-0.3423ex\hbox{\TeX}
      }
  }
\let\ztex\zTeX 
\let\zLaTeX\zTeX
\let\zlatex\zTeX
\protected\def\HoLogo@zTeX#1{\zTeX}
\protected\def\HoLogo@ztex#1{\zTeX}
\protected\def\HoLogo@zLaTeX#1{\zTeX}
\protected\def\HoLogo@zlatex#1{\zTeX}