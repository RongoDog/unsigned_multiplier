module signed_multiplier(
    rst,
    clk,
    x_in,
    sx,
    fx,
    y_in,
    sy,
    fy,
    mul,
    done,
    sz,
    fz,
    z_out,
    z_test,
    z_test_raw,
);

input rst, clk, sx, sy, mul, sz, x_in, y_in;
output fx, fy, done, fz, z_out;

output [23:0] z_test;
output [23:0] z_test_raw;

wire [11:0] x_par;
wire [11:0] x_mul;
wire [11:0] y_par;
wire [11:0] y_mul;

wire [23:0] z_pos;
wire [23:0] z_res_signed;
reg [23:0] z_res_final;

assign z_test = z_res_final;
assign z_test_raw = z_pos;

shift_in s_inx(
    .x_in(x_in),
    .sx(sx),
    .reset(rst),
    .clk(clk),
    .x_parallel(x_par),
    .fx(fx)
);

shift_in s_iny(
    .x_in(y_in),
    .sx(sy),
    .reset(rst),
    .clk(clk),
    .x_parallel(y_par),
    .fx(fy)
);

twos_complement_in twos_in_x(
    .x_in(x_par),
    .enable(1'b1),
    .reset(rst),
    .clk(clk),
    .x_pos_out(x_mul)
);

twos_complement_in twos_in_y(
    .x_in(y_par),
    .enable(1'b1),
    .reset(rst),
    .clk(clk),
    .x_pos_out(y_mul)
);

unsigned_multiplier multiplier(
    .mul(mul),
    .done(done),
    .clk(clk),
    .reset(rst),
    .x_pos(x_mul),
    .y_pos(y_mul),
    .z_pos(z_pos)
);

twos_complement_out twos_out(
    .z_pos(z_pos),
    .enable(1'b1),
    .reset(rst),
    .clk(clk),
    .z_out(z_res_signed)
);

shift_out s_out(
    .z_parallel(z_res_final),
    .sz(sz),
    .reset(rst),
    .clk(clk),
    .z_out(z_out),
    .fz(fz)
);

always@(*) begin
    case(y_par[11]^x_par[11])
        1'b0: z_res_final = z_pos;
        1'b1: z_res_final = z_res_signed;
        default: z_res_final = 'b0;
    endcase
end

endmodule
