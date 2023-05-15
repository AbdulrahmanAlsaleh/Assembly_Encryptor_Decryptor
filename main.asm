.ORIG x3000
    LEA R0 startmsg;loading start of program string into R0
    PUTS;printing
    start
    LEA R0 query;loading the String in R0
    PUTS;printing
    getc;getting the input
    ST R0 saveR0
    LD R1 D;r1 is now = -D
    ADD R1 R1 R0;add them both
    BRz Decrypt; if there equal then decrypt
    
    LD R1 E;r1 is now = -E 
    ADD R1 R1 R0
    BRz Encrypt;go to encryp if input isE
    
    
    LD R1 X;R1 is now =-X
    ADD R1 R1 R0;add to check if R0 is X
    BRz Xout;branch if 0
    
    BRnzp inval;go to invalid 
    
inval;first invalid case done between D E or X
    LEA R0 invalid;loading string 
    PUTS;printing 
    BRnzp start;restart
startmsg    .STRINGZ "\nSTARTING PRIVACY MODULE\n"
invalid     .STRINGZ "\nINVALID INPUT\n"
query       .STRINGZ "\nENTER E OR D OR X\n"
;must store them in an address or i will get errors in the code
D .FILL #-68;the 3 variable are to check if the input is either D E or X are stored in eiter 
E .FILL #-69
X .FILL #-88
nnum0 .FILL #-48;because the other one is two faer
current2 .BLKW #1;for R7 and jsr
SaveR0 .BLKW #1; to save the first input
Xout
    LD R0 mesloc;gets the data
    AND R1 R1 #0;clears R1
    STR R1 R0 #0;sets the number at x4000 to 0
    STR R1 R0 #1;keep doing it until x4009
    STR R1 R0 #2
    STR R1 R0 #3
    STR R1 R0 #4
    STR R1 R0 #5
    STR R1 R0 #6
    STR R1 R0 #7
    STR R1 R0 #8
    STR R1 R0 #9
    halt
    
invalidencryptkey
    LEA R0 invalid;loading string 
    PUTS;printing 
    BRnzp Encrypt

invaliddecryptkey
    LEA R0 invalid;loading string 
    PUTS;printing 
    BRnzp Decrypt


f3
    ST R7 current2;storing because of JSR 
    LD R6 mesloc;loading address x4000 to get the values
    LD R5 decloc;loading address x5000 to store the values
    
    LDR R4 R6 #0;gets the first charachter x4000
    JSR f3doit;gets the value after bitshift right stored in R3
    STR R3 R5 #0;storing the number in x5000
    ;for the rest of these we just do the same until x5009
    LDR R4 R6 #1;gets the second charachter x4001
    JSR f3doit
    STR R3 R5 #1
    
    LDR R4 R6 #2
    JSR f3doit
    STR R3 R5 #2
    
    LDR R4 R6 #3
    JSR f3doit
    STR R3 R5 #3
    
    LDR R4 R6 #4
    JSR f3doit
    STR R3 R5 #4
    
    LDR R4 R6 #5
    JSR f3doit
    STR R3 R5 #5
    
    LDR R4 R6 #6
    JSR f3doit
    STR R3 R5 #6
    
    LDR R4 R6 #7
    JSR f3doit
    STR R3 R5 #7
    
    LDR R4 R6 #8
    JSR f3doit
    STR R3 R5 #8
    
    LDR R4 R6 #9
    JSR f3doit
    STR R3 R5 #9


    LD R7 current2;goes back to the original PC so it doesnt crash
    
RET
Decrypt
    
    
    JSR Checkkey;checkkey asks for the input and checks if its valid
    
    ADD R6 R6 #0;this is just to check if its an error
    BRp invaliddecryptkey; if r6 is 1 then the key is wrong
    
    ST R1 SaveZ1;if they are valid store the values in their respective variables
    ST R2 SaveX1
    ST R3 SaveY1
    ST R4 SaveY2
    ST R5 SaveY3
    
    JSR f3;we do bit shift first because we go in reverse order
    
    JSR f2key;y1y2y3 is in r5 I just get the key
    JSR f2; Do the f2 decryption
    LD R5 gotode;its too far so i need to load for the xor decryption 
    JSRR R5;This is for F1 decryption
    
    
    
    BRnzp start;go back to the start
f3doit
    ADD R3 R4 #0;clear R3
    LD R2 nnum0;
    LD R1 SaveZ1;this is give R1 the actual value of a number
    ADD R1 R1 R2;the actual input 0 through 7
    bitrightl BRnz after2
        AND R0 R0 #0;as explained in my report this functoin goes to 0 and returns the counter for everytime we decremented by 2
        ADD R4 R3 #0
        inner Brnz afterin
            ADD R0 R0 #1
            ADD R3 R0 #0
            ADD R4 R4 #-2
        BRnzp inner
        afterin
        ADD R1 R1 #-1
    BRnzp bitrightl
    after2
    RET
f2
    ST R7 current;store for JSR
    NOT R5 R5 
    ADD R5 R5 #1;we put -key because of the solution
    ;
    LD R0 decloc;address x5000 to get the result of the decryption
    
    LD R1 decloc;address x5000 for storing the vairable
    
    LDR R2 R0 #0;gets the result of the decryption of bitshift
    JSR tester;do the module of decryption
    STR R6 R1 #0;store it in x5000
    ;then i do the same to the for every other until i reach x5009
    LDR R2 R0 #1
    JSR tester
    STR R6 R1 #1
    
    LDR R2 R0 #2
    JSR tester
    STR R6 R1 #2
    
    LDR R2 R0 #3
    JSR tester
    STR R6 R1 #3
    
    LDR R2 R0 #4
    JSR tester
    STR R6 R1 #4
    
    LDR R2 R0 #5
    JSR tester
    STR R6 R1 #5
    
    LDR R2 R0 #6
    JSR tester
    STR R6 R1 #6
    
    LDR R2 R0 #7
    JSR tester
    STR R6 R1 #7
    
    LDR R2 R0 #8
    JSR tester
    STR R6 R1 #8
    
    LDR R2 R0 #9
    JSR tester
    STR R6 R1 #9
    LD R7 current;load the JSR for PC
RET;return 
tester
    LD R3 N;gets -128
    NOT R4 R3;positive 128
    ADD R4 R4 #1;this method is for the 
    
    
    ADD R6 R2 R5;(ci-K)
    fff BRn afff
        ADD R6 R6 R3
    BRnzp fff
    afff
    ADD R6 R6 R4
    RET
  
Encrypt
    JSR Checkkey;this checks if the key is valid
    ADD R6 R6 #0;this is just to check if its an error
    BRp invalidencryptkey
    ;storing the key since it passed the test
    ST R1 SaveZ1;store the values in their respective variables
    ST R2 SaveX1
    ST R3 SaveY1
    ST R4 SaveY2
    ST R5 SaveY3
    LEA R0 promptmsg;print
    PUTS
    ;need 10 inputs lost in this case 
    JSR MSG;requests input of message
    JSR XORstore;stores and encrypts by XOR in x4000's
    JSR f2key;gets the key y1y2y3 is now stored in R5
    JSR f2encrypt;encypts by using the f2
    
    
    JSR f3e;bitshitft
    
    
    BRnzp start;return to the start of the program
f3e
    ST R7 current;loads the address for JSR
    LD R6 mesloc;loads the memory location #4000
    
    LDR R4 R6 #0;gets the first charachter
    JSR encryptor;does the encryption
    STR R4 R6 #0;stores it in x4000
    ST R4 m0;change the value of the message so m0 is now R4 which is after the encryption
    ;do the same for everyother encryption until x4009
    LDR R4 R6 #1;gets 
    JSR encryptor
    STR R4 R6 #1
    ST R4 m1
    
    LDR R4 R6 #2;gets
    JSR encryptor
    STR R4 R6 #2
    ST R4 m2
    
    LDR R4 R6 #3;gets 
    JSR encryptor
    STR R4 R6 #3
    ST R4 m3
    
    LDR R4 R6 #4;gets 
    JSR encryptor
    STR R4 R6 #4
    ST R4 m4
    
    LDR R4 R6 #5;gets
    JSR encryptor
    STR R4 R6 #5
    ST R4 m5
    
    LDR R4 R6 #6;gets
    JSR encryptor
    STR R4 R6 #6
    ST R4 m6
    
    LDR R4 R6 #7
    JSR encryptor
    STR R4 R6 #7
    ST R4 m7
    
    LDR R4 R6 #8
    JSR encryptor
    STR R4 R6 #8
    ST R4 m8
    
    LDR R4 R6 #9
    JSR encryptor
    STR R4 R6 #9
    ST R4 m9
    
    LD R7 current;load to return properly
RET;return
encryptor;the bitshift right
    LD R2 num0
    LD R1 SaveZ1
    ADD R1 R1 R2;give R1 the actual value of z1 
    bitleftl BRnz aftere
        ADD R4 R4 R4;keep adding until r1 is 0
        ADD R1 R1 #-1
    BRnzp bitleftl
    aftere
    RET;return R4


    

f2encrypt
    ;R5 is where the K is stored so I load te current m0
    ST R7 current;store the previous the value of R7 for return
    
    LD R6 mesloc;load the location
    LD R1 m0;the first memory
    JSR MODK;get the value of K+m(i)%128==0
    STR R4 R6 #0;store it at x4000
    ST R4 m0;resave it to m0
    ;under is the same for every key until x4009
    LD R1 m1
    JSR MODK
    STR R4 R6 #1
    ST R4 m1
    
    LD R1 m2
    JSR MODK
    STR R4 R6 #2
    ST R4 m2
    
    LD R1 m3
    JSR MODK
    STR R4 R6 #3
    ST R4 m3
    
    LD R1 m4
    JSR MODK
    STR R4 R6 #4
    ST R4 m4
    
    LD R1 m5
    JSR MODK
    STR R4 R6 #5
    ST R4 m5
    
    LD R1 m6
    JSR MODK
    STR R4 R6 #6
    ST R4 m6
    
    LD R1 m7
    JSR MODK
    STR R4 R6 #7
    ST R4 m7
    
    LD R1 m8
    JSR MODK
    STR R4 R6 #8
    ST R4 m8
    
    LD R1 m9
    JSR MODK
    STR R4 R6 #9
    ST R4 m9
    
    LD R7 current
    RET
gotode .FILL XORdecrypt
decloc .FILL x5000
mesloc .FILL x4000
MODK
    
    
    LD R2 N;-128 or N
    NOT R3 R2;positive 127
    ADD R3 R3 #1;128
    ADD R4 R1 R5;m(i)+k(which is y1y2y3)
    loop BRn endloop;if negative add k if 
    
    ADD R4 R4 R2
    BRnzp loop
    
    endloop
    
    ADD R4 R4 R3
    
    RET
    
f2key   
    ;all of this is y1
    AND R5 R5 #0;where the solution is stored
    LD R1 savey1;this just gets the key for y1y2y3
    LD R2 num0;if 0 then just add it since it wont mater
    ADD R1 R1 R2
    BRz skip100;if its not zero then add 100 because it cant be any other number
    LD R1 num100
    ADD R5 R5 R1
    skip100
    
    ;y2
    LD R1 SaveY2;loop that adds 10 each time until savey2 is 0
    ADD R1 R1 R2
    loopofkey BRnz afterkey2
    ADD R5 R5 #10
    ADD R1 R1 #-1
    BRnzp loopofkey
    afterkey2
    ;y3
    LD R1 SaveY3;;just add the value 
    ADD R1 R1 R2
    ADD R5 R5 R1
    
    
    
RET

SaveZ1 .BLKW #1;this 5 variables are to store the current key
SaveX1 .BLKW #1
SaveY1 .BLKW #1
SaveY2 .BLKW #1
SaveY3 .BLKW #1
;variables here to reach the solution
keymsg      .STRINGZ "\nENTER KEY\n"
promptmsg   .STRINGZ "\nENTER MESSAGE\n"


current .BLKW #1;FOR JSR


N .FILL #-128;mod 
num100 .FILL #100; the actual number 100 for y1

num0 .FILL #-48;numbers for error checking
num9 .FILL #-57;
num8 .FILL #-56
num7 .FILL #-55
num2 .FILL #-50
num1 .FILL #-49

m0 .BLKW #1;where i store the message
m1 .BLKW #1
m2 .BLKW #1
m3 .BLKW #1
m4 .BLKW #1
m5 .BLKW #1
m6 .BLKW #1
m7 .BLKW #1
m8 .BLKW #1
m9 .BLKW #1



    


XORstore
    ;maybe delete the delete load r1 mesloc
    ST R7 current;stores the address to reuse later
    LD R0 m0;for m0
    LD R1 SaveX1;get X1
    LD R3 num0;get the num0
    ADD R3 R3 R1;check if its zero
    BRz skipstore;skip storing since its zero
    LD R6 mesloc
    
    JSR XORencryption; do the encryption\
    STR R5 R6 #0;save the value to x4000
    ST R5 m0;resave it to m0
    
    LD R0 m1;load the second message charachter
    JSR XORencryption;encrypt
    STR R5 R6 #0;store it inx4001
    ST R5 m1;resave it
    ;keep doing until we reach m9 or x4009
    LD R0 m2;for m2
    JSR XORencryption
    STR R5 R6 #2
    ST R5 m2;
    
    LD R0 m3;for m3
    JSR XORencryption
    STR R5 R6 #3
    ST R5 m3
    
    LD R0 m4;for m4
    JSR XORencryption
    STR R5 R6 #4
    ST R5 m4
    
    LD R0 m5;for m5
    JSR XORencryption
    STR R5 R6 #5
    ST R5 m5
    
    
    LD R0 m6;for m6
    JSR XORencryption
    STR R5 R6 #6
    ST R5 m6
    
    LD R0 m7;for m7
    JSR XORencryption
    STR R5 R6 #7
    ST R5 m7
    
    
    LD R0 m8;for m8
    JSR XORencryption
    STR R5 R6 #8
    ST R5 m8
    
    LD R0 m9;for m9
    JSR XORencryption
    STR R5 R6 #9
    ST R5 m9
    
    skipstore;if x1 is 0
    LD R7 current;load for PC
    RET

MSG
        ;need 10 inputs lost in this case 
    LD R1 mesloc;loads the addressx4000
    getc;input
    ST R0 m0;store it in m0 and x4000
    STR R0 R1 #0
    ;do the same until x4009 or m9
    getc
    ST R0 m1
    STR R0 R1 #1
    getc
    ST R0 m2
    STR R0 R1 #2
    getc
    ST R0 m3
    STR R0 R1 #3
    getc
    ST R0 m4
    STR R0 R1 #4
    getc
    ST R0 m5
    STR R0 R1 #5
    getc
    ST R0 m6
    STR R0 R1 #6
    getc
    ST R0 m7
    STR R0 R1 #7
    getc
    ST R0 m8
    STR R0 R1 #8
    getc
    ST R0 m9
    STR R0 R1 #9
    
    RET
XORdecrypt
    ST R7 CURRENT;stores R7 in current to go into another JSR method
    LD R7 mesloc;x4000
    
    LD R1 SaveX1;gets the encryption of x1
    LD R3 num0;get the - num0
    ADD R3 R3 R1;check if its zero
    BRz skipxordecrypt;skip storing since its zero
    LD R6 decloc;load the location
    
    LD R7 decloc;x4000
    LDR R0 R7 #0;gets it @4001
    JSR XORencryption;decrypt
    STR R5 R6 #0;store it in x5000
    ;I know i could have used R6 for both. Also,leep doing it until I reachx5009
    LD R7 decloc;x4000
    LDR R0 R7 #1
    JSR XORencryption
    STR R5 R6 #1
    
    LD R7 decloc;x4000
    LDR R0 R7 #2
    JSR XORencryption
    STR R5 R6 #2
    
    LD R7 decloc;x4000
    LDR R0 R7 #3
    JSR XORencryption
    STR R5 R6 #3
    
    LD R7 decloc;x4000
    LDR R0 R7 #4
    JSR XORencryption
    STR R5 R6 #4
    
    LD R7 decloc;x4000
    LDR R0 R7 #5
    JSR XORencryption
    STR R5 R6 #5
    
    LD R7 decloc;x4000
    LDR R0 R7 #6
    JSR XORencryption
    STR R5 R6 #6
    
    LD R7 decloc;x4000
    LDR R0 R7 #7
    JSR XORencryption
    STR R5 R6 #7
    
    LD R7 decloc;x4000
    LDR R0 R7 #8
    JSR XORencryption
    STR R5 R6 #8
    
    LD R7 decloc;x4000
    LDR R0 R7 #9
    JSR XORencryption
    STR R5 R6 #9
    
    skipxordecrypt
    LD R7 CURRENT
    
    RET
XORencryption
    ;STRING.charAt(i) XOR X1
    ;just copied the homewor
    AND R2 R1 #0;clear the variables
    AND R3 R1 #0
    AND R4 R1 #0
    
    
    ADD R3 R0 #0
    NOT R3 R3
    
    ADD R4 R1 #0
    NOT R4 R4
    
    AND R3 R3 R1
    NOT R3 R3
    
    AND R4 R4 R0
    NOT R4 R4
    
    AND R5 R4 R3;and both of the above
    NOT R5 R5;complement it
    
    RET 
Checkkey
    LEA R0 keymsg
    puts
    AND R1 R1 #0;clear R1
    AND R2 R1 #0;clear R2
    AND R3 R1 #0;clear R3
    AND R4 R1 #0;clear R4
    AND R5 R1 #0;clear R5
    AND R6 R6 #0;clear R6 to check if its invalid
    
    getc;does he want us to do this 5 times
    ADD  R1 R1 R0;must be between 0 and 8
    getc
    ADD  R2 R2 R0;must be non numeric number unless its 0
    getc
    ADD  R3 R3 R0
    getc
    ADD  R4 R4 R0
    getc
    ADD  R5 R5 R0
    ;z1
    LD R0 num7
    ADD R0 R0 R1;check if its more than maximum
    BRp invaly
    
    LD  R0 num0;checking first input 
    ADD R0 R0 R1;check if its less the minimum
    BRn invaly
    
    ;x1 checking
    LD R0 num9;100% works
    ADD R0 R0 R2;check the number 9
    BRnz case1; if its less than 9 we check if its less than 1
    
    LD R0 num1
    ADD R0 R0 R2
    BRzp case2; if its more than 0 then check if its more than 9 else wrong input
    continue
    
    
    ;y1 checking
    ;JSR f2key;need to complete R5 has the number of y1 y2 y3
    LD R0 num0;check if the number is 0
    ADD R0 R0 R3;
    BRz if0;if its a 0 then go to other procedures
    
    LD R0 num1;check if the number is 1
    ADD R0 R0 R3
    BRz if1;if its a 1 then its go to test the cases
    
    BRnzp invaly; if the third charachter is not a 1 or a 0 then its an invalid key
    
    
    
    ending;go to valid if it works
    RET
maxofy .FILL #-128
case1
    LD R0 num0
    ADD R0 R0 R2;check if its less than 1
    BRnz continue;if less than 1 then go to 0
    BRnzp invaly;if not its an invalid key
    
case2
    LD R0 num9;load the number 9
    ADD R0 R0 R2;compare it to the second input
    BRzp continue;if its more than 9 then we should just continue
    BRnzp invaly;if its not then invalid

if1
;if the number 1 we have to ch
    LD R0 num2;check if the maximum is more than 2
    ADD R0 R0 R4
    BRp invaly;if more than 2 then its invalid
    BRz if12;if 2 it means the next number cant be more than 7
    
    
    LD R0 num0;check if the number is less than zer0
    ADD R0 R0 R4
    BRn invaly
    
    
    ;y3 number test
    LD R0 num0;check if the 5th number is less than 0
    ADD R0 R0 R5
    BRn invaly
    
    LD R0 Num9;check if the 5th number is more than 0
    ADD R0 R0 R5
    Brp invaly
    
    
    BRnzp ending;if it didnt branch 


if12;this is because if the first key in so the last number must be less than or equal to 7
    LD R0 num7;check if the number is more than 7 
    ADD R0 R0 R5
    BRp invaly
    
    LD R0 Num0;check if the 5th number is less than 0
    ADD R0 R0 R5
    Brn invaly
    
    BRnzp ending
    
    
if0;if the number 0
    ;y2 number test since the maximum cant happen we can just forget about it
    LD R0 num0;check if the 4th number is less than 0
    ADD R0 R0 R4
    BRn invaly
    
    LD R0 Num9;check if the 4th number is more than 0
    ADD R0 R0 R4
    Brp invaly
    

    ;y3 number test
    LD R0 num0;check if the 5th number is less than 0
    ADD R0 R0 R5
    BRn invaly
    
    LD R0 Num9;check if the 5th number is more than 9
    ADD R0 R0 R5
    Brp invaly
    
    BRnzp ending
invaly
    ADD R6 R6 #1;there is atleast one error so just skip the process
    BRnzp ending
.END
.ORIG x4000;this is where i store the encrypted message message
.END
.ORIG x5000;this is where I decrypt the message
.END