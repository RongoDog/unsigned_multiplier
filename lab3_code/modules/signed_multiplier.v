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
    x_test,
    y_test,
    z_test
);

input rst, clk, sx, sy, mul, sz, x_in, y_in;
output fx, fy, done, fz, z_out;

output [11:0] x_test, y_test;
output [23:0] z_test;

wire [11:0] x_par;
wire [11:0] x_mul;
wire [11:0] y_par;
wire [11:0] y_mul;

wire [23:0] z_pos;
wire [23:0] z_res_signed;

assign x_test = x_par;
assign y_test = y_par;
assign z_test = z_res_signed;

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
    .enable(!(y_par[11]^x_par[11])),
    .reset(rst),
    .clk(clk),
    .z_out(z_res_signed)
);

shift_out s_out(
    .z_parallel(z_res_signed),
    .sz(sz),
    .reset(rst),
    .clk(clk),
    .z_out(z_out),
    .fz(fz)
);

endmodule
