`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/09/06 22:29:31
// Design Name: 
// Module Name: gcd
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




module gcd(
    input wire CLK,
    input wire RST_N,
    input wire[7:0] A,
    input wire[7:0] B,
    input wire START,
    output reg [7:0] Y,
    output reg DONE,
    output reg ERROR
);

wire found, swap;
reg [7:0] reg_a, reg_b, data_a, data_b;
reg [7:0] diff;
reg error_next;
reg [1:0] state, state_next;

parameter [1:0] IDLE = 2'b00;
parameter [1:0] CALC = 2'b01;
parameter [1:0] FINISH = 2'b10;

// [HW]
//Finish this design based on
//the block diagram:
//   1. FSM
//   2. Datapath diagram
//
 always@(posedge CLK or negedge RST_N)begin
    if(!RST_N)begin
        state <= IDLE;
        ERROR <= 0;
    end else  begin
        ERROR <= error_next;
        state <= state_next;
    end
 end
 always@(posedge CLK)begin
    if(START)begin
        reg_a <= A;
        reg_b <= B;
    end else begin
        reg_a <= diff;
        reg_b <= data_b;
    end
 end
 always@(state, posedge START, reg_a, reg_b, found, ERROR)begin
    DONE = 0;
    case(state)
    IDLE: begin
        if(START)begin
            state_next = CALC;
            if(reg_a == 0 || reg_b == 0)
                error_next = 1;
            else
                error_next = 0;
            //error_next = (reg_a == 0 | reg_b == 0);
        end else begin
            state_next = state;
            error_next = ERROR;
        end
    end
    CALC: begin
        error_next = ERROR;
        if(found || ERROR)begin
            state_next = FINISH;
        end else begin
            state_next = CALC; 
        end
    end
    FINISH: begin
        state_next = IDLE;
        error_next = 0;
        DONE = 1;
    end
    endcase
 end

 always@(*)begin
    if(swap)begin
        data_a = reg_b;
        data_b = reg_a;
    end else begin
        data_a = reg_a;
        data_b = reg_b;
    end
 end
 always@(posedge CLK)begin
    if(found)
        Y = data_a;
    else
        Y = 0;
 end
 always@(*)begin
    diff = data_a -data_b;
 end
assign swap = (reg_b > reg_a)? 1 : 0;
assign found = (reg_a == reg_b || A == B)? 1 : 0;       
 
            
endmodule
