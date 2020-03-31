`timescale 1 ns / 1 ns

module RAMshift_taps #(
	parameter Delay_Length = 640,
	parameter INPUT_WIDTH = 8
) (
	input	  					   clken, 
	input	  					   clock,
	input	[INPUT_WIDTH - 1 : 0]  shiftin,
	output	[INPUT_WIDTH - 1 : 0]  shiftout
);

reg  [15:0] RAM_CNT = 0;
reg	 [INPUT_WIDTH - 1 : 0] ram_buf = 0;
reg	 [INPUT_WIDTH - 1 : 0] shift_ram [Delay_Length - 1 : 0];

integer m;
initial begin
	for (m = 0; m<=Delay_Length; m=m+1) begin
		shift_ram[m] = 0;
	end    
end

always @(posedge clock) begin
    if (RAM_CNT == (Delay_Length - 1)) 
        RAM_CNT <= 16'd0;
    else if (clken) 
        RAM_CNT <= RAM_CNT + 1;
	else
		RAM_CNT <= RAM_CNT;
end

always @(posedge clock) begin	
	if (clken) begin
		shift_ram[RAM_CNT] <= shiftin;
	end	
	else begin
		shift_ram[RAM_CNT] <= shift_ram[RAM_CNT];
	end
end

assign shiftout = shift_ram[RAM_CNT];

endmodule

