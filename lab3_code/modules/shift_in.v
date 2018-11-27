// Shift in module.
// Inputs:
//   x_in - serial data input
//   sx - asynchronous start data input on next clock cyle
//   reset - asynchronous reset
//   clk - clock signal
// Outputs:
//   x_parallel - parrallel output
//   fx - ready signal
module shift_in (x_in, sx, reset, clk, x_parallel, fx);

// Parameters define states
parameter WAITING = 2'b00;
parameter SHIFTING = 2'b01;
parameter DONE = 2'b10;

// Input declarations
input x_in, sx, reset, clk;

// Output declarations
output [11:0] x_parallel; 
reg [11:0] local_x_parallel;
assign x_parallel = local_x_parallel;

output fx;
reg local_fx;
assign fx = local_fx;

// State and counts registers
reg [1:0] state;
reg [3:0] count;

// Asynchronous state helpers
reg reset_counter;
reg went_low;

/*
    Main clock and reset loop
*/
always @(posedge clk or posedge reset) begin
    // Asynchronous reset set state to WAITING and count to 0
    if (reset) begin
        state <= WAITING;
        count <= 'b0;
    end else begin
        // If the state signal is detected, we are shifting
        // and the count is 0
        if (reset_counter) begin
            state <= SHIFTING;
            count <= 'b0;
        end else if (state == SHIFTING) begin 
            // We can either shift or be dones
            if (count < 4'd11) begin
                state <= SHIFTING;
                count <= count + 1;
            end else begin
                state <= DONE;
                count <= count;
            end
        // When we are done, we stay done
        end else if (state == DONE) begin
            state <= DONE;
            count <= count;
        end else begin
            state <= WAITING;
            count <= 'b0;
        end
    end
end

/*
    The asynchronous start signal works
    by ensuring that data collection is reset properly
    only if the signal value was previously low.
    This value is checked on a change of state to ensure 
    that the data collection is not continuously reset
    on subsequent clock cycles, thus requiring the start signal
    to go low again
*/
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

/*
    The correct output is based on a change
    in state or count.
*/
always @(state or count) begin
    case (state)
        WAITING: begin
            local_x_parallel = 'b0;
            local_fx = 'b0;
        end
        SHIFTING: begin
            // We assume that the MSB is the first arriving serially. 
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
