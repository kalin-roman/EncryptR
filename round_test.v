/* Copyright (C) 2017 Daniel Page <csdsp@bristol.ac.uk>
 *
 * Use of this source code is restricted per the CC BY-NC-ND license, a copy of 
 * which can be found via http://creativecommons.org (and should be included as 
 * LICENSE.txt within the associated archive or repository).
 */

module round_test();

  wire [ 31 : 0 ] t_rl;   
  wire [ 31 : 0 ] t_rr;
  reg  [ 31 : 0 ] t_xl;
  reg  [ 31 : 0 ] t_xr;
  reg  [ 47 : 0 ] t_k;

  round t( .rl( t_rl ), .rr( t_rr ),
           .xl( t_xl ), .xr( t_xr ), .k( t_k ) );

  initial begin
        $dumpfile( "round_test.vcd" );
        $dumplimit( 10485760 );
        $dumpvars;

        $dumpon;

        if( !$value$plusargs( "xl=%h", t_xl ) ) begin
          $display( "warning: need an unsigned 32-bit hexadecimal value for xl" );
          $display( "         e.g., +xl=F01F60F8"                               );
        end
        if( !$value$plusargs( "xr=%h", t_xr ) ) begin
          $display( "warning: need an unsigned 32-bit hexadecimal value for xr" );
          $display( "         e.g., +xr=000F60D6"                               );
        end
        if( !$value$plusargs(  "k=%h", t_k  ) ) begin
          $display( "warning: need an unsigned 48-bit hexadecimal value for k"  );
          $display( "         e.g., +k=F4FD9864B65A"                            );
        end

    #10 $display( ">[%0d] xl=%h", 0, t_xl );
        $display( ">[%0d] xr=%h", 0, t_xr );
        $display( ">[%0d]  k=%h", 0, t_k  );
        $display( "<[%0d] rl=%h", 0, t_rl );
        $display( "<[%0d] rr=%h", 0, t_rr );

    #10 $dumpoff;
        $finish;
  end

endmodule
