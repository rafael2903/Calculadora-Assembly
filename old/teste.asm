%include  "io.mac"

section .data ; read-only data section
    input db "13254", 0 ;
    input2 db "rodou", 0
section .text
  global _start

_start:

    push input
    call string_number_to_integer
    PutLInt eax
    nwln
    ; add esp, 4

    ; PutStr input

  mov   eax, 1
  xor   edi, edi
  int   0x80

; int ascii_string_number_to_integer(char *str)
string_number_to_integer:
  enter 0, 0

  mov   ebx, 10
  mov   ecx, [ebp + 8]; ecx = str
  mov   edx, 0 ; valor atual
  mov   eax, 0 ; operações
  mov   edi, 0; resultado final
  mov   esi, 1 ; sinal

  mov   dl, [ecx] ; dl = str[i]
  cmp dl, "-"
  jne lp2
  inc ecx
  neg esi

  lp2:
    mov   edx, 0
    mov   dl, [ecx]
    cmp   dl, 0
    je    end
    sub   dl, "0"
    mov   eax, edi
    push  edx
    mul   ebx
    pop   edx
    mov   edi, eax ;
    mov   al , dl
    cbw
    cwde
    add   edi, eax
    inc   ecx
    jmp   lp2

  end:
  mov   eax, edi
  imul  esi

  pop  ebp
  ret   4
