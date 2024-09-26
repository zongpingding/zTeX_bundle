# TODO LIST

- [x] Redesign message system that in a mess:
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


- [x] set background color and main text color in zlatex slide mode.
- [x] create a slide theme creating interface, like `zslideThemeCreate` 
- [ ] consider add a slide theme like `metropolis` in beamer, not only the color, but also the page layout and section style. (a status bar interface may need to add ?)
- [ ] more style for cover page
- [ ] sec-item collection interface, after item collection as well.
- [ ] consider to remove `indextools` or add a hook for `\indexsetup{}` ? Or add a hook `\zlatex_hook_preamble_first:n` to load `indextools`?
- [x] Handle warning about `csquote` with `babel` and `minted`.
- [x] Set default `hyperref` and `biblatex` a group, Don't loading them by default
- [x] remove `fancyhdr` dependency in slide mode, use `\AddToHook{shipout/background}` instead
- [x] implement the `package-option` interface; Now this interface has been implemented, a example usage:
    ```latex
    \documentclass[
      lang=cn,
      packageOption={fontspec=quiet, ctex}
    ]{zlatex}
    ```
- [ ] fixed the bug of wrong `\thesubsection` counter with `shipout` in `slide` mode
- [x] a error whill be throw out if `\author` not given
- [x] ambiguious about `redef`-key in `toc`, considering change it to `toc={style={\latge\bfseries}}`
- [x] weired vspace in  `\partialToC`. Consider add a `\stopcontents` before the next chapter automatically (or set up this function for `section` counter). Add this function to doc. 
- [x] make layout spec more flexible, pre-defined some layouts in class ?
- [ ] learn the breakable-box mechanism, provide such an interface to declear such box
- [ ] when to use `\pagestyle{}` in `book/article` class
- [ ] improve `slide` mode:maybe by Hooking shipout process ?
- [x] fixed typo in document
- [ ] implement the `slide` mode part as a package 