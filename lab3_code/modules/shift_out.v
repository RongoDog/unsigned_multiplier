// Shift out module.
// Inputs:
//   x_in - serial data input
//   sx - asynchronous start data input on next clock cyle
//   reset - asynchronous reset
//   clk - clock signal
// Outputs:
//   z_out - serial output
//   fz - output valid signal
module shift_out (z_parallel, sz, reset, clk, z_out, fz);

// Parameters define states
parameter WAITING = 2'b00;
parameter LOAD = 2'b01;
parameter SHIFTING = 2'b10;
parameter DONE = 2'b11;

// Input definitions
input [23:0] z_parallel;
input sz, reset, clk;

// Output definitions
output fz, z_out;
reg local_fz;
assign fz = local_fz;

// Asynchronous start helpers
reg went_low;
reg load;

// State and count registers
reg [1:0] state;
reg [4:0] count;

// Registers containing loaded input
reg [23:0] tmp;
// We output the MSB of the loaded input
assign z_out = tmp[23];

/*
    Main clock and reset loop
*/
always @(posedge clk or posedge reset) begin
    // Asynchronous reset
    if (reset) begin
        state <= WAITING;
        count <= 'b0;
    end else begin
        // Load is synchronous based on asynchronous start
        if (load) begin
            state <= LOAD;
            count <= 'b0;
        // If shifting or LOADED, we continue until done
        end else if (state == SHIFTING || state == LOAD) begin
            if (count < 5'd23) begin
                state <= SHIFTING;
                count <= count + 1;
            end else begin
                state <= DONE;
                count <= count;
            end
        // Done stays done
        end else if (state == DONE) begin
            state <= DONE;
            count <= count;
        // Edge-case or waiting
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
always @(sz or count or state) begin
    if (~sz) begin
        went_low = 'b1;
    end else if (sz & went_low) begin
        load = 'b1;
        went_low = 'b0;
    end else begin
        load = 'b0;
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
            tmp = 'b0;
            local_fz = 'b0;
        end
        LOAD: begin
            tmp = z_parallel;
            local_fz = 'b1;
        end
        SHIFTING: begin
            // We shift to the left
            // output the MSB to the LSB
            tmp = tmp << 1;
            local_fz = 'b1;
        end
        DONE: begin
            tmp = 'b0;
            local_fz = 'b0;
        end
        default: begin
            tmp = 'b0;
            local_fz = 'b0;
        end
    endcase
end

endmodule
