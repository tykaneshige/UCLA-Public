// Created using Xilinx IDE

`timescale 1ns / 1ps

module testbench_305110285;

	// Inputs
	reg add1;
	reg add2;
	reg add3;
	reg add4;
	reg rst1;
	reg rst2;
	reg clk;
	reg rst;

	// Outputs
	wire [6:0] led_seg;
	wire a1;
	wire a2;
	wire a3;
	wire a4;
	wire [3:0] val1;
	wire [3:0] val2;
	wire [3:0] val3;
	wire [3:0] val4;

	// Instantiate the Unit Under Test (UUT)
	parking_meter uut (
		.add1(add1), 
		.add2(add2), 
		.add3(add3), 
		.add4(add4), 
		.rst1(rst1), 
		.rst2(rst2), 
		.clk(clk), 
		.rst(rst), 
		.led_seg(led_seg), 
		.a1(a1), 
		.a2(a2), 
		.a3(a3), 
		.a4(a4), 
		.val1(val1), 
		.val2(val2), 
		.val3(val3), 
		.val4(val4)
	);
	
	always #1 clk = ~clk;

	initial begin
	
		// Initialize Inputs
		add1 = 0;
		add2 = 0;
		add3 = 0;
		add4 = 0;
		rst1 = 0;
		rst2 = 0;
		clk = 0;
		rst = 1;
		
		// Wait 100 ns for global reset to finish
		#100 rst = 0;
        
		// Add stimulus here

		// Test 1 Series
		// Individually tests each input and verifies correct behavior
		
		// Test 1a
		// Verifies correct behavior for 'add1'
		#10 add1 = 1;
		#2 add1 = 0;
		
		#10 rst = 1;
		#10 rst = 0;
		
		// Test 1b
		// Verifies correct behavior for 'add2'
		#10 add2 = 1;
		#2 add2 = 0;
		
		#10 rst = 1;
		#10 rst = 0;

		// Test 1c
		// Verifies correct behavior for 'add3'
		#10 add3 = 1;
		#2 add3 = 0;
		
		#10 rst = 1;
		#10 rst = 0;
		
		// Test 1d
		// Verifies correct behavior for 'add4'
		#10 add4 = 1;
		#2 add4 = 0;
		
		#10 rst = 1;
		#10 rst = 0;
		
		// Test 1e
		// Verifies correct behavior for 'rst1'
		#10 rst1 = 1;
		#2 rst1 = 0;
		
		#10 rst = 1;
		#10 rst = 0;
		
		// Test 1f
		// Verifies correct behavior for 'rst2'
		#10 rst2 = 1;
		#2 rst2 = 0;
		
		#10 rst = 1;
		#10 rst = 0;
		
		// Test 2 Series
		// Verifies correct display behavior 
		
		// Test 2a
		// Verifies correct display behavior when the machine is idle
		#500;
		
		// Test 2b
		// Verifies correct display behavior when 0 < counter < 180
		#10 rst2 = 1;
		#2 rst2 = 0;
		
		#1000;
		
		#10 rst = 1;
		#10 rst = 0;
		
		// Test 2c
		// Verifies correct display behavior when 180 < counter < 9999
		#10 add4 = 1;
		#2 add4 = 0;
		
		#1000;
		
		#10 rst = 1;
		#10 rst = 0;
		
		// Test 2d
		// Verifies correct display behavior when transitioning from counter = 180 to count = 179
		#100 add3 = 1;
		#2 add3 = 0;
		
		#1000;
		
		#10 rst = 1;
		#10 rst = 0;
		
		// Test 3 Series
		// Verifies that overflow does not occur in any situation
		
		// Test 3a
		// Verifies that add1 does not cause overflow
		#10 add1 = 1;
		#1000 add1 = 0;
		
		#10 rst = 1;
		#10 rst = 0;
		
		// Test 3b
		// Verifies that add2 does not cause overflow
		#10 add2 = 1;
		#1000 add2 = 0;
		
		#10 rst = 1;
		#10 rst = 0;
		
		// Test 3c
		// Verifies that add3 does not cause overflow
		#10 add3 = 1;
		#1000 add3 = 0;
		
		#10 rst = 1;
		#10 rst = 0;
		
		// Test 3d
		// Verifies that add4 does not cause overflow
		#10 add4 = 1;
		#1000 add4 = 0;
		
		#10 rst = 1;
		#10 rst = 0;
				
		$finish;

	end
      
endmodule