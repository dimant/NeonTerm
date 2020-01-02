\ ported from: https://groups.google.com/forum/#!msg/comp.lang.forth/DglVTqncYzQ/W7nsXZO54kEJ
\
\ From: cmo...@uoft02.utoledo.edu
\ Subject: random number gen.
\ Date: 1996/02/23
\ sender: ne...@utnetw.utoledo.edu (News Manager)
\ organization: University of Toledo
\ keywords: random, ANS
\ newsgroups: comp.lang.forth

\ Since there was some discussion about random number generators here
\ a while back, I thought this might be of interest.  It implements
\ the multiply-with-carry algorithm recommended by Marsaglia ( a guru
\ of RNGs ).  So far as I know, it hasn't been formally published,
\ but there is a discussion in the numerical analysis FAQs.

\ The essence of the algorithm is 
\         x[n+1] = x[n] * multiplier + carry mod 2^32
\ where carry is taken from the previous iteration.  I.e., the
\ top 32 bits of the 64-bit product+sum is used to add to the next
\ product.  (It's clearer in Forth.)

\ This is written to generate 16-bit (unsigned) integers with a 16-bit
\ Forth, or 32-bit values with a 32-bit Forth.  The periods should be
\ of the order of 2^29 for 16 bits and 2^58 for 32 bits.  If you want
\ 32 bits with the long period on a 16-bit system, just run separate
\ 16-bit generators with different multipliers for the upper and lower
\ halves.

\ On an EIGHT-bit system, you can run four 8-bit generators, all
\ with different multipliers; with multipliers 65FF 56FF 68FF and 317F
\ the 32-bit values should have a period of about 2^57.5 (~2x10^17).
\ Good multiplier values are important, although for the 32-bit
\ version just about any 30-bit multiplier is apt to give a period
\ of 2^50 or so.
\ ...
\ C. G. Montgomery    c...@physics.utoledo.edu    cmo...@uoft02.utoledo.edu

HEX

\ other good multipliers for 16-bit systems are 61BF 62DC 6594 6363 5E9B
65E8 CONSTANT rmult

\ any seed values should be ok
CREATE rloc 2 CELLS ALLOT DROP DOES> @ ; 3 1 rloc 2!

: rndm  ( -- u ) \ returns one cell full of random bits
    rloc 2@ rmult UM* ROT 0 D+ OVER rloc 2! ;

\ random integer from 0 to n-1
: random ( n -- 0..n-1 )
    rndm UM* NIP ;

\ reseed randomly by exercising rndm a few times
: randomize  ( -- )
    GETRTC ( day hour min sec ms us )
    + + + 0 DO  rndm DROP LOOP
    rndm rndm  rloc 2!
    DROP DROP ;