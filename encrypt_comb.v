/* Copyright (C) 2017 Daniel Page <csdsp@bristol.ac.uk>
 *
 * Use of this source code is restricted per the CC BY-NC-ND license, a copy of 
 * which can be found via http://creativecommons.org (and should be included as 
 * LICENSE.txt within the associated archive or repository).
 */

`include "params.h"

module pre_processing(input wire [ `N_K - 1 : 0 ]   k,   //  input    data: cipher key
                      input wire [ `N_B - 1 : 0 ]   m,   //  input    data:  plaintext message
                      output wire [ 55 : 0 ]   r,
                      output wire [ 31 : 0 ]   r0,
                      output wire [ 31 : 0 ]   r1 ); // output    data: ciphertext message

  // Stage 2: complete this module implementation
  wire [`N_B - 1 : 0]permRes;

  perm_IP permMes(.r(permRes), .x(m));
  perm_PC1 permKey(.r(r), .x(k));

  split_2 spl(.r0(r0),.r1(r1), .x(permRes));

endmodule


module post_processing(input wire [ 31 : 0 ]   x0,   //  input    data: cipher key
                       input wire [ 31 : 0 ]   x1,   //  input    data:  plaintext message
                       output wire [ 63 : 0 ]   r); // output    data: ciphertext message

  // Stage 2: complete this module implementation

  wire [63 : 0] merRes;

  merge_2 mer(.r(merRes), .x0(x0), .x1(x1));

  perm_FP per(.r(r), .x(merRes));


endmodule


module encrypt_comb(  input wire [ `N_K - 1 : 0 ]   k,   //  input    data: cipher key
                      input wire [ `N_B - 1 : 0 ]   m,   //  input    data:  plaintext message
                     output wire [ `N_B - 1 : 0 ]   c ); // output    data: ciphertext message

  // Stage 2: complete this module implementation

  wire [`N_B : 0] messages [0 : `N_R];
  wire [55 : 0] keys [0 : `N_R];
  wire [47 : 0] kForRound [0 : `N_R];

  pre_processing pre(
    .r0(messages[0][31 : 0]), 
    .r1(messages[0][63:32]), 
    .r(keys[0]),
    .m(m), 
    .k(k)
  );

  genvar i;
  generate
    for (i = 1 ; i <= `N_R; i++) begin:id
      
      key_schedule keyMod(
        .r(keys[i]),
        .k(kForRound[i - 1]),
        .x(keys[i - 1]),
        .i(i[3:0] - 4'b0001)
      );

      round ro(
          .rl(messages[i][63 : 32]), 
          .rr(messages[i][31 : 0]), 
          .xl(messages[i - 1][63 : 32]),
          .xr(messages[i - 1][31 : 0]),
          .k (kForRound[i - 1])
      );
    end

  endgenerate

  post_processing pst(
    .r(c), 
    .x0(messages[`N_R][63 : 32]),
    .x1(messages[`N_R][31 : 0])
  );


endmodule
