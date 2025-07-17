/* Copyright (C) 2017 Daniel Page <csdsp@bristol.ac.uk>
 *
 * Use of this source code is restricted per the CC BY-NC-ND license, a copy of 
 * which can be found via http://creativecommons.org (and should be included as 
 * LICENSE.txt within the associated archive or repository).
 */

`include "params.h"

module pre_processing(input wire [ `N_K - 1 : 0 ]   k,   //  input    data: cipher key
                      input wire [ `N_B - 1 : 0 ]   m,   //  input    data:  plaintext message
                      output wire [ 55 : 0 ]   r,    // output    data: cipher key
                      output wire [ 31 : 0 ]   r0,   // output    data: first part of ciphertext message
                      output wire [ 31 : 0 ]   r1 ); // output    data: second part of ciphertext message

  wire [`N_B - 1 : 0]permRes;

  perm_IP permMes(.r(permRes), .x(m));
  perm_PC1 permKey(.r(r), .x(k));

  split_2 spl(.r0(r0),.r1(r1), .x(permRes));

endmodule


module post_processing(input wire [ 31 : 0 ]   x0,   //  input    data:   first part of ciper message
                       input wire [ 31 : 0 ]   x1,   //  input    data:   second part of ciper message
                       output wire [ 63 : 0 ]   r);  // output    data: ciphertext message

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

  reg [ 3 : 0 ] rnd;                    // keep track of number of rounds
  reg ackC;                             // keep track of if the encryption process is finished and encrypted message is ready

  wire [ `N_B - 1 : 0 ] firstM;         // to store encrypted  message from round module
  wire [ 55: 0 ] firstK;                // to store encrypted key from key_schedule module

  wire [ `N_B - 1 : 0 ] startM;         // to store encrypted message from preprocessing
  wire [ 55 : 0 ] startK;               // to store encrypted key from preprocessing

  reg [55 : 0] forKeySched;             // to pass key through rounds
  reg [63 : 0] forRound;                // to pass message through rounds

  wire [ 47 : 0 ] roundKey;             // result of keyschedule for round module

  /*
  Module make a pre processing of the key and plaintext message, before passing it for first round of encryption.
  It is called every CLK but first call only returns message and key for first round, the next calls will be ingnored.
  */
  pre_processing preP(.r0(startM[31 : 0]), 
                      .r1(startM[63 : 32]), 
                      .r(startK), 
                      .k(k),
                      .m(m));

  // prepare key for the next encryption round.
  key_schedule ke(.r(firstK),
                  .k(roundKey),
                  .i(rnd), 
                  .x(forKeySched));

  // Accept the left and right part of a message and encrypt it with the key form keysschedule. 
  // Then return two encrypted parts of the message for the next round of encryption.
  round rou(.rl(firstM[63 : 32]), .rr(firstM[31 : 0]), 
            .xl(forRound[63 : 32]), .xr(forRound[31 : 0]), 
            .k(roundKey));

  //Module return the final result of the encryption computation  after all encryption rounds 
  //The result passes to C on each round but the correct value the module only return on the last round.
  post_processing postP(.r(c),
                        .x0(firstM[63 : 32]),
                        .x1(firstM[31 : 0]));

  assign ack = ackC;    //send signal to use if the encryption process is completed

  // on negative edge of req or positive level of rst signal reset all register to default values
  always @(negedge req or rst) begin
    ackC = 1'b0;
    forKeySched = 0;
    forRound = 0;
    rnd = 4'b0000;
  end

  always @(posedge clk) begin
    if (req) begin                         // check if user requested to make message encryption through request signal
      if ( rnd < `N_R - 1) begin           // check if number of rounds is not exceeded the number of allwoed ones.
        if (forKeySched == 0) begin        // get key and message from pre_processing module for first encription round
          forKeySched = startK;
          forRound = startM;
        end else begin                     // get key and message from key_schedule and round modules for next encription round
          forKeySched = firstK;
          forRound = firstM;
          rnd <= rnd + 4'b0001;            // go to the next round
        end
      end else begin
        ackC = 1;                          // change acknoledge to tell that computation is finished
      end
    end
  end

endmodule
