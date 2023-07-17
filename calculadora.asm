section .data
  welcome_msg   db  "Bem-vindo. Digite seu nome:", 10
  welcome_msg_len equ $ - welcome_msg
  welcome2_msg1 db  "Hola, "
  welcome2_msg1_len equ $ - welcome2_msg1
  welcome2_msg2 db  ", bem-vindo ao programa de CALC IA-32", 10
  welcome2_msg2_len equ $ - welcome2_msg2
  question_msg  db  "Vai trabalhar com 16 ou 32 bits? (digite 0 para 16, e 1 para 32):", 10
  question_msg_len equ $ - question_msg
  menu_msg   db     "ESCOLHA UMA OPÇÃO: ",10,"- 1: SOMA ",10,"- 2: SUBTRACAO ",10,"- 3: MULTIPLICACAO ",10,"- 4: DIVISAO ",10,"- 5: EXPONENCIACAO ",10,"- 6: MOD ",10,"- 7: SAIR", 10
  menu_msg_len equ $ - menu_msg
  first_operand_msg db "Digite o primeiro operando: ", 10
  first_operand_msg_len equ $ - first_operand_msg
  second_operand_msg db "Digite o segundo operando: ", 10
  second_operand_msg_len equ $ - second_operand_msg
  result_msg db "O resultado da operação é: ", 10
  result_msg_len equ $ - result_msg
  overflow_msg db "OCORREU OVERFLOW", 10
  overflow_msg_len equ $ - overflow_msg
  continue_msg db 10, 10, "Pressione enter para continuar"
  continue_msg_len equ $ - continue_msg
  strcls        db  `\033[2J\033[H` ; clear screen
  sizecls       equ $ - strcls

section .bss
  name        resb  100
  precision   resb  1
  menu_option resb  2

section .text
  global _start
  global clear_screen
  global get_first_operand
  global get_second_operand
  global print
  global print_int
  global wait_for_key
  global menu
  global result_msg
  global result_msg_len
  global precision
  global overflow
  global print_continue
  extern sum
  extern subtraction
  extern division
  extern multiplication
  extern exp
  extern mod

_start:
  call  clear_screen
  ; print welcome message
  push  welcome_msg
  push  welcome_msg_len
  call  print

  call  print_welcome2

  ; print question message
  push  question_msg
  push  question_msg_len
  call  print

  ; read precision
  push  precision
  push  2
  call  read
  add   esp, 8

menu:
  ; print menu
  call  clear_screen
  push  menu_msg
  push  menu_msg_len
  call  print

  ; read menu option
  push  menu_option
  push  3
  call  read
  add   esp, 8

  cmp   byte [menu_option],'1'
  je    sum
  cmp   byte [menu_option],'2'
  je    subtraction
  cmp   byte [menu_option],'3'
  je    multiplication
  cmp   byte [menu_option],'4'
  je    division
  cmp   byte [menu_option],'5'
  je    exp
  cmp   byte [menu_option],'6'
  je    mod
  cmp   byte [menu_option],'7'
  jne   menu

  ; exit
  mov   eax, 1
  xor   edi, edi
  int   0x80

; void print(int msglen, char *msg)
print:
  enter 0, 0
  mov   eax, 4          ; sys_write
  mov   ebx, 1          ; stdout
  mov   ecx, [ebp + 12] ; msg
  mov   edx, [ebp + 8]  ; msglen
  int   0x80
  pop   ebp
  ret   8

clear_screen:
  push  strcls
  push  sizecls
  call  print
  ret

; void read(int len, *str)
read:
  enter 0, 0
  mov   eax, 3          ; Código da syscall para ler da entrada padrão
  xor   ebx, ebx        ; Descritor de arquivo padrão de entrada (stdin - 0)
  mov   ecx, [ebp + 12] ; Endereço do buffer para armazenar a string
  mov   edx, [ebp + 8]  ; Tamanho máximo da string
  int   0x80            ; Chama a syscall
  pop   ebp
  ret

; int string_number_to_integer(char *str, int str_len)
string_number_to_integer_32:
  enter 12, 0
  mov   esi, [ebp + 8]        ; ecx = str
  mov   ecx, [ebp + 12]       ; ecx = str_len
  dec   ecx
  mov   edx, 0                ; valor atual
  mov   [ebp - 4], dword 10   ; base
  mov   [ebp - 8], dword 0    ; resultado final
  mov   [ebp - 12], dword 1   ; sinal

  mov   dl, [esi]             ; dl = str[i]
  cmp   dl, "-"
  jne   s2n32_loop
  inc   esi
  dec   ecx
  neg   dword [ebp - 12]      ; sinal = -1
  s2n32_loop:
    mov   edx, 0
    mov   dl, [esi]
    cmp   dl, 0xa
    sub   dl, "0"
    mov   eax, dword [ebp - 8]
    push  edx
    mul   dword [ebp - 4]
    jo    s2n32_overflow
    pop   edx
    mov   dword [ebp - 8], eax
    mov   al , dl
    cbw
    cwde
    add   dword [ebp - 8], eax
    inc   esi
    loop   s2n32_loop

  s2n32_done:
    mov   eax, dword [ebp - 8]
    test  eax, eax ; Verifica se o número é negativo, se for, significa que houve overflow
    js    s2n32_overflow
    imul  dword [ebp - 12] ; Ajusta o sinal

  s2n32_end:
    leave
    ret   4

  s2n32_overflow:
    push overflow_msg
    push overflow_msg_len
    call print
    jmp s2n32_end

; short int string_number_to_integer(char *str, int str_len)
string_number_to_integer_16:
  enter 6, 0
  mov   esi, [ebp + 8]        ; ecx = str
  mov   ecx, [ebp + 12]       ; ecx = str_len
  dec   ecx
  mov   dx, 0               ; valor atual
  mov   [ebp - 2], word 10  ; base
  mov   [ebp - 4], word 0   ; resultado final
  mov   [ebp - 6], word 1   ; sinal

  mov   dl, [esi]           ; dl = str[i]
  cmp   dl, "-"
  jne   s2n16_loop
  inc   esi
  dec   ecx
  neg   word [ebp - 6]     ; sinal = -1
  s2n16_loop:
    mov   dx, 0
    mov   dl, [esi]
    cmp   dl, 0xa
    je    s2n16_done
    sub   dl, "0"
    mov   ax, word [ebp - 4]
    push  dx
    mul   word [ebp - 2]
    jo    s2n16_overflow
    pop   dx
    mov   word [ebp - 4], ax
    mov   al , dl
    cbw
    cwde
    add   word [ebp - 4], ax
    jc    s2n16_overflow
    inc   esi
    loop   s2n16_loop

  s2n16_done:
    mov   ax, word [ebp - 4]
    test  ax, ax ; Verifica se o número é negativo, se for, significa que houve overflow
    js    s2n16_overflow
    imul  word [ebp - 6] ; Ajusta o sinal

  s2n16_end:
    leave
    ret   4

  s2n16_overflow:
    push overflow_msg
    push overflow_msg_len
    call print
    jmp s2n16_end


; int read_int()
read_int:
  enter 12, 0
  ; mov   dword [ebp - 11], 0
  lea   esi, [esp]
  push  esi
  push  12
  call  read
  push  eax ; quantidade de caracteres lidos
  push  esi ; endereço do buffer
  cmp  byte [precision], '0'
  je    rdI16
  call  string_number_to_integer_32
  jmp   rdI_end
  rdI16:
  call  string_number_to_integer_16
  rdI_end:
  leave
  ret

; int get_first_operand()
get_first_operand:
  enter 0, 0
  push  first_operand_msg
  push  first_operand_msg_len
  call  print
  call  read_int
  pop   ebp
  ret

; int get_second_operand()
get_second_operand:
  enter 0, 0
  push  second_operand_msg
  push  second_operand_msg_len
  call  print
  call  read_int
  pop   ebp
  ret

; void print_int(int n || short int n)
print_int:
  enter   11, 0             ; Reserva espaço para o buffer
  cmp     byte [precision], '0'
  je      _16
  mov     edi, [ebp + 8]    ; Pega o número a ser convertido da pilha
  jmp     _32

  _16:
    mov   ax, [ebp + 8]     ; Pega o número de 16 bits a ser convertido da pilha
    cwde                    ; Converte para 32 bits
    mov   edi, eax

  _32:
  lea     esi, [ebp - 4]    ; Pega o endereço do buffer na pilha
  push    ebx
  push    edi
  push    esi
  xor     ebx, ebx
  test    edi, edi          ; Verifica se o número é negativo
  js      handle_negative

  ; Se o número for zero
  mov     eax, edi
  cmp     edi, 0
  jnz     not_zero
  mov     [ebp - 4], byte '0'
  inc     ebx
  jmp     print_result

  not_zero:
    mov ecx, 10
    mov eax, edi

  convert_loop:
    xor edx, edx
    div ecx
    add dl, '0'
    mov [esi + ebx], dl
    inc ebx
    cmp ebx, 11
    je  continue2
    test eax, eax
    jnz convert_loop


  continue2:
    ; dec ebx
    ; Prepara para inverter a string
    mov edi, esi
    lea esi, [esi + ebx]
    dec esi

  ; PutStr esi
  invert_loop:
    cmp edi, esi
    jge print_result
    mov al, [edi]
    mov ah, [esi]
    mov [esi], al
    mov [edi], ah
    inc edi
    dec esi
    jmp invert_loop

  print_result:
    mov edx, ebx
    mov eax, 4
    mov ebx, 1
    lea ecx, [ebp - 4]
    int 0x80
    pop esi
    pop edi
    pop ebx
    leave
    ret

  handle_negative:
    neg edi
    mov byte [esi], '-'
    inc esi
    inc ebx
    jmp not_zero

; void wait_for_key()
wait_for_key:
  enter 0, 0
  mov   eax, 3
  xor   ebx, ebx
  mov   ecx, esp
  mov   edx, 5
  int   0x80
  pop   ebp
  ret

print_welcome2:
  enter 0, 0
  push  name
  push  100
  call  read
  add   esp, 8
  sub   eax, 1                ; posição do último caractere
  mov   [name + eax], dword 0 ; remove \n do nome
  call  clear_screen
  push  welcome2_msg1
  push  welcome2_msg1_len
  call  print
  push  name
  push  100
  call  print
  push  welcome2_msg2
  push  welcome2_msg2_len
  call  print
  pop   ebp
  ret

overflow:
  push  overflow_msg
  push  overflow_msg_len
  call  print
  mov   eax, 1
  mov   ebx, 0
  int   0x80

print_continue:
  push  continue_msg
  push  continue_msg_len
  call  print
  call  wait_for_key
  ret
