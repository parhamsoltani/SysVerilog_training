`timescale 1ns/1ps
module ahb_interface_tb;
  // Clock generation
  bit clk = 0;
  always #5 clk = ~clk;
  
  // Instantiate interface
  ahb_interface ahb();
  
  // Connect clock
  assign ahb.HCLK = clk;
  
  // Test stimulus
  initial begin
    // Initialize signals
    ahb.HADDR   = '0;
    ahb.HWRITE  = '0;
    ahb.HTRANS  = 2'b00; // IDLE
    ahb.HWDATA  = '0;
    
    // Wait for 2 clock cycles
    repeat(2) @(posedge clk);
    
    // Test case 1: Valid IDLE transaction
    @(posedge clk);
    ahb.HTRANS = 2'b00; // IDLE
    ahb.HADDR  = 21'h10_0000;
    ahb.HWRITE = 1'b1;
    ahb.HWDATA = 8'hAA;
    
    // Test case 2: Valid NONSEQ transaction
    @(posedge clk);
    ahb.HTRANS = 2'b10; // NONSEQ
    ahb.HADDR  = 21'h20_0000;
    ahb.HWRITE = 1'b0;
    
    // Test case 3: Invalid transaction (2'b01)
    @(posedge clk);
    ahb.HTRANS = 2'b01;  // This should trigger the error
    
    // Run for a few more cycles
    repeat(5) @(posedge clk);
    
    $finish;
  end
  
  // Optional: Monitor for viewing transactions
  initial begin
    $monitor("Time=%0t HTRANS=%b HADDR=%h HWRITE=%b HWDATA=%h", 
             $time, ahb.HTRANS, ahb.HADDR, ahb.HWRITE, ahb.HWDATA);
  end
  
endmodule