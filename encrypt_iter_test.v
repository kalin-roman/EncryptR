/* Copyright (C) 2017 Daniel Page <csdsp@bristol.ac.uk>
 *
 * Use of this source code is restricted per the CC BY-NC-ND license, a copy of 
 * which can be found via http://creativecommons.org (and should be included as 
 * LICENSE.txt within the associated archive or repository).
 */

`include "params.h"

module encrypt_iter_test();

  integer i;
   
  reg  [ `N_K - 1 : 0 ] v_k [ 0 : `N_V - 1 ]; // test vector cipher key
  reg  [ `N_B - 1 : 0 ] v_m [ 0 : `N_V - 1 ]; // test vector  plaintext message
  reg  [ `N_B - 1 : 0 ] v_c [ 0 : `N_V - 1 ]; // test vector ciphertext message

  reg  [ `N_B - 1 : 0 ] t_t;
   
  reg  [ `N_K - 1 : 0 ] t_k;                  // DUT cipher key
  reg  [ `N_B - 1 : 0 ] t_m;                  // DUT  plaintext message
  wire [ `N_B - 1 : 0 ] t_c;                  // DUT ciphertext message
      
  reg                   t_clk;                // DUT       clock signal
  reg                   t_rst;                // DUT       reset signal
  reg                   t_req;                // DUT     request signal
  wire                  t_ack;                // DUT acknowledge signal
   
  encrypt_iter t( .clk( t_clk ), 
                  .rst( t_rst ), 
                  .req( t_req ), 
                  .ack( t_ack ), .k( t_k ), .m( t_m ), .c( t_c ) );
         
  task test( input integer i );
    begin
      if( t_ack === 1'bX ) begin
        $display( "![%0d] aborting (ack = 1'bX)", i ); $finish;
      end
      if( t_ack === 1'bZ ) begin
        $display( "![%0d] aborting (ack = 1'bZ)", i ); $finish;
      end       

      t_k = v_k[ i ];
      t_m = v_m[ i ];

      t_req = 1;

      wait( t_clk == 0 );
      wait( t_clk == 1 );
      wait( t_clk == 0 );

      wait( t_ack == 1 );
          
      t_t = t_c; 

      wait( t_clk == 0 );
      wait( t_clk == 1 );
      wait( t_clk == 0 );

      t_req = 0;    

      wait( t_clk == 0 );
      wait( t_clk == 1 );
      wait( t_clk == 0 );

      wait( t_ack == 0 );

      wait( t_clk == 0 );
      wait( t_clk == 1 );
      wait( t_clk == 0 );

      $display( ">[%0d] k=%h", i, t_k );
      $display( ">[%0d] m=%h", i, t_m );
      $display( "<[%0d] c=%h", i, t_t );

      $display( "?[%0d] %s", i, ( t_t === v_c[ i ] ) ? "pass" : "fail" );
    end
  endtask

  initial begin
       t_clk =      0;
       t_rst =      0;
       t_req =      0;
  end

  always  begin
    #1 t_clk = ~t_clk;
  end
   
  initial begin
    $readmemh( "./vectors_k.txt", v_k );
    $readmemh( "./vectors_m.txt", v_m );
    $readmemh( "./vectors_c.txt", v_c );
     
    $dumpfile( "encrypt_iter_test.vcd" );
    $dumplimit( 10485760 );
    $dumpvars;

    $dumpon;

    t_rst = 1;

    wait( t_clk == 0 );
    wait( t_clk == 1 );
    wait( t_clk == 0 );

    t_rst = 0;

    wait( t_clk == 0 );
    wait( t_clk == 1 );
    wait( t_clk == 0 );

    for( i = 0; i < `N_V; i = i + 1 ) begin
      test( i );
    end
     
    $dumpoff;
    $finish;
  end

endmodule
