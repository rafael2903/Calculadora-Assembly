section .data
  title db 'SOMA', 0xa, 0xa
  title_len equ $ - title

section .text
  global sum
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

sum:
  call  clear_screen
  push  title
  push  title_len
  call  print
  cmp   byte [precision], '0'
  je    sum16

sum32:
  call  get_first_operand
  push  eax
  call  get_second_operand

  add   eax, [esp]
  mov   esi, eax

  push  result_msg
  push  result_msg_len
  call  print

  push  esi
  call  print_int
  add   esp, 8
  jmp   end

sum16:
  call  get_first_operand
  push  ax
  call  get_second_operand

  add   ax, [esp]
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
