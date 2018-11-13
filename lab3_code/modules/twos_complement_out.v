//Verilog HDL for "lab3", "twos_complement_out" "verilog"


module twos_complement_out (z_pos, enable, reset, clk, z_out);

input enable, reset, clk;
input [23:0] z_pos;

output [23:0] z_out;
reg [23:0] z_out_local;
assign z_out = z_out_local;

always@(posedge clk or posedge reset) begin
  if (reset | (!enable)) begin
    z_out_local <= 'b0;
  end else begin 
    z_out_local <= (~z_pos) + 1;
  end
end

endmodule
