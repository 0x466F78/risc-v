# hello_world.s - Cetak "Hello world\n" ke layar TTY (0xF0000000)

        .data
msg:    .asciz "Hello world\n"     # Teks yang dicetak (diakhiri null byte 0)

        .text
main:
        li   s0, 0xF0000000        # Alamat layar TTY
        la   s1, msg               # Alamat karakter saat ini
        li   a0, 0                 # Jumlah karakter yang sudah dicetak

loop:
        lbu  t0, 0(s1)             # Baca 1 karakter (1 byte)
        beqz t0, done              # Jika sudah 0 (akhir teks), selesai
        sb   t0, 0(s0)             # Kirim karakter ke layar TTY
        addi s1, s1, 1             # Geser ke karakter berikutnya
        addi a0, a0, 1             # Tambah hitungan karakter
        j    loop                  # Ulangi ke awal loop

done:
        ebreak                     # Hentikan CPU
