add wave -position insertpoint  \
sim:/control/D_IN \
sim:/control/ALUOp \
sim:/control/ALUSrc \
sim:/control/beq_bne \
sim:/control/branch \
sim:/control/Halt \
sim:/control/J_link \
sim:/control/J_O \
sim:/control/J_reg \
sim:/control/MemtoReg \
sim:/control/MemWrite \
sim:/control/RegDst \
sim:/control/RegWrite

force -freeze sim:/control/D_IN 32'h00000020 0
run 100

force -freeze sim:/control/D_IN 32'h20000000 0
run 100

force -freeze sim:/control/D_IN 32'h24000000 0
run 100

force -freeze sim:/control/D_IN 32'h00000021 0
run 100

force -freeze sim:/control/D_IN 32'h00000024 0
run 100

force -freeze sim:/control/D_IN 32'h30000000 0
run 100

force -freeze sim:/control/D_IN 32'h3F000000 0
run 100

force -freeze sim:/control/D_IN 32'h8F000000 0
run 100

force -freeze sim:/control/D_IN 32'hF8000000 0
run 100

force -freeze sim:/control/D_IN 32'h00000027 0
run 100

force -freeze sim:/control/D_IN 32'h00000026 0
run 100

force -freeze sim:/control/D_IN 32'h28000000 0
run 100

force -freeze sim:/control/D_IN 32'h00000025 0
run 100

force -freeze sim:/control/D_IN 32'h34000000 0
run 100

force -freeze sim:/control/D_IN 32'h0000002A 0
run 100

force -freeze sim:/control/D_IN 32'h28000000 0
run 100

force -freeze sim:/control/D_IN 32'h00000000 0
run 100

force -freeze sim:/control/D_IN 32'h00000002 0
run 100

force -freeze sim:/control/D_IN 32'h00000003 0
run 100

force -freeze sim:/control/D_IN 32'hAC000000 0
run 100

force -freeze sim:/control/D_IN 32'h00000023 0
run 100

force -freeze sim:/control/D_IN 32'h10000000 0
run 100

force -freeze sim:/control/D_IN 32'h14000000 0
run 100

force -freeze sim:/control/D_IN 32'h08000000 0
run 100

force -freeze sim:/control/D_IN 32'h0C000000 0
run 100

force -freeze sim:/control/D_IN 32'h00000008 0
run 100

force -freeze sim:/control/D_IN 32'h7C000000 0
run 100

force -freeze sim:/control/D_IN 32'hFC000000 0
run 100



















