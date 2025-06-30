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

module round( output wire [ 31 : 0 ] rl,
              output wire [ 31 : 0 ] rr,
               input wire [ 31 : 0 ] xl,
               input wire [ 31 : 0 ] xr,
               input wire [ 47 : 0 ] k );

  // Stage 1: complete this module implementation
  assign rl =  xr;
  
  wire [47:0]xorRes;
  wire [47:0]perm1Res;

  wire [5:0] r0;
  wire [5:0] r1;
  wire [5:0] r2;
  wire [5:0] r3;
  wire [5:0] r4;
  wire [5:0] r5;
  wire [5:0] r6;
  wire [5:0] r7;

  perm_E per1(.r(perm1Res),.x(xr));

  multipXor48 mulXor1(.xorRes(xorRes),.permR(perm1Res), .k(k));

  split_1 sp1(.r0(r0), .r1(r1), 
              .r2(r2), .r3(r3), 
              .r4(r4), .r5(r5),
              .r6(r6), .r7(r7),
              .x(xorRes));

  wire [3:0] rm0;
  wire [3:0] rm1;
  wire [3:0] rm2;
  wire [3:0] rm3;
  wire [3:0] rm4;
  wire [3:0] rm5;
  wire [3:0] rm6;
  wire [3:0] rm7;

  sbox_0 s0(.r(rm0),.x(r0));
  sbox_1 s1(.r(rm1),.x(r1));
  sbox_2 s2(.r(rm2),.x(r2));
  sbox_3 s3(.r(rm3),.x(r3));
  sbox_4 s4(.r(rm4),.x(r4));
  sbox_5 s5(.r(rm5),.x(r5));
  sbox_6 s6(.r(rm6),.x(r6));
  sbox_7 s7(.r(rm7),.x(r7));

  wire [31:0] mergeResult;

  merge_1 m1(.r (mergeResult),
             .x0(rm0),.x1(rm1),
             .x2(rm2),.x3(rm3),
             .x4(rm4),.x5(rm5),
             .x6(rm6),.x7(rm7));

  wire [31:0] perm2Res;

  perm_P per2(.r(perm2Res), .x(mergeResult));

  wire [31:0]xorRes2;

  multipXor32 mulXor2(.xorRes(xorRes2),.permR(perm2Res), .k(xl));

  assign rr = xorRes2;

endmodule
