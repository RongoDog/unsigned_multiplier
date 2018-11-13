//Verilog HDL for "lab3", "twos_complement_in" "verilog"
module twos_complement_in (x_in, enable, reset, clk, x_pos_out);

input enable, reset, clk;
input [11:0] x_in;

output [11:0] x_pos_out;
reg [11:0] x_pos;
assign x_pos_out = x_pos;

always@(posedge clk or posedge reset) begin
  if (reset | (!enable)) begin
    x_pos <= 'b0;
  end else if (x_in[11]) begin
    x_pos <= (~x_in) + 1;
  end else begin
    x_pos <= x_in;
  end
end

endmodule
