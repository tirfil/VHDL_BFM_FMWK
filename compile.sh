set FLAG -v --work=work --workdir=work --syn-binding --ieee=synopsys --std=93c -fexplicit
ghdl -a $FLAG bfm_pkg.vhd
ghdl -a $FLAG cpu_pkg.vhd
ghdl -a $FLAG bfm_cpu.vhd
ghdl -a $FLAG tb_bfm_cpu.vhd
ghdl -e $FLAG tb_bfm_cpu
ghdl -r $FLAG tb_bfm_cpu --vcd=wave.vcd

