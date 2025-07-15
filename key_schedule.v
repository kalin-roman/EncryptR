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

  wire [55:0] res01;
  wire [55:0] res23;

  split_0 sp1(.r1(res01[55:28]), .r0(res01[27:0]), .x(x));

  clr_28bit clr1(.r(res23[55:28]), .y(i), .x(res01[55:28]));
  clr_28bit clr2(.r(res23[27:0]), .y(i), .x(res01[27:0]));

  merge_0 mer(.r(r), .x1(res23[55:28]), .x0(res23[27:0]));

  perm_PC2 per(.r(k), .x(r));

endmodule
