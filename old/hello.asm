section .rodata ; read-only data section
  welcome_msg   db  "Bem-vindo. Digite seu nome:", 10
  welcome2_msg1 db  "Hola, "
  welcome2_msg2 db  ", bem-vindo ao programa de CALC IA-32", 10

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

  call  print_welcome2

  ; exit
  mov   rax, 60
  mov   rdi, 0
  syscall


; void print(char *msg, int msglen)
print:
  push  rbp ;
  mov   rbp, rsp
  mov   rax, 1  ; sys_write
  mov   rdi, 1  ; stdout
  mov   rsi, [rbp + 24] ; msg
  mov   rdx, [rbp + 16] ; msglen
  syscall
  pop   rbp
  ret   16  ; return and clean the stack

; Lê o nome do usuário da entrada padrão e armazena em name
read_name:
  mov   rax, 0    ; Código da syscall para ler da entrada padrão
  mov   rdi, 0    ; Descritor de arquivo padrão de entrada (stdin)
  mov   rsi, name ; Endereço do buffer para armazenar o nome
  mov   rdx, 32   ; Tamanho máximo do nome
  syscall         ; Chama a syscall
  ret

; int strlen(char *str)
strlen:
  push  rbp
  mov   rbp, rsp
  mov   rax, -1                     ; rax = i = -1
  lp:
    inc   rax                       ; i++
    cmp   qword [rbp + 16 + rax], 0 ; str[i] == '\0'?
    jne   lp                        ; if not, continue loop
  dec   rax                         ; i--
  dec   rax                         ; i--
  dec   rax                         ; i--
  pop   rbp
  ret   8

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
