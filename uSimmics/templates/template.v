// ***********************************************************
// Description:
// Date:
// Author:
// ***********************************************************

`timescale 1ps/100fs

// -----------------------------------------------------------
// sub module

module SubModule (signal1, signal2, signal3);
  wire intern1, intern2, intern3;
  input signal1, signal2;
  output signal3;

  assign intern1 = signal1 | signal2;  // logic OR
  assign intern2 = signal1 & signal2;  // logic AND
  assign intern3 = intern1 ^ intern2;  // logic XOR
  assign #1000 signal3 = ~intern3;  // invert after 1ns
endmodule


// -----------------------------------------------------------
// main module

module TestBench ();
  wire gnd, signal1, signal2;

  assign gnd = 0;
  assign signal1 = 1;
  SubModule Sub1 (gnd, signal1, signal2);

  initial begin
    $dumpfile("digi.vcd"); // name of output file must be "digi.vcd"!
    $dumpvars();
    #10000 $finish;    // run 10ns
  end

endmodule   // of 'TestBench'
