# echo.s - Baca karakter dari keyboard (UART RX) dan kirim langsung ke layar TTY (UART TX)

        .text
main:
        li   s0, 0xF0000000        # Alamat dasar MMIO (0xF0000000 = UART TX / TTY)
        li   s5, 0                 # Penghitung jumlah karakter yang diterima

wait:
        lw   t2, 8(s0)             # Baca UART_STATUS (0xF0000008)
        andi t2, t2, 1             # Cek bit 0: apakah ada karakter masuk dari keyboard?
        beqz t2, wait              # Jika belum ada (0), tunggu terus

        lw   t3, 4(s0)             # Baca karakter dari UART_RXDATA / Keyboard (0xF0000004)
        addi s5, s5, 1             # Tambah jumlah karakter yang diterima

echo:
        sb   t3, 0(s0)             # Kirim karakter apa adanya ke layar TTY (0xF0000000)
        li   t4, 10                # Kode ASCII 10 = newline ('\n' / Enter)
        bne  t3, t4, wait          # Selama bukan Enter/newline, ulangi ke 'wait'

        lw   s6, 8(s0)             # Baca status UART terakhir
        sw   s5, 0x10(s0)          # Tampilkan jumlah karakter ke GPIO_OUT (0xF0000010)
        ebreak                     # Hentikan CPU
