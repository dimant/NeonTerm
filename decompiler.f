HEX

: MEMCMP ( addr1 addr2 n -- r )
    0 ?DO
        OVER I + C@ OVER I + C@ <> IF
            DROP DROP FALSE UNLOOP EXIT
        THEN
    LOOP 
    DROP DROP TRUE ;

: ?WORD ( addr -- b )
    @ DUP >NAME FIND = ;

: JSR 20 ;
: NUL 0 ;
: '(enter) ] ' (enter) [ LITERAL ;
: '(dovar) ] ' (dovar) [ LITERAL ;
: '(lit) ] ' (lit) [ LITERAL ;
: 'EXIT ] ' EXIT [ LITERAL ;
: '(?branch) ] ' (?branch) [ LITERAL ;
: '(branch) ] ' (branch) [ LITERAL ;
: '(.") ] ' (.") [ LITERAL ;

CREATE PAT-ENTER 3 , JSR ,C '(enter) , DOES> @ ;
CREATE PAT-EXIT 3 , 'EXIT , NUL ,C DOES> @ ;
CREATE PAT-NUM 2 , '(lit) , DOES> @ ;

: ?CONSUME ( addr pat-addr - r ; returns consumed bytes if pat matches, 0 otherwise )
    DUP @ -ROT
    DUP @
    SWAP CELL + SWAP
    MEMCMP IF
        ( return offset )
    ELSE
        DROP 0
    THEN ;

: CONSUME-WORD ( addr -- n )
    DUP ?WORD IF @ >NAME TYPE SPACE CELL ELSE DROP 0 THEN ;

: CONSUME-NUM ( addr -- n )
    DUP PAT-NUM ?CONSUME ?DUP IF + @ . 2 CELLS ELSE DROP 0 THEN ;

: CONSUME-ENTER
    PAT-ENTER ?CONSUME ?DUP IF 3A EMIT SPACE ELSE 0 THEN ;

: CONSUME-END ( addr -- n )
    PAT-EXIT ?CONSUME ?DUP IF 3B EMIT ELSE 0 THEN ;

: CONSUME-BRANCH ( addr -- n )
    @ DUP '(?branch) = OVER '(branch) = OR IF 
        >NAME TYPE SPACE 2 CELLS ELSE 
        DROP 0
    THEN ;

: CONSUME-STRING ( addr - n )
    DUP @ '(.") = IF
        CELL + DUP 
        2E EMIT 22 EMIT SPACE TYPE 22 EMIT SPACE
        STRLEN 1+ CELL +
    ELSE
        DROP 0
    THEN ;

: SEE ( addr -- )
    DUP CONSUME-ENTER ?DUP IF
    +
        BEGIN
            DUP CONSUME-END IF DROP EXIT ELSE
            DUP CONSUME-NUM ?DUP IF + ELSE
            DUP CONSUME-BRANCH ?DUP IF + ELSE
            DUP CONSUME-STRING ?DUP IF + ELSE
            DUP CONSUME-WORD ?DUP IF + ELSE
                ." Unknown token at: " 8 DUMP DROP EXIT
            THEN THEN THEN THEN THEN
        AGAIN
    THEN ;

: FOO 1 IF 32 ELSE 55 THEN ;

: FOO ." hello" 1 2 3 ;
