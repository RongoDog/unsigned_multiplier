//Verilog HDL for "lab3", "shift_in" "verilog"


module shift_in (x_in, sx, reset, clk, x_parallel, fx);

input x_in, sx, reset, clk;

output [11:0]  x_parallel; 
reg [11:0] local_x_parallel;
assign x_parallel = local_x_parallel;

output fx;
reg local_fx;
assign fx = local_fx;

reg started; 
reg [3:0] count;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        local_x_parallel <= 'b0;
        local_fx <= 0;
        count <= 'b0;
        started <= 0;
    end else if (started) begin
        local_x_parallel <= {local_x_parallel[10:0], x_in};
	count = count + 1;
    end 
end

always @(posedge sx) begin
    local_fx <= 0;
    started <= 'b1;
    count <= 4'b0000;
end

always @(count) begin
    if (count > 4'd12) begin
        local_fx <= 1;
        started <= 0;
        count <= 4'b0000;
    end
end

endmodule
