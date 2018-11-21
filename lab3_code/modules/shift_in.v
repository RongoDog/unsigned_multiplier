module shift_in (x_in, sx, reset, clk, x_parallel, fx);

input x_in, sx, reset, clk;

output [11:0]  x_parallel; 
reg [11:0] local_x_parallel;
assign x_parallel = local_x_parallel;

output fx;
reg local_fx;
assign fx = local_fx;

reg started;
reg start;
reg [3:0] count;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        started <= 'b0;
        local_x_parallel <= 'b0;
        local_fx <= 0;
        count <= 4'b1111;
    end else begin
        if (start && (count != 'b0)) begin
            started <= 'b1;
            local_x_parallel <= 'b0;
            local_fx <= 0;
            count <= 'b0;
        end else if (started) begin
            started <= 'b1;
            if (count > 4'd11) begin
                local_x_parallel <= local_x_parallel;
                local_fx <= 'b1;
                count <= count;
            end else begin
                local_x_parallel <= {local_x_parallel[10:0], x_in};
                local_fx <= 'b0;
                count <= count + 1;
            end
        end else begin
            started <= 'b0;
            local_x_parallel <= 'b0;
            local_fx <= 0;
            count <= 4'b1111;
        end
    end
end

always @(sx) begin
    if (sx) begin
        start = 'b1;
    end
end

endmodule
