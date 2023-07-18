section .data
  title db 'MÓDULO', 0xa, 0xa
  title_len equ $ - title

section .text
  global mod
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
  extern divide32
  extern divide16

mod:
  call  clear_screen
  push  title
  push  title_len
  call  print
  cmp   byte [precision], '0'
  je    mod16

mod32:
  call  divide32
  mov   esi, edx
  push  result_msg
  push  result_msg_len
  call  print
  push  esi
  call  print_int
  add   esp, 8
  jmp   end

mod16:
  call  divide16
  mov   si, dx
  push  result_msg
  push  result_msg_len
  call  print
  push  si
  call  print_int
  add   esp, 4

end:
  call  print_continue
  jmp   menu
