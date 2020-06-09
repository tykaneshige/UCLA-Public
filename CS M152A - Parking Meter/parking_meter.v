// Created using Xilinx IDE

`timescale 1ns / 1ps

module parking_meter(
	input add1,
	input add2,
	input add3,
	input add4,
	input rst1,
	input rst2,
	input clk,
	input rst,
	output reg[6:0] led_seg,
	output reg a1,
	output reg a2,
	output reg a3,
	output reg a4,
	output reg[3:0] val1,
	output reg[3:0] val2,
	output reg[3:0] val3,
	output reg[3:0] val4);

reg[13:0] counter;

reg[1:0] switch_digit;

// --- Auxiliary Functions --- //

// Divide-by-100 Module
reg clk_100;
reg[6:0] counter100;

always @ (posedge (clk))
begin

	if (counter100 == 49) begin
		clk_100 <= ~clk_100;
		counter100 <= 0;
	end else begin
		counter100 <= counter100 + 1;
	end

end

// --- Main Functions --- //

// Input Module
always @ (posedge(clk))
begin

	if (rst) begin
	
		counter <= 0;
		
		switch_digit <= 0;
		
		clk_100 <= 0;
		counter100 <= 0;

	end else begin
	
		if (add1) begin
		
			if ((9999 - counter) >= 60) begin
				counter <= counter + 60;
				switch_digit <= 0;
			end else begin
				counter <= 9999;
			end
			
		end else if (add2) begin
		
			if ((9999 - counter) >= 120) begin
				counter <= counter + 120;
				switch_digit <= 0;
			end else begin
				counter <= 9999;
			end
	
		end else if (add3) begin
			
			if ((9999 - counter) >= 180) begin
				counter <= counter + 180;
				switch_digit <= 0;
			end else begin
				counter <= 9999;
			end		

		end else if (add4) begin
		
			if ((9999 - counter) >= 300) begin
				counter <= counter + 300;
				switch_digit <= 0;
			end else begin
				counter <= 9999;
			end
			
		end else if (rst1) begin
		
			counter <= 16;
			switch_digit <= 0;
			
		end else if (rst2) begin
		
			counter <= 150;
			switch_digit <= 0;

		end
	
	end

end

// Counter Module
// Decrement the counter
always @ (posedge(clk_100))
begin

	if (counter > 0) begin
		counter <= counter - 1;
	end

end

// Output Module
// Uses active-low logic for led_seg (as discussed in lab)
always @ (*)
begin

	val1 <= counter / 1000;
	val2 <= (counter - (val1 * 1000)) / 100;
	val3 <= (counter - (val1 * 1000) - (val2 * 100)) / 10;
	val4 <= (counter - (val1 * 1000) - (val2 * 100) - (val3 * 10));
	
end

// Display Module
// Determine the display outputs (led_seg, anodes)
always @ (posedge (clk))
begin

	if ((counter > 0) && (counter < 180)) begin
	
		if (!(counter % 2)) begin
		
			case (switch_digit)
			
				0:
				begin
				
					a1 <= 1;
					a2 <= 0;
					a3 <= 0;
					a4 <= 0;
					
					case (val1)
					
						0: led_seg <= 0000001;
						1: led_seg <= 1001111;
						2: led_seg <= 0010010;
						3: led_seg <= 0000110;
						4: led_seg <= 1001101;
						5: led_seg <= 0100100;
						6: led_seg <= 0100000;
						7: led_seg <= 0001111;
						8: led_seg <= 0000000;
						9: led_seg <= 0000100;
					
					endcase
				
				end
				
				1: 
				begin
				
					a1 <= 0;
					a2 <= 1;
					a3 <= 0;
					a4 <= 0;
					
					case (val2)
					
						0: led_seg <= 0000001;
						1: led_seg <= 1001111;
						2: led_seg <= 0010010;
						3: led_seg <= 0000110;
						4: led_seg <= 1001101;
						5: led_seg <= 0100100;
						6: led_seg <= 0100000;
						7: led_seg <= 0001111;
						8: led_seg <= 0000000;
						9: led_seg <= 0000100;
					
					endcase
				
				end
				
				2: 
				begin
				
					a1 <= 0;
					a2 <= 0;
					a3 <= 1;
					a4 <= 0;
					
					case (val3)
					
						0: led_seg <= 0000001;
						1: led_seg <= 1001111;
						2: led_seg <= 0010010;
						3: led_seg <= 0000110;
						4: led_seg <= 1001101;
						5: led_seg <= 0100100;
						6: led_seg <= 0100000;
						7: led_seg <= 0001111;
						8: led_seg <= 0000000;
						9: led_seg <= 0000100;
					
					endcase
				
				end
				
				3: 
				begin
				
					a1 <= 0;
					a2 <= 0;
					a3 <= 0;
					a4 <= 1;
					
					case (val4)
					
						0: led_seg <= 0000001;
						1: led_seg <= 1001111;
						2: led_seg <= 0010010;
						3: led_seg <= 0000110;
						4: led_seg <= 1001101;
						5: led_seg <= 0100100;
						6: led_seg <= 0100000;
						7: led_seg <= 0001111;
						8: led_seg <= 0000000;
						9: led_seg <= 0000100;
					
					endcase
				
				end
				
			endcase
			
			switch_digit <= switch_digit + 1;
		
		end else begin
		
			a1 <= 1;
			a2 <= 1;
			a3 <= 1;
			a4 <= 1;
			
			led_seg <= 7'b1111111;
			switch_digit <= 0;
			
		end
	
	end else begin
	
		if (clk_100) begin
		
			case (switch_digit)
			
				0:
				begin
				
					a1 <= 1;
					a2 <= 0;
					a3 <= 0;
					a4 <= 0;
					
					case (val1)
					
						0: led_seg <= 0000001;
						1: led_seg <= 1001111;
						2: led_seg <= 0010010;
						3: led_seg <= 0000110;
						4: led_seg <= 1001101;
						5: led_seg <= 0100100;
						6: led_seg <= 0100000;
						7: led_seg <= 0001111;
						8: led_seg <= 0000000;
						9: led_seg <= 0000100;
					
					endcase
				
				end
				
				1: 
				begin
				
					a1 <= 0;
					a2 <= 1;
					a3 <= 0;
					a4 <= 0;
					
					case (val2)
					
						0: led_seg <= 0000001;
						1: led_seg <= 1001111;
						2: led_seg <= 0010010;
						3: led_seg <= 0000110;
						4: led_seg <= 1001101;
						5: led_seg <= 0100100;
						6: led_seg <= 0100000;
						7: led_seg <= 0001111;
						8: led_seg <= 0000000;
						9: led_seg <= 0000100;
					
					endcase
				
				end
				
				2: 
				begin
				
					a1 <= 0;
					a2 <= 0;
					a3 <= 1;
					a4 <= 0;
					
					case (val3)
					
						0: led_seg <= 0000001;
						1: led_seg <= 1001111;
						2: led_seg <= 0010010;
						3: led_seg <= 0000110;
						4: led_seg <= 1001101;
						5: led_seg <= 0100100;
						6: led_seg <= 0100000;
						7: led_seg <= 0001111;
						8: led_seg <= 0000000;
						9: led_seg <= 0000100;
					
					endcase
				
				end
				
				3: 
				begin
				
					a1 <= 0;
					a2 <= 0;
					a3 <= 0;
					a4 <= 1;
					
					case (val4)
					
						0: led_seg <= 0000001;
						1: led_seg <= 1001111;
						2: led_seg <= 0010010;
						3: led_seg <= 0000110;
						4: led_seg <= 1001101;
						5: led_seg <= 0100100;
						6: led_seg <= 0100000;
						7: led_seg <= 0001111;
						8: led_seg <= 0000000;
						9: led_seg <= 0000100;
					
					endcase
				
				end
				
			endcase
			
			switch_digit <= switch_digit + 1;
		
		end else begin
		
			a1 <= 1;
			a2 <= 1;
			a3 <= 1;
			a4 <= 1;
			
			led_seg <= 7'b1111111;
			switch_digit <= 0;
			
		end
		
	end

end

endmodule