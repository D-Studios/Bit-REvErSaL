*-----------------------------------------------------------
* Title      :  Bit REvErSaL
* Written by :  Trevor Trusty
* Description:  Write an assembly language program to reverse the bits of a byte.
*-----------------------------------------------------------
    ORG    $1000
START:

* Put program code here
    CLR D0
    CLR D1
    CLR D2
    CLR D3
    MOVE #$01,D3
    MOVE.b value,D1
    jmp loop
   
loop:
    ** get last bit **
    MOVE D1,D2
    AND #$01,D2
    LSR #$01,D1      ; bit shift D1 right
    
    ROR.b D3,D2      ; rotate right D2 by D3 bits
    ADD #1, D3      ; increment rotation number
    
    ADD D2,D0
    
    ADD #1, D4      ; increment loop index
    CMP #8, D4
    BGE EXIT
    jmp loop
    
EXIT:
    MOVE.b D0,reverse
    CLR D1
    CLR D2
    CLR D3
    CLR D4
    MOVE.b reverse, D1  ; test memory write
    SIMHALT             ; halt simulator

* Put variables and constants here
value   DC.b    %10110011 ; hex B3. reverse: 11001101 or hex CD
reverse DS.b 1
    END    START        ; last line of source


