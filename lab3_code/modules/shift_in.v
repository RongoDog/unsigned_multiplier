module shift_in 
    #(parameter WAITING = 2'b00, parameter SHIFTING = 2'b01, parameter DONE = 2'b00)
    (x_in, sx, reset, clk, x_parallel, fx);

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

reg went_low;
wire restart;
assign restart = sx&went_low;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= WAITING;
        count <= 'b0;
    end else begin
        state <= next_state;
        count <= next_count;
    end
end

always @(sx or next_count or next_state) begin
    if (~sx) begin
        went_low = 'b1;
    end else if (next_state == SHIFTING && next_count == 'b0) begin
        went_low = 'b0;
    end else begin
        went_low = 'b0;
    end
end

always @(state or count or restart) begin
    if (restart) begin
        next_state = SHIFTING;
        next_count = 'b0;
    end else begin
        case (state)
            WAITING:
                next_state = WAITING;
                next_count = 'b0;
                restarted <= 0;
            SHIFTING;
                if (count > 4'd11) begin
                    next_state = DONE;
                    next_count = count;
                end else begin
                    next_state = SHIFTING;
                    next_count = count + 1;
                end
            DONE:
                next_state = DONE;
                next_count = count;
            default:
                next_state = WAITING;
                next_count = 'b0;
        endcase
    end
end

always @(state or count) begin
    case (state)
        case WAITING:
            local_x_parallel = 'b0;
            local_fx = 'b0;
        case SHIFTING:
            local_x_parallel = {local_x_parallel[10:0], x_in};
            local_fx = 'b0;
        case DONE:
            local_x_parallel = local_x_parallel;
            local_fx = 'b1;
        default:
            local_x_parallel = 'b0;
            local_fx = 'b0;
    endcase
end

endmodule
