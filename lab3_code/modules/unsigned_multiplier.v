// Two complement out module.
// Inputs:
//   mul - Start multiplication signal
//   reset - asynchronous reset
//   clk - clock signal
//   x_pos - input multiplier
//   y_pos - input multiplicand
// Outputs:
//   z_out - parallel 24-bit output
module unsigned_multiplier(mul, reset, clk, done, x_pos, y_pos, z_pos);

// Parameters representing possible states
parameter WAITING = 2'b00;
parameter LOAD = 2'b01;
parameter MULTIPLYING = 2'b10;
parameter DONE = 2'b11;

// Input definitions
input mul, reset, clk;
input [11:0] x_pos, y_pos;

// Output definitions
output [23:0] z_pos;
reg [23:0] local_z_pos;
assign z_pos = local_z_pos;

output done;
reg local_done;
assign done = local_done;

// Asynchronous state helpers
reg load;
reg went_low;

// State and count state registers
reg [1:0] state;
reg [3:0] count;

wire [12:0] temp_sum;

// Keeps a temporary sum of the 12 MSBs of the current 
// result and the multiplicand
assign temp_sum = y_pos + local_z_pos[23:12];

always@(posedge clk or posedge reset) begin
    // Asynchronous reset
    if (reset) begin
        state <= WAITING;
        count <= 'b0;
    end else begin
        // Synchronous load based on asynchronous start signal
        if (load) begin
            state <= LOAD;
            count <= 'b0;
        // If in the LOAD or MULTIPLYING state we continue multiplying
        // if we haven't performed all operations and we increment the count
        end else if (state == MULTIPLYING || state == LOAD) begin
            if (count < 4'd12) begin
                state <= MULTIPLYING;
                count <= count + 1;
            end else begin
                state <= DONE;
                count <= count;
            end
        // Done stays done
        end else if (state == DONE) begin
            state <= DONE;
            count <= count;
        // Edge case or WAITING
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
always@(mul or count or state) begin
    if (~mul) begin
        went_low = 'b1;
    end else if (mul & went_low) begin
        load = 'b1;
        went_low = 'b0;
    end else begin
        load = 'b0;
        went_low = 'b0;
    end
end

/*
    We output the correct value based
    on change in state of progress in multiplications
*/
always @(state or count) begin
    case (state)
        // When WAITING we output 0s
        WAITING: begin
            local_z_pos = 'b0;
            local_done = 'b0;
        end
        // LOAD involves loaded one of the inputs
        // into the LSB of our output
        LOAD: begin
            local_z_pos[23:12] = 12'b000000000000;
            local_z_pos[11:0] = x_pos;
            local_done = 'b0;
        end
        // MULTIPLYING means that 
        // 1. We will modify the MSB of our current 
        // result depending on the current LSB (a bit in the multiplier).
        // 2. Shift our current result to the right by 1
        // 3. Load the carry from the temporary sum into the MSB
        // 4. Check if we are done asynchronously by monitoring count.
        MULTIPLYING: begin
            if (local_z_pos[0] == 1'b1) begin
                local_z_pos[23:12] = temp_sum[11:0];
            end
            local_z_pos = local_z_pos >> 1; 
            local_z_pos[23] = temp_sum[12];
            if (count < 4'd12) begin
                local_done = 'b0;
            end else begin
                local_done = 'b1;
            end
        end
        // DONE simply means outputing the current loaded
        // registers and signaling 'done'
        DONE: begin
            local_z_pos = local_z_pos;
            local_done = 'b1;
        end
        // We default to a RESET
        default: begin
            local_z_pos = 'b0;
            local_done = 'b0;
        end
    endcase
end

endmodule 
