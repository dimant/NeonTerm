: CMOVE ( c-addr1 c-addr2 n -- )
    0 ?DO
        OVER I + C@ OVER I + C!
    LOOP
    DROP DROP ;

: (S") R> DUP BEGIN DUP C@ ?DUP WHILE DROP 1+ REPEAT 1+ >R ;

: S" (lit) ] ' (S") , [ , 22 TIBSPLIT ,S ; IMMEDIATE
\ : FOO S" foo" TYPE ;

: CELL+ CELL + ;

: 2! SWAP OVER ! CELL+ ! ;

: 2@ DUP CELL+ @ SWAP @ ;

: MOD ( a b -- m ; 16bit mod operation )
    0 SWAP UM/MOD ;

DECIMAL

: 4BITHEX ( a -- c )
    DUP 9 > IF 10 - 65 + 
        ELSE 48 + 
        THEN ;

: PRINT-EMIT ( a -- )
    DUP 31 > OVER 127 < AND IF EMIT ELSE DROP 46 EMIT THEN ;

: BYTE-HEX-EMIT ( a -- )
    DUP 240 AND 4 U>> 4BITHEX EMIT 
    15 AND 4BITHEX EMIT ;

: CELL-HEX-EMIT ( a -- )
    DUP 65280 AND 8 U>> BYTE-HEX-EMIT
    255 AND BYTE-HEX-EMIT SPACE ;

: NDUMP ( addr n -- )
    OVER CELL-HEX-EMIT ." : "
    DUP 0 ?DO OVER I + C@ BYTE-HEX-EMIT SPACE LOOP ." | "
    DUP 0 ?DO OVER I + C@ PRINT-EMIT SPACE LOOP
    DROP DROP ;

8 CONSTANT DUMP-LINE-LEN

: DUMP ( addr n -- )
    DUMP-LINE-LEN MOD
    CR
    DUP 0  ?DO PLUCK I DUMP-LINE-LEN * + DUMP-LINE-LEN NDUMP CR LOOP 
    PLUCK OVER DUMP-LINE-LEN * + PLUCK NDUMP 
    DROP DROP DROP ;


\ : FS 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 ;
\ SP@ 1 + DEPTH 1 - CELLS DUMP
