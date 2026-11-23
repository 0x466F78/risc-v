# RISC-V

Prosesor 32-bit di Logisim-evolution.

- **ISA:** RISC-V RV32I — Instruksi 32-bit lengkap (`ADD`/`ADDI`, `LOAD`/`STORE`, `BRANCH`, `JAL`/`JALR`, `LUI`/`AUIPC`, `ECALL`/`EBREAK` = `HALT`) dengan jalur data 32-bit.
- **Eksekusi:** *Single-Cycle* — Satu instruksi selesai dalam satu siklus *clock*.
- **Register:** 32 register *general-purpose* 32-bit (`x0`–`x31`, dengan `x0 = 0`) serta *counter* performa (`cycles` dan `instret`).

## Peta Memori & Memory-Mapped I/O

CPU menggunakan arsitektur **Harvard** (memori instruksi dan memori data terpisah):

| Alamat / Rentang | Komponen / Register | Akses | Keterangan |
| :--- | :--- | :---: | :--- |
| `0x0000_0000` – `0x0000_0FFF` | **IMEM (ROM)** | R | ROM instruksi (1K × 32-bit / 1024 instruksi) |
| `0x0000_0000` – `0x0000_3FFF` | **DMEM (RAM)** | R/W | RAM data (4K × 32-bit / 16 KiB, `.data` mulai di `0x0000_0000`) |
| `0xF000_0000` | **`UART_TXDATA` (TTY)** | W | Output karakter ASCII ke layar TTY (`sb`/`sw`) |
| `0xF000_0004` | **`UART_RXDATA` (Keyboard)** | R | Baca karakter dari antrean *keyboard* (hanya menggeser antrean saat `MemRead=1`) |
| `0xF000_0008` | **`UART_STATUS`** | R | Status UART (misalnya bit 0 menandakan karakter siap dibaca) |
| `0xF000_0010` | **`GPIO_OUT`** | R/W | Output ke 4 *hex/7-segment display* & LED (`0x10` word/16-bit bawah, `0x12` byte ke-2 untuk LED) |
| `0xF000_0014` | **`GPIO_IN`** | R | Input dari 8 *DIP switch* |

- **Dekode alamat I/O:** Region I/O aktif saat `Addr[31:28] = 0xF`, dan register dipilih menggunakan `Addr[4:2]`. Alamat lain di dalam region I/O bernilai `0` saat dibaca.

## Tutorial Pemrograman

Contoh program singkat untuk mencetak **`HI`** ke layar TTY (`0xF0000000`):

```asm
        .text
main:
        li   t0, 0xF0000000        # t0 = alamat layar TTY

        li   t1, 72                # 72 dalam ASCII = 'H'
        sb   t1, 0(t0)             # Kirim 'H' ke layar TTY

        li   t1, 73                # 73 dalam ASCII = 'I'
        sb   t1, 0(t0)             # Kirim 'I' ke layar TTY

        ebreak                     # Hentikan CPU
```

## Compile Assembly

Jalankan dari direktori `sw/`:

```bash
cd ~/Downloads/rv32i/sw
python3 asm.py demo/hi.s -o build/hi
```

Output yang dihasilkan di `sw/build/`:

* `hi.text.hex` — kode instruksi (`v3.0 hex words plain`)
* `hi.data.hex` — data memori (`v3.0 hex words plain`)
* `hi.lst` — *listing* alamat, kode mesin, dan baris sumber

## Menjalankan di Simulator

1. Buka `hw/cpu.circ` di **Logisim-evolution**.
2. Klik kanan **ROM instruksi** (`IMEM`) → **Load Image...** → pilih file `sw/build/<nama>.text.hex` (muat juga `<nama>.data.hex` ke **RAM data** jika diperlukan).
3. Tekan **Ctrl+R** untuk *reset*, lalu **Ctrl+K** untuk menjalankan *clock* (atau **Ctrl+T** untuk *half-cycle*).
4. Untuk program I/O seperti `echo.s`, klik komponen **Keyboard** (`0xF0000004`) dan ketikkan karakter untuk melihat output di layar/TTY (`0xF0000000`).