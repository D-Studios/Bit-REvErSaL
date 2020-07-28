



# Assembly: Reversing the bits of a binary number

**Here, I will explain how to reverse the order of bits in a given binary number, algorithmically and in assembly code.**

- For example, we will set a variable ```I``` to a byte-sized integer in base-2: ```10110011```

- In order to reverse the bits of our 8-bit integer, we'll need to isolate each place-value, and move each bit to their proper place in reverse order
  using two binary operations called bit-shifting and bit rotation. 

  - To better explain this, let's look at our original value of `10110011`. This number is comprised of 8 bits and they can be separated
    by addition like this:

    ```
      1 0 0 0 0 0 0 0
    + 0 0 0 0 0 0 0 0
    + 0 0 1 0 0 0 0 0
    + 0 0 0 1 0 0 0 0
    + 0 0 0 0 0 0 0 0
    + 0 0 0 0 0 0 0 0
    + 0 0 0 0 0 0 1 0
    + 0 0 0 0 0 0 0 1
    -----------------
      1 0 1 1 0 0 1 1
    ```

    But how do we apply this concept to reversing the bits?

## Bit Shifting

To accomplish this, the first operation we need to know about is "Bit Shifting", specifically bit shifting right, aka "Logical Shift Right".

A logical shift right is when all the digits move right 1 or more binary place values, and the right most digit is removed as a result.
If we were to perform a logical shift right on our number `I`,  we would get this transformation `10110011 ⇒ 1011001`, where the last
`1` was removed. 

## Bit Rotation

The second concept we need to know is called Bit Rotation. This is similar to Bit Shifting, except when the bits shift over, the bit at the end is moved to the other side. For instance, if we were to rotate right by one bit the value of `I`, we would get the this transformation:
`10110011 ⇒ 1101100` where the rightmost digit was moved all the way to the front.

Now we can write an algorithm to reverse the bits using Bit Shifting and Bit Rotation.

## Bit Reversal Algorithm

Let's create an algorithm for Bit Reversal. First I'll explain it using *Register Transfer Language (RTL)* notation and pseudocode. 

- Copy the integer stored in  ```I``` from memory into one of the CPU's data-registers for quicker access
  ``` [R1] ← 10110011```

- Set the initial number of rotations that it will take to get a digit into it's correct (reversed) place. We will increase number this each iteration of the algorithm.
  ```[R2] ← 1 ```

- Now we need a loop to look at each bit and move them to their new position.

  - ```c++
    for(int i = 0; i < N; i++){	// C style loop (N is equal to 8 for this example, because we have 8 bits)
        do stuff....
    }
    ```

    - First we need to copy the data from R1 to another register so we can make changes without affecting the original copy.
      ````[R3] ← [R1] ````
      Now we can use boolean logic to get just the right-most bit by itself. We can do this by using the expression 
      `10110011 &(AND) 1`, because anything "AND" the preceding zero bits will become zero, and the last bit "AND" 1 will become whatever the last bit is. Allow me to demonstrate with two numbers:

    - ```
         1 0 1 1				0 1 1 0
      and					and
         0 0 0 1				0 0 0 1
      ----------			------------
      =  0 0 0 1			=	0 0 0 0
      ```

      So, to get the last bit of `I`, we can do the following operation: 	`[R3] ←  [R3] & 1 ` which will take 
      `10110011 & 00000001 = 00000001 ` and store the result  back into the register R3. 

    -  Next we need to bit rotations until the digit is in it's new proper place in the reversed integer. Each iteration will take one more rotation than the last to get the digit to it's proper place, and we are keeping track of this using the R2 register which we initialized to `1` earlier.  So lets apply the rotation on the register R3 for the first iteration.
      `[R3] ← ROTATE [R3] R2 TIMES`. This will rotate `00000001` one time, and store `10000000` in R3.

    - Now we will start keeping track of the result using the Register R0, by adding the byte from R3 to R0.

      `[R0] ← [R0] + [R3]`

    - Then we increase the value of R2 so that two rotations will happen in the next iteration.
      `[R2] ← [R2] + 1 `

    - Finally, before we end this iteration of the loop and begin the next, we need to shift-right the original binary number so that we can access the next digit that we need. (*Note: at the start, we stored our number in register R1*)
      `[R1] ← ShiftRight[R1]`, which will change R1's value from `10110011` to `1011001`

    - This algorithm would look something like this in high-level pseudocode

      ```c++
      // Pseudocode
      a = 10110011
      r = 1 // Number of rotations to perform
      total = 0 // variable where the resulting reversed integer will be stored
      for(int i = 0; i < N; i++){
           temp = a
           rotate(&temp, r) // performs a right bit rotation on temp of "r" bits
           total += temp    // adds new value of temp to the total
           r++;			 // increments the number of rotations for the next iteration
           ShiftRight(a)    // performs a right bit shift of the binary value stored in a 
      }
      ```

    - Now let's write assembly for the Motorola 68000.
         (The AND instruction is a binary "and" operation. The LSR instruction is a logical shift right. The ROR is rotate operand right.)
    
         ```asm
         ** CODE SECTION **
         START:
             MOVE #1, D3			; [D3] <- 1   (Initialize number of rotations to perform)
             MOVE.b value, D1	; [D1] <- [value] (move the set binary value into a register)
             jmp LOOP  			; Enter loop (recursive subroutine)
         LOOP:
             ** get last bit **
             MOVE D1,D2
             AND #1,D2			; Isolate the last digit 
             LSR #1,D1 			; bit shift D1 right
             
             ROR.b D3,D2    		; rotate right D2 by amount of bits specified by the value in D3
             ADD #1, D3  		; [D3] <- [D3] + 1    (increment rotation number)
             
             ADD D2,D0			; [D0] <- [D0] + [D2] (add new value to the total)
             
             ADD #1, D4  		; increment loop index
             CMP #N, D4				
             BGE EXIT			; IF [D4] >= 8 THEN EXIT	
             jmp loop			; ELSE loop
             
         EXIT:
             MOVE.b D0,reverse	; [reverse] <- [D0]Store final reversed binary value 
             				   ; into a variable stored in memory
             SIMHALT             ; halt simulator
         
         ** DATA SECTION **
         value   DC.b    %10110011 
         reverse DS.b 1
         N	EQU	8
             END    START        ; last line of source
         
         
         ```
    
         

