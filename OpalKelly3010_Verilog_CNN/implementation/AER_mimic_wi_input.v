`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:47:06 10/20/2020 
// Design Name: 
// Module Name:    AER_mimic_wi_input 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module AER_mimic_wi_input
#(
    // parameter X_LENGTH          = 240, //DAVIS240x180
    // parameter Y_DEPTH           = 180, //DAVIS240x180
    // parameter MAX_SIZE          = X_LENGTH * Y_DEPTH;
    // parameter X_ADDR_WIDTH      = 8, //addrx:0~239
    // parameter Y_ADDR_WIDTH      = 8  //addry:0~179
    parameter X_LENGTH          = 320, //
    parameter Y_DEPTH           = 240, //
    parameter MAX_SIZE          = X_LENGTH * Y_DEPTH,
    parameter X_ADDR_WIDTH      = 9, //addrx:0~319
    parameter Y_ADDR_WIDTH      = 8  //addry:0~239
)
(
    input  wire clk,
    input  wire rst,
    input  wire aer_trig, //pulse to trig AER
    ////input option 1
    // input  wire [X_ADDR_WIDTH-1:0] addr_x_start,
    // input  wire [X_ADDR_WIDTH-1:0] addr_x_stop,
    // input  wire [Y_ADDR_WIDTH-1:0] addr_y_start,
    // input  wire [Y_ADDR_WIDTH-1:0] addr_y_stop,
    // input  wire polarity,
    ////input option 2
    input  wire read_data_neg,
    input  wire read_data_pos,
    output wire [16:0] addr,
    //IF with AER
    input  wire AER_nack,
    output reg  AER_nreq,
    output reg  [9:0] AER_data
);


//////////////////////////////////////////////
//// FSM to generate control logic and address to access memory
//////////////////////////////////////////////

    reg [X_ADDR_WIDTH-1:0] addr_x;
    reg [Y_ADDR_WIDTH-1:0] addr_y;
    // reg [X_ADDR_WIDTH+Y_ADDR_WIDTH-1:0] index_AER;
    reg polarity;
    // assign addr = {addr_y, addr_x};
    assign addr = X_LENGTH*addr_y+addr_x;

//// FSM
    reg [3:0] state;
    localparam[3:0]
    idle              = 4'b0000,
    data_prepare1     = 4'b0001,
    data_pass1        = 4'b0010,
    assert_low1       = 4'b0011,
    deassert_high1    = 4'b0100,
    data_prepare2     = 4'b0101,
    data_pass2        = 4'b0110,
    assert_low2       = 4'b0111,
    deassert_high2    = 4'b1000,
    data_wait         = 4'b1001;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state       <= idle;
        AER_data    <= 0;
        AER_nreq    <= 1;
        addr_x      <= 0;
        addr_y      <= 0;
        polarity    <= 0;
    end
    else begin
        case (state)
        idle: begin
            if (aer_trig) begin //start AER
                state       <= data_prepare1;
                AER_data    <= 0;
                AER_nreq    <= 1;
                addr_x      <= 0;
                addr_y      <= 0;
                polarity    <= 0;
            end
            else begin
                state       <= idle;
                AER_data    <= 0;
                AER_nreq    <= 1;
                addr_x      <= 0;
                addr_y      <= 0;
                polarity    <= 0;
            end
        end
        data_prepare1: begin
            if (addr_y < Y_DEPTH) begin
                state       <= data_pass1;
            end
            else begin
                state       <= idle;
            end
        end
        data_pass1: begin // pass addr_y
            state       <= assert_low1;
            AER_data    <= {1'b0, 1'b0, 8'd179 - addr_y[7:0]};
            AER_nreq    <= 1;
        end
        assert_low1: begin
            if (~AER_nack) begin
                state       <= deassert_high1;
                AER_nreq    <= 0;
            end
            else begin
                state       <= assert_low1;
                AER_nreq    <= 0;
            end
        end
        deassert_high1: begin
            if (AER_nack) begin
                state       <= data_prepare2;
                AER_nreq    <= 1;
            end
            else begin
                state       <= deassert_high1;
                AER_nreq    <= 1;
            end
        end
        data_prepare2: begin
            // if (addr_x<=X_LENGTH) begin
                if (read_data_neg) begin
                    state       <= data_pass2;
                    polarity    <= 0;
                end
                else if (read_data_pos) begin
                    state       <= data_pass2;
                    polarity    <= 1;
                end
                else begin //next addr
                    addr_x      <= addr_x==X_LENGTH-1 ? 0 : addr_x + 1;
                    addr_y      <= addr_x==X_LENGTH-1 ? addr_y + 1 : addr_y;
                    state       <= addr_x==X_LENGTH-1 ? data_prepare1 : data_wait;
                end
            // end
        end
        data_wait: begin//wait mem output
            state       <= data_prepare2;
        end
        data_pass2: begin// pass addr_x
            state       <= assert_low2;
            AER_data    <= {1'b1, addr_x[7:0], polarity};
            AER_nreq    <= 1;
        end
        assert_low2: begin
            if (~AER_nack) begin
                state       <= deassert_high2;
                AER_nreq    <= 0;
            end
            else begin
                state       <= assert_low2;
                AER_nreq    <= 0;
            end
        end
        deassert_high2: begin
            if (addr_y == Y_DEPTH-1 && addr_x == X_LENGTH-1) begin
                state       <= idle;
                AER_data    <= 0;
                AER_nreq    <= 1;
                addr_x      <= 0;
                addr_y      <= 0;
            end
            else begin
                if (AER_nack) begin
                    state       <= addr_x==X_LENGTH-1 ? data_prepare1 : data_wait;//data_prepare2;
                    AER_nreq    <= 1;
                    addr_x      <= addr_x==X_LENGTH-1 ? 0 : addr_x + 1;
                    addr_y      <= addr_x==X_LENGTH-1 ? addr_y + 1 : addr_y;
                end
                else begin
                    state       <= deassert_high2;
                    AER_nreq    <= 1;
                end
            end
        end
        default: begin
            state       <= idle;
            AER_data    <= 0;
            AER_nreq    <= 1;
            addr_x      <= 0;
            addr_y      <= 0;
            polarity    <= 0;
        end
        endcase 
    end
end


endmodule
