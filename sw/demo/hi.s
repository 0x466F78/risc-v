# hi.s - Cetak "HI" ke layar TTY (0xF0000000)

        .text
main:
        li   t0, 0xF0000000        # t0 = alamat layar TTY

        li   t1, 72                # 72 dalam ASCII = 'H'
        sb   t1, 0(t0)             # Kirim 'H' ke layar TTY

        li   t1, 73                # 73 dalam ASCII = 'I'
        sb   t1, 0(t0)             # Kirim 'I' ke layar TTY

        ebreak                     # Hentikan CPU
