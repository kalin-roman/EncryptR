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
  // always @(r) begin
  //   $display("pp: x0= %h, x1= %h, r=%d, n=%d",  x0, x1, r);
  // end

endmodule

module encrypt_pipe(  input wire [ `N_K - 1 : 0 ]   k,   //  input    data: cipher key
                      input wire [ `N_B - 1 : 0 ]   m,   //  input    data:  plaintext message
                     output wire [ `N_B - 1 : 0 ]   c,   // output    data: ciphertext message

                      input wire                  clk,   //  input control:       clock signal
                      input wire                  rst ); //  input control:       reset signal




  // Stage 4: complete this module implementation
reg [1 : 0]start;
reg [3 : 0] ticks;
reg [3 : 0] pipline;

reg [55 : 0] k0 [0 : `N_V - 1];
reg [63 : 0] m0 [0 : `N_V - 1];
reg [63 : 0 ] c0 [0 : `N_V - 1];

reg [3:0] iR [0 : `N_V - 1]; // number of round for each input

wire [47 : 0] forRound [0 : `N_V - 1];

reg [ `N_B - 1 : 0 ] firstM [0 : `N_V - 1]; // to store computed message from round
reg [ 55: 0 ] firstK [0 : `N_V - 1]; // to store 

reg [`N_B - 1 : 0]res;


wire [55 : 0] startK;
wire [`N_B - 1 : 0] startM;

integer n;

pre_processing pre(.r(startK),
                   .r0(startM[31:0]), 
                   .r1(startM[63:32]), 
                   .m(m), 
                   .k(k));

genvar i;

generate
  for ( i = 0; i < `N_V; i++) begin: id
    key_schedule ke(.r(firstK[i]),
                    .k(forRound[i]),
                    .i(iR[i]), // (ticks - i[3:0] - 4'b0001) working
                    .x(k0[i]));
    round rou(.xl(m0[i][63:32]),.xr(m0[i][31:0]),
              .rl(firstM[i][63:32]),.rr(firstM[i][31:0]),
              .k(forRound[i]));
    post_processing po(.r(c0[i]), 
                       .x0(firstM[i][63:32]), 
                       .x1(firstM[i][31:0]));
    end

endgenerate

assign c = res;
  

// initial begin
//   for (integer i = 0;i < `N_V ; i++) begin
//     iR[i] = 0;
//   end
// end

always @(negedge rst) begin
  ticks = 0;
  pipline = 0;
  start[1] = 1'b1;
end

always @(k) begin
  start[0] = 1'b1;
end

always @(posedge rst) begin
  res = c0[ticks]; 
end

always @(posedge clk) begin
  if(start == 2'b11) begin 

    if(pipline < `N_V) begin
      k0[pipline] = startK;
      m0[pipline] = startM;
      // $display("[%d]: m0[%h] <<-- startM[%h]", pipline, m0[pipline], startM);
      pipline = pipline + 1;
      iR[pipline] = 0;
      // $display("start --- [%d]:  iR[%h]", pipline, iR[pipline]);

    end  

    ticks = ticks + 1;
    // $display("  k0 = %h, fK = %h ,  r = %d", k0[0], firstK[0], ticks );

    #1 for (integer i = 0;i < pipline ; i++ ) begin
      if (iR[i] < `N_R) begin
        k0[i] = firstK[i];
        m0[i] = firstM[i];  
        iR[i] += 1 ; 
        // $display("next --- [%d]:  iR[%h]", i, iR[i]);

      end
    $display("[%d]:  c0[%h]", i, c0[i]);
    end
      // $display("[%d]:  c0[%h]", ticks, c0[ticks]);

  end
end

endmodule
