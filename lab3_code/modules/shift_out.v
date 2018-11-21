//Verilog HDL for "lab3", "shift_out" "verilog"


module shift_out (z_parallel, sz, reset, clk, z_out, fz);

input [23:0] z_parallel;
input sz, reset, clk;

output fz, z_out;
reg local_fz;
assign fz = local_fz;

reg load;
reg loaded;
reg in_progress;
reg [4:0] count;

reg [23:0] tmp;
assign z_out = tmp[0];

always @(posedge clk or posedge reset) begin
    if (reset) begin
        tmp <= 'b0;
        local_fz <= 'b0;
        count <= 'b0;
        loaded <= 'b0;
        in_progress <= 'b0;
    end else if (load) begin
        tmp <= z_parallel;
        local_fz <= 'b1;
        count <= 'b0;
        loaded <= 'b1;
        in_progress <= 'b0;
    end else if (loaded | in_progress) begin
        loaded <= 'b0;
        in_progress <= 'b1;
        if (count > 5'd23) begin
            tmp <= 'b0;
            local_fz <= 'b0; 
            count <= 'b0;
        end else begin
            tmp <= {1'b0, tmp[23:1]};
            local_fz <= 'b1;
            count <= count + 1;
        end
    end
end

always @(posedge sz or posedge reset or posedge loaded) begin
    if (reset) begin
        load <= 'b0;
    end else if (loaded) begin
        load <= 'b0;
    end else if (sz) begin
        load <= 'b1;
    end else begin
        load <= 'b0;
    end
end

endmodule
