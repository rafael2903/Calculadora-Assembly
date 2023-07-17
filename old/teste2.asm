%include "io.mac"
section .data
    str_buffer db "111111", 0xa  ; Tamanho do buffer para armazenar a string (10 dígitos + 1 para o sinal ou terminador de string)
    overflow_msg db "OCORREU OVERFLOW", 0x0

section .bss


section .text
global _start

_start:

    ; mov edi, -234
    mov esi, str_buffer
    push esi
    call string_number_to_integer_16bits

    nwln
    PutInt ax
    ; PutInt 111111
    nwln

    mov eax, 1
    mov ebx, 0
    int 0x80

; int string_number_to_integer(char *str)
string_number_to_integer_16bits:
  enter 6, 0
  mov   ecx, [ebp + 8]        ; ecx = str
  mov   dx, 0                ; valor atual
  mov   [ebp - 2], word 10   ; base
  mov   [ebp - 4], word 0    ; resultado final
  mov   [ebp - 6], word 1   ; sinal

  mov   dl, [ecx]       ; dl = str[i]
  cmp   dl, "-"
  jne   lp2
  inc   ecx
  neg   word [ebp - 12]             ; sinal = -1
  lp2:
    mov   dx, 0
    mov   dl, [ecx]
    cmp   dl, 0xa
    je    done
    sub   dl, "0"
    mov   ax, word [ebp - 4]
    push  dx
    mul   word [ebp - 2]
    jo    overflow
    pop   dx
    mov   word [ebp - 4], ax ;
    mov   al , dl
    cbw
    cwde
    add   word [ebp - 4], ax
    jc    overflow
    inc   ecx
    jmp   lp2

  done:
    mov   ax, word [ebp - 4]
    imul  word [ebp - 6] ; Ajusta o sinal
    js    overflow

  end:
    leave
    ret   4

  overflow:
    PutStr overflow_msg
    jmp end
