section .data
  title db 'EXPONENCIACAO', 0xa, 0xa
  title_len equ $ - title

section .text
  global exp
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

exp:
  call  clear_screen
  push  title
  push  title_len
  call  print
  cmp   byte [precision], '0'
  je    exp16

exp32:
  call  get_first_operand
  push  eax
  call  get_second_operand
  mov   ecx, eax ; epoente
  pop   eax ; base
  mov   ebx, eax ; base

  test  ecx, ecx
  jz    exp32_zero
  cmp   ecx, 1
  je    exp32_one
  dec   ecx
  exp32_loop:
    imul  ebx
    loop  exp32_loop

  ; verifica se houve overflow
  test  eax, eax
  js    compare_negative32
  test  edx, edx ; Se eax for positivo, edx deve ser 0
  jnz   overflow
  jmp   exp32_continue
  compare_negative32:
    cmp   edx, -1 ; Se eax for negativo, edx deve ser -1
    jne   overflow
  jmp   exp32_continue

  exp32_zero:
    mov   eax, 1
    jmp   exp32_continue

  exp32_one:
    mov   eax, ebx

  exp32_continue:
    mov   esi, eax
    push  result_msg
    push  result_msg_len
    call  print
    push  esi
    call  print_int
    add   esp, 8
    jmp   end

exp16:
  call  get_first_operand
  push  ax
  call  get_second_operand
  mov   cx, ax ; epoente
  pop   ax ; base
  mov   bx, ax ; base

  test  cx, cx
  jz    exp16_zero
  cmp   cx, 1
  je    exp16_one
  dec   cx
  exp16_loop:
    imul  bx
    loop  exp16_loop

  ; verifica se houve overflow
  test  ax, ax
  js    compare_negative16
  test  dx, dx ; Se ax for positivo, dx deve ser 0
  jnz   overflow
  jmp   exp16_continue
  compare_negative16:
    cmp   dx, -1 ; Se ax for negativo, dx deve ser -1
    jne   overflow
  jmp   exp16_continue

  exp16_zero:
    mov   ax, 1
    jmp   exp16_continue

  exp16_one:
    mov   ax, bx

  exp16_continue:
    mov   si, ax
    push  result_msg
    push  result_msg_len
    call  print
    push  si
    call  print_int
    add   esp, 4
    jmp   end

end:
  call  print_continue
  jmp   menu
