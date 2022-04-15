;----------------------------------------------------------------------------
; binary-diagnostic64.asm
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

%include "syscall.inc"  ; OS-specific system call macros

extern          binary_ascii_to_int
extern          uint_to_ascii

;-----------------------------------------------------------------------------
; CONSTANTS
;-----------------------------------------------------------------------------

;-----------------------------------------------------------------------------
; Section DATA
;-----------------------------------------------------------------------------
SECTION .data

zerototal:      dq 0
onetotal:       dq 0
reportrows:     dq 12                           ; corelates to number of rows in report section
reportcolumns:  dq 5                            ; corelates to number of columns in report section

report:         db "00100"
                db "11110"
                db "10110"
                db "10111"
                db "10101"
                db "01111"
                db "00111"
                db "11100"
                db "10000"
                db "11001"
                db "00010"
                db "01010"
.output         db "Gamma:             "
.gamma          db "_____",10
                db "Epsilon:           "
.epsilon        db "_____",10
report_len      equ $-report.output
                db 0

outstr:         db "Power Consumption: "
.power          db "    ",10,10
outstr_len      equ $-outstr
                db 0

;-----------------------------------------------------------------------------
; Section RODATA
;-----------------------------------------------------------------------------
SECTION .rodata

;-----------------------------------------------------------------------------
; Section BSS
;-----------------------------------------------------------------------------
SECTION .bss

;-----------------------------------------------------------------------------
; Section TEXT
;-----------------------------------------------------------------------------
SECTION .text

        ;-----------------------------------------------------------
        ; PROGRAM'S START ENTRY
        ;-----------------------------------------------------------
%ifidn __OUTPUT_FORMAT__, macho64
        DEFAULT REL
        global start                            ; make label available to linker
start:                                          ; standard entry point for ld
%else
        DEFAULT ABS
        global _start:function                  ; make label available to linker
_start:
%endif
setup_loop:
        mov     rcx,0                           ; outer loop -> columns
column_loop:
        mov     r8,0                            ; inner loop -> rows
        mov     QWORD [zerototal],0             ; count zeros for row
        mov     QWORD [onetotal],0              ; count ones for row
row_loop:
        mov     rax,QWORD [reportcolumns]       ; load rowwidth to rax
        mul     r8w                             ; multiply by current row
        add     rax,rcx                         ; add column offset
        add     rax,report                      ; add report adress -> get current adress
        cmp     BYTE [rax],'1'                  ; check wheter char is '1'
        je      one
zero:
        inc     QWORD [zerototal]               ; registerd '0'
        jmp     continue_row_loop
one:
        inc     QWORD [onetotal]                ; registerd '1'
continue_row_loop:
        inc     r8                              ; row successfully registered
        cmp     r8,[reportrows]                 ; check for end of row
        jb      row_loop
finished_row_loop:
        mov     rax,QWORD [zerototal]
        cmp     rax,QWORD [onetotal]            ; compare amoutn of red '0' with '1'
        jb      gamma_one               
        mov     BYTE [report.gamma+rcx],'0'     ; gamma is '0', epsilon is '1'
        mov     BYTE [report.epsilon+rcx],'1'
        jmp     prepare_next_column
gamma_one:
        mov     BYTE [report.gamma+rcx],'1'     ; gamma is '1', epsilon is '0'
        mov     BYTE [report.epsilon+rcx],'0'
prepare_next_column:
        inc     rcx                             ; column successfully registered
        cmp     rcx,[reportcolumns]             ; check for end of column
        jb      column_loop

        ;-----------------------------------------------------------
        ; convert gamma to integer
        ;-----------------------------------------------------------
        mov     rsi,report.gamma
        mov     rdi,0
        push    QWORD [reportcolumns]
        call    binary_ascii_to_int
        pop     QWORD [reportcolumns]
        mov     rax,rdi
        
        ;-----------------------------------------------------------
        ; convert epsilon to integer
        ;-----------------------------------------------------------
        push    rax                             ; push gamma integer value
        mov     rsi,report.epsilon
        mov     rdi,0
        push    QWORD [reportcolumns]
        call    binary_ascii_to_int
        pop     QWORD [reportcolumns]

        ;-----------------------------------------------------------
        ; calculate power consumption
        ;-----------------------------------------------------------
        pop     rax                             ; get gamma integer value
        mul     rdi                             ; multiply by epsilon integer value

        mov     rsi,rax
        mov     rdi,outstr.power
        push    QWORD [reportcolumns]
        call    uint_to_ascii
        pop     QWORD [reportcolumns]
        
        ;-----------------------------------------------------------
        ; print gamma, epsilon and power consumption
        ;-----------------------------------------------------------
        SYSCALL_4 SYS_WRITE, FD_STDOUT, report.output, report_len

        SYSCALL_4 SYS_WRITE, FD_STDOUT, outstr, outstr_len
        
        ;-----------------------------------------------------------
        ; create label before program exit for our gdb script
        ;-----------------------------------------------------------
_exit:
        ;-----------------------------------------------------------
        ; call system exit and return to operating system / shell
        ;-----------------------------------------------------------
        SYSCALL_2 SYS_EXIT, 0

        ;-----------------------------------------------------------
        ; END OF PROGRAM
        ;-----------------------------------------------------------

