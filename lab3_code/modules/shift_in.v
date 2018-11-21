module shift_in (x_in, sx, reset, clk, x_parallel, fx);

parameter WAITING = 2'b00;
parameter SHIFTING = 2'b01;
parameter DONE = 2'b10;

input x_in, sx, reset, clk;

output [11:0]  x_parallel; 
reg [11:0] local_x_parallel;
assign x_parallel = local_x_parallel;

output fx;
reg local_fx;
assign fx = local_fx;

reg [1:0] state;
reg [1:0] next_state;
reg [3:0] count;
reg [3:0] next_count;

reg reset_counter;
reg went_low;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= WAITING;
        count <= 'b0;
    end else begin
        if (reset_counter) begin
            state <= SHIFTING;
            count <= 'b0;
        end else if (state == SHIFTING) begin 
            else if (count < 4'd11) begin
                state <= SHIFTING;
                count <= count + 1;
            end else begin
                state <= DONE;
                count <= count;
            end
        end else begin
            state <= WAITING;
            count <= 'b0;
        end
    end
end

always @(sx or count or state) begin
    if (~sx) begin
        went_low = 'b1;
    end else if (sx & went_low) begin
        reset_counter = 'b1;
        went_low = 'b0;
    end else begin
        reset_counter = 'b0;
        went_low = 'b0;
    end
end

always @(state or count) begin
    case (state)
        WAITING: begin
            local_x_parallel = 'b0;
            local_fx = 'b0;
        end
        SHIFTING: begin
            local_x_parallel = {local_x_parallel[10:0], x_in};
            local_fx = 'b0;
        end
        DONE: begin
            local_x_parallel = local_x_parallel;
            local_fx = 'b1;
        end
        default: begin
            local_x_parallel = 'b0;
            local_fx = 'b0;
        end
    endcase
end

endmodule
