\ --------- Terminal UI ---------- \
\ (c) 2024 Zora "Glyphli" Harrison \

\ Cursor \
0 variable tui.curX tui.curX !
0 variable tui.curY tui.curY !
: tui.set-x ( u -- ) tui.curX ! ;
: tui.set-y ( u -- ) tui.curY ! ;
: tui.get-x ( -- u ) tui.curX @ ;
: tui.get-y ( -- u ) tui.curY @ ;
: tui.set-xy ( u u -- ) 2dup tui.set-y tui.set-x ;
: tui.get-xy ( -- u u ) tui.get-x tui.get-y ;
: tui.mov-xy ( -- ) tui.get-xy at-xy ;
: tui.x++ 1 tui.curX +! ; : tui.x-- -1 tui.curX +! ;
: tui.y++ 1 tui.curY +! ; : tui.y-- -1 tui.curY +! ;

\ Write \
: tui.cr ( -- ) cr 0 tui.set-x tui.y++ ;
: tui.emit ( c -- ) emit tui.x++ ;
: tui.xemit ( c -- ) xemit tui.x++ ;

\ Clear \
: tui.page ( -- ) 0 0 tui.set-xy page ;
: tui.row ( -- ) tui.get-x form swap drop 0 ?do bl emit loop 0 tui.set-x  ;
: tui.column ( -- ) tui.get-y form swap drop 0 ?do i tui.set-y tui.mov-xy bl emit loop tui.set-y ;
