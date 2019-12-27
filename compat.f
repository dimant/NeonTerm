: CMOVE ( c-addr1 c-addr2 n -- )
    0 ?DO
        OVER @ OVER !
    LOOP
    DROP DROP ;

: MOD ( a b -- m ) 0 SWAP UM/MOD ; ( 16bit mod operation )

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
    DUP 255 AND BYTE-HEX-EMIT SPACE
    65280 AND 8 U>> BYTE-HEX-EMIT ;

: NDUMP ( addr n -- )
    OVER CELL-HEX-EMIT ." : "
    DUP 0 ?DO OVER I + C@ BYTE-HEX-EMIT SPACE LOOP ." | "
    DUP 0 ?DO OVER I + C@ PRINT-EMIT SPACE LOOP
    DROP DROP ;

: DUMP ( addr n -- )
    16 MOD
    CR
    DUP 0  ?DO PLUCK I 16 * + 16 NDUMP CR LOOP 
    PLUCK OVER 16 * + PLUCK NDUMP ;


\ : FS 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 ;
\ SP@ 1 + DEPTH 1 - CELLS DUMP
