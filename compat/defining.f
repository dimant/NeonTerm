: CMOVE ( c-addr1 c-addr2 n -- )
    0 ?DO
        OVER @ OVER !
    LOOP
    DROP DROP ;
