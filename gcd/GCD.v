
`default_nettype none
module GCD
	#(parameter WIDTH=8)
	(input clk,
	 input start,
	 input [WIDTH-1:0] A,
	 input [WIDTH-1:0] B,
	 output reg [WIDTH-1:0] RESULT,
	 output reg done );
	
	reg [WIDTH-1:0] regA,regB,tmp;
	reg run = 1'b0;
	
	always @ (posedge clk) begin
		if (start==1'b1) begin
			if (A==0 && B==0) begin
				RESULT <= 0;
				done <= 1'b1;
			end
			else begin
				regA <= A;
				regB = B;
				done <= 1'b0;
				run  <= 1'b1;
			end
		end
	end
	
	always @ (posedge clk) begin
		if (run) begin
			if (regB !=0) begin
				if (regA >= regB)
					regA <= regA - regB;
				else begin
					tmp  <= regA;
					regA <= regB;
					regB = tmp;
				end
			end
			else begin
				RESULT <= regA;
				done   <= 1'b1;
				run    <= 1'b0;
			end
		end
	end
endmodule