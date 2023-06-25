section .rodata ; read-only data section
  msg: db "Hello, world!", 10
  msglen: equ $ - msg

section .text
        global _start

_start:

  ; print hello word message usign a function and passing the parameters in the stack
  push dword msglen ; esp = esp - 4
  push dword msg ; esp = esp - 4
  call print
  add rsp, 8 ; rsp = rsp + 8
  ; exit
  mov eax, 60
  mov edi, 0
  syscall

; print function
print:
  push rbp ;
  mov rbp, rsp
  mov eax, 1 ; sys_write
  mov edi, 1 ; stdout
  mov esi, [rbp + 16] ; msg
  mov edx, [rbp + 24] ; msglen
  syscall
  pop rbp
  ret
