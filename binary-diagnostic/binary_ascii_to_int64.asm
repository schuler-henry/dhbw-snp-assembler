;----------------------------------------------------------------------------
; binary_ascii_to_int64.asm - convert ascii binary to integer
;----------------------------------------------------------------------------
;
; DHBW Ravensburg - Campus Friedrichshafen
;
; Vorlesung Systemnahe Programmierung (SNP)
;
;----------------------------------------------------------------------------
;
; Architecture:  x86-64
; Language:      NASM Assembly Language
;
; Author:        Henry Schuler
;
;----------------------------------------------------------------------------

;-----------------------------------------------------------------------------
; Section TEXT
;-----------------------------------------------------------------------------
SECTION .text

        global binary_ascii_to_int:function

binary_ascii_to_int:
        ; rsi: ascii binary number
        ; rdi: integer return value
        ; esp+8: ascii binary length 
        push    rbp
        mov     rbp,rsp
        push    rcx

        mov     rcx,0
loop:
        shl     rdi,1
        cmp     BYTE [rsi+rcx],'0'
        je      is_zero
is_one:
        inc     rdi
is_zero:
        inc     rcx
        cmp     rcx,[rbp+16]
        jb      loop

        pop     rcx
        pop     rbp
        ret
