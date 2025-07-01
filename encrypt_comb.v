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

module encrypt_comb(  input wire [ `N_K - 1 : 0 ]   k,   //  input    data: cipher key
                      input wire [ `N_B - 1 : 0 ]   m,   //  input    data:  plaintext message
                     output wire [ `N_B - 1 : 0 ]   c ); // output    data: ciphertext message

  // Stage 2: complete this module implementation

  wire [`N_B : 0] message [0 : `N_R];
  wire [55 : 0] key [0 : `N_R];
  ы
  wire [55 : 0] preprokey;

  pre_processing pre(.r0(message[0][31 : 0]), .r1(message[0][63:32], 
                     .r(preprokey),              .m(m), .k(k)), );
  genvar i;

  generate
    for (i = 1 ; i <= `N_R; i++) begin
      key_schedule keyMod(.k[],.r(),.x(),.i());
      round ro(.rr(message[i][31 : 0]), .rl(message[i][63 : 32]), key[0]);
    end
  endgenerate


endmodule
