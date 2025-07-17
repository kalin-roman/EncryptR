/* Copyright (C) 2017 Daniel Page <csdsp@bristol.ac.uk>
 *
 * Use of this source code is restricted per the CC BY-NC-ND license, a copy of 
 * which can be found via http://creativecommons.org (and should be included as 
 * LICENSE.txt within the associated archive or repository).
 */
module multipXor48( output wire [ 47 : 0 ] xorRes,
                   input wire [ 47 : 0 ] permR,
                   input wire [ 47 : 0 ] k);

  genvar t;
  
  generate
    for (t = 0; t <= 47; t++) begin:id
      xor xor1(xorRes[t], permR[t], k[t]);
    end
  endgenerate

endmodule

module multipXor32( output wire [ 31 : 0 ] xorRes,
                   input wire [ 31 : 0 ] permR,
                   input wire [ 31 : 0 ] k);

  genvar t;
  
  generate
    for (t = 0; t <= 31; t++) begin:id
      xor xor2(xorRes[t], permR[t], k[t]);
    end
  endgenerate

endmodule

module optForSbox( output wire[ 31 : 0 ] rm,
                   input wire [ 47 : 0 ] x);

  sbox_0 s0(.r(rm[ 3 : 0 ]),  .x(x[ 5 : 0 ]));
  sbox_1 s1(.r(rm[ 7 : 4 ]),  .x(x[ 11 : 6 ]));
  sbox_2 s2(.r(rm[ 11 : 8 ]), .x(x[ 17 : 12 ]));
  sbox_3 s3(.r(rm[ 15 : 12 ]),.x(x[ 23 : 18 ]));
  sbox_4 s4(.r(rm[ 19 : 16 ]),.x(x[ 29 : 24 ]));
  sbox_5 s5(.r(rm[ 23 : 20 ]),.x(x[ 35 : 30 ]));
  sbox_6 s6(.r(rm[ 27 : 24 ]),.x(x[ 41 : 36 ]));
  sbox_7 s7(.r(rm[ 31 : 28 ]),.x(x[ 47 : 42 ]));

endmodule


module round( output wire [ 31 : 0 ] rl,
              output wire [ 31 : 0 ] rr,
               input wire [ 31 : 0 ] xl,
               input wire [ 31 : 0 ] xr,
               input wire [ 47 : 0 ] k);

  // Stage 1: complete this module implementation
  assign rl =  xr;
    
  wire [ 47 : 0 ]resOfPer;
  wire [ 47 : 0 ]perm1Res;
  wire [ 47 : 0 ]xorRes;

  perm_E per1(.r(perm1Res),.x(xr));

  multipXor48 mulXor1(.xorRes(xorRes),.permR(perm1Res), .k(k));

  split_1 sp1(.r0(resOfPer[ 5 : 0 ]), .r1(resOfPer[ 11 : 6 ]), 
              .r2(resOfPer[ 17 : 12 ]), .r3(resOfPer[ 23 : 18 ]), 
              .r4(resOfPer[ 29 : 24 ]), .r5(resOfPer[ 35 : 30 ]),
              .r6(resOfPer[ 41 : 36 ]), .r7(resOfPer[ 47 : 42 ]),
              .x(xorRes));

  wire [ 31 : 0 ] rm;
  optForSbox opt1(.rm(rm), .x(resOfPer));

  wire [ 31 : 0 ] mergeResult;

  merge_1 m1(.r (mergeResult),
             .x0(rm[ 3 : 0 ]),.x1(rm[ 7 : 4 ]),
             .x2(rm[ 11 :  8 ]),.x3(rm[ 15 : 12 ]),
             .x4(rm[ 19 : 16 ]),.x5(rm[ 23 : 20 ]),
             .x6(rm[ 27 : 24 ]),.x7(rm[ 31 : 28 ]));

  wire [ 31 : 0 ] perm2Res;

  perm_P per2(.r(perm2Res), .x(mergeResult));

  wire [ 31 : 0 ]xorRes2;

  multipXor32 mulXor2(.xorRes(xorRes2),.permR(perm2Res), .k(xl));

  assign rr = xorRes2;


endmodule
