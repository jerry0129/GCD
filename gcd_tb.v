`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/09/06 22:35:51
// Design Name: 
// Module Name: gcd_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module gcd_tb;
    parameter cyc = 10;
    parameter delay = 1;
    
    reg clk, rst_n, start;
    reg [7:0] a, b;
    wire done, error;
    wire [7:0] y;
    
    gcd gcd01(
        clk,
        rst_n,
        a,
        b,
        start,
        y,
        done,
        error

);
    always #(cyc/2) clk = ~clk; //clock
    
    initial begin
        //$fsdbDumpfile("gcd.fsdb");
        //$fsdbDumpvars;
        //$sdf_annotate ("gcd_syn.sdf", gcd01);
        $dumpfile("gcd.vcd");
		$dumpvars(0, gcd01);
        $monitor($time, "CLK=%b RST_N=%b START=%b A=%b B=%b | DONE=%b Y=%b ERROR=%b", 
        clk, rst_n, start, a, b, done,
         y, error);
     end
     
     initial begin
        clk = 1;
        rst_n = 1;
        #(cyc);
        #(delay) rst_n = 0;
        #(cyc*4) rst_n = 1;
        #(cyc*2);
        
        #(cyc) nop;
        
        #(cyc) load; data_in(8'd6, 8'd21);
        #(cyc) nop;
        @(posedge done)
        
        //#(cyc) nop;
        //#(delay)
        #(cyc) load; data_in(8'd5, 8'd15);
        #(cyc) nop;
        @(posedge done)
        
        //#(cyc) nop;
        //#(delay)
        #(cyc) load; data_in(8'd0, 8'd15);
        #(cyc) nop;
        @(posedge done)
        
        
        //#(cyc) nop;
        //#(delay)
        #(cyc) load; data_in(8'd17, 8'd0);
        #(cyc) nop;
        @(posedge done)
//[HW] apply more patterns to cover 
// different conditons

        #(cyc) nop;
        #(cyc*8);
        $finish;
    end
    
//using tasks to improve the readability
    task nop;
        begin
            start = 0;
        end
    endtask
    task load;
        begin
            start = 1;
        end
    endtask
    task data_in;
        input [7:0] data1, data2;
        begin
            a = data1;
            b = data2;
        end
    endtask
    
endmodule
