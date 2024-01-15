#==============================================================================
# File:         radixsort.s (PA 1)
#
# Description:  Skeleton for assembly radixsort routine. 
#
#       To complete this assignment, add the following functionality:
#
#       1. Call find_exp. (See radixsort.c)
#          Pass 2 arguments:
#
#          ARG 1: Pointer to the first element of the array
#          (referred to as "array" in the C code)
#
#          ARG 2: Number of elements in the array
#          
#          Remember to use the correct CALLING CONVENTIONS !!!
#          Pass all arguments in the conventional way!
#
#       2. Call radsort. (See radixsort.c)
#          Pass 3 arguments:
#
#          ARG 1: Pointer to the first element of the array
#          (referred to as "array" in the C code)
#
#          ARG 2: Number of elements in the array
#
#          ARG 3: Exponentiated radix
#          (output of find_exp)
#                 
#          Remember to use the correct CALLING CONVENTIONS !!!
#          Pass all arguments in the conventional way!
#
#       2. radsort routine.
#          The routine is recursive by definition, so radsort MUST 
#          call itself. There are also two helper functions to implement:
#          find_exp, and arrcpy.
#          Again, make sure that you use the correct calling conventions!
#
#==============================================================================

.data
HOW_MANY:   .asciiz "How many elements to be sorted? "
ENTER_ELEM: .asciiz "Enter next element: "
ANS:        .asciiz "The sorted list is:\n"
SPACE:      .asciiz " "
EOL:        .asciiz "\n"

.text
.globl main

#==========================================================================
main:
#==========================================================================

    #----------------------------------------------------------
    # Register Definitions
    #----------------------------------------------------------
    # $s0 - pointer to the first element of the array
    # $s1 - number of elements in the array
    # $s2 - number of bytes in the array
    #----------------------------------------------------------
    
    #---- Store the old values into stack ---------------------
    addiu   $sp, $sp, -32
    sw      $ra, 28($sp)

    #---- Prompt user for array size --------------------------
    li      $v0, 4              # print_string
    la      $a0, HOW_MANY       # "How many elements to be sorted? "
    syscall         
    li      $v0, 5              # read_int
    syscall 
    move    $s1, $v0            # save number of elements

    #---- Create dynamic array --------------------------------
    li      $v0, 9              # sbrk
    sll     $s2, $s1, 2         # number of bytes needed
    move    $a0, $s2            # set up the argument for sbrk
    syscall
    move    $s0, $v0            # the addr of allocated memory


    #---- Prompt user for array elements ----------------------
    addu    $t1, $s0, $s2       # address of end of the array
    move    $t0, $s0            # address of the current element
    j       read_loop_cond

read_loop:
    li      $v0, 4              # print_string
    la      $a0, ENTER_ELEM     # text to be displayed
    syscall
    li      $v0, 5              # read_int
    syscall
    sw      $v0, 0($t0)     
    addiu   $t0, $t0, 4

read_loop_cond:
    bne     $t0, $t1, read_loop 

    #---- Call find_exp, then radixsort ------------------------
    ble $s1, $zero, print_array

    # Pass the two arguments in $a0 and $a1 before calling
    # find_exp. Again, make sure to use proper calling 
    # conventions!
    move $a0, $s0
    move $a1, $s1
    jal find_exp

    # Pass the three arguments in $a0, $a1, and $a2 before
    # calling radsort (radixsort)
    move $a0, $s0
    move $a1, $s1
    move $a2, $v0
    jal radsort

print_array:
    #---- Print sorted array -----------------------------------
    li      $v0, 4              # print_string
    la      $a0, ANS            # "The sorted list is:\n"
    syscall

    #---- For loop to print array elements ---------------------
    
    #---- Initiazing variables ---------------------------------
    move    $t0, $s0            # address of start of the array
    addu    $t1, $s0, $s2       # address of end of the array
    j       print_loop_cond

print_loop:
    li      $v0, 1              # print_integer
    lw      $a0, 0($t0)         # array[i]
    syscall
    li      $v0, 4              # print_string
    la      $a0, SPACE          # print a space
    syscall            
    addiu   $t0, $t0, 4         # increment array pointer

print_loop_cond:
    bne     $t0, $t1, print_loop

    li      $v0, 4              # print_string
    la      $a0, EOL            # "\n"
    syscall          

    #---- Exit -------------------------------------------------
    lw      $ra, 28($sp)
    addiu   $sp, $sp, 32
    jr      $ra


radsort: 
    # You will have to use a syscall to allocate
    # temporary storage (mallocs in the C implementation)

    # Saving registers (TODO)
    addi $sp, $sp, -28 #change offset when we have more stuff
    sw $s0, 24($sp)
    sw $s1, 20($sp)
    sw $s2, 16($sp)
    sw $ra, 12($sp)
    sw $a2, 8($sp)
    sw $a1, 4($sp)
    sw $a0, 0($sp)

    # Global constants (Radix)
    li $s0, 10

    # if (n < 2 || exp == 0)
    slti $t0, $a1, 2    # n < 2
    bne $t0, $zero, radsort_exit1  # go to exit2 when n >= 2
    beqz $a2, radsort_exit1

    # Malloc lines (2)
    # Malloc for children array
    li $a0, 4             # Size of pointer (4 bytes)
    mul $a0, $a0, $s0     # Total size needed (4 * RADIX)
    li $v0, 9             # Syscall for sbrk
    syscall               # Allocate memory
    move $s1, $v0         # Address of children array

    # Malloc for children_len array
    li $a0, 4             # Size of unsigned int (4 bytes)
    mul $a0, $a0, $s0     # Total size needed (4 * RADIX)
    li $v0, 9             # Syscall for sbrk
    syscall               # Allocate memory
    move $s2, $v0         # Address of children_len array 

    # For loop to initialize bucket counts to zero
    move $t0, $zero
    j radsort_init_loop_cond

radsort_init_loop:
    # children_len[i] = 0;
    sll $t1, $t0, 2    # 4 x i
    add $t1, $s2, $t1  # address of children_len[i]
    sw $zero, 0($t1)   # set children_len[i] = 0

    # increment
    addi $t0, $t0, 1

radsort_init_loop_cond:
    blt $t0, $s0, radsort_init_loop # if i < RADIX

    # For loop to assign array values to appropriate buckets
    move $t0, $zero
    j radsort_assign_buckets_loop_cond

radsort_assign_buckets_loop:
    # unsigned sort_index = (array[i] / exp) % RADIX;
    sll $t1, $t0, 2    # 4 x i
    add $t1, $a0, $t1  # address of array[i]
    lw $t2, 0($t1)     # array[i]
    divu $t2, $a2      # array[i] / exp
    mflo $t2           # quotient
    divu $t2, $s0      # quotient % RADIX
    mfhi $t2           # remainder

    # if (children_len[sort_index] != 0), jump to radsort_assign_buckets
    sll $t3, $t2, 2    # 4 x sort_index
    add $t4, $s2, $t3  # address of children_len[sort_index]
    lw $t5, 0($t4)     # children_len[sort_index]
    bneqz $t5, radsort_assign_buckets

    # malloc for children[sort_index]
    li $a0, 4             # Size of pointer (4 bytes)
    mul $a0, $a0, $a1     # Total size needed (4 * n)
    li $v0, 9             # Syscall for sbrk
    syscall               # Allocate memory
    add $t6, $s1, $t3     # address of children[sort_index]
    sw $v0, 0($t6)        # children[sort_index] = malloc(4 * n)

radsort_assign_buckets:
    # children[sort_index][children_len[sort_index]] = array[i];
    sll $t7, $t5, 2    # 4 x children_len[sort_index]
    lw $t8, 0($t6)     # children[sort_index]
    add $t8, $t8, $t7  # address of children[sort_index][children_len[sort_index]]
    sw $t2, 0($t8)     # children[sort_index][children_len[sort_index]] = array[i]

    # increment children_len[sort_index]
    addi $t5, $t5, 1
    sw $t5, 0($t4)

    # increment i
    addi $t0, $t0, 1

radsort_assign_buckets_loop_cond:
    blt $t0, $a1, radsort_assign_buckets_loop # if i < n

radsort_cont1:
    #Keep going (line 77 in .c)


# Case when n < 2 || exp == 0:
radsort_exit1:
    # restore registers
    lw $a0, 0($sp)
    lw $a1, 4($sp)
    lw $a2, 8($sp)
    lw $ra, 12($sp)
    addi $sp, $sp, 16
    jr $ra

L1:
    jr      $ra



find_exp:
    # leaf procedure
    lw $t0, 0($a0)             # unsigned largest = array[0];
    move $t1, $zero            # int i = 0;

exp_for1:
    bge $t1, $a1, exp_exit1      # exit loop if i >= n

    # Get array[i]
    sll $t2, $t1, 2             # t2 = 4 * i
    add $t2, $a0, $t2          # t2 = array + 4 * i
    lw $t3, 0($t2)             # load array[i]

    bgt $t0, $t3, exp_sub_exit1 # if (largest > array[i])
    move $t0, $t3

exp_sub_exit1:
    addi $t1, $t1, 1      # i++
    j exp_for1            # go back to the top of the loop

exp_exit1:
    li $v0, 1                 # exp = 1
    
exp_while_loop:
    li $t1, 10            # RADIX = 10
    blt $t0, $t1, exp_exit2    # Check if largest < RADIX
    
    divu $t0, $t1    # largest = largest / RADIX
    mflo $t0              # move quotient to largest
    
    mul $v0, $v0, $t1     # exp = exp * RADIX
    
    j exp_while_loop      # loop
    
exp_exit2:
    jr $ra                # return             

arrcpy:
    # leaf procedure
    move $t0, $zero # i = 0;

arrcpy_for1:
    bge $t0, $a2, arrcpy_exit1 # exit loop if i >= n

    #  dst[i] = src[i]
    sll $t1, $t0, 2    # t1 = 4 * i
    add $t2, $a0, $t1  # t2 = dst + 4 * i
    add $t3, $a1, $t1  # t3 = src + 4 * i

    lw $t4, 0($t3)     # load in src[i]
    sw $t4, 0($t2)     # save to dst[i]

    addi $t0, $t0, 1   # i++
    j arrcpy_for1      # go back to top

arrcpy_exit1:
    jr      $ra
