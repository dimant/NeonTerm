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

: EMPTY-STACK ( ... -- ) \ handles underflowed stack too
   DEPTH ?DUP IF DUP 0< IF NEGATE 0 DO 0 LOOP ELSE 0 DO DROP LOOP THEN THEN ;

: ERROR      \ ( ... -- )
   ." IN TEST" SPACE CURRENT-TEST @ .
   EMPTY-STACK \ throw away everything else
   #ERRORS @ 1 + #ERRORS !
   0 CURRENT-TEST !
   QUIT
;

: T{
      CURRENT-TEST @ 1+ CURRENT-TEST !
   ;

: -> ( ... -- ) \ record depth and content of stack
   DEPTH DUP ACTUAL-DEPTH !
   ?DUP IF \ If there is something on the stack,
      0 DO ACTUAL-RESULTS I CELLS + ! LOOP \ save to actual results
   THEN ;

: }T \ ( ... -- ) Compare stack expected contents with saved (actual) contents
   DEPTH ACTUAL-DEPTH @ = IF \ if depths match,
      DEPTH ?DUP IF \ and there is something on the stack
         0  DO \ for each cell
           ACTUAL-RESULTS I CELLS + @ \ compare actual with expected
           = 0= IF ." INCORRECT RESULT " ERROR THEN
         LOOP
      THEN
   ELSE \ If depths don't match
      ." WRONG NUMBER OF RESULTS " ERROR
   THEN ;
