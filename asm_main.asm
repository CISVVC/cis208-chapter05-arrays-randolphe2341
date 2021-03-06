;
; File: asm_main.asm
;
; Author: Ethan Randolph
;
; Description: This program will use a subprogram to multiply an entire array by a scalar
;
; Email: randolphe@student.vvc.edu
;
; Date Created: 11/12/18

%define ARRAY_SIZE 5
%include "asm_io.inc"
;
; initialized data is put in the .data segment
;
segment .data
        syswrite: equ 4
        stdout: equ 1
        exit: equ 1
        SUCCESS: equ 0
        kernelcall: equ 80h
	; My values for program
	array1: dw 1,2,3,4,5
	size1: dd ARRAY_SIZE
	scalar1: dd 10 

; uninitialized data is put in the .bss segment
;
segment .bss

;
; code is put in the .text segment
;
segment .text
        global  asm_main
asm_main:
        enter   0,0               ; setup routine
        pusha
; *********** Start  Assignment Code *******************
	; First, this program will print out the initial values of array1
	mov ebx,0
	while3:
	cmp ebx,4
	jg then3
		mov ax,[array1+2*ebx]
		movzx eax,ax
		call print_int
		call print_nl
		inc ebx
		jmp while3
	then3:
	; Now, the program will call the subprogram arrayScalarMultiplier to multiply the array
	push dword array1
	push dword [size1]
	push dword [scalar1]
	call arrayScalarMultiplier
	add esp, 12
	; Finally, the program will print out the new values of array1
	mov ebx,0
	while2:
	cmp ebx,4
	jg then2
		mov ax,[array1+2*ebx]
		movzx eax,ax
		call print_int
		call print_nl
		inc ebx
		jmp while2
	then2:
        popa
        mov     eax, SUCCESS       ; return back to the C program
        leave                     
        ret
;------------------------------------------------------------
; Subprogram: arrayScalarMultiplier
; Parameters: (in order pushed to stack)
;	The array that will be multiplied [ebp+16]
;	The size of the array [ebp+12]
;	The scalar each array entry will be multiplied by [ebp+8]
; Notes:
;	While ax, ebx, and ecx are used, their values are first pushed to the stack,
;	then popped afterwards. In other words, their original values before this
;	subprogram was called are restored.
segment .text
arrayScalarMultiplier:
	;Prologue
	push ebp
	mov ebp, esp
	push ecx
	push ebx
	push eax
	; Subprogram code
	mov ecx, [ebp+16] ; Address of array is moved to ecx
	mov ebx, [ebp+12] ; The size of the array (int) is moved to ebx
	sub ebx,1 ; The size is subtracted by 1 because 0 is a number in the calculations (0,1,2,3,4)
	while:
	cmp ebx,0
	jl then ;if ebx is not 0 yet, keep going.
		mov ax,[ecx+2*ebx] ;the value of the array: ax = array1[ebx]
		imul ax,[ebp+8] ; ax * size = ax
		mov [ecx+2*ebx],ax ; Now the new value of ax replaces its old value: array1[ebx] = ax
		dec ebx ; ebx--
		jmp while
	then:
	;Epilogue
		pop eax
		pop ebx
		pop ecx
		pop ebp
		ret
; *********** End Assignment Code **********************
