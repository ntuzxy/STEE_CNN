module reset_synchronizer(
    input wire clk,
    input wire asyc_rst_n,

    output wire sync_rst_n,
    output wire sync_rst
    );

    reg rst_out;
    reg rst_out_int;
    // sync reset output
    always @( negedge asyc_rst_n or posedge clk) begin
        if (!asyc_rst_n) begin
            rst_out <= 1'b0;
            rst_out_int <= 1'b0;
        end else begin
            rst_out_int <= 1'b1;
            rst_out <= rst_out_int;
        end
    end

    assign sync_rst = ~rst_out;
    assign sync_rst_n = rst_out;
endmodule
