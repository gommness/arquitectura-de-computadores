# Programa Ejemplo
.data 0
num0: .word 1 # posic 0
num1: .word 2 # posic 4
num2: .word 4 # posic 8
num3: .word 8 # posic 12
num4: .word 16 # posic 16
num5: .word 32 # posic 20
num6: .word 0 # posic 24
num7: .word 0 # posic 28
num8: .word 0 # posic 32
num9: .word 0 # posic 36
num10: .word 0 # posic 40
num11: .word 0 # posic 44


.text 0
main:
  # carga num0 a num5 en los registros 9 a 14
  lw $1, 0($zero) # En r1 un 1
  lw $2, 4($zero) # En r2 un 2
  lw $3, 8($zero) # En r3 un 4
  nop
  nop
  nop
  nop
  # RIESGOS REGISTRO BRANCH
  add $4, $2, $2 # En r4 un 4
  nop
  nop
  nop
  nop
  beq $4, $3, salto # Salta
  nop
  nop
  add $4,$1,$2 # No se ejecuta. Si se ejecutara, en r4 un 3 = 1 + 2
  salto:  nop
  nop
  add $6, $1, $1 # en r6 un 2 = 1 + 1
  add $7, $2, $2 # En r7 un 4 = 2 + 2
  beq $2, $6, salto2 # Salta
  nop
  nop
  add $1, $1, $2 # No se ejecuta. Si se ejecutara, en r1 un 3 = 1 + 2
  salto2: nop
  lw $1, 0($zero) # En r1 un 1
  lw $2, 4($zero) # En r2 un 2
  lw $3, 8($zero) # En r3 un 4
  nop
  nop
  # RIESGOS MEMORIA BRANCH
  lw $8, 8($zero) # En r8 un 4
  beq $8, $7, salto3 # Salta
  add $1, $1, $2 # No se ejecuta. Si se ejecutara, en r1 un 3 = 1 + 2
  salto3: nop
  lw $1, 0($zero) # En r1 un 1
  lw $2, 4($zero) # En r2 un 2
  lw $3, 8($zero) # En r3 un 4
  nop
  nop
  lw $9, 8($zero) # En r9 un 4
  add $10, $1, $2 # En r10 un 3 = 1 + 2
  beq $9, $7, salto4 # Salta
  add $1, $1, $2 # No se ejecuta. Si se ejecutara, en r1 un 3 = 1 + 2
  
  salto4: #----------------------------------------------------------------------------------------
  nop
  nop
  nop
  lw $1, 0($zero) # En r1 un 1
  lw $2, 4($zero) # En r2 un 2
  lw $3, 8($zero) # En r3 un 4
  nop
  nop
  nop
  addi $1, $1, 1 # guardo en r1 un 2
  and $2, $2, $2 # si funciona, el valor de r2 no cambiara
  and $3, $3, $0 # si funciona, el valor de r3 sera 0
  # debe pasar las dos pruebas anteriores
  nop
  nop
  nop
  lw $1, 0($zero) # En r1 un 1
  lw $2, 4($zero) # En r2 un 2
  lw $3, 8($zero) # En r3 un 4
  nop
  nop
  nop
  or $1, $1, $0 # si funciona, el valor de r1 no deberia cambiar
  or $2, $2, $2 # si funciona, el valor de r2 no deberia cambiar
  nop
  nop
  nop
  sub $4, $3, $3 # si funciona, el valor de r4 deberia ser 0
  sub $5, $1, $2 # r5 = -1 
  sub $6, $2, $1 # r6 = 1
  nop
  nop
  nop
  xor $4, $1, $1 # si funciona, r4 = 0
  xor $5, $1, $2 # si funciona, r5 = 3 (..0000011)
  nop
  nop
  nop
  sw $1, 4($zero)
  nop
  nop
  nop
  lw $1, 4($zero) # el valor de r1 deberia ser 1 ahora
  nop
  nop
  nop
  lui $3, 1 # r3 debera valer todo 0s
  nop
  nop
  nop
  lw $1, 0($zero) # En r1 un 1
  lw $2, 4($zero) # En r2 un 2
  lw $3, 8($zero) # En r3 un 4
  nop
  nop
  nop
  slti $1, $1, 0 # r1 deberia valer 0.
  slti $2, $2, 3 # En r2 1.
  nop
  nop
  nop
  lw $1, 0($zero) # En r1 un 1
  lw $2, 4($zero) # En r2 un 2
  lw $3, 8($zero) # En r3 un 4
  nop
  nop
  nop
  j salto4


