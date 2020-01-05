HEX

\ some example programs:

\ HEADER CONSTASM
\     23 LDA-IMM
\     PHA
\     ASM-END

\ HEADER ADDASM
\     PLA
\     CLC
\     1 ADC-SR
\     1 STA-SR
\     ASM-END

\ addressing modes:
\ IMM           immediate
\ ABS           absolute
\ ABSL          absolute long
\ ABSIX         absolute indexed X
\ ABSIY         absolute indexed Y
\ ALIX          absolute long indexed X
\ SR            stack relative
\ SRIIY         SR indirect indexed Y
\ DP            direct page
\ DPI           DP indirect
\ DPIL          DP indirect long
\ DPIX          DP indexed X
\ DPIY          DP indexed Y
\ DPIIX         DP indirect indexed X
\ DPIIY         DP indirect indexed Y
\ DPILIY        DP indirect long indexed Y

\ branching is program counter relative

\ Tidy up after ASM:
\ B9 00 00      load accumulator from 0x0000 + index Y
\ C8            increment index register Y
\ C8            increment index register y
\ 3A            decrement accumulator
\ 60            return from subroutine
\ 00            BRK should never come here
: ASM-END 
    B9 ,C 00 ,C 00 ,C C8 ,C 
    C8 ,C 3A ,C 48 ,C 60 ,C 
    00 ,C ; IMMEDIATE

\ Add with carry to accumulator
: ADC-DPIIX     61 ,C ,C    ; IMMEDIATE
: ADC-SR        63 ,C ,C    ; IMMEDIATE
: ADC-DP        65 ,C ,C    ; IMMEDIATE
: ADC-DPIL      67 ,C ,C    ; IMMEDIATE
: ADC-IMM       69 ,C ,     ; IMMEDIATE \ assuming 16bit mode
: ADC-ABS       6D ,C ,     ; IMMEDIATE \ 0x0000 LE
: ADC-ABSL      6F ,C ,C ,  ; IMMEDIATE \ 0x00 0x0000LE
: ADC-DPIIY     71 ,C ,C    ; IMMEDIATE
: ADC-DPI       72 ,C ,C    ; IMMEDIATE
: ADC-SRIIY     73 ,C ,C    ; IMMEDIATE
: ADC-DPIX      75 ,C ,C    ; IMMEDIATE
: ADC-DPILIY    77 ,C ,C    ; IMMEDIATE
: ADC-ABSIY     79 ,C ,     ; IMMEDIATE \ 0x0000LE
: ADC-ABSIX     7D ,C ,     ; IMMEDIATE \ 0x0000LE
: ADC-ALIX      7F ,C ,C ,  ; IMMEDIATE \ 0x00 0x0000LE

\ increment
: INC-A         1A ,C       ; IMMEDIATE \ increment accumulator
: INC-DP        E6 ,C ,C    ; IMMEDIATE
: INC-ABS       EE ,C ,     ; IMMEDIATE \ 0x0000LE
: INC-DPIX      F6 ,C ,C    ; IMMEDIATE
: INC-ABSIX     FE ,C ,     ; IMMEDIATE \ 0x0000LE
: INX           E8 ,C       ; IMMEDIATE \ increment index x
: INY           CB ,C       ; IMMEDIATE \ increment index y

\ Subtract with borrow from accumulator
: SBC-DPIIX     E1 ,C ,C    ; IMMEDIATE
: SBC-SR        E3 ,C ,C    ; IMMEDIATE
: SBC-DP        E5 ,C ,C    ; IMMEDIATE
: SBC-DPIL      E7 ,C ,C    ; IMMEDIATE
: SBC-IMM       E9 ,C ,     ; IMMEDIATE \ assuming 16bit mode
: SBC-ABS       ED ,C ,     ; IMMEDIATE \ 0x0000 LE
: SBC-ABSL      EF ,C ,C ,  ; IMMEDIATE \ 0x00 0x0000LE
: SBC-DPIIY     F1 ,C ,C    ; IMMEDIATE
: SBC-DPI       F2 ,C ,C    ; IMMEDIATE
: SBC-SRIIY     F3 ,C ,C    ; IMMEDIATE
: SBC-DPIX      F5 ,C ,C    ; IMMEDIATE
: SBC-DPILIY    F7 ,C ,C    ; IMMEDIATE
: SBC-ABSIY     F9 ,C ,     ; IMMEDIATE \ 0x0000LE
: SBC-ABSIX     FD ,C ,     ; IMMEDIATE \ 0x0000LE
: SBC-ALIX      FF ,C ,C ,  ; IMMEDIATE \ 0x00 0x0000LE

\ decrement
: DEC-A         3A ,C       ; IMMEDIATE \ decrement accumulator
: DEC-DP        C6 ,C ,C    ; IMMEDIATE
: DEC-ABS       CE ,C ,     ; IMMEDIATE \ 0x0000LE
: DEC-DPIX      D6 ,C ,C    ; IMMEDIATE
: DEC-ABSIX     DE ,C ,     ; IMMEDIATE \ 0x0000LE
: DEX           CA ,C       ; IMMEDIATE
: DEY           88 ,C       ; IMMEDIATE

\ arithmetic shift left
: ASL-DP        06 ,C ,C    ; IMMEDIATE
: ASL-A         0A ,C       ; IMMEDIATE
: ASL-ABS       0E ,C ,     ; IMMEDIATE \ 0x0000LE
: ASL-DPIX      16 ,C ,C    ; IMMEDIATE
: ASL-ABSIX     1E ,C ,     ; IMMEDIATE \ 0x0000LE

\ compare accumulator with memory
: CMP-DPIIX     C1 ,C ,C    ; IMMEDIATE
: CMP-SR        C3 ,C ,C    ; IMMEDIATE
: CMP-DP        C5 ,C ,C    ; IMMEDIATE
: CMP-DPIL      C7 ,C ,C    ; IMMEDIATE
: CMP-IMM       C9 ,C ,     ; IMMEDIATE \ 0x0000LE assuming 16bit mode
: CMP-ABS       CD ,C ,     ; IMMEDIATE \ 0x0000LE
: CMP-ABSL      CF ,C ,C ,  ; IMMEDIATE \ 0x00 0x0000LE
: CMP-DPIIY     D1 ,C ,C    ; IMMEDIATE
: CMP-DPI       D2 ,C ,C    ; IMMEDIATE
: CMP-SRIIY     D3 ,C ,C    ; IMMEDIATE
: CMP-DPIX      D5 ,C ,C    ; IMMEDIATE
: CMP-DPILIY    D7 ,C ,C    ; IMMEDIATE
: CMP-ABSIY     D9 ,C ,     ; IMMEDIATE \ 0x0000 LE
: CMP-ABSIX     DD ,C ,     ; IMMEDIATE \ 0x0000 LE
: CMP-ALIX      DF ,C ,C ,  ; IMMEDIATE \ 0x00 0x0000LE

\ compare index register X with memory
: CPX-IMM       E0 ,C ,     ; IMMEDIATE \ 0x0000LE assuming 16bit mode
: CPX-DP        E4 ,C ,C    ; IMMEDIATE
: CPX-ABS       EC ,C ,     ; IMMEDIATE \ 0x0000LE

\ compare index register Y with memory
: CPY-IMM       C0 ,C ,     ; IMMEDIATE \ 0x0000LE assuming 16bit mode
: CPY-DP        C4 ,C ,C    ; IMMEDIATE
: CPY-ABS       CC ,C ,     ; IMMEDIATE \ 0x0000LE

\ test bits
: BIT-DP        24 ,C ,C    ; IMMEDIATE
: BIT-ABS       2C ,C ,     ; IMMEDIATE \ 0x0000LE
: BIT-DPIX      34 ,C ,C    ; IMMEDIATE
: BIT-ABSIX     3C ,C ,     ; IMMEDIATE \ 0x0000LE
: BIT-IMM       89 ,C ,     ; IMMEDIATE \ 0x0000LE assuming 16bit mode

: TRB-DP        14 ,C ,C    ; IMMEDIATE \ test and reset memory bits against accumulator
: TRB-ABS       1C ,C ,     ; IMMEDIATE \ test and reset memory bits against accumulator
: TSB-DP        04 ,C ,C    ; IMMEDIATE \ test and set memory bits against accumulator
: TSB-ABS       0C ,C ,     ; IMMEDIATE \ test and set memory bits against accumulator

\ logical shift right
: LSR-DP        46 ,C ,C    ; IMMEDIATE
: LSR           4A ,C       ; IMMEDIATE
: LSR-ABS       4E ,C ,     ; IMMEDIATE \ 0x0000LE
: LSR-DPIX      56 ,C ,C    ; IMMEDIATE
: LSR-ABSIX     5E ,C ,     ; IMMEDIATE \ 0x0000LE

: ROL-DP        26 ,C ,C    ; IMMEDIATE
: ROL           2A ,C       ; IMMEDIATE \ rotate accumulator left
: ROL-ABS       2E ,C ,     ; IMMEDIATE \ 0x0000LE
: ROL-DPIX      36 ,C ,C    ; IMMEDIATE
: ROL-ABSIX     3E ,C ,     ; IMMEDIATE \ 0x0000LE

: ROR-DP        66 ,C ,C    ; IMMEDIATE
: ROR           6A ,C       ; IMMEDIATE
: ROR-ABS       6E ,C ,     ; IMMEDIATE \ 0x0000LE
: ROR-DPIX      76 ,C ,C    ; IMMEDIATE
: ROR-ABSIX     7E ,C ,     ; IMMEDIATE \ 0x0000LE

\ And accumulator with memory
: AND-DPIIX     21 ,C ,C    ; IMMEDIATE
: AND-SR        23 ,C ,C    ; IMMEDIATE
: AND-DP        25 ,C ,C    ; IMMEDIATE
: AND-DPIL      27 ,C ,C    ; IMMEDIATE
: AND-IMM       29 ,C ,     ; IMMEDIATE \ assuming 16bit mode
: AND-ABS       2D ,C ,     ; IMMEDIATE \ 0x0000LE
: AND-ABSL      2F ,C ,C ,  ; IMMEDIATE \ 0x00 0x0000LE
: AND-DPIIY     31 ,C ,C    ; IMMEDIATE
: AND-DPI       32 ,C ,C    ; IMMEDIATE
: AND-SRIIY     33 ,C ,C    ; IMMEDIATE
: AND-DPIX      35 ,C ,C    ; IMMEDIATE
: AND-DPILIY    37 ,C ,C    ; IMMEDIATE
: AND-ABSIY     39 ,C ,     ; IMMEDIATE \ 0x0000LE
: AND-ABSIX     3D ,C ,     ; IMMEDIATE \ 0x0000LE
: AND-ALIX      3F ,C ,C ,  ; IMMEDIATE \ 0x00 0x0000LE

\ OR accumulator with memory
: ORA-DPIIX     01 ,C ,C    ; IMMEDIATE
: ORA-SR        03 ,C ,C    ; IMMEDIATE
: ORA-DP        05 ,C ,C    ; IMMEDIATE
: ORA-DPIL      07 ,C ,C    ; IMMEDIATE
: ORA-IMM       09 ,C ,     ; IMMEDIATE \ assuming 16bit mode
: ORA-ABS       0D ,C ,     ; IMMEDIATE \ 0x0000LE
: ORA-ABSL      0F ,C ,C ,  ; IMMEDIATE \ 0x00 0x0000LE
: ORA-DPIIY     11 ,C ,C    ; IMMEDIATE
: ORA-DPI       12 ,C ,C    ; IMMEDIATE
: ORA-SRIIY     13 ,C ,C    ; IMMEDIATE
: ORA-DPIX      15 ,C ,C    ; IMMEDIATE
: ORA-DPILIY    17 ,C ,C    ; IMMEDIATE
: ORA-ABSIY     19 ,C ,     ; IMMEDIATE \ 0x0000LE
: ORA-ABSIX     1D ,C ,     ; IMMEDIATE \ 0x0000LE
: ORA-ALIX      1F ,C ,C ,  ; IMMEDIATE \ 0x00 0x0000LE

\ XOR accumulator with memory
: EOR-DPIIX     41 ,C ,C    ; IMMEDIATE
: EOR-SR        43 ,C ,C    ; IMMEDIATE
: EOR-DP        45 ,C ,C    ; IMMEDIATE
: EOR-DPIL      47 ,C ,C    ; IMMEDIATE
: EOR-IMM       49 ,C ,     ; IMMEDIATE \ assuming 16bit mode
: EOR-ABS       4D ,C ,     ; IMMEDIATE \ 0x0000LE
: EOR-ABSL      4F ,C ,C ,  ; IMMEDIATE \ 0x00 0x0000LE
: EOR-DPIIY     51 ,C ,C    ; IMMEDIATE
: EOR-DPI       52 ,C ,C    ; IMMEDIATE
: EOR-SRIIY     53 ,C ,C    ; IMMEDIATE
: EOR-DPIX      55 ,C ,C    ; IMMEDIATE
: EOR-DPILIY    57 ,C ,C    ; IMMEDIATE
: EOR-ABSIY     59 ,C ,     ; IMMEDIATE \ 0x0000LE
: EOR-ABSIX     5D ,C ,     ; IMMEDIATE \ 0x0000LE
: EOR-ALIX      5F ,C ,C ,  ; IMMEDIATE \ 0x00 0x0000LE

\ load accumulator from memory
: LDA-DPIIX     A1 ,C ,C    ; IMMEDIATE
: LDA-SR        A3 ,C ,C    ; IMMEDIATE
: LDA-DP        A5 ,C ,C    ; IMMEDIATE
: LDA-DPIL      A7 ,C ,C    ; IMMEDIATE
: LDA-IMM       A9 ,C ,     ; IMMEDIATE \ 0x0000LE assuming 16bit mode
: LDA-ABS       AD ,C ,     ; IMMEDIATE \ 0x0000LE
: LDA-ABSL      AF ,C ,C ,  ; IMMEDIATE \ 0x00 0x0000LE
: LDA-DPIIY     B1 ,C ,C    ; IMMEDIATE
: LDA-DPI       B2 ,C ,C    ; IMMEDIATE
: LDA-SRIIY     B3 ,C ,C    ; IMMEDIATE
: LDA-DPIX      B5 ,C ,C    ; IMMEDIATE
: LDA-DPILIY    B7 ,C ,C    ; IMMEDIATE
: LDA-ABSIY     B9 ,C ,     ; IMMEDIATE \ 0x0000LE
: LDA-ABSIX     BD ,C ,     ; IMMEDIATE \ 0x0000LE
: LDA-ALIX      BF ,C ,C ,  ; IMMEDIATE \ 0x00 0x0000LE

\ store accumulator to memory
: STA-DPIIX     81 ,C ,C    ; IMMEDIATE
: STA-SR        83 ,C ,C    ; IMMEDIATE
: STA-DP        85 ,C ,C    ; IMMEDIATE
: STA-DPIL      87 ,C ,C    ; IMMEDIATE
: STA-IMM       89 ,C ,     ; IMMEDIATE \ 0x0000LE assuming 16bit mode
: STA-ABS       8D ,C ,     ; IMMEDIATE \ 0x0000LE
: STA-ABSL      8F ,C ,C ,  ; IMMEDIATE \ 0x00 0x0000LE
: STA-DPIIY     91 ,C ,C    ; IMMEDIATE
: STA-DPI       92 ,C ,C    ; IMMEDIATE
: STA-SRIIY     93 ,C ,C    ; IMMEDIATE
: STA-DPIX      95 ,C ,C    ; IMMEDIATE
: STA-DPILIY    97 ,C ,C    ; IMMEDIATE
: STA-ABSIY     99 ,C ,     ; IMMEDIATE \ 0x0000LE
: STA-ABSIX     9D ,C ,     ; IMMEDIATE \ 0x0000LE
: STA-ALIX      9F ,C ,C ,  ; IMMEDIATE \ 0x00 0x0000LE

\ load index register X from memory
: LDX-DP        A6 ,C ,C    ; IMMEDIATE
: LDX-ABS       AE ,C ,     ; IMMEDIATE \ 0x0000LE
: LDX-DPIY      B6 ,C ,C    ; IMMEDIATE
: LDX-ABSIY     BE ,C ,     ; IMMEDIATE \ 0x0000LE

\ store index register X to memory
: STX-DP        86 ,C ,C    ; IMMEDIATE
: STX-ABS       8E ,C ,     ; IMMEDIATE \ 0x0000LE
: STX-DPIY      96 ,C ,C    ; IMMEDIATE

\ load index register Y from memory
: LDY-DP        A4 ,C ,C    ; IMMEDIATE
: LDY-ABS       AC ,C ,     ; IMMEDIATE \ 0x0000LE
: LDY-DPIX      B4 ,C ,C    ; IMMEDIATE
: LDY-IMM       A0 ,C ,     ; IMMEDIATE \ 0x0000LE assuming 16bit mode

\ store index register Y to memory
: STY-DP        84 ,C ,C    ; IMMEDIATE
: STY-ABS       8C ,C ,     ; IMMEDIATE \ 0x0000LE
: STY-DPIY      94 ,C ,C    ; IMMEDIATE

\ store zero to memory
: STZ-DP        64 ,C ,C    ; IMMEDIATE
: STZ-DPIX      74 ,C ,C    ; IMMEDIATE
: STZ-ABS       9C ,C ,     ; IMMEDIATE \ 0x0000LE
: STZ-ABSIX     9E ,C ,     ; IMMEDIATE \ 0x0000LE

\ transfer data between registers
: TAX           AA ,C       ; IMMEDIATE \ transfer accumulator to index register X
: TAY           A8 ,C       ; IMMEDIATE \ transfer accumulator to index register Y
: TCD           5B ,C       ; IMMEDIATE \ transfer 16bit accumulator to direct page register
: TCS           1B ,C       ; IMMEDIATE \ transfer 16bit accumulator to stack pointer
: TDC           7B ,C       ; IMMEDIATE \ transfer direct page register to 16bit accumulator
: TSC           3B ,C       ; IMMEDIATE \ transfer stack pointer to 16bit accumulator
: TSX           BA ,C       ; IMMEDIATE \ transfer stack pointer to index register X
: TXA           8A ,C       ; IMMEDIATE \ transfer index register X to accumulator
: TXS           9A ,C       ; IMMEDIATE \ transfer index register X to stack pointer
: TXY           9B ,C       ; IMMEDIATE \ transfer index register X to index register Y
: TYA           98 ,C       ; IMMEDIATE \ transfer index register Y to accumulator
: TYX           BB ,C       ; IMMEDIATE \ transfer index register Y to index register X

: XBA           EB ,C       ; IMMEDIATE \ exchange B and A 8bit accumulators
: XCE           FB ,C       ; IMMEDIATE \ exchange carry and emulation flags

\ block move source, dest
: MVN           54 ,C ,C ,C ; IMMEDIATE \ block move negative
: MVP           44 ,C ,C ,C ; IMMEDIATE \ block move positive

\ Branch
: BLT           90 ,C ,C    ; IMMEDIATE \ branch if carry clear (BCC), PC relative
: BGE           B0 ,C ,C    ; IMMEDIATE \ branch if carry set (BCS), PC relative
: BEQ           F0 ,C ,C    ; IMMEDIATE \ branch if equal, PC relative
: BNE           D0 ,C ,C    ; IMMEDIATE \ branch if not equal,  relative
: BMI           30 ,C ,C    ; IMMEDIATE \ branch if minus, PC relative
: BPL           10 ,C ,C    ; IMMEDIATE \ branch if plus, PC relative
: BRA           80 ,C ,C    ; IMMEDIATE \ branch always, PC relative
: BRL           82 ,C ,     ; IMMEDIATE \ branch always long 0x0000LE, PC relative long
: BVC           50 ,C ,C    ; IMMEDIATE \ branch if overflow clear, PC relative
: BVS           70 ,C ,C    ; IMMEDIATE \ branch if overflow set, PC relative

\ jump
: JMP-ABS       4C ,C ,     ; IMMEDIATE \ 0x0000LE
: JMP-ABSL      5C ,C ,C ,  ; IMMEDIATE \ 0x00 0x0000LE
: JMP-ABSI      6C ,C ,     ; IMMEDIATE \ 0x0000LE
: JMP-ABSII     7C ,C ,     ; IMMEDIATE \ 0x0000LE
: JMP-ABSIL     DC ,C ,     ; IMMEDIATE \ 0x0000LE

\ jump to subroutine
: JSR-ABS       20 ,C ,     ; IMMEDIATE \ 0x0000LE
: JSR-ABSL      22 ,C ,C ,  ; IMMEDIATE \ 0x00 0x0000LE
: JSR-ABSII     FC ,C ,     ; IMMEDIATE \ 0x0000LE

\ return
: RTI            40 ,C      ; IMMEDIATE \ return from interrupt
: RTL            6B ,C      ; IMMEDIATE \ return from subroutine long
: RTS            60 ,C      ; IMMEDIATE \ return from subroutine

\ push onto the stack
: PEI           D4 ,C ,C    ; IMMEDIATE \ push effective indirect address
: PER           62 ,C ,     ; IMMEDIATE \ 0x0000LE push effective PC relative indirect address
: PHA           48 ,C       ; IMMEDIATE \ push accumulator
: PHB           8B ,C       ; IMMEDIATE \ push data bank register
: PHD           0B ,C       ; IMMEDIATE \ push direct page register
: PHK           4B ,C       ; IMMEDIATE \ push program bank register
: PHP           08 ,C       ; IMMEDIATE \ push processor status register
: PHX           DA ,C       ; IMMEDIATE \ push index register X
: PHY           5A ,C       ; IMMEDIATE \ push index register Y

\ pull from the stack
: PLA           68 ,C       ; IMMEDIATE \ pull accumulator
: PLB           AB ,C       ; IMMEDIATE \ pull data bank register
: PLD           2B ,C       ; IMMEDIATE \ pull direct page register
: PLP           28 ,C       ; IMMEDIATE \ pull processor status register
: PLX           FA ,C       ; IMMEDIATE \ pull index register X
: PLY           7A ,C       ; IMMEDIATE \ pull index register Y

\ clear flags
: CLC           18 ,C       ; IMMEDIATE \ clear carry
: CLD           D8 ,C       ; IMMEDIATE \ clear decimal
: CLI           58 ,C       ; IMMEDIATE \ clear interrupt disable
: CLV           B8 ,C       ; IMMEDIATE \ clear overflow flag

\ set flags
: SEC           38 ,C       ; IMMEDIATE \ set carry flag
: SED           F8 ,C       ; IMMEDIATE \ set decimal flag
: SEI           78 ,C       ; IMMEDIATE \ set interrupt disable flag
: SEP           E2 ,C ,C    ; IMMEDIATE \ set processor status bits

: BRK           00 ,C       ; IMMEDIATE \ break
: STP           DB ,C       ; IMMEDIATE \ stop processor
: NOP           EA ,C       ; IMMEDIATE \ no op
: COP           02 ,C       ; IMMEDIATE \ enable coprocessor
: REP           C2 ,C ,C    ; IMMEDIATE \ reset processor status bits
: WAI           CB ,C       ; IMMEDIATE \ wait for interrupt

: WDM           42 ,C       ; IMMEDIATE \ reserved for future expansion
