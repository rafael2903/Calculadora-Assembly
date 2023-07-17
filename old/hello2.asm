section .rodata ; read-only data section
  welcome_msg   db  "Bem-vindo. Digite seu nome:", 10
  welcome2_msg1 db  "Hola, "
  welcome2_msg2 db  ", bem-vindo ao programa de CALC IA-32", 10

  welcome_msg_len: equ $ - welcome_msg

  strcls        db  `\033[2J\033[H`
  sizecls       equ $ - strcls

section .bss ; uninitialized data section
  name  resb  32 ; reserve 32 bytes for name

section .text
        global _start

_start:
  ; print welcome message
  push  welcome_msg
  push  28
  call  print

  ; call  print_welcome2

  ; exit
  mov   eax, 60
  mov   edi, 0
  syscall


; void print(char *msg, int msglen)
print:
  push  ebp
  mov   ebp, esp
  mov   eax, 1  ; sys_write
  mov   edi, 1  ; stdout
  mov   esi, [ebp + 12] ; msg
  mov   edx, [ebp + 8] ; msglen
  syscall
  pop   ebp
  ret   8  ; return and clean the stack

; Lê o nome do usuário da entrada padrão e armazena em name
read_name:
  mov   eax, 0    ; Código da syscall para ler da entrada padrão
  mov   edi, 0    ; Descritor de arquivo padrão de entrada (stdin)
  mov   esi, name ; Endereço do buffer para armazenar o nome
  mov   edx, 32   ; Tamanho máximo do nome
  syscall         ; Chama a syscall
  ret

; int strlen(char *str)
strlen:
  push  ebp
  mov   ebp, esp
  mov   eax, -1                     ; eax = i = -1
  lp:
    inc   eax                       ; i++
    cmp   word [ebp + 8 + eax], 0 ; str[i] == '\0'?
    jne   lp                        ; if not, continue loop
  dec   eax                         ; i--
  dec   eax                         ; i--
  dec   eax                         ; i--
  pop   ebp
  ret   4

print_welcome2:
  call  read_name

  ; clear screen
  push  strcls
  push  sizecls
  call  print

  push  welcome2_msg1
  push  6
  call  print

  ; push  name
  ; call  strlen

  push  name
  push  32
  call  print

  push  welcome2_msg2
  push  38
  call  print

  ret
