# ============================================================
# Program: Reverse a String (MARS)
# Description: Reads a string from the user, reverses it, and prints it.
# Matches the Python high-level version line-by-line.
# ============================================================

.data
prompt:          .asciiz "Please Enter a String: "
result_msg:      .asciiz "Reversed String: "
newline:         .asciiz "\n"
input_buffer:    .space 256        # User input buffer
reversed_buffer: .space 256        # Reversed string buffer

.text
.globl main

main:
    # --------------------------------------------------------
    # Print prompt message
    # --------------------------------------------------------
    li $v0, 4
    la $a0, prompt
    syscall

    # --------------------------------------------------------
    # Read input string
    # --------------------------------------------------------
    li $v0, 8
    la $a0, input_buffer
    li $a1, 256
    syscall

    # --------------------------------------------------------
    # Calculate string length (manual loop like Python)
    # --------------------------------------------------------
    la $t0, input_buffer   # $t0 = pointer to input
    li $t1, 0              # $t1 = length counter

find_length:
    lb $t2, 0($t0)         # load current byte

    beq $t2, $zero, length_done   # string end
    beq $t2, 10, length_done      # newline from input

    addi $t1, $t1, 1        # length++
    addi $t0, $t0, 1        # move pointer
    j find_length

length_done:
    # Save length to $t5 for reverse logic
    move $t5, $t1           # $t5 = length

    # --------------------------------------------------------
    # Reverse the string
    # --------------------------------------------------------
    la $t0, input_buffer     # start of input
    la $t2, reversed_buffer  # pointer to output buffer

    add $t3, $t0, $t5        # t3 = input_start + length (one past end)

reverse_loop:
    beq $t5, $zero, end_reverse

    addi $t3, $t3, -1        # move back one character
    lb $t4, 0($t3)           # load character
    sb $t4, 0($t2)           # store character in output

    addi $t2, $t2, 1         # move output pointer
    addi $t5, $t5, -1        # decrement remaining characters
    j reverse_loop

end_reverse:
    sb $zero, 0($t2)         # null terminate reversed string

    # --------------------------------------------------------
    # Print result message
    # --------------------------------------------------------
    li $v0, 4
    la $a0, result_msg
    syscall

    # Print reversed string
    li $v0, 4
    la $a0, reversed_buffer
    syscall

    # Print newline
    li $v0, 4
    la $a0, newline
    syscall

    # Exit program
    li $v0, 10
    syscall
