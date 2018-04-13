# Name: Mario Eugenio Zuñiga Carrillo
#	Sergio Manuel Diaz Muños
# Date: 02/06/17
# Description: Hanoi Tower

# Logic of Hanoi Tower
#void towerOfHanoi(int n, char from, char to, char aux) {
#	if(n == 1) {
#		move(from, to);
#	}	x
#	
#	//left	
#	towerOfHanoi(n-1, fromrod, auxrod, torod);
#	
#	move(n, from, to);
#
#	//right
#	towerOfHanoi(n-1, auxrod, torod, fromrod);
#}

.text

MAIN:
	# Initialization of values
	addi $s0, $zero, 8		# Number of discs
 	addi $s1, $zero, 0		# Tower 1	
 	
 	add $a0, $a0, $s0		# We take the disc value
 	sub $a0, $a0, 1			# We decrease the value
 	srl $a0, $a0, 3			# We shift 3 values to the right
 	add $a0, $a0, 1			# We add 1 to the result
 	
 	#sll $s2, $a0, 5			# With the a0 value, we obtain the size of Tower 2
 	#sll $s3, $a0, 6			# With the a0 value, we obtain the size of Tower 3
 	
 	addi $s2, $zero, 32
 	addi $s3, $zero, 64
 	
 	add $t5, $s0, 9			# Counter for ending the code
 	
 	addi $t2, $zero, 0		# We clean register t2 to avoid unwanted values
 	
 	add $t1, $zero, $s0		# Temporary value for initialization of discs
 	add $t1, $t1, 1			# Counter for the discs increases
 	add $t3, $zero, $s0		# Temporary value
 	
 	#addi $a2, $zero, 268500992	# Decimal value of the beggining of the data segment
 	lui $a2, 0x1001
 	ori $a2, $a2, 0x0000
 
 	#addi $t5, $zero, 268500992	# Decimal value of the beggining of the data segment	
 	lui $t5, 0x1001
 	ori $t5, $t5, 0x0000
 	
 	addi $t6, $zero, 96		# Register with the total space of the 3 towers
 	
 	#addi $sp, $zero, 268566528
 	lui $sp, 0x1001
 	ori $sp, $sp, 0x0400
 	
 	
 	
TOWER_SAFE_INIT:
	# TOWER_SAFE_INIT will fill the 3 towers with 0 values, this for forward implementation with other proyects, in order
	# to avoid values different than 0 when the program loads
	sw, $s1, 0($t5)			# The current address will be filled with a 0
	addi $t5, $t5, 4		# Adress increases by 4
	add $t2, $t2, 4			# Counter increases by 4
	
	beq $t2, $t6, POINT_DATA	# We check if the counter is equal to the size of the 3 towers, if it is, it means
					# that the safe init is completed, and we can continue
					
	j TOWER_SAFE_INIT		# If it isn't finished, we keep using this function
 	 
POINT_DATA: 	 
 	#addi $t5, $zero, 268500992	# Register t5 returns to the direction of the towers
 	lui $t5, 0x1001
 	ori $t5, $t5, 0x0000
 	sub $t2, $s2, 4			# Temporary value that points the highest position for the tower to remove disc
	


TOWER_INIT:
 	# The first tower gets all the discs values
 	addi $t1, $t1, -1			# Decrease of disc
	sw  $t1, 0($t5)				# The value for the tower is saved
	add $t5, $t5, 4			# The value of the stack pointer is increased by 4
	beq $t1, $s1, HANOI_LEFT		# We check if all the discs have been stored in address
	j TOWER_INIT				# If not, we jump back to the beggining of this function
	
	
HANOI_LEFT:
	# This "function" checks if all the possible movements to the left have been made
	bne $s0, $zero, CREATE_MOVEMENT_LEFT		# We check if the discs are 0, if not, a movement is created
	
LOOP:
	jr $ra		# We jump to the register stored in register access
	j LOOP		# We keep going to the jump register line
	
CREATE_MOVEMENT_LEFT:
	# The current value of the towers must be saved, with that, a left movement is created
	# Every move created is saved to the position where the stack pointer initially starts
	
	sw $ra, -0($sp)		# The return address of this movement is stored in the stack pointer
 	sw $s0, -4($sp)		# The value of s0 is load to the stack pointer (offset + 4)
 	sw $s1, -8($sp)		# The value of s0 is load to the stack pointer (offset + 8)		
 	sw $s2, -12($sp)		# The value of s0 is load to the stack pointer (offset + 12)	
 	sw $s3, -16($sp)		# The value of s0 is load to the stack pointer (offset + 16)	
 	addi $sp, $sp, -20	# The stack pointer adds another 20 
 	addi $s0, $s0, -1 	# The value of the discs decreases
 	
 	# The first tower must remain the same (in order of the logic of above) [s1 remains]
 	# The middle and final tower must be switching for the following cases [s2 & s3 switch]
	
	# In this section the second and third tower are shifted for the future movement
	addi $t7, $zero, 0	# The register t7 needs to be cleared
	add $t7, $s3, $zero	# The value of the second tower is saved in t7
	addi $s3, $zero, 0	# The second tower is cleared
	add $s3, $s2, $zero	# The value of the third tower, is now of tower 2
	addi $s2, $zero, 0	# The third tower is cleared 
	add $s2, $t7, $zero	# The original value of the second tower is passed to the third tower
	
RECURSION:
	# This function allows to keep creating movements if needed, calling upon itself
	# Now that the movement was created, we return to the HANOI_LEFT, to verify if another we can make anohter movement
	
	# If we return from HANOI_RIGHT, when we return to HANOI_LEFT, if the disc value is 1 or above, the address of the states
	# of the towers will be overwritten with the new position of the towers
	
	jal HANOI_LEFT		# We jump to the beggining, and the address of this movement is stored to access it later
	
	
LOAD_TOWERS:
	# For the next movement, we need to know the current value of each tower
	
	#The values must be loaded the opposite way they were saved
	lw $s3, 4($sp)		# The value of the third tower is loaded (offset -4)
	lw $s2, 8($sp)		# The value of the second tower is loaded (offset -8)
	lw $s1, 12($sp)	# The value of the first tower is loaded (offset -12)
	lw $s0, 16($sp)	# The value of the discs is loaded (offset -16)
	lw $ra, 20($sp)	# The return address of the towers is loaded (offset -20)
	
	addi $sp, $sp, 20	# The stack pointer needs to be moved to the "sections" of this towers
	
	

MOVE_DISC:
	# This function moves a disc from tower to tower
	# We have to access the original position of the stack pointer, where the towers were saved
	# so we use the register a2, that has the value of the initial position of the stack pointer
	add $a1, $a2, 0				# Register a1 gets the initial value of $sp
	add $a1, $a1, $t2			# Register a1 now points to the top of the first tower
	add $a1, $a1, $s1
	lw $t6, ($a1)				# We load the value stored in the current address
	beq $t6, $zero, LOOK_FOR_DISC		# We verify if the value found is 0		
	j MOVEMENT_COUNT			# If is anything but 0, it counts the movement
	
	
LOOK_FOR_DISC:					# If it was 0, it means, that there was no disc
	# If we know that the address didn't had a disc, we have to decrease the address to go lower in the tower
	
	addi $a1, $a1, -4			# The direction needs to be decreased
	lw $t6, ($a1)				# The value stored in the address of a1 is loaded to t6
	sub $t5, $t5, 1				# The counter to finish the code decreases
	beq $t5, $zero, EXIT			# If the counter is 0, it means that the towers are finished, and the code can end
	beq $t6, $zero, LOOK_FOR_DISC		# If the value of t6 is still 0, it means that we haven't found a disc
	

MOVEMENT_COUNT:		
	# If we reach here, it means t6 had a disc that now needs to be moved to another tower
	
	add $t5, $t1, 9				# The counter needs to restart, meaning that the code hasn't finished
	sw $zero, ($a1)				# The address where we obtained the disc is cleaned
	
	# The register a1 will now look for the top position (from bottom to top), where the disc can be stored
	add $a1, $s3, $a2			# The address of the third tower is added to a1
	lw $t4, ($a1)				# We load the value of the address of a1 to t4
	bne $t4, $zero, LOOK_FOR_TOP		# We need to verify if the value is 0
	j HANOI_RIGHT				# If it is, it means that the place is available to store
	
LOOK_FOR_TOP:		# If it didn't, it means, that the place is full by another disc, so we need to go higher
	add $a1, $a1, 4				# The address of the tower is increased by 4
	lw $t4, ($a1)				# We load the value of the new address
	bne $t4, $zero, LOOK_FOR_TOP		# We check again if the place is available, until the value is 0
						# we keep checking
	
	j HANOI_RIGHT				# If it is, it means that the place is available to store

HANOI_RIGHT:
	# Now that we know that the place is available, we can store the val
	sw $t6, ($a1)		# The disc is stored in the new tower
	
	# The towers 1 & 2 must be switched
	addi $a3, $zero, 0	# Register a1 is cleaned
	add $a3, $s1, 0		# The current value of Tower1 is saved in a1
	addi $s1, $zero, 0	# Tower1 is cleaned
	
	add $s1, $s2, 0		# The value of Tower2 is now of Tower1
	addi $s2, $zero, 0	# Tower2 is cleared
	add $s2, $a3, 0		# The old value of Tower1 is now of Tower2
	
	addi $s0, $s0, -1	# The value of discs decrease by 1
	
	# The current value of the towers is switched is temporary
	# Before jumping back to RECURSION, if the value of disc is above 0, it means that new movements, with the new base
	# of towers, exist
	
	j RECURSION		# We jump back to RECURSION

EXIT:
