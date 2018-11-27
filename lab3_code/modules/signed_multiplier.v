// 2x12bit to 24bit unsigned multiplier module.
// Inputs:
//   rst - asynchronous reset
//   clk - clock signal
//   sx - start serial multiplier input loading
//   sy - start serial multiplicand input loading
//   mul - start multiplication
//   sz - start serial output reading
//   x_in - serial multiplier input
//   y_in - serial multiplicant input
// Outputs:
//   fx - multiplier loading complete
//   fy - multiplicand loading complete
//   done - multiplication complete signal
//   fz - serial output valid
//   z_out - serial output
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
    z_out
);

// Input/Output definitions
input rst, clk, sx, sy, mul, sz, x_in, y_in;
output fx, fy, done, fz, z_out;

// Defines wires for the inputs that are
// paralleled and the inputs to be multiplied
wire [11:0] x_par;
wire [11:0] x_mul;
wire [11:0] y_par;
wire [11:0] y_mul;

// Defines wires for the positive output
// and the output that is signed
wire [23:0] z_pos;
wire [23:0] z_res_signed;

// Input shift in modules
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

// We take the twos complement of the inputs
// NOTE: The module does not perform the operation
// if the MSB is 0.
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

// Multiplier performs necessary operations
unsigned_multiplier multiplier(
    .mul(mul),
    .done(done),
    .clk(clk),
    .reset(rst),
    .x_pos(x_mul),
    .y_pos(y_mul),
    .z_pos(z_pos)
);

// The twos complement out module is directed
// to take the twos complement of the result
// only if only one of the inputs is negative
twos_complement_out twos_out(
    .z_pos(z_pos),
    .enable(!(y_par[11]^x_par[11])),
    .reset(rst),
    .clk(clk),
    .z_out(z_res_signed)
);

// Shift out
shift_out s_out(
    .z_parallel(z_res_signed),
    .sz(sz),
    .reset(rst),
    .clk(clk),
    .z_out(z_out),
    .fz(fz)
);

endmodule
