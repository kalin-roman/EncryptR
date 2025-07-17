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
                       output wire [ 63 : 0 ]   r); // output     data: ciphertext message

  wire [63 : 0] merRes;

  merge_2 mer(.r(merRes), .x0(x0), .x1(x1));

  perm_FP per(.r(r), .x(merRes));

endmodule

module encrypt_pipe(  input wire [ `N_K - 1 : 0 ]   k,   //  input    data: cipher key
                      input wire [ `N_B - 1 : 0 ]   m,   //  input    data:  plaintext message
                     output wire [ `N_B - 1 : 0 ]   c,   // output    data: ciphertext message

                      input wire                  clk,   //  input control:       clock signal
                      input wire                  rst ); //  input control:       reset signal




  // Stage 4: complete this module implementation
  reg [1 : 0] start;                          // flag to start messages encryption 
  reg [3 : 0] pipline;                        // counter of incoming message 

  reg [55 : 0] orgKey [0 : `N_V - 1];             // array of keys for input paramters of key_schedule()
  reg [`N_B - 1 : 0] orgMes [0 : `N_V - 1];       // array of messages for round()
  reg [`N_B - 1 : 0 ] finRes [0 : `N_V - 1];

  reg [4:0] iR [0 : `N_V - 1];                // number of rounds for message encrytion

  reg [ `N_B - 1 : 0 ] firstM [0 : `N_V - 1]; // to store computed message from round()
  reg [ 55: 0 ] firstK [0 : `N_V - 1];        // to store computed key from key_schedule()

  reg [`N_B - 1 : 0]res;                      // final result     

  wire [55 : 0] startK;                       // computed key from pre_proessing()  
  wire [`N_B - 1 : 0] startM;                 // computed message from pre_proessing()
  wire [47 : 0] keyForRound [0 : `N_V - 1];   // keys that passes from keyschedule to round() 

  /*
    Module make a pre processing of the key and plaintext message, before passing it for first round of encryption.
    It is called only one time for each incoming message and key from user. Initialize startM and startK registers.
  */
  pre_processing pre(.r(startK),             
                    .r0(startM[31:0]), 
                    .r1(startM[63:32]), 
                    .m(m), 
                    .k(k));

  /*
    This loop iterate through all messages with keys and execute related encryption round.
  */

  genvar i;

  generate
    for ( i = 0; i < `N_V; i++) begin: id
      // Compute key for the round module and pass the new one for the next encryption round.
      key_schedule ke(.r(firstK[i]),
                      .k(keyForRound[i]),
                      .i((iR[i][3:0])), 
                      .x(orgKey[i]));
      // Accept the left and right part of a previous message and encrypt it with the key form keysschedule. 
      // Then return two encrypted parts of the message for the next round of encryption.
      round rou(.xl(orgMes[i][63:32]),    .xr(orgMes[i][31:0]),
                .rl(firstM[i][63:32]),.rr(firstM[i][31:0]),
                .k(keyForRound[i]));

      //Module return the final result of the encryption computation  after all encryption rounds 
      //The result passes to finRes[i] on each pipeline but the correct value the module only return on the last round.
      post_processing po(.r(finRes[i]), 
                        .x0(firstM[i][63:32]), 
                        .x1(firstM[i][31:0]));
      end

  endgenerate

  assign c = res;

  // Initializing encrytion algorithm by rst signal from user
  always @(rst) begin
    res = 0;
    pipline = 0;
    start[1] = 1'b1;                          // set second bit to 1 when reset signal is recieved 
    for (integer kk = 0; kk < `N_V ; kk++) begin
      orgKey[kk] = 0;
      orgMes[kk] = 0;
      iR[kk] = 0;
    end
  end

  always @(k or m) begin
    start[0] = 1'b1;                          // set first bit to 1 when module recieved message and key for computation
  end

  always @(posedge clk) begin
    // When rst toggeld and first message with key are passed, then the computation begins
    if(start == 2'b11) begin 
      if(pipline < `N_V) begin
        // Save pre-processed key and message value for the first pipeline stage
        orgKey[pipline] = startK;
        orgMes[pipline] = startM;
        iR[pipline] = 0;  // set to zero the number of rounds for the next incoming message
        pipline = pipline + 1;
      end 

      /*
        New key and encrypted message from the previous encryption round 
        transfer to the next one. "For loop" used for each  
      */
      #1 for (integer i = 0;i < pipline ; i++ ) begin
        // Transfer message and key for the next round and next pipline
        if (iR[i] < `N_R - 1) begin
          orgKey[i] = firstK[i];
          orgMes[i] = firstM[i];
          iR[i] += 5'b00001 ; // increment number of a round for each message
        end else if (iR[i] >= `N_R) begin
          // after the last encryption round, encrypted message is ready to be passed to the user
          res = finRes[i];
        end else begin
          iR[i] += 5'b00001;
        end
      end
    end
  end

endmodule
