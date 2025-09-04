# =============================================================
# Clocks: CLK_IN (top), Clk (PLL_Ports.c0), FIRCLK_w (PLL_lower_freq_Ports.c0)
# =============================================================

# --- Base input clock on AF14 (edit period if not 50 MHz) ---
create_clock -name CLK_IN -period 20.000 [get_ports {CLK_IN}]
derive_pll_clocks

# --- Clk: PLL_Ports.c0 generated from CLK_IN -----------------
create_generated_clock -name Clk \
  -source [get_ports {CLK_IN}] \
  [get_pins {PLL_Ports|c0}]

# --- FIRCLK_w: PLL_lower_freq_Ports.c0 generated from Clk ----
create_generated_clock -name FIRCLK_w \
  -source [get_pins {PLL_Ports|c0}] \
  [get_pins {PLL_lower_freq_Ports|c0}]

# --- Standard uncertainty -----------------------------------
derive_clock_uncertainty

# --- Async resets/buttons not timed as data ------------------
set_false_path -from [get_ports {RESET* reset* KEY* SW*}] -to [all_registers]

# --- Simple GPIO I/O delays (LED/HEX/SW/KEY) -----------------
set_input_delay  0.0 -clock [get_clocks *] [get_ports {SW* KEY*}]
set_output_delay 0.0 -clock [get_clocks *] [get_ports {LED* HEX*}]
