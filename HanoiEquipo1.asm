
.eqv startTower a0		# Torre de inicio
.eqv auxTower a1		# Torre auxiliar
.eqv endTower a2		# Torre final

.eqv condicional s0 		# condicional para ir al caso base

.eqv N s1			# Numero de discos

.eqv tempSwap t0 		# Temporal para hacer swap
.eqv tempCount t2		# Temporal para insertar los discos

.data
.text

main:
   	lui startTower, 0x10010   		# Torre de inicio (a0) parte alta
   	
    	lui auxTower, 0x10010           	# Torre auxiliar (a1) parte alta
    	addi auxTower, auxTower, 0x020		# Torre auxiliar (a1) parte baja
                              
    	lui endTower, 0x10010			# Torre final (a2) parte alta    
 	addi endTower, endTower, 0x040   	# Torre final (a2) parte baja
 	
    	addi condicional, zero, 1		# condicional = 1
    	
    	add tempSwap, zero, zero		# Iniciamos la variable temporal con 0
	addi N, zero, 3 			# Numero de discos
	add tempCount, N, zero  		# Guardamos el número de addDisks para manipularlo y no alterar la variable original
	
	addDisks: 					# Agregar los discos a la primer columna
		sw tempCount, 0(startTower)		# Agrega el disco a la posición 0
		addi tempCount, tempCount, -1		# Decrementa el valor de el valor temporal, para saber que disco sigue en el stack
	
		addi startTower, startTower, 4		# Aumentamos el apuntador para agregar el siguiente disco
		bne tempCount, zero, addDisks		# Mientras tengamos discos por guardar volvemos a hacer la funcion anterior

	jal ra, hanoi				# Llamo a la función hanoi, guardando en ra el registro
	jal zero, end				# Salto al fin del programa	
 
hanoi:	
	addi sp, sp, -4				# Push al stack, primero decremento	
	sw ra, 0(sp)				# Luego guardo	 

	beq N, condicional, casoBase		# Si N = 1 se va a la función caso base

	# Swap: Hacemos swap de la torre destino y la auxiliar
	addi N, N, -1				# N-1 se vuelve la variable del ciclo para saber en qué disco vamos
	add tempSwap, auxTower, zero 		# Se guarda la torre auxiliar en el temporal
	add auxTower, endTower, zero  		# Se intercambian el disco del origen a torre temporal
	add endTower, tempSwap, zero    	# La torre destino se vuelve la temporal que era la auxiliar 
    					
	jal ra, hanoi				# Saltamos a la función Hanoi
	

	# Swap: Hacemos swap de la torre origen y la destino
	add tempCount, endTower, zero		# Se guarda en variable temporal
	add endTower, auxTower, zero		# El valor de End pasa a ser el de Auxiliar
	add auxTower, tempCount, zero		# El valor de auxiliar pasa a ser el del temporal guardado que es End
	  
	addi startTower, startTower, -4		# Se toma el disco de Inicio que está más arriba
	lw tempSwap, 0(startTower)		# Se carga el dato del disco en el temporal
	sw zero, 0(startTower)			# Se restablece el 0 en el espacio de la torre antes de moverlo
	sw tempSwap, 0(endTower)  		# Se escribe el dato temporal en la torre destino
    	addi endTower, endTower, 4 		# Se agrega disco a la torre Final
	    		
	# Swap: Hacemos swap de la torre origen a la auxiliar
	add tempSwap, startTower, zero		# Se guarda el dato de inicio en un temporal
	add startTower, auxTower, zero		# El valor de origen pasa a ser el de auxiliar
	add auxTower, tempSwap, zero		# El valor Auxiliar pasa a ser el origen que estaba en temporal
			
		
	addi N, N, -1				# reducimos el valor de N en N-1 
	jal ra, hanoi				# Saltamos a la función Hanoi
							
	# Swap: Hacemos swap de la torre origen a la auxiliar
	add tempSwap, startTower, zero		# Se guarda el dato de inicio en un temporal
	add startTower, auxTower, zero		# El valor de origen pasa a ser el de auxiliar
	add auxTower, tempSwap, zero		# El valor Auxiliar pasa a ser el origen que estaba en temporal

			
	lw ra, 0(sp)				# Se carga el return adress de la posición
	addi sp, sp, 4				# Se aumenta en 4 para apuntar al siguiente return adress 
	
	addi N, N, 1				# Se aumenta el disco de la llamada anterior
	jalr zero, ra, 0			# Se Salta a la posicion anterior de return adress para continuar con la recursividad	

casoBase:
	addi startTower, startTower, -4		# Se toma el disco del inicio
	lw tempSwap, 0(startTower)		# Se guarda el disco en un temporal
	sw zero, 0(startTower)			# Se remplaza el dato con 0 antes de moverlo a destino
	sw tempSwap, 0(endTower)  		# Se escribe el dato temporal al destino
	addi endTower, endTower, 4 		# Se aumenta el apuntador del destino que se le agregó un disco
	addi N, N, 1				# Se suma 1 a N
		
	lw ra, 0(sp)				# Se carga el return adress de la posición
	addi sp, sp, 4				# Se aumenta en 4 para apuntar al siguiente return adress 
	jalr zero, ra, 0			# Se Salta a la posicion anterior de return adress para continuar con la recursividad	
	
end:
    add zero, zero, zero
