//Verilog HDL for "lab3", "shift_out" "verilog"


module shift_out (z_parallel, sz, reset, clk, z_out, fz);

input [23:0] z_parallel;
input sz, reset, clk;

output fz, z_out;
reg local_fz;
assign fz = local_fz;

reg started; 
reg has_started;
reg [4:0] count;

reg [23:0] tmp;
assign z_out = tmp[0];

always @(posedge clk or posedge reset) begin
    if (reset) begin
        tmp <= 'b0;
        local_fz <= 0;
        count <= 'b0;
        started <= 0;
    end else if (started) begin
        tmp <= {1'b0, tmp[23:1]};
        count <= count + 1;
    end else if (has_started) begin
        tmp <= z_parallel;
        count <= 5'b00000;
        started <= 1'b1;
        local_fz <= 1;
        has_started <= 0;
    end 
end

always @(posedge sz) begin
    has_started <= 1'b1;
    started <= 1'b0;
end

always @(count) begin
    if (count > 5'd23) begin
        tmp <= 'b0;
        local_fz <= 0; 
        started <= 0;
        count <= 5'b0000;
    end
end
endmodule
