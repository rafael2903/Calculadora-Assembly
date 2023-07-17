section .data
  title db 'DIVISÃO', 0xa, 0xa
  title_len equ $ - title

section .text
  global division
  global divide32
  global divide16
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

division:
  call  clear_screen
  push  title
  push  title_len
  call  print
  cmp   byte [precision], '0'
  je    div16

div32:
  call divide32
  mov   esi, eax
  push  result_msg
  push  result_msg_len
  call  print
  push  esi
  call  print_int
  add   esp, 8
  jmp   end

div16:
  call divide16
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

divide32:
  enter 0, 0
  call  get_first_operand
  push  eax
  call  get_second_operand
  pop   ebx
  xchg  eax, ebx
  mov   edx, 0
  test  eax, eax
  jns   mod32_div
  cdq   ; extende o sinal de eax para edx quando eax é negativo
  mod32_div:
    idiv  ebx
  pop   ebp
  ret

divide16:
  enter 0, 0
  call  get_first_operand
  push  ax
  call  get_second_operand
  pop   bx
  xchg  ax, bx
  mov   dx, 0
  test  ax, ax
  jns   mod16_div
  cwd   ; extende o sinal de ax para dx quando ax é negativo
  mod16_div:
    idiv  bx
  pop   ebp
  ret
