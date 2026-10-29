# Lab 10 - Task 2: FSM in RISC-V assembly (Venus-compatible, no .eqv)
# S0 = input waiting, S1 = countdown (matches Lab 5 FSM)
#
# Address map (Lab 8 AddressDecoder, address[9:8]):
#   data memory 0x000-0x1FF | LEDs 0x200 (write) | switches 0x300 (read)
# Stack top = 0x1FC
# Delay count = 5000000 (~1 s per step at 10 MHz). Use 3 when simulating.

.text
main:
    li   sp, 0x1FC             # initialize stack pointer
    li   s1, 0x300             # s1 = switch address
    li   s2, 0x200             # s2 = LED address

# ---------------- S0: input waiting ----------------
input_wait:
    sw   zero, 0(s2)           # LEDs off
wait_loop:
    lw   a0, 0(s1)             # read switches
    beqz a0, wait_loop         # switches == 0 -> keep polling
    sw   a0, 0(s2)             # capture value, show on LEDs
    jal  ra, countdown         # S1: a0 = initial count
    j    input_wait            # counter hit 0 -> back to S0

# ---------------- S1: countdown subroutine ----------------
# Argument: a0 = initial count
countdown:
    addi sp, sp, -8            # make stack frame
    sw   ra, 4(sp)             # save return address
    sw   s0, 0(sp)             # save s0
    mv   s0, a0                # s0 = counter

count_loop:
    beqz s0, count_done        # counter == 0 -> finished
    li   t1, 5000000           # delay iterations (DELAY_CNT)
delay:
    addi t1, t1, -1
    bnez t1, delay
    addi s0, s0, -1            # decrement counter
    sw   s0, 0(s2)             # update LEDs (switches are ignored here)
    j    count_loop

count_done:
    lw   s0, 0(sp)             # restore s0
    lw   ra, 4(sp)             # restore return address
    addi sp, sp, 8             # pop stack frame
    ret                        # back to main loop (input_wait)