# demo.s - Fibonacci F(0..11), jumlah ke a0 (0xE8), cetak TTY, lalu set GPIO

        .data
fib:    .space 48                  # 12 word (48 byte) di RAM

        .text
main:
        li   sp, 0x3FF0            # Stack pointer
        la   s0, fib               # Pointer ke array fib
        li   t0, 0                 # F(0)
        li   t1, 1                 # F(1)
        li   t2, 12                # Jumlah elemen

fib_loop:
        sw   t0, 0(s0)             # Simpan Fibonacci ke RAM
        add  t3, t0, t1            # F(n+2) = F(n) + F(n+1)
        mv   t0, t1
        mv   t1, t3
        addi s0, s0, 4             # Geser ke word berikutnya
        addi t2, t2, -1
        bnez t2, fib_loop

        la   s0, fib               # Reset pointer array
        li   a0, 0                 # Total jumlah (hasil: 0xE8)
        li   t2, 12

sum_loop:
        lw   t4, 0(s0)
        add  a0, a0, t4
        addi s0, s0, 4
        addi t2, t2, -1
        bnez t2, sum_loop

        li   s1, 0xF0000000        # UART TX / TTY
        li   t5, 72  ; sb t5, 0(s1)   # 'H'
        li   t5, 101 ; sb t5, 0(s1)   # 'e'
        li   t5, 108 ; sb t5, 0(s1)   # 'l'
        li   t5, 108 ; sb t5, 0(s1)   # 'l'
        li   t5, 111 ; sb t5, 0(s1)   # 'o'
        li   t5, 32  ; sb t5, 0(s1)   # ' '
        li   t5, 82  ; sb t5, 0(s1)   # 'R'
        li   t5, 73  ; sb t5, 0(s1)   # 'I'
        li   t5, 83  ; sb t5, 0(s1)   # 'S'
        li   t5, 67  ; sb t5, 0(s1)   # 'C'
        li   t5, 45  ; sb t5, 0(s1)   # '-'
        li   t5, 86  ; sb t5, 0(s1)   # 'V'
        li   t5, 33  ; sb t5, 0(s1)   # '!'
        li   t5, 10  ; sb t5, 0(s1)   # '\n'

        sw   a0, 0x10(s1)          # GPIO_OUT hex display
        li   t5, 0xFF
        sb   t5, 0x12(s1)          # GPIO_OUT 8 LED
        ebreak                     # Halt CPU
