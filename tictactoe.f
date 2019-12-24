CREATE BOARD 9 ALLOT

: SQUARE ( square# -- addr) BOARD + ;
: CLEAR 9 0 DO 0 I SQUARE C! LOOP ; CLEAR
: BAR ." | " ;
: DASH 45 EMIT ;
: DASHES CR 9 0 DO DASH LOOP CR ;
: SPACE 32 EMIT ;
: SPACES ( n -- ) 0 DO SPACE LOOP ;
: MOD ( a b -- m ) 0 SWAP UM/MOD DROP ;

: DEBUGB 9 0 DO I SQUARE C@ . LOOP ;

: .BOX ( square# -- )
    DUP SQUARE C@ DUP 0= IF
        OVER 1+ . ELSE
        DUP 1 = IF
            ." X " ELSE
            ." O "
        DROP
    THEN THEN DROP ;

: DISPLAY ( -- ) 
    CR 9 0 DO I IF
        I 3 MOD 0= IF
        DASHES ELSE
        BAR THEN THEN 
        I .BOX
    LOOP ;

: PLAY ( player square# -- )
    1- 0 MAX 8 MIN SQUARE C! ;

: X! ( square# -- ) 1 SWAP PLAY DISPLAY ;
: O! ( square# -- ) 2 SWAP PLAY DISPLAY ;
