section .text
bits 32
global _start
extern exit, scanf, printf
import exit msvcrt.dll
import scanf msvcrt.dll
import printf msvcrt.dll
section .data
format_decimal db "%d",0
super dd 0
temp1 dd 1
temp2 dd 1
temp3 dd 1
temp4 dd 1
temp5 dd 1
temp6 dd 1
temp7 dd 1
_start:
mov eax, [a]
mul eax, [a]
mov [temp1], eax
mov eax, [super]
sub eax, [temp1]
mov [temp2], eax
mov eax, [super]
add eax, [temp2]
mov [temp3], eax
mov eax, [super]
sub eax, [temp3]
mov [temp4], eax
mov eax, [super]
div eax, [temp4]
mov [temp5], eax
mov eax, [super]
mul eax, [temp5]
mov [temp6], eax
mov eax, [temp6]
mov [super], eax
mov eax, [super]
add eax, [super]
mov [temp7], eax
mov eax, [temp7]
mov [super], eax
push dword [super]
push dword format_decimal
call [printf]
add esp,4*2
push dword 0
call [exit]
