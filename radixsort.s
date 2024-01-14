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
    # ADD YOUR CODE HERE! 

    # Pass the two arguments in $a0 and $a1 before calling
    # find_exp. Again, make sure to use proper calling 
    # conventions!


    # Pass the three arguments in $a0, $a1, and $a2 before
    # calling radsort (radixsort)


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


# ADD YOUR CODE HERE! 

radsort: 
    # You will have to use a syscall to allocate
    # temporary storage (mallocs in the C implementation)
    jr      $ra

find_exp:
    jr      $ra               

arrcpy:
    jr      $ra
