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

module encrypt_iter(  input wire [ `N_K - 1 : 0 ]   k,   //  input    data: cipher key
                      input wire [ `N_B - 1 : 0 ]   m,   //  input    data:  plaintext message
                     output wire [ `N_B - 1 : 0 ]   c,   // output    data: ciphertext message

                      input wire                  clk,   //  input control:       clock signal
                      input wire                  rst,   //  input control:       reset signal
                      input wire                  req,   //  input control:     request signal
                     output wire                  ack ); // output control: acknowledge signal

  // Stage 3: complete this module implementation
  reg [ 4 : 0 ] rnd;
  reg ackC;

  reg [ `N_B - 1 : 0 ] startM;
  reg [ `N_K - 1 : 0 ] startK;

  wire [ `N_B - 1 : 0 ] endM;
  wire [ `N_K - 1 : 0 ] endK;

  wire [ `N_B - 1 : 0 ] testExampStart [0 : `N_R - 1];
  wire [ `N_K - 1 : 0 ] testExampEnd [0 : `N_R - 1];




  reg [ `N_B - 1 : 0 ] startM;
  reg [ `N_K - 1 : 0 ] startK;


  wire [ 47 : 0 ] testExampKey [0 : `N_R - 1];
  wire [ `N_B - 1 : 0 ] testExampMess [0 : `N_R - 1];
  wire [ 55 : 0 ] testExampTranKey [0 : `N_R - 1];

  pre_processing preP(.r0(testExampMess[0][31 : 0]), 
                      .r1(testExampMess[0][63 : 32]), 
                      .r(testExampTranKey[0]), 
                      .k(startK),
                      .m(startM));

  key_schedule ke(.r(testExampTranKey[rnd + 4'b0001]),
                  .k(testExampKey[rnd]) ,
                  .i(rnd), 
                  .x(testExampTranKey[rnd]));

  round rou(.rl(testExampMess[rnd + 4'b0001][63 : 32]), .rr(testExampMess[rnd + 4'b0001][31 : 0]), 
            .xl(testExampMess[rnd][63 : 32]), .xr(testExampMess[rnd][63 : 32]), 
            .k(testExampKey[rnd]));

  post_processing postP(.r(c),.x0(testExampMess[rnd + 4'b0001][63 : 32]),.x1(testExampMess[rnd + 4'b0001][31 : 0]));


  // integer o;
  // always @(rst) begin
  //   for ( o = 0 ; i < `N_R; i++) begin
  //     testExampKey[o] = 0;
  //     testExampMess[o] = 0;
  //     testExampTranKey[o] =0;
  //   end
  // end

  always @(req) begin
    startM = m;
    startK = k;
    rnd = 4'b0000;
  end

  always @(posedge clk) begin
    if (req) begin
      startK = endK;
      startM = endM;
      rnd <= rnd + 5'b00001;
      if ( rnd >= `N_R  )begin
        ackC <= 1;
      end 
    end

  end

endmodule
