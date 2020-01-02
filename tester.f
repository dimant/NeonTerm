\ ported to neon, original at https://raw.githubusercontent.com/gerryjackson/forth2012-test-suite/master/src/tester.fr

\ From: John Hayes S1I
\ Subject: tester.fr
\ Date: Mon, 27 Nov 95 13:10:09 PST  

\ (C) 1995 JOHNS HOPKINS UNIVERSITY / APPLIED PHYSICS LABORATORY
\ MAY BE DISTRIBUTED FREELY AS LONG AS THIS COPYRIGHT NOTICE REMAINS.
\ VERSION 1.2

\ 24/11/2015 Replaced Core Ext word <> with = 0=
\ 31/3/2015 Variable #ERRORS added and incremented for each error reported.
\ 22/1/09 The words { and } have been changed to T{ and }T respectively to
\ agree with the Forth 200X file ttester.fs. This avoids clashes with
\ locals using { ... } and the FSL use of } 

\ HEX

VARIABLE #ERRORS 0 #ERRORS !
VARIABLE CURRENT-TEST 0 CURRENT-TEST !
VARIABLE ACTUAL-DEPTH 0 ACTUAL-DEPTH !
CREATE ACTUAL-RESULTS 20 CELLS ALLOT DROP

: EMPTY-STACK ( ... -- ) \ EMPTY STACK: HANDLES UNDERFLOWED STACK TOO.
   DEPTH ?DUP IF DUP 0< IF NEGATE 0 DO 0 LOOP ELSE 0 DO DROP LOOP THEN THEN ;

: ERROR      \ ( ... -- )
   ." IN TEST" SPACE CURRENT-TEST @ .
   EMPTY-STACK               \ THROW AWAY EVERY THING ELSE
   #ERRORS @ 1 + #ERRORS !
   0 CURRENT-TEST !
   QUIT  \ *** Uncomment this line to QUIT on an error
;

: T{
      CURRENT-TEST @ 1+ CURRENT-TEST !
   ;

: ->      \ ( ... -- ) RECORD DEPTH AND CONTENT OF STACK.
   DEPTH DUP ACTUAL-DEPTH !      \ RECORD DEPTH
   ?DUP IF            \ IF THERE IS SOMETHING ON STACK
      0 DO ACTUAL-RESULTS I CELLS + ! LOOP \ SAVE THEM
   THEN ;

: }T      \ ( ... -- ) COMPARE STACK (EXPECTED) CONTENTS WITH SAVED
      \ (ACTUAL) CONTENTS.
   DEPTH ACTUAL-DEPTH @ = IF      \ IF DEPTHS MATCH
      DEPTH ?DUP IF         \ IF THERE IS SOMETHING ON THE STACK
         0  DO            \ FOR EACH STACK ITEM
           ACTUAL-RESULTS I CELLS + @   \ COMPARE ACTUAL WITH EXPECTED
           = 0= IF ." INCORRECT RESULT " ERROR THEN
         LOOP
      THEN
   ELSE               \ DEPTH MISMATCH
      ." WRONG NUMBER OF RESULTS " ERROR
   THEN ;
