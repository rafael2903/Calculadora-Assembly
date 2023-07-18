section .data
  title db 'MULTIPLICAÇÃO', 0xa, 0xa
  title_len equ $ - title

section .text
  global multiplication
  extern clear_screen
  extern get_first_operand
  extern get_second_operand
  extern print
  extern print_int
  extern print_continue
  extern menu
  extern result_msg
  extern result_msg_len
  extern precision
  extern overflow

multiplication:
  call  clear_screen
  push  title
  push  title_len
  call  print
  cmp   byte [precision], '0'
  je    mul16

mul32:
  call  get_first_operand
  push  eax
  call  get_second_operand

  imul  dword [esp]
  ; verifica se houve overflow
  test  eax, eax
  js    compare_negative32
  test  edx, edx ; Se eax for positivo, edx deve ser 0
  jnz   overflow
  jmp   continue32
  compare_negative32:
    cmp   edx, -1 ; Se eax for negativo, edx deve ser -1
    jne   overflow
  continue32:
    mov   esi, eax
    push  result_msg
    push  result_msg_len
    call  print

    push  esi
    call  print_int

    add   esp, 8
    jmp   end

mul16:
  call  get_first_operand
  push  ax
  call  get_second_operand

  imul  dword [esp]
  ; verifica se houve overflow
  test  ax, ax
  js    compare_negative16
  test  dx, dx ; Se ax for positivo, dx deve ser 0
  jnz   overflow
  jmp   continue16
  compare_negative16:
    cmp dx, -1 ; Se ax for negativo, dx deve ser -1
    jne  overflow
  continue16:
    mov   si, ax
    push  result_msg
    push  result_msg_len
    call  print

    push  si
    call  print_int
    add   esp, 4

end:
  call  print_continue
  jmp   menu
