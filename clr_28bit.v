/* Copyright (C) 2017 Daniel Page <csdsp@bristol.ac.uk>
 *
 * Use of this source code is restricted per the CC BY-NC-ND license, a copy of 
 * which can be found via http://creativecommons.org (and should be included as 
 * LICENSE.txt within the associated archive or repository).
 */

module f (output wire[  1 : 0 ]res,
          input wire [  3 : 0 ] y);

  // each four bits represent case-numbers 0, 1, 8, 15.
  wire [ 15 : 0 ] zoef = 16'b0000000110001111;

  wire [ 15 : 0 ] mask; // to check y-bits with bits for each case
  wire [ 3 : 0 ] cnc;   // if some bit will be 1, then case-number is found
  wire isCase;      // if 1 then number is found, else if 0 it is not found

  // check y on 0000 (0)
  xor z3(mask[15], zoef[15], y[3]);
  xor z2(mask[14], zoef[14], y[2]);
  xor z1(mask[13], zoef[13], y[1]);
  xor z0(mask[12], zoef[12], y[0]);

  nor uup(cnc[3], mask[12],mask[13],mask[14],mask[15]);

  // check y on 0001 (1)
  xor o3(mask[11], zoef[11], y[3]);
  xor o2(mask[10], zoef[10], y[2]);
  xor o1(mask[9], zoef[9], y[1]);
  xor o0(mask[8], zoef[8], y[0]);

  nor uup1(cnc[2], mask[8],mask[9],mask[10],mask[11]);

  // check y on 1000 (8)
  xor e3(mask[7], zoef[7], y[3]);
  xor e2(mask[6], zoef[6], y[2]);
  xor e1(mask[5], zoef[5], y[1]);
  xor e0(mask[4], zoef[4], y[0]);

  nor uup2(cnc[1], mask[7],mask[6],mask[5],mask[4]);

  // check y on 1111 (15)
  xor f3(mask[3], zoef[3], y[3]);
  xor f2(mask[2], zoef[2], y[2]);
  xor f1(mask[1], zoef[1], y[1]);
  xor f0(mask[0], zoef[0], y[0]);

  nor uup3(cnc[0], mask[3],mask[2],mask[1],mask[0]);

  // check if y is the case-number
  or finRes(isCase, cnc[0], cnc[1], cnc[2], cnc[3]);

  // return for output 2 or 1 with the help of 1-bits full-adder  
  // full-adder adds 1 to isCase wire to get 1 or 2 for output res wire 
  wire w0 , w1 , w2;
  xor t0( w0 , 1'b1, isCase );
  and t1( w1 , 1'b1, isCase );

  xor t2( res[1], w0 , 1'b0 );
  and t3( w2 , w0 , 1'b0 );

  or t4( res[0] , w1 , w2 );

endmodule

module clr_28bit( output wire [ 27 : 0 ] r,
                   input wire [ 27 : 0 ] x,
                   input wire [  3 : 0 ] y );

  // Stage 1: complete this module implementation

  wire [ 1 : 0 ] shiftVal;

  f s(.res(shiftVal), .y(y));

  wire [ 27 : 0 ] leftShift = x << shiftVal;
  wire [ 27 : 0 ] rightShift = x >> (28 - shiftVal);

  assign r = leftShift | rightShift;

endmodule
