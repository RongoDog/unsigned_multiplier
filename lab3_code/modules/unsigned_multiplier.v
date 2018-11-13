module unsigned_multiplier(mul, reset, clk, done, x_pos, y_pos, z_pos);

input mul, reset, clk;
input [11:0] x_pos, y_pos;

output [23:0] z_pos;
reg [23:0] local_z_pos;
assign z_pos = local_z_pos;

output done;
reg local_done;
assign done = local_done;

reg load;
reg started;
reg [3:0] count; 
reg shift_in;
wire [12:0] temp_sum;

assign temp_sum = y_pos + local_z_pos[23:12];

always@(posedge clk or posedge reset) begin
  if (reset) begin
    local_z_pos <= 'b0;
    local_done <= 'b0;
    count <= 'b0;
    started <= 'b0;
    load <= 'b0;
  end else if (load) begin
    load <= 'b0;
    started <= 'b1;
    count <= 'b0;
    local_z_pos[23:12] <= 12'b000000000000;
    local_z_pos[11:0] <= x_pos;
    shift_in <= 1'b0;
  end else if (started) begin
    if (local_z_pos[0] == 1'b1) begin
      local_z_pos[23:12] = temp_sum[11:0];
    end
    local_z_pos = local_z_pos >> 1; 
    local_z_pos[23] = temp_sum[12];
    count <= count + 1'b1;
  end
end

always@(count) begin
  if (count > 4'd11) begin
    started <= 'b0;
    count <= 'b0;
    local_done <= 'b1;
    load <= 'b0;
  end
end

always@(posedge mul) begin
  load <= 'b1;
end

endmodule 
