/* Copyright (C) 2017 Daniel Page <csdsp@bristol.ac.uk>
 *
 * Use of this source code is restricted per the CC BY-NC-ND license, a copy of 
 * which can be found via http://creativecommons.org (and should be included as 
 * LICENSE.txt within the associated archive or repository).
 */

module key_schedule( output wire [ 55 : 0 ] r,
                     output wire [ 47 : 0 ] k,
                      input wire [ 55 : 0 ] x,
                      input wire [  3 : 0 ] i);

  // Stage 1: complete this module implementation

  wire [27:0] r0; 
  wire [27:0] r1; 
  wire [27:0] r2; 
  wire [27:0] r3;

  split_0 sp1(.r1(r1), .r0(r0), .x(x));

  clr_28bit clr1(.r(r2), .y(i), .x(r1));
  clr_28bit clr2(.r(r3), .y(i), .x(r0));

  merge_0 mer(.r(r), .x1(r2), .x0(r3));

  perm_PC2 per(.r(k), .x(r));
  // always @(r) begin
  //   $display("ks: x= %h, r= %h, t=%d, n=%d",  x, r, ticks, n);
  // end
endmodule
