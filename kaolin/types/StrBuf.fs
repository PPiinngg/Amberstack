\ --- Fixed size string buffer --- \
\ (c) 2024 Zora "Glyphli" Harrison \

\ ------------ LAYOUT ------------ \
\  1. Buffer size [cell]           \
\  2. String length [cell]         \
\  3, 4, ... Characters [4 bytes]  \
\ -------------------------------- \

4 constant utf8char ( UTF8 character )
0 invert utf8char 8 * rshift constant utf8charMask

: StrBuf.allot ( ptr u -- ptr ) utf8char * dup 2 cells + allot swap tuck ! dup 1 cells + 0 swap ! ;
: StrBuf.zero ( ptr -- )
    dup @ 1+ swap utf8char + swap 0
    ?do dup utf8char i * + 0 swap !
    loop drop ;

: StrBuf.push ( utf8char ptr -- )
    dup dup @ swap 1 cells + @ <=
    if 2drop
    else 1 cells + tuck dup @ utf8char * + 1 cells + ! 1 swap +!
    then ;
: StrBuf.pop ( ptr -- )
    1 cells + dup @ 0 =
    if 2drop
    else dup dup -1 swap +! 1 cells + swap @ utf8char * + 0 swap !
    then ;

: StrBuf.idx ( u ptr -- utf8char )
    2dup 1 cells + @ >=
    if 2drop 0
    else swap utf8char * + 2 cells + @ utf8charMask and
    then ;

: StrBuf.print ( ptr -- )
    dup dup @ swap 1 cells + @ min 0
    ?do dup i swap StrBuf.idx xemit
    loop drop ;
