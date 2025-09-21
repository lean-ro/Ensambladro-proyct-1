
li t0,369 # v0 carga en t0 primera parte de la palabra 
li t1,723 # v1 carga en t1 seguda parte de la palabra

# carga de las llaves 

li t2,6936
li t3,2002  # llaves 
li t4,3697
li t5,4408

li t6,0 # acumulado
li s0,32 # numero de vueltas 
li s1,7690 # delta

# guardado en memoria 

li a0, 0x10000000 #direccion de memoria 

sw t0, 0(a0)  # guarda la primera parte de la palabra 
sw t1, 4(a0)  # guarda la segunda parte de la palabra
sw t2, 8(a0)  # guarda la llave 0
sw t3, 12(a0) # guarda la llave 1
sw t4, 16(a0) # guarda la llave 2
sw t5, 20(a0) # guarda la llave 3
sw s0,24(a0)  # guarda el numero de vueltas 
sw s1,28(a0)  # guarda el delta 

Bucle: #cifrado

    add t6,t6,s1 # suma el acumulado con delta
    
   # operacion de v1 para sumar a v0 
   
    slli s2,t1,4 # 4 shift left
    add s2,s2,t2 # guarda en s2 v1 con 4 shft + llave 0 
    add s3,t1,t6 # guarda v1 + delta
    srli s4,t1,5 # guarda en s4 v1 con 5 shit right
    add s4,s4,t3 # suma la llave 1 
    xor s2,s2,s3 # xor de v1 mod con v1 + delta
    xor s2,s2,s4 # xor de v1 mod1 con v1 + delta con v1 mod2
    add t0,t0,s2 # sumar la modificacion a v0
    
     # operacion de v0 para sumar a v1 
    
    slli s2,t0,4 # 4 shift left
    add s2,s2,t4 # guarda en s2 v1 con 4 shft + llave 2
    add s3,t0,t6 # guarda en s3 v0 + acumulado
    srli s4,t0,5 # guarada en s4 v0 con 5 shit right
    add s4,s4,t5 # suma la llave 3 
    xor s2,s2,s3 # xor de v0 mod1 con v0 + delta
    xor s2,s2,s4 # xor de v0 mod1 con v1 + delta con v0 mod2
    add t1,t1,s2 # suma la modificacion a v1
    
    addi s0,s0,-1 # resta una de las vueltas 
    
    bnez s0,Bucle # si no es cero salta a Bucle 
    
    sw t0,32(a0) # guarda v0 cifrado
    sw t1,36(a0) # guarda v1 cifrado
    sw t6,40(a0) # guarda el acumulado 
    
#recuperar memoria 

lw t0,32(a0) # recupera el valor v0 cifrada en el registro 
lw t1,36(a0) # recupera el valor v1 cifrada en el registro
lw t2,8(a0)  # recupera la llave 0
lw t3,12(a0) # recupera la llave 1
lw t4,16(a0) # recupera la llave 2
lw t5,20(a0) # recupera la llave 3
lw s0,24(a0) # recupera el numero de vueltas 
lw s1,28(a0) # recupera el delta
lw s5,40(a0) # recupera el acumulado

Bucle2: #descifra

    # operacion de v0 para restar a v1 
    
    slli s2,t0,4 # hace 4 shift left a v0 cifrado
    add s2,s2,t4 # suma la llave 2
    add s3,t0,s5 # suma v0 con el acumulado
    srli s4,t0,5 # hace 5 shitf right
    add s4,s4,t5 # suma la llave 3
    xor s2,s2,s3 # xor de v0 mod 
    xor s2,s2,s4 # xor de v0 mod 
    sub t1,t1,s2 # resta v1 con v0 mod
    
    # operacion de v1 para restar a v0 
    
    slli s2,t1,4 # hace 4 shift left a v1 cifrado
    add s2,s2,t2 # suma la llave 0
    add s3,t1,s5 # suma v1 con el acumulado
    srli s4,t1,5 # hace 5 shitf right
    add s4,s4,t3 # suma la llave 1
    xor s2,s2,s3 # xor de v1 mod 
    xor s2,s2,s4 # xor de v1 mod 
    sub t0,t0,s2 # resta v0 con v1 mod
    
    sub s5,s5,s1  # le resta delta al acumulado
    addi s0,s0,-1 # decrementa una vuelta
    
    bnez s0,Bucle2 # si no es cero salta a Bucle2
    
    sw t0,44(a0) # guarda v0 descifrado
    sw t1,48(a0) # guarda v1 descifrado

lw s6,0(a0)   # v0 original
lw s7,4(a0)   # v1 original
lw s8,32(a0)  # v0 cifrado 
lw s9,36(a0)  # v1 cifrado
lw s10,44(a0) # v0 descifrado
lw s11,48(a0) # v1 descifrado
    
fin:
    j fin
