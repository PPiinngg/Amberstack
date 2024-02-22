\ -------- Rune: Toolbox --------- \
\ (c) 2024 Zora "Glyphli" Harrison \
s" ../kaolin/kaolin.fs" included

\ Config \
s" ᛮ "  ( Prompt )              constant promptLen constant promptPtr
2048    ( Cmd buffer length )   create cmd cmd swap StrBuf.allot

\ REPL \
: prompt ( -- ) promptPtr promptLen dup 0 ?do over xc@+ nip tui-xemit +x/string loop ;

\ : readline ( -- )
\     begin xkey dup case
\         13  of drop /n -1 endof
\         127 of drop cmdLen @ 0 <> if cmd-pop-char cur-l bl emit-xy then 0 endof
\         dup cmd  emit-xy cur-r 0
\     0 endcase until ;

\ Entrypoint \
: reload s" rune.fs" included tui-page cmd StrBuf-zero clearstacks ;
\ : rune reload begin prompt readline printbuf clearbuf again ;
