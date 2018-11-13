`include "shift_in.v"
`include "shift_out.v"
`include "twos_complement_in.v"
`include "twos_complement_out.v"
`include "unsigned_multiplier.v"

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

reg [11:0] x_par;
reg [11:0] x_pos_par;
reg [11:0] x_mul;
reg [11:0] y_par;
reg [11:0] y_pos_par;
reg [11:0] y_mul;

reg [23:0] z_pos;
reg [23:0] z_res_signed;
reg [23:0] z_res_final;

assign x_test = x_par;
assign y_test = y_par;
assign z_test = z_res_final;

shift_in s_inx(
    .x_in(x_in),
    .sx(sx),
    .reset(rst),
    .clk(clk),
    .x_parallel(x_par),
    .fx(fx)
);

shift_in s_iny(
    .x_in(x_in),
    .sx(sx),
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
    .x_pos_out(x_pos_par)
);

twos_complement_in twos_in_y(
    .x_in(y_par),
    .enable(1'b1),
    .reset(rst),
    .clk(clk),
    .x_pos_out(y_pos_par)
);

always@(x_par[0]) begin
    case(x_par[0])
        1'b1: x_mul = x_par;
        1'b0: x_mul = x_pos_par;
        default: x_mul = 'b0;
    endcase    
end

always@(y_par[0]) begin
    case(y_par[0])
        1'b1: y_mul = y_par;
        1'b0: y_mul = y_pos_par;
        default: y_mul = 'b0;
    endcase    
end

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

always@(y_par[0] or x_par[0]) begin
    case(y_par[0]^x_par[0])
        1'b0: z_res_final = z_pos;
        1'b1: z_res_final = z_res_signed;
        default: z_res_final = 24'b0;
    endcase
end

endmodule
