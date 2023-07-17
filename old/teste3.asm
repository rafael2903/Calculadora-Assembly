%include "io.mac"
section .data
    num_format db "%d", 0

section .bss
    str_buffer resb 11  ; Tamanho do buffer para armazenar a string (10 dígitos + 1 para o sinal ou terminador de string)
    num resd 1         ; Reserva 1 palavra de 32 bits para o número a ser convertido
    _str resb 11        ; Reserva espaço para armazenar a string resultante

section .text
global _start

_start:

    ; mov edi, -234
    ; mov esi, str_buffer
    push 4455
    call print_int

    mov eax, 1
    mov ebx, 0
    int 0x80

print_int:
    enter   10, 0           ; Reserva espaço para o buffer
    mov     edi, [ebp + 8]  ; Pega o número a ser convertido da pilha
    lea     esi, [ebp - 4]  ; Pega o endereço do buffer na pilha
    push    ebx
    push    edi
    push    esi
    xor     ebx, ebx
    test    edi, edi        ; Verifica se o número é negativo
    js      handle_negative

    ; Se o número for zero
    mov     eax, edi
    cmp     edi, 0
    jnz     not_zero
    mov     [ebp - 4], byte '0'
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
        test eax, eax
        jnz convert_loop

    ; Prepara para inverter a string
    mov byte [esi + ebx], 0xa
    mov edi, esi
    lea esi, [esi + ebx]
    dec esi

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
        mov eax, 4
        mov ebx, 1
        lea ecx, [ebp - 4]
        mov edx, 10
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
        jmp not_zero
