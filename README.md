# PS/2 Keyboard to 8-Digit 7-Segment Display Interface (Verilog)

This Verilog project allows real-time input from a PS/2 keyboard to be displayed on an 8-digit 7-segment display. Each key press shifts the digits to the left, maintaining a history of the last 8 digits entered.

## Features

- **PS/2 Keyboard Interface**: Captures keycodes from a standard PS/2 keyboard.
- **Debouncing**: Clean signal processing using software debounce for PS/2 data and clock lines.
- **7-Segment Display Driver**: Displays numeric digits (0–9) on an 8-digit multiplexed 7-segment display.
- **Shift Register Behavior**: Keeps track of the last 8 numeric key presses.

## Modules

### 1. `SSD_display`
- Drives the 8-digit 7-segment display using time-multiplexing.
- Converts 4-bit values into appropriate 7-segment codes.
- Inputs: 8 nibbles (A–H), clock, reset
- Outputs: `anode`, `segment`

### 2. `debounce`
- Debounces button or signal input.
- Parameterized debounce length.
- Used for PS/2 clock and data lines.

### 3. `keyboard`
- Captures serial PS/2 data stream.
- Extracts 8-bit scan codes.
- Matches keycodes for digits 0–9 and shifts display values accordingly.
- Interfaces with `SSD_display` to show the result.

## Hardware Requirements

- FPGA development board (tested with Xilinx/Intel boards)
- PS/2 Keyboard (with PS/2 connector or adapter)
- 8-digit common anode 7-segment display

## PS/2 Key Mappings

| Key | PS/2 Scan Code |
|-----|----------------|
| 0   | `0x45`         |
| 1   | `0x16`         |
| 2   | `0x1E`         |
| 3   | `0x26`         |
| 4   | `0x25`         |
| 5   | `0x2E`         |
| 6   | `0x36`         |
| 7   | `0x3D`         |
| 8   | `0x3E`         |
| 9   | `0x46`         |

## How It Works

1. The PS/2 signals are debounced using the `debounce` module.
2. On valid clock edges, the `keyboard` module captures the PS/2 data bits and reconstructs the 8-bit scan code.
3. Valid digit codes are mapped and stored in an 8-digit shift register (`A` to `H`).
4. The `SSD_display` module multiplexes these digits onto the 7-segment display with appropriate timing and encoding.

## To Do

- Add support for hexadecimal characters (A–F).
- Add backspace/delete key functionality.
- Display scan codes or ASCII characters instead of just digits.
- Integrate UART output for debugging.



