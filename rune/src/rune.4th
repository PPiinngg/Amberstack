\ ---- Rune: Extensible shell ---- \
\ (c) 2024 Zora "Glyphli" Harrison \

\ Terminal \
( State )
variable curX
variable curY
( Words )
: /n ( -- ) cr 0 curX ! 1 curY +! ;
: clearterm ( -- ) page 0 curX ! 0 curY ! ;
: emit-xy ( c -- ) curX @ curY @ 2dup at-xy rot xemit at-xy ;
: cur-mov ( xn yn -- ) curY +! curX +! curX @ curY @ at-xy ;
: cur-l -1  0 cur-mov ; : cur-u  0 -1 cur-mov ;
: cur-r  1  0 cur-mov ; : cur-d  0  1 cur-mov ;

\ REPL \
( State )
create cmdBuf 2048 cells allot
variable cmdLen
( Words )
: cmd-push-char ( c -- ) cmdBuf cmdlen @ + ! 1 cmdLen +! ;
: cmd-pop-char ( -- ) -1 cmdLen +! 0 cmdBuf cmdLen @ + ! ;
: prompt ( -- ) 5870 ( ᛮ ) emit-xy cur-r 32 emit-xy cur-r ; 2 constant promptLen
: readline ( -- )
    begin xkey dup case
        13  of drop /n -1 endof
        127 of drop cmdLen @ 0 <> if cmd-pop-char cur-l 32 emit-xy then 0 endof
        cmd-push-char emit-xy cur-r 0
    0 endcase until ;
: printbuf ( DO THIS NEXT !!!!!!!!!! ) ;
: clearbuf ( -- ) cmdLen @ 0 ?do cmd-pop-char loop ;

\ Entrypoint \
: reload s" rune.4th" included clearterm clearbuf clearstacks ;
: rune reload begin prompt readline printbuf clearbuf again ;
