\ -------- Rune: Toolbox --------- \
\ (c) 2024 Zora "Glyphli" Harrison \
s" ../kaolin/kaolin.fs" included
s" config.fs" included

\ REPL \
: prompt ( -- ) promptPtr promptLen dup 0 ?do over xc@+ nip tui.xemit +x/string loop ;

: readline ( -- )
    begin xkey dup case
        13  of drop tui.cr -1 endof
        127 of drop cmd 1 cells + @ 0 <> 
            if cmd StrBuf.pop tui.x-- tui.mov-xy space tui.mov-xy
            then 0
        endof
        dup cmd StrBuf.push tui.xemit 0
    0 endcase until ;

\ Entrypoint \
: reload s" rune.fs" included tui.page clearstacks ;
: rune reload begin cmd StrBuf.zero prompt readline tui.cr cmd StrBuf.print tui.cr again ;
