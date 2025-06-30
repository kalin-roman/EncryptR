/* Copyright (C) 2017 Daniel Page <csdsp@bristol.ac.uk>
 *
 * Use of this source code is restricted per the CC BY-NC-ND license, a copy of 
 * which can be found via http://creativecommons.org (and should be included as 
 * LICENSE.txt within the associated archive or repository).
 */

module round( output wire [ 31 : 0 ] rl,
              output wire [ 31 : 0 ] rr,
               input wire [ 31 : 0 ] xl,
               input wire [ 31 : 0 ] xr,
               input wire [ 47 : 0 ] k );

  // Stage 1: complete this module implementation
  assign rl =  xr;
  
  wire [47:0]xorRes;
  wire [47:0]permRes;

  perm_E per2(.r(permRes),.x(xr));
  xor xor1(xorRes, permRes, k);

  split_1 sp1();



endmodule
