// Two complement out module.
// Inputs:
//   z_pos - parrallel 24-bit input
//   enable - If enable is low, the circuit take the twos complement
//   reset - asynchronous reset
//   clk - clock signal
// Outputs:
//   z_out - parallel 24-bit output
module twos_complement_out (z_pos, enable, reset, clk, z_out);

// Input definitions
input enable, reset, clk;
input [23:0] z_pos;

// Output definitions
output [23:0] z_out;
reg [23:0] z_out_local;
assign z_out = z_out_local;

always@(posedge clk or posedge reset) begin
  // Asynchronous reset
  if (reset) begin
    z_out_local <= 'b0;
  // If enable is high we just pass through
  end else if (enable) begin
    z_out_local <= z_pos;
  // Otherwise, we obtain the twos complement
  end else begin 
    z_out_local <= (~z_pos) + 1;
  end
end

endmodule
