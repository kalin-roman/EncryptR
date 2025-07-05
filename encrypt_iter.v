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
  // initial begin
  //     $monitor( "merRes=%h", merRes);
  //     $monitor( "r=%h", startK);      
  // end

endmodule

module encrypt_iter(  input wire [ `N_K - 1 : 0 ]   k,   //  input    data: cipher key
                      input wire [ `N_B - 1 : 0 ]   m,   //  input    data:  plaintext message
                     output wire [ `N_B - 1 : 0 ]   c,   // output    data: ciphertext message

                      input wire                  clk,   //  input control:       clock signal
                      input wire                  rst,   //  input control:       reset signal
                      input wire                  req,   //  input control:     request signal
                     output wire                  ack ); // output control: acknowledge signal

  // Stage 3: complete this module implementation
  reg [ 3 : 0 ] rnd;
  reg ackC;

  wire [ `N_B - 1 : 0 ] firstM;
  wire [ 55: 0 ] firstK;

  wire [ `N_B - 1 : 0 ] startM;
  wire [ 55 : 0 ] startK;

  reg [55 : 0] forKeySched;
  reg [63 : 0] forRound;

  wire [ 47 : 0 ] roundKey;

  pre_processing preP(.r0(startM[31 : 0]), 
                      .r1(startM[63 : 32]), 
                      .r(startK), 
                      .k(k),
                      .m(m));

  key_schedule ke(.r(firstK),
                  .k(roundKey),
                  .i(rnd), 
                  .x(forKeySched));

  round rou(.rl(firstM[63 : 32]), .rr(firstM[31 : 0]), 
            .xl(forRound[63 : 32]), .xr(forRound[31 : 0]), 
            .k(roundKey));

  post_processing postP(.r(c),
                        .x0(firstM[63 : 32]),
                        .x1(firstM[31 : 0]));

  // initial begin
      // #15 $monitor( "xl=%h \n xr=%h \n k=%h \n rl=%h \n rr=%h \n rnd=%h \n ack = %h\n", 
      //            forRound[63 : 32],
      //            forRound[31 : 0],
      //            roundKey,
      //            firstM[63 : 32],
      //            firstM[31 : 0],
      //            rnd,
      //            ackC
      //            );  

      // $monitor( " r0 =%h \n r1 =%h \n r =%h \n m =%h \n k =%h \nrnd =%h \n ack = %h\n", 
      //       startM[63 : 32],
      //       startM[31 : 0],
      //       startK,
      //       k,
      //       m,
      //       rnd,
      //       ackC
      //       );     

      // $monitor( " x =%h \n i =%h \n r =%h \n k =%h \n ack = %h \n", 
      //       forKeySched,
      //       rnd,
      //       roundKey,
      //       firstK,
      //       ackC
      //       );    
      // $monitor( "rst = %h", 
      //      rst
      //       );    
  // end

  assign ack = ackC;

  // always @(rst) begin
  //   // firstM = 0;
  //   // firstK = 0;
  //   forKeySched = 0;
  //   forRound = 0;
  //   // startM = 0;
  //   // startK = 0;
  //   rnd = 4'b0000;
  //   ackC = 0;
  // end

  always @(negedge req) begin
    ackC = 1'b0;
    forKeySched = 0;
    forRound = 0;
    rnd = 4'b0000;
  end

  always @(posedge clk) begin
    if (req) begin
      if ( rnd < `N_R - 1)begin
        if (forKeySched == 0) begin
          forKeySched = startK;
          forRound = startM;
        end else begin
          forKeySched = firstK;
          forRound = firstM;
          rnd <= rnd + 4'b0001;
        end
      end else begin
        ackC = 1;
      end

    end

  end

endmodule
