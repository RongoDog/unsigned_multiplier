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

output [11;0] x_test, y_test;
output [23:0] z_test;

wire [11:0] x_par;
wire [11:0] x_mul;
wire [11:0] y_par;
wire [11:0] y_mul;

wire [23:0] z_pos;
wire [23:0] z_res_signed;
wire [23:0] z_res_final;

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


assign z_res_final[23] = ((y_par[11]^x_par[11]) & z_res_signed[23]) | (!(y_par[11]^x_par[11]) & z_pos[23]); 
assign z_res_final[22] = ((y_par[11]^x_par[11]) & z_res_signed[22]) | (!(y_par[11]^x_par[11]) & z_pos[22]); 
assign z_res_final[21] = ((y_par[11]^x_par[11]) & z_res_signed[21]) | (!(y_par[11]^x_par[11]) & z_pos[21]); 
assign z_res_final[20] = ((y_par[11]^x_par[11]) & z_res_signed[20]) | (!(y_par[11]^x_par[11]) & z_pos[20]); 
assign z_res_final[19] = ((y_par[11]^x_par[11]) & z_res_signed[19]) | (!(y_par[11]^x_par[11]) & z_pos[19]); 
assign z_res_final[18] = ((y_par[11]^x_par[11]) & z_res_signed[18]) | (!(y_par[11]^x_par[11]) & z_pos[18]); 
assign z_res_final[17] = ((y_par[11]^x_par[11]) & z_res_signed[17]) | (!(y_par[11]^x_par[11]) & z_pos[17]); 
assign z_res_final[16] = ((y_par[11]^x_par[11]) & z_res_signed[16]) | (!(y_par[11]^x_par[11]) & z_pos[16]); 
assign z_res_final[15] = ((y_par[11]^x_par[11]) & z_res_signed[15]) | (!(y_par[11]^x_par[11]) & z_pos[15]); 
assign z_res_final[14] = ((y_par[11]^x_par[11]) & z_res_signed[14]) | (!(y_par[11]^x_par[11]) & z_pos[14]); 
assign z_res_final[13] = ((y_par[11]^x_par[11]) & z_res_signed[13]) | (!(y_par[11]^x_par[11]) & z_pos[13]); 
assign z_res_final[12] = ((y_par[11]^x_par[11]) & z_res_signed[12]) | (!(y_par[11]^x_par[11]) & z_pos[12]); 
assign z_res_final[11] = ((y_par[11]^x_par[11]) & z_res_signed[11]) | (!(y_par[11]^x_par[11]) & z_pos[11]); 
assign z_res_final[10] = ((y_par[11]^x_par[11]) & z_res_signed[10]) | (!(y_par[11]^x_par[11]) & z_pos[10]); 
assign z_res_final[9] = ((y_par[11]^x_par[11]) & z_res_signed[9]) | (!(y_par[11]^x_par[11]) & z_pos[9]); 
assign z_res_final[8] = ((y_par[11]^x_par[11]) & z_res_signed[8]) | (!(y_par[11]^x_par[11]) & z_pos[8]); 
assign z_res_final[7] = ((y_par[11]^x_par[11]) & z_res_signed[7]) | (!(y_par[11]^x_par[11]) & z_pos[7]); 
assign z_res_final[6] = ((y_par[11]^x_par[11]) & z_res_signed[6]) | (!(y_par[11]^x_par[11]) & z_pos[6]); 
assign z_res_final[5] = ((y_par[11]^x_par[11]) & z_res_signed[5]) | (!(y_par[11]^x_par[11]) & z_pos[5]); 
assign z_res_final[4] = ((y_par[11]^x_par[11]) & z_res_signed[4]) | (!(y_par[11]^x_par[11]) & z_pos[4]); 
assign z_res_final[3] = ((y_par[11]^x_par[11]) & z_res_signed[3]) | (!(y_par[11]^x_par[11]) & z_pos[3]); 
assign z_res_final[2] = ((y_par[11]^x_par[11]) & z_res_signed[2]) | (!(y_par[11]^x_par[11]) & z_pos[2]); 
assign z_res_final[1] = ((y_par[11]^x_par[11]) & z_res_signed[1]) | (!(y_par[11]^x_par[11]) & z_pos[1]); 
assign z_res_final[0] = ((y_par[11]^x_par[11]) & z_res_signed[0]) | (!(y_par[11]^x_par[11]) & z_pos[0]); 


endmodule
