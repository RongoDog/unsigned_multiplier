module shift_in (x_in, sx, reset, clk, x_parallel, fx);

input x_in, sx, reset, clk;

output [11:0]  x_parallel; 
reg [11:0] local_x_parallel;
assign x_parallel = local_x_parallel;

output fx;
reg local_fx;
assign fx = local_fx;

reg started;
reg in_progress; 
reg restart;
reg [3:0] count;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        started <= 'b0;
        local_x_parallel <= 'b0;
        local_fx <= 0;
        count <= 'b0;
        in_progress <= 'b0;
    end else begin
        if (restart) begin
            started <= 'b1;
            local_x_parallel <= 'b0;
            local_fx <= 0;
            count <= 'b0;
            in_progress <= 'b0;
        end else if (started | in_progress) begin
            started <= 'b0;
            in_progress <= 'b1;
            if (count > 4'd12) begin
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
            in_progress <= 'b0;
            local_x_parallel <= 'b0;
            local_fx <= 0;
            count <= 'b0;
        end
    end
end

always @(posedge sx or posedge started or posedge reset) begin
    if (reset) begin
        restart <= 'b0;
    end else if (started) begin
        restart <= 'b0;
    end else if (sx) begin
        restart <= 'b1;
    end else begin
        restart <= 'b0;
    end
end

endmodule
