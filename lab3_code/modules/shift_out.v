//Verilog HDL for "lab3", "shift_out" "verilog"

module shift_out (z_parallel, sz, reset, clk, z_out, fz);

parameter WAITING = 2'b00;
parameter LOAD = 2'b01;
parameter SHIFTING = 2'b10;
parameter DONE = 2'b11;

input [23:0] z_parallel;
input sz, reset, clk;

output fz, z_out;
reg local_fz;
assign fz = local_fz;

reg went_low;
reg load;

reg [1:0] state;
reg [4:0] count;

reg [23:0] tmp;
assign z_out = tmp[23];

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= WAITING;
        count <= 'b0;
    end else begin
        if (load) begin
            state <= LOAD;
            count <= 'b0;
        end else if (state == SHIFTING || state == LOAD) begin
            if (count < 4'd23) begin
                state <= SHIFTING;
                count <= count + 1;
            end else begin
                state <= DONE;
                count <= count;
            end
        end else if (state == DONE) begin
            state <= DONE;
            count <= count;
        end else begin
            state <= WAITING;
            count <= 'b0;
        end
    end
end

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

always @(state or count) begin
    case (state)
        WAITING: begin
            tmp = 'b0;
            local_fz = 'b0;
        end
        LOAD: begin
            tmp <= z_parallel;
            local_fz <= 'b1;
        end
        SHIFTING: begin
            tmp <= tmp << 1;
            local_fz <= 'b1;
        end
        DONE: begin
            tmp <= 'b0;
            local_fz = 'b0;
        end
        default: begin
            tmp <= 'b0;
            local_fz = 'b0;
        end
    endcase
end

endmodule
