/* Copyright (C) 2017 Daniel Page <csdsp@bristol.ac.uk>
 *
 * Use of this source code is restricted per the CC BY-NC-ND license, a copy of 
 * which can be found via http://creativecommons.org (and should be included as 
 * LICENSE.txt within the associated archive or repository).
 */

/* Modules that split x into n subwords, where r_i denotes the i-th subword for 
 * 0 <= i < n; the size of subwords, and thus the number and size of inputs and
 * outputs, depends on the module.
 */

module split_0( output wire [ 27 : 0 ] r0,
                output wire [ 27 : 0 ] r1,
                 input wire [ 55 : 0 ]  x );

  assign { r1, r0 } = x;

endmodule

module split_1( output wire [  5 : 0 ] r0,
                output wire [  5 : 0 ] r1,
                output wire [  5 : 0 ] r2,
                output wire [  5 : 0 ] r3,
                output wire [  5 : 0 ] r4,
                output wire [  5 : 0 ] r5,
                output wire [  5 : 0 ] r6,
                output wire [  5 : 0 ] r7,
                 input wire [ 47 : 0 ]  x );

  assign { r7, r6, r5, r4, r3, r2, r1, r0 } = x;

endmodule

module split_2( output wire [ 31 : 0 ] r0,
                output wire [ 31 : 0 ] r1,
                 input wire [ 63 : 0 ]  x );

  assign { r1, r0 } = x;

endmodule

/* Modules that merge r from n subwords, where x_i denotes the i-th subword for 
 * 0 <= i < n; the size of subwords, and thus the number and size of inputs and
 * outputs, depends on the module.
 */

module merge_0( output wire [ 55 : 0 ]  r,
                 input wire [ 27 : 0 ] x0,
                 input wire [ 27 : 0 ] x1 );

  assign r = { x1, x0 };

endmodule

module merge_1( output wire [ 31 : 0 ]  r,
                 input wire [  3 : 0 ] x0,
                 input wire [  3 : 0 ] x1,
                 input wire [  3 : 0 ] x2,
                 input wire [  3 : 0 ] x3,
                 input wire [  3 : 0 ] x4,
                 input wire [  3 : 0 ] x5,
                 input wire [  3 : 0 ] x6,
                 input wire [  3 : 0 ] x7 );

  assign r = { x7, x6, x5, x4, x3, x2, x1, x0 };

endmodule

module merge_2( output wire [ 63 : 0 ]  r,
                 input wire [ 31 : 0 ] x0,
                 input wire [ 31 : 0 ] x1 );

  assign r = { x1, x0 };

endmodule

/* Modules that implement various permutations used in DES, namely
 *
 * - IP,  the (64-to-64)-bit "initial"            permutation,  
 * - FP,  the (64-to-64)-bit   "final"            permutation,
 * - E,   the (32-to-48)-bit "expansion"          permutation,
 * - P,   the (32-to-32)-bit "permute"            permutation,
 * - PC1, the (64-to-56)-bit "permuted choice #1" permutation, and
 * - PC2, the (56-to-48)-bit "permuted choice #2" permutation
 * 
 * where, for a given n-bit to m-bit permutation f, the corresponding module 
 * will compute the n-bit output r = f( x ) from the m-bit input x.
 */

module perm_IP( output wire [ 63 : 0 ] r, 
                 input wire [ 63 : 0 ] x );

  assign r = { x[  6 ], x[ 14 ], x[ 22 ], x[ 30 ], x[ 38 ], x[ 46 ], x[ 54 ], x[ 62 ], 
               x[  4 ], x[ 12 ], x[ 20 ], x[ 28 ], x[ 36 ], x[ 44 ], x[ 52 ], x[ 60 ], 
               x[  2 ], x[ 10 ], x[ 18 ], x[ 26 ], x[ 34 ], x[ 42 ], x[ 50 ], x[ 58 ], 
               x[  0 ], x[  8 ], x[ 16 ], x[ 24 ], x[ 32 ], x[ 40 ], x[ 48 ], x[ 56 ], 
               x[  7 ], x[ 15 ], x[ 23 ], x[ 31 ], x[ 39 ], x[ 47 ], x[ 55 ], x[ 63 ], 
               x[  5 ], x[ 13 ], x[ 21 ], x[ 29 ], x[ 37 ], x[ 45 ], x[ 53 ], x[ 61 ], 
               x[  3 ], x[ 11 ], x[ 19 ], x[ 27 ], x[ 35 ], x[ 43 ], x[ 51 ], x[ 59 ], 
               x[  1 ], x[  9 ], x[ 17 ], x[ 25 ], x[ 33 ], x[ 41 ], x[ 49 ], x[ 57 ] };

endmodule

module perm_FP( output wire [ 63 : 0 ] r, 
                 input wire [ 63 : 0 ] x );

  assign r = { x[ 24 ], x[ 56 ], x[ 16 ], x[ 48 ], x[  8 ], x[ 40 ], x[  0 ], x[ 32 ], 
               x[ 25 ], x[ 57 ], x[ 17 ], x[ 49 ], x[  9 ], x[ 41 ], x[  1 ], x[ 33 ], 
               x[ 26 ], x[ 58 ], x[ 18 ], x[ 50 ], x[ 10 ], x[ 42 ], x[  2 ], x[ 34 ], 
               x[ 27 ], x[ 59 ], x[ 19 ], x[ 51 ], x[ 11 ], x[ 43 ], x[  3 ], x[ 35 ], 
               x[ 28 ], x[ 60 ], x[ 20 ], x[ 52 ], x[ 12 ], x[ 44 ], x[  4 ], x[ 36 ], 
               x[ 29 ], x[ 61 ], x[ 21 ], x[ 53 ], x[ 13 ], x[ 45 ], x[  5 ], x[ 37 ], 
               x[ 30 ], x[ 62 ], x[ 22 ], x[ 54 ], x[ 14 ], x[ 46 ], x[  6 ], x[ 38 ], 
               x[ 31 ], x[ 63 ], x[ 23 ], x[ 55 ], x[ 15 ], x[ 47 ], x[  7 ], x[ 39 ] };

endmodule

module perm_E( output wire [ 47 : 0 ] r, 
                input wire [ 31 : 0 ] x );

  assign r = { x[  0 ], x[ 31 ], x[ 30 ], x[ 29 ], x[ 28 ], x[ 27 ], x[ 28 ], x[ 27 ], 
               x[ 26 ], x[ 25 ], x[ 24 ], x[ 23 ], x[ 24 ], x[ 23 ], x[ 22 ], x[ 21 ], 
               x[ 20 ], x[ 19 ], x[ 20 ], x[ 19 ], x[ 18 ], x[ 17 ], x[ 16 ], x[ 15 ], 
               x[ 16 ], x[ 15 ], x[ 14 ], x[ 13 ], x[ 12 ], x[ 11 ], x[ 12 ], x[ 11 ], 
               x[ 10 ], x[  9 ], x[  8 ], x[  7 ], x[  8 ], x[  7 ], x[  6 ], x[  5 ], 
               x[  4 ], x[  3 ], x[  4 ], x[  3 ], x[  2 ], x[  1 ], x[  0 ], x[ 31 ] };

endmodule

module perm_P( output wire [ 31 : 0 ] r, 
                input wire [ 31 : 0 ] x );

  assign r = { x[ 16 ], x[ 25 ], x[ 12 ], x[ 11 ], x[  3 ], x[ 20 ], x[  4 ], x[ 15 ], 
               x[ 31 ], x[ 17 ], x[  9 ], x[  6 ], x[ 27 ], x[ 14 ], x[  1 ], x[ 22 ], 
               x[ 30 ], x[ 24 ], x[  8 ], x[ 18 ], x[  0 ], x[  5 ], x[ 29 ], x[ 23 ], 
               x[ 13 ], x[ 19 ], x[  2 ], x[ 26 ], x[ 10 ], x[ 21 ], x[ 28 ], x[  7 ] };

endmodule

module perm_PC1( output wire [ 55 : 0 ] r, 
                  input wire [ 63 : 0 ] x );

  assign r = { x[  7 ], x[ 15 ], x[ 23 ], x[ 31 ], x[ 39 ], x[ 47 ], x[ 55 ], x[ 63 ], 
               x[  6 ], x[ 14 ], x[ 22 ], x[ 30 ], x[ 38 ], x[ 46 ], x[ 54 ], x[ 62 ], 
               x[  5 ], x[ 13 ], x[ 21 ], x[ 29 ], x[ 37 ], x[ 45 ], x[ 53 ], x[ 61 ], 
               x[  4 ], x[ 12 ], x[ 20 ], x[ 28 ], x[  1 ], x[  9 ], x[ 17 ], x[ 25 ], 
               x[ 33 ], x[ 41 ], x[ 49 ], x[ 57 ], x[  2 ], x[ 10 ], x[ 18 ], x[ 26 ], 
               x[ 34 ], x[ 42 ], x[ 50 ], x[ 58 ], x[  3 ], x[ 11 ], x[ 19 ], x[ 27 ], 
               x[ 35 ], x[ 43 ], x[ 51 ], x[ 59 ], x[ 36 ], x[ 44 ], x[ 52 ], x[ 60 ] };

endmodule

module perm_PC2( output wire [ 47 :0 ] r, 
                  input wire [ 55 :0 ] x );

  assign r = { x[ 42 ], x[ 39 ], x[ 45 ], x[ 32 ], x[ 55 ], x[ 51 ], x[ 53 ], x[ 28 ], 
               x[ 41 ], x[ 50 ], x[ 35 ], x[ 46 ], x[ 33 ], x[ 37 ], x[ 44 ], x[ 52 ], 
               x[ 30 ], x[ 48 ], x[ 40 ], x[ 49 ], x[ 29 ], x[ 36 ], x[ 43 ], x[ 54 ], 
               x[ 15 ], x[  4 ], x[ 25 ], x[ 19 ], x[  9 ], x[  1 ], x[ 26 ], x[ 16 ], 
               x[  5 ], x[ 11 ], x[ 23 ], x[  8 ], x[ 12 ], x[  7 ], x[ 17 ], x[  0 ], 
               x[ 22 ], x[  3 ], x[ 10 ], x[ 14 ], x[  6 ], x[ 20 ], x[ 27 ], x[ 24 ] };

endmodule

/* Modules that implement the DES (6-to-4)-bit S-boxes, which are basically just
 * look-up (or substitution) tables; the i-th module computes a 4-bit output 
 * 
 * r = S-box_i( x ) 
 * 
 * given a 6-bit input x.
 */

module sbox_0( output wire [ 3 : 0 ] r, 
                input wire [ 5 : 0 ] x );

  reg [ 3 : 0 ] t;

  assign r = t;

  always @ ( x ) begin
    case( x )
      6'h00 : t = 4'hD;
      6'h01 : t = 4'h1;
      6'h02 : t = 4'h2;
      6'h03 : t = 4'hF;
      6'h04 : t = 4'h8;
      6'h05 : t = 4'hD;
      6'h06 : t = 4'h4;
      6'h07 : t = 4'h8;
      6'h08 : t = 4'h6;
      6'h09 : t = 4'hA;
      6'h0A : t = 4'hF;
      6'h0B : t = 4'h3;
      6'h0C : t = 4'hB;
      6'h0D : t = 4'h7;
      6'h0E : t = 4'h1;
      6'h0F : t = 4'h4;
      6'h10 : t = 4'hA;
      6'h11 : t = 4'hC;
      6'h12 : t = 4'h9;
      6'h13 : t = 4'h5;
      6'h14 : t = 4'h3;
      6'h15 : t = 4'h6;
      6'h16 : t = 4'hE;
      6'h17 : t = 4'hB;
      6'h18 : t = 4'h5;
      6'h19 : t = 4'h0;
      6'h1A : t = 4'h0;
      6'h1B : t = 4'hE;
      6'h1C : t = 4'hC;
      6'h1D : t = 4'h9;
      6'h1E : t = 4'h7;
      6'h1F : t = 4'h2;
      6'h20 : t = 4'h7;
      6'h21 : t = 4'h2;
      6'h22 : t = 4'hB;
      6'h23 : t = 4'h1;
      6'h24 : t = 4'h4;
      6'h25 : t = 4'hE;
      6'h26 : t = 4'h1;
      6'h27 : t = 4'h7;
      6'h28 : t = 4'h9;
      6'h29 : t = 4'h4;
      6'h2A : t = 4'hC;
      6'h2B : t = 4'hA;
      6'h2C : t = 4'hE;
      6'h2D : t = 4'h8;
      6'h2E : t = 4'h2;
      6'h2F : t = 4'hD;
      6'h30 : t = 4'h0;
      6'h31 : t = 4'hF;
      6'h32 : t = 4'h6;
      6'h33 : t = 4'hC;
      6'h34 : t = 4'hA;
      6'h35 : t = 4'h9;
      6'h36 : t = 4'hD;
      6'h37 : t = 4'h0;
      6'h38 : t = 4'hF;
      6'h39 : t = 4'h3;
      6'h3A : t = 4'h3;
      6'h3B : t = 4'h5;
      6'h3C : t = 4'h5;
      6'h3D : t = 4'h6;
      6'h3E : t = 4'h8;
      6'h3F : t = 4'hB;
    endcase
  end

endmodule

module sbox_1( output wire [ 3 : 0 ] r, 
                input wire [ 5 : 0 ] x );

  reg [ 3 : 0 ] t;

  assign r = t;

  always @ ( x ) begin
    case( x )
      6'h00 : t = 4'h4;
      6'h01 : t = 4'hD;
      6'h02 : t = 4'hB;
      6'h03 : t = 4'h0;
      6'h04 : t = 4'h2;
      6'h05 : t = 4'hB;
      6'h06 : t = 4'hE;
      6'h07 : t = 4'h7;
      6'h08 : t = 4'hF;
      6'h09 : t = 4'h4;
      6'h0A : t = 4'h0;
      6'h0B : t = 4'h9;
      6'h0C : t = 4'h8;
      6'h0D : t = 4'h1;
      6'h0E : t = 4'hD;
      6'h0F : t = 4'hA;
      6'h10 : t = 4'h3;
      6'h11 : t = 4'hE;
      6'h12 : t = 4'hC;
      6'h13 : t = 4'h3;
      6'h14 : t = 4'h9;
      6'h15 : t = 4'h5;
      6'h16 : t = 4'h7;
      6'h17 : t = 4'hC;
      6'h18 : t = 4'h5;
      6'h19 : t = 4'h2;
      6'h1A : t = 4'hA;
      6'h1B : t = 4'hF;
      6'h1C : t = 4'h6;
      6'h1D : t = 4'h8;
      6'h1E : t = 4'h1;
      6'h1F : t = 4'h6;
      6'h20 : t = 4'h1;
      6'h21 : t = 4'h6;
      6'h22 : t = 4'h4;
      6'h23 : t = 4'hB;
      6'h24 : t = 4'hB;
      6'h25 : t = 4'hD;
      6'h26 : t = 4'hD;
      6'h27 : t = 4'h8;
      6'h28 : t = 4'hC;
      6'h29 : t = 4'h1;
      6'h2A : t = 4'h3;
      6'h2B : t = 4'h4;
      6'h2C : t = 4'h7;
      6'h2D : t = 4'hA;
      6'h2E : t = 4'hE;
      6'h2F : t = 4'h7;
      6'h30 : t = 4'hA;
      6'h31 : t = 4'h9;
      6'h32 : t = 4'hF;
      6'h33 : t = 4'h5;
      6'h34 : t = 4'h6;
      6'h35 : t = 4'h0;
      6'h36 : t = 4'h8;
      6'h37 : t = 4'hF;
      6'h38 : t = 4'h0;
      6'h39 : t = 4'hE;
      6'h3A : t = 4'h5;
      6'h3B : t = 4'h2;
      6'h3C : t = 4'h9;
      6'h3D : t = 4'h3;
      6'h3E : t = 4'h2;
      6'h3F : t = 4'hC;
    endcase
  end

endmodule

module sbox_2( output wire [ 3 : 0 ] r, 
                input wire [ 5 : 0 ] x );

  reg [ 3 : 0 ] t;

  assign r = t;

  always @ ( x ) begin
    case( x )
      6'h00 : t = 4'hC;
      6'h01 : t = 4'hA;
      6'h02 : t = 4'h1;
      6'h03 : t = 4'hF;
      6'h04 : t = 4'hA;
      6'h05 : t = 4'h4;
      6'h06 : t = 4'hF;
      6'h07 : t = 4'h2;
      6'h08 : t = 4'h9;
      6'h09 : t = 4'h7;
      6'h0A : t = 4'h2;
      6'h0B : t = 4'hC;
      6'h0C : t = 4'h6;
      6'h0D : t = 4'h9;
      6'h0E : t = 4'h8;
      6'h0F : t = 4'h5;
      6'h10 : t = 4'h0;
      6'h11 : t = 4'h6;
      6'h12 : t = 4'hD;
      6'h13 : t = 4'h1;
      6'h14 : t = 4'h3;
      6'h15 : t = 4'hD;
      6'h16 : t = 4'h4;
      6'h17 : t = 4'hE;
      6'h18 : t = 4'hE;
      6'h19 : t = 4'h0;
      6'h1A : t = 4'h7;
      6'h1B : t = 4'hB;
      6'h1C : t = 4'h5;
      6'h1D : t = 4'h3;
      6'h1E : t = 4'hB;
      6'h1F : t = 4'h8;
      6'h20 : t = 4'h9;
      6'h21 : t = 4'h4;
      6'h22 : t = 4'hE;
      6'h23 : t = 4'h3;
      6'h24 : t = 4'hF;
      6'h25 : t = 4'h2;
      6'h26 : t = 4'h5;
      6'h27 : t = 4'hC;
      6'h28 : t = 4'h2;
      6'h29 : t = 4'h9;
      6'h2A : t = 4'h8;
      6'h2B : t = 4'h5;
      6'h2C : t = 4'hC;
      6'h2D : t = 4'hF;
      6'h2E : t = 4'h3;
      6'h2F : t = 4'hA;
      6'h30 : t = 4'h7;
      6'h31 : t = 4'hB;
      6'h32 : t = 4'h0;
      6'h33 : t = 4'hE;
      6'h34 : t = 4'h4;
      6'h35 : t = 4'h1;
      6'h36 : t = 4'hA;
      6'h37 : t = 4'h7;
      6'h38 : t = 4'h1;
      6'h39 : t = 4'h6;
      6'h3A : t = 4'hD;
      6'h3B : t = 4'h0;
      6'h3C : t = 4'hB;
      6'h3D : t = 4'h8;
      6'h3E : t = 4'h6;
      6'h3F : t = 4'hD;
    endcase
  end

endmodule

module sbox_3( output wire [ 3 : 0 ] r, 
                input wire [ 5 : 0 ] x );

  reg [ 3 : 0 ] t;

  assign r = t;

  always @ ( x ) begin
    case( x )
      6'h00 : t = 4'h2;
      6'h01 : t = 4'hE;
      6'h02 : t = 4'hC;
      6'h03 : t = 4'hB;
      6'h04 : t = 4'h4;
      6'h05 : t = 4'h2;
      6'h06 : t = 4'h1;
      6'h07 : t = 4'hC;
      6'h08 : t = 4'h7;
      6'h09 : t = 4'h4;
      6'h0A : t = 4'hA;
      6'h0B : t = 4'h7;
      6'h0C : t = 4'hB;
      6'h0D : t = 4'hD;
      6'h0E : t = 4'h6;
      6'h0F : t = 4'h1;
      6'h10 : t = 4'h8;
      6'h11 : t = 4'h5;
      6'h12 : t = 4'h5;
      6'h13 : t = 4'h0;
      6'h14 : t = 4'h3;
      6'h15 : t = 4'hF;
      6'h16 : t = 4'hF;
      6'h17 : t = 4'hA;
      6'h18 : t = 4'hD;
      6'h19 : t = 4'h3;
      6'h1A : t = 4'h0;
      6'h1B : t = 4'h9;
      6'h1C : t = 4'hE;
      6'h1D : t = 4'h8;
      6'h1E : t = 4'h9;
      6'h1F : t = 4'h6;
      6'h20 : t = 4'h4;
      6'h21 : t = 4'hB;
      6'h22 : t = 4'h2;
      6'h23 : t = 4'h8;
      6'h24 : t = 4'h1;
      6'h25 : t = 4'hC;
      6'h26 : t = 4'hB;
      6'h27 : t = 4'h7;
      6'h28 : t = 4'hA;
      6'h29 : t = 4'h1;
      6'h2A : t = 4'hD;
      6'h2B : t = 4'hE;
      6'h2C : t = 4'h7;
      6'h2D : t = 4'h2;
      6'h2E : t = 4'h8;
      6'h2F : t = 4'hD;
      6'h30 : t = 4'hF;
      6'h31 : t = 4'h6;
      6'h32 : t = 4'h9;
      6'h33 : t = 4'hF;
      6'h34 : t = 4'hC;
      6'h35 : t = 4'h0;
      6'h36 : t = 4'h5;
      6'h37 : t = 4'h9;
      6'h38 : t = 4'h6;
      6'h39 : t = 4'hA;
      6'h3A : t = 4'h3;
      6'h3B : t = 4'h4;
      6'h3C : t = 4'h0;
      6'h3D : t = 4'h5;
      6'h3E : t = 4'hE;
      6'h3F : t = 4'h3;
    endcase
  end

endmodule

module sbox_4( output wire [ 3 : 0 ] r, 
                input wire [ 5 : 0 ] x );

  reg [ 3 : 0 ] t;

  assign r = t;

  always @ ( x ) begin
    case( x )
      6'h00 : t = 4'h7;
      6'h01 : t = 4'hD;
      6'h02 : t = 4'hD;
      6'h03 : t = 4'h8;
      6'h04 : t = 4'hE;
      6'h05 : t = 4'hB;
      6'h06 : t = 4'h3;
      6'h07 : t = 4'h5;
      6'h08 : t = 4'h0;
      6'h09 : t = 4'h6;
      6'h0A : t = 4'h6;
      6'h0B : t = 4'hF;
      6'h0C : t = 4'h9;
      6'h0D : t = 4'h0;
      6'h0E : t = 4'hA;
      6'h0F : t = 4'h3;
      6'h10 : t = 4'h1;
      6'h11 : t = 4'h4;
      6'h12 : t = 4'h2;
      6'h13 : t = 4'h7;
      6'h14 : t = 4'h8;
      6'h15 : t = 4'h2;
      6'h16 : t = 4'h5;
      6'h17 : t = 4'hC;
      6'h18 : t = 4'hB;
      6'h19 : t = 4'h1;
      6'h1A : t = 4'hC;
      6'h1B : t = 4'hA;
      6'h1C : t = 4'h4;
      6'h1D : t = 4'hE;
      6'h1E : t = 4'hF;
      6'h1F : t = 4'h9;
      6'h20 : t = 4'hA;
      6'h21 : t = 4'h3;
      6'h22 : t = 4'h6;
      6'h23 : t = 4'hF;
      6'h24 : t = 4'h9;
      6'h25 : t = 4'h0;
      6'h26 : t = 4'h0;
      6'h27 : t = 4'h6;
      6'h28 : t = 4'hC;
      6'h29 : t = 4'hA;
      6'h2A : t = 4'hB;
      6'h2B : t = 4'h1;
      6'h2C : t = 4'h7;
      6'h2D : t = 4'hD;
      6'h2E : t = 4'hD;
      6'h2F : t = 4'h8;
      6'h30 : t = 4'hF;
      6'h31 : t = 4'h9;
      6'h32 : t = 4'h1;
      6'h33 : t = 4'h4;
      6'h34 : t = 4'h3;
      6'h35 : t = 4'h5;
      6'h36 : t = 4'hE;
      6'h37 : t = 4'hB;
      6'h38 : t = 4'h5;
      6'h39 : t = 4'hC;
      6'h3A : t = 4'h2;
      6'h3B : t = 4'h7;
      6'h3C : t = 4'h8;
      6'h3D : t = 4'h2;
      6'h3E : t = 4'h4;
      6'h3F : t = 4'hE;
    endcase
  end

endmodule

module sbox_5( output wire [ 3 : 0 ] r, 
                input wire [ 5 : 0 ] x );

  reg [ 3 : 0 ] t;

  assign r = t;

  always @ ( x ) begin
    case( x )
      6'h00 : t = 4'hA;
      6'h01 : t = 4'hD;
      6'h02 : t = 4'h0;
      6'h03 : t = 4'h7;
      6'h04 : t = 4'h9;
      6'h05 : t = 4'h0;
      6'h06 : t = 4'hE;
      6'h07 : t = 4'h9;
      6'h08 : t = 4'h6;
      6'h09 : t = 4'h3;
      6'h0A : t = 4'h3;
      6'h0B : t = 4'h4;
      6'h0C : t = 4'hF;
      6'h0D : t = 4'h6;
      6'h0E : t = 4'h5;
      6'h0F : t = 4'hA;
      6'h10 : t = 4'h1;
      6'h11 : t = 4'h2;
      6'h12 : t = 4'hD;
      6'h13 : t = 4'h8;
      6'h14 : t = 4'hC;
      6'h15 : t = 4'h5;
      6'h16 : t = 4'h7;
      6'h17 : t = 4'hE;
      6'h18 : t = 4'hB;
      6'h19 : t = 4'hC;
      6'h1A : t = 4'h4;
      6'h1B : t = 4'hB;
      6'h1C : t = 4'h2;
      6'h1D : t = 4'hF;
      6'h1E : t = 4'h8;
      6'h1F : t = 4'h1;
      6'h20 : t = 4'hD;
      6'h21 : t = 4'h1;
      6'h22 : t = 4'h6;
      6'h23 : t = 4'hA;
      6'h24 : t = 4'h4;
      6'h25 : t = 4'hD;
      6'h26 : t = 4'h9;
      6'h27 : t = 4'h0;
      6'h28 : t = 4'h8;
      6'h29 : t = 4'h6;
      6'h2A : t = 4'hF;
      6'h2B : t = 4'h9;
      6'h2C : t = 4'h3;
      6'h2D : t = 4'h8;
      6'h2E : t = 4'h0;
      6'h2F : t = 4'h7;
      6'h30 : t = 4'hB;
      6'h31 : t = 4'h4;
      6'h32 : t = 4'h1;
      6'h33 : t = 4'hF;
      6'h34 : t = 4'h2;
      6'h35 : t = 4'hE;
      6'h36 : t = 4'hC;
      6'h37 : t = 4'h3;
      6'h38 : t = 4'h5;
      6'h39 : t = 4'hB;
      6'h3A : t = 4'hA;
      6'h3B : t = 4'h5;
      6'h3C : t = 4'hE;
      6'h3D : t = 4'h2;
      6'h3E : t = 4'h7;
      6'h3F : t = 4'hC;
    endcase
  end

endmodule

module sbox_6( output wire [ 3 : 0 ] r, 
                input wire [ 5 : 0 ] x );

  reg [ 3 : 0 ] t;

  assign r = t;

  always @ ( x ) begin
    case( x )
      6'h00 : t = 4'hF;
      6'h01 : t = 4'h3;
      6'h02 : t = 4'h1;
      6'h03 : t = 4'hD;
      6'h04 : t = 4'h8;
      6'h05 : t = 4'h4;
      6'h06 : t = 4'hE;
      6'h07 : t = 4'h7;
      6'h08 : t = 4'h6;
      6'h09 : t = 4'hF;
      6'h0A : t = 4'hB;
      6'h0B : t = 4'h2;
      6'h0C : t = 4'h3;
      6'h0D : t = 4'h8;
      6'h0E : t = 4'h4;
      6'h0F : t = 4'hE;
      6'h10 : t = 4'h9;
      6'h11 : t = 4'hC;
      6'h12 : t = 4'h7;
      6'h13 : t = 4'h0;
      6'h14 : t = 4'h2;
      6'h15 : t = 4'h1;
      6'h16 : t = 4'hD;
      6'h17 : t = 4'hA;
      6'h18 : t = 4'hC;
      6'h19 : t = 4'h6;
      6'h1A : t = 4'h0;
      6'h1B : t = 4'h9;
      6'h1C : t = 4'h5;
      6'h1D : t = 4'hB;
      6'h1E : t = 4'hA;
      6'h1F : t = 4'h5;
      6'h20 : t = 4'h0;
      6'h21 : t = 4'hD;
      6'h22 : t = 4'hE;
      6'h23 : t = 4'h8;
      6'h24 : t = 4'h7;
      6'h25 : t = 4'hA;
      6'h26 : t = 4'hB;
      6'h27 : t = 4'h1;
      6'h28 : t = 4'hA;
      6'h29 : t = 4'h3;
      6'h2A : t = 4'h4;
      6'h2B : t = 4'hF;
      6'h2C : t = 4'hD;
      6'h2D : t = 4'h4;
      6'h2E : t = 4'h1;
      6'h2F : t = 4'h2;
      6'h30 : t = 4'h5;
      6'h31 : t = 4'hB;
      6'h32 : t = 4'h8;
      6'h33 : t = 4'h6;
      6'h34 : t = 4'hC;
      6'h35 : t = 4'h7;
      6'h36 : t = 4'h6;
      6'h37 : t = 4'hC;
      6'h38 : t = 4'h9;
      6'h39 : t = 4'h0;
      6'h3A : t = 4'h3;
      6'h3B : t = 4'h5;
      6'h3C : t = 4'h2;
      6'h3D : t = 4'hE;
      6'h3E : t = 4'hF;
      6'h3F : t = 4'h9;
    endcase
  end

endmodule

module sbox_7( output wire [ 3 : 0 ] r, 
                input wire [ 5 : 0 ] x );

  reg [ 3 : 0 ] t;

  assign r = t;

  always @ ( x ) begin
    case( x )
      6'h00 : t = 4'hE;
      6'h01 : t = 4'h0;
      6'h02 : t = 4'h4;
      6'h03 : t = 4'hF;
      6'h04 : t = 4'hD;
      6'h05 : t = 4'h7;
      6'h06 : t = 4'h1;
      6'h07 : t = 4'h4;
      6'h08 : t = 4'h2;
      6'h09 : t = 4'hE;
      6'h0A : t = 4'hF;
      6'h0B : t = 4'h2;
      6'h0C : t = 4'hB;
      6'h0D : t = 4'hD;
      6'h0E : t = 4'h8;
      6'h0F : t = 4'h1;
      6'h10 : t = 4'h3;
      6'h11 : t = 4'hA;
      6'h12 : t = 4'hA;
      6'h13 : t = 4'h6;
      6'h14 : t = 4'h6;
      6'h15 : t = 4'hC;
      6'h16 : t = 4'hC;
      6'h17 : t = 4'hB;
      6'h18 : t = 4'h5;
      6'h19 : t = 4'h9;
      6'h1A : t = 4'h9;
      6'h1B : t = 4'h5;
      6'h1C : t = 4'h0;
      6'h1D : t = 4'h3;
      6'h1E : t = 4'h7;
      6'h1F : t = 4'h8;
      6'h20 : t = 4'h4;
      6'h21 : t = 4'hF;
      6'h22 : t = 4'h1;
      6'h23 : t = 4'hC;
      6'h24 : t = 4'hE;
      6'h25 : t = 4'h8;
      6'h26 : t = 4'h8;
      6'h27 : t = 4'h2;
      6'h28 : t = 4'hD;
      6'h29 : t = 4'h4;
      6'h2A : t = 4'h6;
      6'h2B : t = 4'h9;
      6'h2C : t = 4'h2;
      6'h2D : t = 4'h1;
      6'h2E : t = 4'hB;
      6'h2F : t = 4'h7;
      6'h30 : t = 4'hF;
      6'h31 : t = 4'h5;
      6'h32 : t = 4'hC;
      6'h33 : t = 4'hB;
      6'h34 : t = 4'h9;
      6'h35 : t = 4'h3;
      6'h36 : t = 4'h7;
      6'h37 : t = 4'hE;
      6'h38 : t = 4'h3;
      6'h39 : t = 4'hA;
      6'h3A : t = 4'hA;
      6'h3B : t = 4'h0;
      6'h3C : t = 4'h5;
      6'h3D : t = 4'h6;
      6'h3E : t = 4'h0;
      6'h3F : t = 4'hD;
    endcase
  end

endmodule
