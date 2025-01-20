% ----------------------------------------------------------------------
%                        zlatex class metadata
% ----------------------------------------------------------------------
\ExplSyntaxOn
\NeedsTeXFormat{LaTeX2e}
\clist_const:Nn \c__zlatex_lang_support_clist    {en, cn}
\tl_const:Nn \c__zlatex_class_name_tl            {zlatex}
\tl_const:Nn \c__zlatex_class_version_tl         {1.0.0}
\tl_const:Nn \c__zlatex_class_date_tl            {2024/12/17}
\tl_const:Nn \c__zlatex_class_description_tl     {A~pre-release~latex3~document~class~for~article,~book,~or~slides;
                                                  Support~languages:\clist_use:Nn \c__zlatex_lang_support_clist{,~}}

\ProvidesExplClass{\c__zlatex_class_name_tl}         % Class name
                  {\c__zlatex_class_date_tl}         % Class Date updated
                  {\c__zlatex_class_version_tl}      % Class Version latest
                  {\c__zlatex_class_description_tl}  % Class Description



% ----------------------------------------------------------------------
%                         class module and library 
% ----------------------------------------------------------------------
\clist_new:N \g__zlatex_module_library_loaded_clist
\clist_gclear:N \g__zlatex_module_library_loaded_clist
\cs_new_nopar:Npn \__zlatex_load_module_library:nn #1#2 {
  \clist_map_inline:nn {#2} {
    \clist_if_in:NnTF \g__zlatex_module_library_loaded_clist {#1:##1} {
      \msg_set:nnn {zlatex} {#1-loaded} {zlatex~#1~"##1"~already~loaded,ignored~loading~\msg_line_context:}
      \msg_warning:nnn {zlatex} {#1-loaded} {##1}
    }{
      \file_if_exist:nTF {#1/zlatex.#1.##1.tex}{
        \clist_gput_right:Nn \g__zlatex_module_library_loaded_clist {#1:##1}
        \makeatletter\file_input:n {#1/zlatex.#1.##1.tex}
      }{
        \msg_set:nnn {zlatex} {#1-not-found} {zlatex~#1~`##1'~not~found.}
        \msg_error:nnn {zlatex} {#1-not-found} {##1}
      }
    }
  }
}
\NewDocumentCommand\zlatexloadmodule{m}{
  \__zlatex_load_module_library:nn {module}{#1}\ExplSyntaxOff
}
\NewDocumentCommand\zlatexloadlibrary{m}{
  \__zlatex_load_module_library:nn {library}{#1}\ExplSyntaxOff
}



% ----------------------------------------------------------------------
%                             class tools
% ----------------------------------------------------------------------
\RequirePackage{ztool}
% zlatex hook interface
\cs_new_protected:Npn \zlatex_hook_preamble_last:n #1
  { \AddToHook{env/document/before}{#1} }
\cs_new_protected:Npn \zlatex_label_hook_preamble_last:nn #1#2
  { \AddToHook{env/document/before}[#1]{#2} }
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
\cs_new:Npn \__zlatex_plus_key_aux:nnn #1#2#3
  {% #1:var; #2:p-key; #3:s-key
    #2 / #3     .tl_set:N = \exp_not:c { #1 } ,
    #2 / #3 +   .code:n   = { \tl_put_right:Nn \exp_not:c { #1 } { ##1 } } ,
    #2 / #3 ~ + .code:n   = { \tl_put_right:Nn \exp_not:c { #1 } { ##1 } }
  }



% ----------------------------------------------------------------------
%                   zlatex Message system
% ----------------------------------------------------------------------                 
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
% meta key warning message
\cs_new_protected:Npn \zlatex_metakey_msg_warning:nn #1#2 {
  \zlatex_msg_set:nn {#1}
    {You~use~an~invalid~key~"\l_keys_path_str"~or~key~assign~for~it~in~the~meta~
    key~"#1",~Valid~options~are:#2;~Assignment~Ignored~and~zLaTeX~default~"#1"~
    settings~of~this~key~substitute.}
  \zlatex_msg_warn:n {#1}
}

% zlatex class options message
\zlatex_msg_set:nn {option-unknown}{
  You~use~an~unknown~class~option~key:'\l_keys_path_str'.~Valid~options~are:lang,~
  hyper,~fancy,~class,~classOption(<clist>),~toc(<key-value>),~font(<key-value>),~
  layout(<key-value>),~section(<key-value>),~mathSpec(<key-value>),~bib_index(<key-value>).~
  Assignment~Ignored~and~LaTeX~default~settings~substitute.
}
\zlatex_msg_set:nn {option-language} {
  Current~invalid~language~option~is:~'\g__zlatex_lang_str',~zlatex~only~
  support~'en(english)',~and~'cn(chinese)'~till~now.
}



% ----------------------------------------------------------------------
%                             class option 
% ----------------------------------------------------------------------
% package options passing
\cs_new:Npn \zlatex_package_options_pass:nn #1#2 {
  \PassOptionsToPackage{#2}{#1}
}
\cs_new:Npn \zlatex_package_options_pass_deprecate:n #1 {
  \zlatex_msg_set:nn {package-option}{
    No~options~were~passed~to~package:#1,~Deprecated~this~option(s)~for~package~#1.
  }
  \zlatex_msg_warn:n {package-option}
}
% setup class options
\zlatex_option_keys_define:n {  
  % basic options
  lang            .str_gset:N   = \g__zlatex_lang_str,
  lang            .initial:n    = { en },
  hyper           .bool_gset:N  = \g__zlatex_hyperref_bool,
  hyper           .initial:n    = { false },
  fancy           .bool_gset:N  = \g__zlatex_fancy_bool,
  fancy           .initial:n    = { false },
  % sub class and options
  class           .str_gset:N   = \g__zlatex_subclass_type_str,
  class           .initial:n    = { article },
  classOption     .clist_gset:N = \g__zlatex_subclass_option_clist,
  classOption     .initial:n    = { oneside, 12pt },
  packageOption   .code:n       = { 
    \keyval_parse:NNn 
      \zlatex_package_options_pass_deprecate:n 
      \zlatex_package_options_pass:nn {#1} 
  },
  % zlatex options meta key 
  toc             .meta:nn      = { zlatex / option / toc }{#1},
  font            .meta:nn      = { zlatex / option / font }{#1},
  layout          .meta:nn      = { zlatex / option / layout }{#1},
  section         .meta:nn      = { zlatex / option / section }{#1},
  mathSpec        .meta:nn      = { zlatex / option / mathSpec }{#1},
  bib_index       .meta:nn      = { zlatex / option / bib_index }{#1},
  unknown         .code:n       = { 
    \zlatex_msg_warn:n {option-unknown} 
  }
}

% sub-key for each meta option
\zlatex_keys_define:nn { option / toc }{
  column          .int_gset:N   = \g__zlatex_toc_column_int,
  column          .initial:n    = { 1 },
  title           .code:n       = { 
    \@ifpackageloaded{babel}{
      \AddToHook{package/babel/after}{
        \zlatex_hook_doc_begin:n {\renewcommand{\contentsname}{#1}}
      }
    }{
      \zlatex_hook_doc_begin:n {\renewcommand{\contentsname}{#1}}
    }
  },
  title-vspace    .dim_gset:N   = \g__zlatex_toc_title_vspace_dim,
  title-vspace    .initial:n    = { -2em },
  stretch         .fp_gset:N    = \g__zlatex_toc_stretch_fp,
  stretch         .initial:n    = { 1 },
  unknown         .code:n       = { 
    \zlatex_metakey_msg_warning:nn {option-toc}
      {column(<int>:1), title(<tl>:contentname), title-vspace(<dim>:-2em)} 
  }
}
\zlatex_keys_define:nn { option / font }{
  config          .bool_gset:N  = \g__zlatex_font_config_bool,
  config          .initial:n    = { false }, 
  unknown         .code:n       = { 
    \zlatex_metakey_msg_warning:nn {option-font}
      {config(<bool>:false)} 
  }
}
\zlatex_keys_define:nn { option / layout }{
  margin          .bool_gset:N  = \g__zlatex_margin_bool,
  margin          .initial:n    = { false },
  slide           .bool_gset:N  = \g__zlatex_slide_bool,
  slide           .initial:n    = { false },
  aspect          .tl_gset:N    = \g__zlatex_aspectratio_tl,
  aspect          .initial:n    = { 12|9 },
  theme           .str_gset:N   = \g__zlatex_slide_theme_str,
  theme           .initial:n    = { AnnArborDefault },
  unknown         .code:n       = { 
    \zlatex_metakey_msg_warning:nn {option-layout}
      {margin(<bool>:false), slide, aspect} 
  }
}
\zlatex_keys_define:nn { option / mathSpec }{
  alias           .bool_gset:N  = \g__zlatex_math_alias_bool,
  alias           .initial:n    = { false },
  envStyle        .tl_gset:N    = \g__zlatex_thm_style_tl,
  envStyle        .initial:n    = { plain },
  font            .choice:,
  font / newtx    .code:n       = { 
    \zlatex_hook_preamble_last:n { \RequirePackage{newtxmath} } 
  },
  font / mtpro2   .code:n       = { 
    \zlatex_hook_preamble_last:n { 
      \RequirePackage[lite, subscriptcorrection, slantedGreek, nofontinfo]{mtpro2} 
    } 
  },
  font / euler    .code:n       = { 
    \zlatex_hook_preamble_last:n { \RequirePackage[OT1, euler-digits]{eulervm} } 
  },
  font / mathpazo .code:n       = { 
    \let\rmbefore\rmdefault
    \zlatex_hook_preamble_last:n { \RequirePackage{mathpazo} } 
    \let\rmdefault\rmbefore
  },
  font / unknown  .code:n       = { 
    \zlatex_metakey_msg_warning:nn {option-mathSpec-font}{newtx, mtpro2, euler, mathpazo} 
  },
  unknown         .code:n       = { 
    \zlatex_metakey_msg_warning:nn {option-mathSpec}
      {alias(<bool>:false), envStyle, font(<choice>:newtx,mtpro2,euler,mathpazo)} 
  }
}
\zlatex_keys_define:nn { option / bib_index }{
  load                .bool_gset:N  = \g__zlatex_bib_index_load_bool,
  source              .str_gset:N   = \g__zlatex_bib_source_str,
  source              .initial:n    = { ref.bib },
  backend             .str_gset:N   = \g__zlatex_bib_backend_str,
  backend             .initial:n    = { biber },
  unknown             .code:n       = { 
    \zlatex_metakey_msg_warning:nn {option-bib_index}
      {load(<bool>:false), source, backend} 
  } 
}

% option setup
\ProcessKeyOptions [ zlatex / option ]
\NewDocumentCommand{\zlatexSetup}{m}{ \zlatex_keys_set:nn {option}{#1} }



% ----------------------------------------------------------------------
%                          subClass and package Option 
% ----------------------------------------------------------------------
% pass clist options main subclass: 'article', 'book', 'ctexbook'
\zlatex_msg_set:nn {option-subclass}{
  subclass~option:"\g__zlatex_subclass_type_str"~is~not~
  accessible,~Valid~options~are:article,~book,~l3doc~and~ctexbook.
}
\str_case:VnF \g__zlatex_subclass_type_str {
  {article}{
    \PassOptionsToClass{\g__zlatex_subclass_option_clist}{ article }
    \LoadClass{article}
  }
  {book}{
    \PassOptionsToClass{\g__zlatex_subclass_option_clist}{ book }
    \LoadClass{book}   
  }
  {ctexbook}{
    \str_set:Nn \g__zlatex_lang_str {cn}
    \PassOptionsToClass{\g__zlatex_subclass_option_clist}{ ctexbook }
    \PassOptionsToPackage{quiet}{fontspec}
    \LoadClass{ctexbook}    
  }
  {l3doc}{
    \PassOptionsToClass{\g__zlatex_subclass_option_clist}{ l3doc }
    \LoadClass{l3doc} 
  }
}{\zlatex_msg_error:n {option-subclass}}

% baisc document class and packages option
\tl_set_rescan:NnV \l_tmpa_tl {\cctab_select:N \c_code_cctab}{\g__zlatex_lang_str}
\clist_if_in:NVF \c__zlatex_lang_support_clist {\l_tmpa_tl}
  {\zlatex_msg_error:n {option-language}}
\str_case:VnF \g__zlatex_lang_str {
  {en} { 
    \sys_if_engine_xetex:TF {
      \zlatex_hook_preamble_last:n {
        \bool_if:NF \g__zlatex_font_config_bool {
          \zlatex_msg_set:nn {compile-engine-pdftex}
            {Current~compile~engine~is~XETEX,~For~better~output,~use~PDFTEX~instead.}
          \zlatex_msg_warn:n {compile-engine-pdftex}
        }
      }
    }{\RequirePackage[utf8]{inputenc}}
    \RequirePackage[T1]{fontenc}
    \RequirePackage[english]{babel}
    \zlatex_hook_preamble_last:n {
      \RequirePackage{csquotes}
      \RequirePackage{microtype}
    }
  }
  {cn} {
    \sys_if_engine_pdftex:T {
      \zlatex_msg_set:nn {compile-engine-xetex}
        {Current~compile~engine~is~PDFTEX,~For~chinese~material,~use~XETEX~instead.}
      \zlatex_msg_error:n {compile-engine-xetex}
    }
    \PassOptionsToPackage{quiet}{fontspec}
    \PassOptionsToPackage{no-math}{fontspec}
    \str_if_eq:VnF \g__zlatex_subclass_type_str {ctexbook}{
      \RequirePackage[UTF8, heading]{ctex}
      \linespread{1.3}
    }
  }
}{\zlatex_msg_error:n {option-language}}   



% ----------------------------------------------------------------------
%                             basic packages
% ----------------------------------------------------------------------
\RequirePackage{xcolor}
\RequirePackage{framed}
\RequirePackage{amsfonts, amsmath}          
\RequirePackage{esint} 
\counterwithin{equation}{section}



% ----------------------------------------------------------------------
%                              font  config
% ----------------------------------------------------------------------
\__zlatex_load_module_library:nn {module}{fontcfg}



% ----------------------------------------------------------------------
%                               layout
% ----------------------------------------------------------------------
\__zlatex_load_module_library:nn {module}{layout}



% ----------------------------------------------------------------------
%                               slide mode
% ----------------------------------------------------------------------
\bool_if:NTF \g__zlatex_slide_bool {
  \__zlatex_load_module_library:nn {library}{slide}
}{\newcommand\zslideSetup[1]{}}



% ----------------------------------------------------------------------
%                              page info
% ----------------------------------------------------------------------
\__zlatex_load_module_library:nn {module}{pageinfo}



% ----------------------------------------------------------------------
%                        ref and hyperref
% ----------------------------------------------------------------------
\__zlatex_load_module_library:nn {module}{indexref}
\__zlatex_load_module_library:nn {module}{theme}



% ----------------------------------------------------------------------
%                           Math Environments 
% ----------------------------------------------------------------------
\__zlatex_load_module_library:nn {module}{thm}
\bool_if:NT \g__zlatex_math_alias_bool {
  \__zlatex_load_module_library:nn {library}{mathalias}
}



% ----------------------------------------------------------------------
%                              toc setup
% ----------------------------------------------------------------------
\__zlatex_load_module_library:nn {module}{toc}



% ----------------------------------------------------------------------
%                            sec format
% ----------------------------------------------------------------------
\bool_if:NTF \g__zlatex_fancy_bool {
  \__zlatex_load_module_library:nn {library}{fancy}
}{
  \__zlatex_load_module_library:nn {module}{titlesec}
}



% ----------------------------------------------------------------------
%                          bool check user interface
% ----------------------------------------------------------------------
\newcommand\zlatexHyperTF[2]{
  \bool_if:NTF \g__zlatex_hyperref_bool {#1}{#2}
}
\newcommand\zlatexFancyTF[2]{
  \bool_if:NTF \g__zlatex_fancy_bool {#1}{#2}
}
\newcommand\zlatexMarginTF[2]{
  \bool_if:NTF \g__zlatex_margin_bool {#1}{#2}
}
\newcommand\zlatexSlideTF[2]{
  \bool_if:NTF \g__zlatex_slide_bool {#1}{#2}
}
\newcommand\zlatexFontConfigTF[2]{
  \bool_if:NTF \g__zlatex_font_config_bool {#1}{#2}
}
\newcommand\zlatexMathAliasTF[2]{
  \bool_if:NTF \g__zlatex_math_alias_bool {#1}{#2}
}
\newcommand\zlatexBibIndexLoadTF[2]{
  \bool_if:NTF \g__zlatex_bib_index_load_bool {#1}{#2}
}



% ----------------------------------------------------------------------
%                           extra commands
% ----------------------------------------------------------------------
% Graphics 
\RequirePackage{graphicx}
\RequirePackage{sidenotes}
\graphicspath{
  {./figure/}{./figures/}{./image/}{./images/}
  {./Pictures/}{./picture/}{./Pics/}{./pics/}
  {./graphics/}{./graphic/}
}
% Iteration item 
\renewcommand{\labelitemii}{\(\circ\)}
\renewcommand{\labelitemiii}{\(\diamond\)}
% reset counter command
\NewDocumentCommand{\zlatexCounterWith}{mm}{\@addtoreset{#1}{#2}}
% zlatex class options debug
\newcommand{\zlatexOptions}{
  \textbf{Class~Options:}~
  \str_use:N \g__zlatex_lang_str {~-~}
  \clist_use:Nn \g__zlatex_subclass_option_clist{~-~}
  \par
}
% verbatim command like '\verb'
\NewDocumentCommand\zlatexVerb{O{\texttt}v}{#1{#2}}
% framed env for user interface
\cs_new_protected:Npn \zlatexFramed:nn #1#2 {
  \DeclareDocumentEnvironment{#1}{O{#2}}{
    \def\FrameCommand{{\color{##1}\vrule width 3pt}\colorbox{##1!10}}
    \MakeFramed{\advance\hsize-\width\FrameRestore}\noindent   
  }{\endMakeFramed}
}
\NewDocumentCommand\zlatexFramed{O{black}m}{
  \zlatexFramed:nn {#2}{#1}
}
\NewDocumentCommand\zLaTeX{}{z\LaTeX{}}
% constant
\dim_new:N \c_zlatex_quad_dim 
\ztool_gget_wd:Nn \c_zlatex_quad_dim {\quad}