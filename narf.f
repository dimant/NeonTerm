\ Result of HEADER:
\ 2A20 : 62 61 72 66 00 00 06 2A | b a r f . . . * 
\ 2A28 : 00 6E 61 72 66 00 00 28 | . n a r f . . ( 

\ name, terminated with 00 00
\ pointer to previous word terminated by 00

\ > ' + >NAME 20 DUMP 
\ 0895 : 2B 00 00 7C 08 68 18 63 | + . . | . h . c
\ 089D : 01 83 01 B9 00 00 C8 C8 | . . . . . . . .
\ 08A5 : 3A 48 60 00 4D 2B 00 00 | : H ` . M + . .

\ 68                            PLA     Pull Accumulator
\ 18                            CLC     Clear carry
\ 63 01                         ADC     Add with carry
\ 83 01                         STA     Store accumulator to memory
\ B9 00 00                      LDA     Load accumulator from memory
\ C8                            INY     Increment Index Register Y
\ C8                            INY     Increment Index Register Y
\ 3A                            DEC A   Decrement accumulator
\ 48                            PHA     Push Accumulator
\ 60                            RTS     Return from subroutine
\ 00

HEADER MYADD 
    68 ,C 18 ,C 63 ,C 01 ,C 
    83 ,C 01 ,C B9 ,C 00 ,C
    00 ,C C8 ,C C8 ,C 3A ,C 
    48 ,C 60 ,C 00 ,C ;

\ > ' - >NAME 40 DUMP 
\ 08C5 : 2D 00 00 AF 08 A3 03 38 | - . . . . . . 8 
\ 08CD : E3 01 83 03 68 B9 00 00 | . . . . h . . . 
\ 08D5 : C8 C8 3A 48 60 00 44 2B | . . : H ` . 

\ A3 03                         LDA     Load accumulator from memory
\ 38                            SEC     Set carry flag
\ E3 01                         SBC     Subtract with Borrow from Accumulator
\ 83 03                         STA     Store Accumulator to Memory
\ 68                            PLA     Pull Accumulator
\ B9 00 00                      LDA     Load accumulator from memory
\ C8                            INY     Increment Index Register Y
\ C8                            INY     Increment Index Register Y
\ 3A                            DEC A   Decrement accumulator
\ 48                            PHA     Push Accumulator
\ 60                            RTS     Return from subroutine
\ 00

\ > ' * >NAME 40 DUMP 
\ 0A16 : 2A 00 00 CD 09 68 85 00 | * . . . . h . . 
\ 0A1E : 68 85 02 A9 10 00 85 04 | h . . . . . . . 
\ 0A26 : A9 00 00 46 00 90 03 18 | . . . F . . . . 
\ 0A2E : 65 02 06 02 C6 04 D0 F3 | e . . . . . . . 
\ 0A36 : 48 B9 00 00 C8 C8 3A 48 | H . . . . . : H 
\ 0A3E : 60 00 55 4D 2F 4D 4F 44 | ` . U M / M O D

\ turns out there is no mul instruction, * is defined in terms of addition

\ > ' AND >NAME 60 DUMP 
\ 0B7E : 41 4E 44 00 00 6E 0B 68 | A N D . . n . h
\ 0B86 : 23 01 83 01 B9 00 00 C8 | # . . . . . . .
\ 0B8E : C8 3A 48 60 00 4F 52 00 | . : H ` . O R .
\ 0B96 : 00 85 0B 68 03 01 83 01 | . . . h . . . .
\ 0B9E : B9 00 00 C8 C8 3A 48 60 | . . . . . : H `
\ 0BA6 : 00 58 4F 52 00 00 99 0B | . X O R . . . .
\ 0BAE : 68 43 01 83 01 B9 00 00 | h C . . . . . .
\ 0BB6 : C8 C8 3A 48 60 00 53 50 | . . : H ` . S P
\ 0BBE : 40 00 00 AE 0B 8A BA DA | @ . . . . . . .
\ 0BC6 : AA B9 00 00 C8 C8 3A 48 | . . . . . . : H
\ 0BCE : 60 00 53 50 21 00 00 C3 | ` . S P ! . . .
\ 0BD6 : 0B 8A FA 9A AA B9 00 00 | . . . . . . . .

\ AND
\ 68                            PLA     Pull Accumulator
\ 23 01                         AND     And accumulator with memory
\ 83 01                         STA     Store accumulator to memory
\ B9 00 00                      LDA     Load accumulator from memory
\ C8                            INY     Increment Index Register Y
\ C8                            INY     Increment Index Register Y
\ 3A                            DEC A   Decrement accumulator
\ 48                            PHA     Push Accumulator
\ 60                            RTS     Return from subroutine
\ 00

\ OR
\ 68                            PLA     Pull Accumulator
\ 03 01                         ORA     OR Accumulator with Memory
\ 83 01                         STA     Store accumulator to memory
\ B9 00 00                      LDA     Load accumulator from memory
\ C8                            INY     Increment Index Register Y
\ C8                            INY     Increment Index Register Y
\ 3A                            DEC A   Decrement accumulator
\ 48                            PHA     Push Accumulator
\ 60                            RTS     Return from subroutine
\ 00

\ XOR
\ 68                            PLA     Pull Accumulator
\ 43 01                         EOR     Exclusive-OR Accumulator with Memory
\ 83 01                         STA     Store accumulator to memory
\ B9 00 00                      LDA     Load accumulator from memory
\ C8                            INY     Increment Index Register Y
\ C8                            INY     Increment Index Register Y
\ 3A                            DEC A   Decrement accumulator
\ 48                            PHA     Push Accumulator
\ 60                            RTS     Return from subroutine
\ 00

HEX

HEADER ONE
    A9 ,C 01 ,                                              \ put constant 1 (0x0100LE) into ACC
    48 ,C                                                   \ push ACC onto the stack
    B9 ,C 00 ,C 00 ,C C8 ,C C8 ,C 3A ,C 48 ,C 60 ,C 00 ,C   \ tidy up and return
   
    08 ,C                                                   \ push PHP onto the stack

HEADER ADDASM
    PLA
    CLC
    1 ADC-SR
    1 STA-SR
    ASM-END

\ > ' IF SEE : 4E7 , HERE 0 , 0 ; IMMEDIATE

\ > ' ELSE SEE : DROP 4CD , HERE 0 , SWAP HERE SWAP ! 0 ; IMMEDIATE
\ > 4CD >NAME TYPE (branch)

\ > ' THEN SEE : DROP HERE SWAP ! ; IMMEDIATE
\ > 4E7 >NAME TYPE (?branch)

\ > ' (branch) >NAME 30 DUMP 
\ 04C1 : 28 62 72 61 6E 63 68 29 | ( b r a n c h ) 
\ 04C9 : 00 00 B2 04 B9 00 00 A8 | . . . . . . . . 
\ 04D1 : B9 00 00 C8 C8 3A 48 60 | . . . . . : H ` 
\ 04D9 : 00 28 3F 62 72 61 6E 63 | .

\ B2 04             LDA-DPI 0x04
\ B9 00 00          LDA-ABSIY 0x0000
\ A8                TAY
\ clean up

\ > ' (?branch) >NAME 30 DUMP 
\ 04DA : 28 3F 62 72 61 6E 63 68 | ( ? b r a n c h 
\ 04E2 : 29 00 00 CD 04 68 D0 06 | ) . . . . h . . 
\ 04EA : B9 00 00 A8 80 02 C8 C8 | . . . . . . . . 
\ 04F2 : B9 00 00 C8 C8 3A 48 60 | . . . . . : H ` 
\ 04FA : 00 28 64 6F 29 00 00 E7 | .

\ 68                PLA
\ D0 06             BNE GOTO
\ B9 00 00          LDA-ABSIY 0x0000
\ A8                TAY
\ 80 02             BRA 0x02                # skip next 2 instructions
\ C8                INY LABEL: GOTO         # go here 
\ C8                INY
\ clean up


\ > ' R> >NAME 20 DUMP 
\ 0784 : 52 3E 00 00 75 07 E8 BD | R > . . u . . . 
\ 078C : 00 00 E8 48 B9 00 00 C8 | . . . H . . . . 
\ 0794 : C8 3A 48 60 00 21 00 00 | . : H ` . ! . . 

\ E8                INX
\ BD 00 00          LDA-ABSIX 0x0000
\ E8                INX
\ 48                PHA
\ clean up

\ > ' >R >NAME 20 DUMP 
\ 076F : 3E 52 00 00 5B 07 68 CA | > R . . [ . h . 
\ 0777 : 9D 00 00 CA B9 00 00 C8 | . . . . . . . . 
\ 077F : C8 3A 48 60 00 52 3E 00 | . : H ` . R > . 

\ 68                PLA
\ CA                DEX
\ 9D 00 00          STA-ABSIX
\ CA                DEX
\ clean up

\ > ' (enter) >NAME 20 DUMP 
\ 0425 : 28 65 6E 74 65 72 29 00 | ( e n t e r ) . 
\ 042D : 00 00 00 CA 98 9D 00 00 | . . . . . . . . 
\ 0435 : CA 7A C8 B9 00 00 C8 C8 | . z . . . . . . 
\ 043D : 3A 48 60 00 28 64 6F 63 | : H ` . ( d o c 

\ CA                DEX
\ 98                TYA
\ 9D 00 00          STA-ABSIX
\ CA                DEX
\ 7A                PLY
\ CA                DEX
\ clean up

\ > ' EXIT >NAME 20 DUMP 
\ 0493 : 45 58 49 54 00 00 7F 04 | E X I T . . . . 
\ 049B : E8 BC 00 00 E8 B9 00 00 | . . . . . . . . 
\ 04A3 : C8 C8 3A 48 60 00 28 6C | . . : H ` . ( l 

\ E8                INX
\ BC 00 00          LDA-ABSIX 0x0000
\ E8                INX
\ clean up

\ > ' DUP >NAME 20 DUMP 
\ 0603 : 44 55 50 00 00 FE 05 A3 | D U P . . . . . 
\ 060B : 01 48 B9 00 00 C8 C8 3A | . H . . . . . : 
\ 0613 : 48 60 00 3F 44 55 50 00 | H ` . ? D U P . 

\ A3 01             LDA-SR
\ 48                PHA
\ clean up


\ > ' C@ >NAME 20 DUMP 
\ 080C : 43 40 00 00 FD 07 68 85 | C @ . . . . h . 
\ 0814 : 00 A9 00 00 E2 20 B2 00 | . . . . .   . . 
\ 081C : C2 20 48 B9 00 00 C8 C8 | .   H . . . . . 
\ 0824 : 3A 48 60 00 4C 21 00 00 | : H ` . L ! . . 

\ 68                PLA
\ 85 00             STA-DP 0x00
\ A9 00 00          LDA-IMM 0x0000
\ E2 20             SEP 0010 0000 -> M=1 accumulator register size
\ B2 00             LDA-DPI 0x00
\ C2 20             REP 0010 0000 -> M=0 accumulator register size
\ 48                PHA