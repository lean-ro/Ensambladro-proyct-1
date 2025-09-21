li t0,100 # v0 carga 100 en t0 primera parte de la palabra 
li t1,200 # v1 carga 200 en t1 seguda parte de la palabra
# carga de las llaves 

li t2,1
li t3,2  # son las llaves 
li t4,3
li t5,4

li t6,0 # acumulado
li s0,2 # numero de vueltas 
li s1,5 # delta

#dirrecion de memoria 
li a0, 0x10000000 #direccion de memoria 
sw t0, 0(a0) # guarada la primera parte de la palabra 
sw t1, 4(a0) #guarada la segunda parte de la palabra 

Bucle: #cifrado
    add t6,t6,s1 # suma el acumulado con delta
    
    slli s2,t1,4 # 4 shift left
    add s2,s2,t2 # garda en s2 v1 con 4 shft+ llave 1 
    add s3,t1,t6 # guarada v1 + delta
    srli s4,t1,5 # guarada en s4 v1 con 5 shit right
    add s4,s4,t3 # suma la segunda llave 
    xor s2,s2,s3 # xor de v1 mod con v1+delta
    xor s2,s2,s4 # xor de v1 mod1 con v1+delta con v1 mod2
    add t0,t0,s2 # sumar la modificacion a v0
    
    slli s2,t0,4 # 4 shift left
    add s2,s2,t4 # garda en s2 v1 con 4 shft+ llave 3
    add s3,t0,t6 # guarda en s3 v0 + acumulado
    srli s4,t0,5 # guarada en s4 v0 con 5 shit right
    add s4,s4,t5 #suma la segunda llave 
    xor s2,s2,s3 # xor de v0 mod1 con v0+delta
    xor s2,s2,s4 # xor de v0 mod1 con v1+delta con v0 mod2
    add t1,t1,s2 # sumar la modificacion a v1
    
    add t6,t6,s1 # sumar en el acumulado delta
    addi s0,s0,-1 #restar uan de las vueltas 
    
    bnez s0,Bucle # si no es cero salta a bucle 
    
    sw t0,8(a0) #guarda v0 cifrado
    sw t1 12(a0) # guarda v1 cifrado
    
Bucle2: #descifra

    lw t0,8(a0) #recupera el valor cifrada en el registro 
    lw t1,12(a0) #recupera el valor cifrada en el registro 
    
    slli a2,t0,4 # hace 4 shift left a v0 cifrado
    add a2,a2,t4 # suma 
fin:
    j fin
