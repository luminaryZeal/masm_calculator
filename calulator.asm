{\rtf1\ansi\ansicpg1252\deff0{\fonttbl{\f0\fnil\fprq1\fcharset0 Courier New;}{\f1\fnil\fcharset0 Calibri;}}
{\*\generator Msftedit 5.41.21.2509;}\viewkind4\uc1\pard\sa200\sl276\slmult1\lang1033\f0\fs20 TITLE MASM main (main.asm)\par
INCLUDE Irvine32.inc\par
.data\par
\par
number1 BYTE 50 DUP(0) ; number 1 length buffer\par
n1bytecount DWORD ? ; holds number 1 length\par
\par
number2 BYTE 50 DUP(0) ; number 2 length buffer\par
n2bytecount DWORD ? ; holds number 2 length\par
\par
number3 BYTE 50 DUP(0) ; variable use number\par
nmaxbytecount DWORD ? ;holds greatest length\par
\par
numprompt1 BYTE "Enter a number to be added >",0\par
numprompt2 BYTE "Enter a second number to be added >", 0\par
\par
\par
.code\par
\par
MAIN PROC\par
\tab\par
\par
\par
\tab call Clrscr\par
\tab\par
\par
\par
GETNUM1:\par
\tab ;number 1\par
\tab mov edx, OFFSET numprompt1 ;load location of buffer\par
\tab call writestring ; send message to monitor\par
\tab\par
\tab ;read input for number 1 from the command line\par
\tab mov edx, OFFSET number1 ; load the location of the buffer for num1\par
\tab mov ecx, SIZEOF number1 ;max input number size\par
\tab call readstring ; read typed value stored at edx and ecx\par
\tab mov n1bytecount, eax ; eax returns actual input length\par
\tab call crlf\par
\tab\par
\tab ;check if something was entered\par
\tab cmp eax,0\par
\tab je EMPTYNUMBER1\par
\tab\par
GETNUM2:\par
\tab ;number 2\par
\tab mov edx, OFFSET numprompt2\par
\tab call writestring\par
\tab\par
\tab ;read input for number 2 from command line\par
\tab mov edx, OFFSET number2\par
\tab mov ecx, SIZEOF number2\par
\tab call readstring\par
\tab mov n2bytecount, eax\par
\tab call crlf\par
\tab\par
\tab ;check if something was entered\par
\tab cmp eax, 0\par
\tab je EMPTYNUMBER2\par
\tab jmp FILLNUM3\par
\tab\par
EMPTYNUMBER1:\par
\tab mov number1, '0'\par
\tab mov n1bytecount[0], 1\par
\tab jmp GETNUM2\par
\par
EMPTYNUMBER2:\par
\tab mov number2, '0'\par
\tab mov n2bytecount, 1\par
\tab jmp FILLNUM3\par
\par
FILLNUM3:\tab\par
\tab ;fill number 3 with ascii 0's\par
\tab mov eax, 0\par
\tab mov esi, 0\par
\tab mov eax, n1bytecount\par
\tab cmp eax, n2bytecount\par
\tab jge FILLNUM3LOOP\par
\tab mov eax, n2bytecount\par
\par
\tab FILLNUM3LOOP:\par
\tab\tab mov number3[esi], '0'\par
\tab\tab inc esi\par
\tab\tab cmp eax,esi\par
\tab\tab jne FILLNUM3LOOP\par
\tab\tab\par
\tab ; eax holds the greatest length\par
\tab mov nmaxbytecount, eax\par
\tab\par
REVERSENUMBERS:\par
;reverse the numbers to make math easier\par
\tab\par
\tab ;assign max location to di\par
\tab mov eax, 0\par
\tab mov eax, n1bytecount\par
\tab mov esi, eax ; if 5 long, then need to iterate 5 times 0-4\par
\tab mov edi, 0\par
\par
\tab REVERSENUM1LOOP:\par
\tab\tab mov al, number1[edi]\par
\tab\tab inc edi\par
\tab\tab dec esi\par
\tab\tab mov number3[esi], al\par
\tab\tab jnz REVERSENUM1LOOP ;looks at esi register\par
\tab\par
\tab mov esi, 0\par
\tab\par
\tab ; move the value back to number1\par
\tab MOVNUM3TONUM1LOOP:\par
\tab\tab mov al, number3[esi]\par
\tab\tab mov number1[esi], al\par
\tab\tab inc esi\par
\tab\tab cmp esi, n1bytecount\par
\tab\tab jne MOVNUM3TONUM1LOOP\par
\tab\tab\par
\tab ; do the same for number2\par
\tab mov eax, 0\par
\tab mov eax, n2bytecount\par
\tab mov esi, eax\par
\tab mov edi, 0\par
\par
\tab REVERSENUM2LOOP:\par
\tab\tab mov al, number2[edi]\par
\tab\tab inc edi\par
\tab\tab dec esi\par
\tab\tab mov number3[esi], al\par
\tab\tab jnz REVERSENUM2LOOP ;looks at esi register\par
\tab\par
\tab mov esi, 0\par
\tab\par
\tab ; move the value back to number1\par
\tab MOVNUM3TONUM2LOOP:\par
\tab\tab mov al, number3[esi]\par
\tab\tab mov number2[esi], al\par
\tab\tab inc esi\par
\tab\tab cmp esi, n2bytecount\par
\tab\tab jne MOVNUM3TONUM2LOOP\par
\tab\tab\par
; add trailing zeros to smaller length number\par
APPENDTRAILINGZEROSTOSMALL:\par
\tab mov eax, n1bytecount\par
\tab cmp eax, n2bytecount\par
\tab jl TRAILINGZEROSNUM1\par
\tab jg TRAILINGZEROSNUM2\par
\tab jmp CONVERTFROMASCII\par
\tab\par
\tab TRAILINGZEROSNUM1: \par
\tab\tab mov esi, n1bytecount ;location of next digit\par
\tab\tab TRAILINGZEROSNUM1LOOP:\par
\tab\tab\tab mov number1[esi], '0'\par
\tab\tab\tab inc esi\par
\tab\tab\tab cmp esi, nmaxbytecount\par
\tab\tab\tab jl TRAILINGZEROSNUM1LOOP\par
\tab\tab\tab jmp CONVERTFROMASCII\par
\tab\tab\tab\par
\tab TRAILINGZEROSNUM2: \par
\tab\tab mov esi, n2bytecount ;location of next digit\par
\tab\tab TRAILINGZEROSNUM2LOOP:\par
\tab\tab\tab mov number2[esi], '0'\par
\tab\tab\tab inc esi\par
\tab\tab\tab cmp esi, nmaxbytecount\par
\tab\tab\tab jl TRAILINGZEROSNUM2LOOP\par
\tab\tab\tab jmp CONVERTFROMASCII ; jump not necessary, but helps for defensive, modular coding\par
\par
CONVERTFROMASCII:\par
\tab mov esi, 0\par
\tab\par
\tab N1FROMASCIILOOP:\par
\tab\tab mov al, number1[esi]\par
\tab\tab sub al, 30h\par
\tab\tab mov number1[esi], al\par
\tab\tab inc esi\par
\tab\tab cmp esi, nmaxbytecount\par
\tab\tab jl N1FROMASCIILOOP\par
\tab\par
\tab mov esi, 0\par
\tab\par
\tab N2FROMASCIILOOP:\par
\tab\tab mov al, number2[esi]\par
\tab\tab sub al, 30h\par
\tab\tab mov number2[esi], al\par
\tab\tab inc esi\par
\tab\tab cmp esi, nmaxbytecount\par
\tab\tab jl N2FROMASCIILOOP\par
\tab\tab\par
\par
;add with carry\par
mov esi, 0\par
mov eax, 0\par
mov ebx, 0\par
mov ecx, nmaxbytecount ;nmaxbytecount contains greatest length\par
mov edx, 0\par
\par
ADDNUMBERSLOOP:\par
\tab mov al, number1[esi]\par
\tab mov bl, number2[esi]\par
\tab add eax, ebx\par
\tab add eax, edx\par
\tab mov edx, 0\par
\tab\par
\tab cmp eax, 0ah\par
\tab jl NOCARRY\par
\tab mov edx, 1\par
\tab sub eax, 0ah\par
\tab\par
\tab NOCARRY:\par
\tab mov number3[esi], al\par
\tab inc esi\par
\tab cmp esi, ecx\par
\tab jl ADDNUMBERSLOOP\par
\tab ;if loop would end, check for final carry\par
\tab cmp edx, 1\par
\tab jge ADDFINALCARRY\par
\tab jmp REVERSENUMBERSFINAL\par
\tab\par
\tab ADDFINALCARRY:\par
\tab\tab mov number3[esi], 1 ;esi already incremented\par
\tab\tab mov eax, nmaxbytecount\par
\tab\tab add eax, 1\par
\tab\tab mov nmaxbytecount, eax\par
\tab\tab\par
REVERSENUMBERSFINAL:\par
\par
\tab mov esi, 0\par
\tab\par
\tab ; move the final value to number1, and convert to ascii\par
\tab MOVERESULTTONUM1:\par
\tab\tab mov al, number3[esi]\par
\tab\tab ;convert the number to ascii\par
\tab\tab add al, 30h\par
\tab\tab mov number1[esi], al\par
\tab\tab inc esi\par
\tab\tab cmp esi, nmaxbytecount\par
\tab\tab jne MOVERESULTTONUM1\par
\tab\tab\par
\tab ;assign max location to esi\par
\tab mov eax, 0\par
\tab mov eax, nmaxbytecount\par
\tab mov esi, eax\par
\tab mov edi, 0\par
\par
\tab REVERSERESULTLOOP:\par
\tab\tab mov al, number1[edi]\par
\tab\tab inc edi\par
\tab\tab dec esi\par
\tab\tab mov number3[esi], al\par
\tab\tab jnz REVERSERESULTLOOP ;looks at esi register\par
\tab\tab\par
\tab MOVERESULTTONUM1FINAL:\par
\tab\tab mov al, number3[esi]\par
\tab\tab mov number1[esi], al\par
\tab\tab inc esi\par
\tab\tab cmp esi, nmaxbytecount\par
\tab\tab jne MOVERESULTTONUM1FINAL\par
\tab\par
mov edx, OFFSET number1\par
call writestring\par
call crlf\par
\par
; clearing the numbers and adding the jump was done for testing\par
;mov eax, 0\par
;mov number1, ah\par
;mov number2, ah\par
\par
;jmp GETNUM1\par
\par
exit\par
MAIN ENDP\par
END main\lang9\f1\fs22\par
}
 