#!/bin/bash
nasm -f elf32 -o soma.o soma.asm
nasm -f elf32 -o subtracao.o subtracao.asm
nasm -f elf32 -o divisao.o divisao.asm
nasm -f elf32 -o multiplicacao.o multiplicacao.asm
nasm -f elf32 -o exp.o exp.asm
nasm -f elf32 -o mod.o mod.asm
nasm -f elf32 -o calculadora.o calculadora.asm
ld -m elf_i386 -o calculadora calculadora.o soma.o subtracao.o divisao.o multiplicacao.o exp.o mod.o
./calculadora
