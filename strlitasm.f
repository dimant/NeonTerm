HEX

HEADER PRINTX
    20 SEP              \ set acc to 8bit
    0 LDA-IMM
    INA
    4 CMP-IMM
    00 BNE
    20 REP              \ reset acc to 16bit
    PHA
    ASM-END
' PRINTX >NAME 20 DUMP

HEADER MODE
    3 LDA-IMM
    20 SEP              \ set acc to 8bit
    INA
    3 CMP-IMM8
    20 REP              \ reset acc to 16bit
    PHA
    ASM-END
MODE .

HEADER (X")
    INX                 \ point to top of R - 1
    0 LDA-ABSIX         \ load last return address into acc
    PHA                 \ ptr to beginning of str
    PHX                 \ store X so we can use the register
    TAX                 \ transfer ptr from acc to indX
    20 SEP              \ set acc to 8bit
    0 LDA-ABSIX         \ load a char into acc 8bit LOOP
    0 CMP-IMM8          \ if it is not zero
    INX                 \ advance pointer,
                        \ doing this before BNE ensures we skip \0
    F8 BNE              \ then go to LOOP
                        \ now indX holds a ptr to \0 + 1
    20 REP              \ reset acc to 16bit
    TXA                 \ save the ptr to acc
    PLX                 \ restore X
    0 STA-ABSIX         \ store ptr in acc to address in indX
    DEX                 \ point back to top of R
    ASM-END

HEX

HEADER (X")
    INX
    0 LDA-ABSIX
    INA
    INA
    INA
    INA
    0 STA-ABSIX
    DEX
    PHA
    ASM-END

: X" POSTPONE (X") 22 TIBSPLIT ,S ; IMMEDIATE

: FOO X" foo" ;

FOO .

' FOO >NAME 20 DUMP


    INX                 \ point to top of R - 1
    0 LDA-ABSIX         \ load last return address into acc
    DEX                 \ point back to top of R
    PHA                 \ ptr to beginning of str
    PHX                 \ store X so we can use the register
    TAX                 \ we will use X to iterate over the string
    20 SEP              \ set acc to 8bit
    0 LDA-ABSIX         \ 3 load address in X into acc LOOP
    INX                 \ 1 increment X to point past this char
    0 CMP-IMM8          \ 2 check for zero
    F9 BNE              \ -6 if not zero, go back to LOOP
    20 REP              \ reset acc to 16bit
    PLX                 \ restore X
    ASM-END

: X" (X") ;

\ : X" (X") , 22 TIBSPLIT ,S ; IMMEDIATE

: FOO X" ;

: BAR FOO ;
