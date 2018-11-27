// Twos complement in module.
// Inputs:
//   x_in - parrallel 12-bit input
//   enable - If enable is low, the circuit passes 0
//   reset - asynchronous reset
//   clk - clock signal
// Outputs:
//   x_pos_out - parrallel output positive
module twos_complement_in (x_in, enable, reset, clk, x_pos_out);

// Input definitions
input enable, reset, clk;
input [11:0] x_in;

// Output definitions
output [11:0] x_pos_out;
reg [11:0] x_pos;
assign x_pos_out = x_pos;

always@(posedge clk or posedge reset) begin
  // Asynchronous reset or !enabled
  if (reset | (!enable)) begin
    x_pos <= 'b0;
  // We take the twos complement if negative
  end else if (x_in[11]) begin
    x_pos <= (~x_in) + 1;
  // Otherwise we just pass through
  end else begin
    x_pos <= x_in;
  end
end

endmodule
