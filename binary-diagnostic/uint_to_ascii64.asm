;-----------------------------------------------------------------------------
; uint_to_ascii64.asm - convernts integer number to ascii number
;-----------------------------------------------------------------------------
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
; Author:        Ralf Reutemann
; Created:       2021-12-02
;
; Editet by:     Henry Schuler
; Edited:        2022-01-14
;
;----------------------------------------------------------------------------

;-----------------------------------------------------------------------------
; Section TEXT
;-----------------------------------------------------------------------------
SECTION .text

        global uint_to_ascii:function

uint_to_ascii:
        ; rdi: number in ascii (return value)
        ; rsi: number as int (input value)
        ; rcx: loopcounter for number positions
        ; rbx: divisor for division

        push    rbp
        mov     rbp,rsp
        push    rcx                     ; safe all required registers
        push    rbx     

        mov     rcx,[rbp+16]            ; set loop counter (row-width)
        test    rsi,rsi
        jnz     .loop_start             ; only start if input > 0
        mov     byte [rdi+rcx-1],'0'    ; if 0 -> set to ascii 0 and exit
        jmp     .loop_exit

.loop_start:
        mov     rbx,10                  ; set divisor rbx to 10 (decimal)
        mov     rax,rsi                 ; copy given number into accumulator
.loop:
        ;-----------------------------------------------------------
        ; loop through every decimal position of rsi and transform to ascii
        ;-----------------------------------------------------------
        test    rax,rax                 ; test accu for 0 -> exit
        jz      .loop_exit
        xor     rdx,rdx                 ; empty rdx for division
        div     rbx                     ; divide rax by divisor rbx
        add     dl,'0'                  ; rest is safed in dl -> add ascii 0 to get ascii number
        mov     byte [rdi+rcx-1],dl     ; safe ascii number into return string
        dec     rcx                     ; decrement loop counter for next digit
        jnz     .loop
.loop_exit:
        pop     rbx                     ; restore all safed registers
        pop     rcx
        pop     rbp
        ret
