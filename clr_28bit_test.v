/* Copyright (C) 2017 Daniel Page <csdsp@bristol.ac.uk>
 *
 * Use of this source code is restricted per the CC BY-NC-ND license, a copy of 
 * which can be found via http://creativecommons.org (and should be included as 
 * LICENSE.txt within the associated archive or repository).
 */

module clr_28bit_test();

  wire [ 27 : 0 ] t_r;   
  reg  [ 27 : 0 ] t_x;
  reg  [  3 : 0 ] t_y;

  clr_28bit t( .r( t_r ), .x( t_x ), .y( t_y ) );

  initial begin
        $dumpfile( "clr_28bit_test.vcd" );
        $dumplimit( 10485760 );
        $dumpvars;

        $dumpon;

        if( !$value$plusargs( "x=%h", t_x ) ) begin
          $display( "warning: need an unsigned 28-bit hexadecimal value for x" );
          $display( "         e.g., +x=55330FF"                                );
        end

        if( !$value$plusargs( "y=%h", t_y ) ) begin
          $display( "warning: need an unsigned  4-bit hexadecimal value for y" );
          $display( "         e.g., +y=0"                                      );
        end

    #10 $display( ">[%0b] x=%b", 0, t_x );
        $display( ">[%0b] y=%b", 0, t_y );
        $display( "<[%0b] r=%h", 0, t_r );

    #10 $dumpoff;
        $finish;
  end

endmodule
