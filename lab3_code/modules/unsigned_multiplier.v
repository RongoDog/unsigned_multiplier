module unsigned_multiplier(mul, reset, clk, done, x_pos, y_pos, z_pos);

parameter WAITING = 2'b00;
parameter LOAD = 2'b01;
parameter MULTIPLYING = 2'b10;
parameter DONE = 2'b11;

input mul, reset, clk;
input [11:0] x_pos, y_pos;

output [23:0] z_pos;
reg [23:0] local_z_pos;
assign z_pos = local_z_pos;

output done;
reg local_done;
assign done = local_done;

reg load;

reg [1:0] state;
reg [3:0] count;

wire [12:0] temp_sum;

assign temp_sum = y_pos + local_z_pos[23:12];

always@(posedge clk or posedge reset) begin
    if (reset) begin
        state <= WAITING;
        count <= 'b0;
    end else begin
        if (load) begin
            state <= LOAD;
            count <= 'b0;
        end else if (state == MULTIPLYING || state == LOAD) begin
            if (count < 4'd11) begin
                state <= MULTIPLYING;
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


always@(posedge mul) begin
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

always @(state or count) begin
    case (state)
        WAITING: begin
            local_z_pos = 'b0;
            local_done = 'b0;
        end
        LOAD: begin
            local_z_pos[23:12] = 12'b000000000000;
            local_z_pos[11:0] = x_pos;
            local_done = 'b0;
        end
        MULTIPLYING: begin
            if (local_z_pos[0] == 1'b1) begin
                local_z_pos[23:12] = temp_sum[11:0];
            end
            local_z_pos = local_z_pos >> 1; 
            local_z_pos[23] = temp_sum[12];
            local_done = 'b0;
        end
        DONE: begin
            local_z_pos <= local_z_pos;
            local_done = 'b0;
        end
        default: begin
            local_z_pos = 'b0;
            local_done = 'b0;
        end
    endcase
end

endmodule 
