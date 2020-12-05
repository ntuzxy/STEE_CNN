module spi_cell_top(reset_n,clk_phase1,clk_phase2,capture,spi_din,capture_in,spi_out,data_out,addr_out);

localparam DATA_WIDTH =16;
localparam ADDR_WIDTH =7;
localparam TOTAL_WIDTH= DATA_WIDTH+ ADDR_WIDTH;

input reset_n;
input clk_phase1;
input clk_phase2;
input capture;
input [DATA_WIDTH -1 : 0] capture_in;
output [DATA_WIDTH -1 : 0] data_out;
output [ADDR_WIDTH -1 : 0] addr_out;
input spi_din;
output spi_out;

reg [TOTAL_WIDTH -1 :0] int_store1;
reg [TOTAL_WIDTH -1 :0] int_store2;

wire [TOTAL_WIDTH -1 : 0] din_int;

assign din_int = ~ capture ? {spi_din,int_store2[TOTAL_WIDTH-1:1]} : {capture_in,int_store2[ADDR_WIDTH-1 : 0]};

assign spi_out = int_store2[0];
assign data_out = int_store2[TOTAL_WIDTH-1 : ADDR_WIDTH];
assign addr_out = int_store2[ADDR_WIDTH -1 : 0];
genvar i;
generate 
	for (i=0;i< TOTAL_WIDTH;i=i+1) begin: ff1
		always @( posedge clk_phase1 or negedge reset_n) begin
			if (!reset_n) int_store1[i] <= 1'b0;
			else int_store1[i] <= din_int[i];
		end
	end
endgenerate

genvar i1;
generate 
	for (i1=0;i1< TOTAL_WIDTH;i1=i1+1) begin: ff2
		always @( posedge clk_phase2 or negedge reset_n) begin
			if (!reset_n) int_store2[i1] <= 1'b0;
			else int_store2[i1] <= int_store1[i1];
		end
	end
endgenerate


endmodule 
