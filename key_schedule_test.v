/* Copyright (C) 2017 Daniel Page <csdsp@bristol.ac.uk>
 *
 * Use of this source code is restricted per the CC BY-NC-ND license, a copy of 
 * which can be found via http://creativecommons.org (and should be included as 
 * LICENSE.txt within the associated archive or repository).
 */

module key_schedule_test();

  wire [ 55 : 0 ] t_r;
  wire [ 47 : 0 ] t_k;
  reg  [ 55 : 0 ] t_x;
  reg  [  3 : 0 ] t_i;

  key_schedule t( .r( t_r ), .k( t_k ), .x( t_x ), .i( t_i ) );

  initial begin
        $dumpfile( "key_schedule_test.vcd" );
        $dumplimit( 10485760 );
        $dumpvars;

        $dumpon;

        if( !$value$plusargs( "x=%h", t_x ) ) begin
          $display( "warning: need an unsigned 56-bit hexadecimal value for x" );
          $display( "         e.g., +x=0F3355F55330FF"                         );
        end
        if( !$value$plusargs( "i=%h", t_i ) ) begin
          $display( "warning: need an unsigned  4-bit hexadecimal value for i" );
          $display( "         e.g., +i=0"                                      );
        end

    #10 $display( ">[%0d] k=%h", 0, t_k );
        $display( ">[%0d] x=%h", 0, t_x );
        $display( ">[%0d] i=%h", 0, t_i );
        $display( "<[%0d] r=%h", 0, t_r );

    #10 $dumpoff;
        $finish;
  end

endmodule
