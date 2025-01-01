module linear_regression_estimation #(
    parameter DATA_WIDTH = 32,       
    parameter RAM_DEPTH = 10      
)(
    input i_clock,
    input i_reset, 
    input signed [DATA_WIDTH-1:0] i_samples_x_in,
    input i_samples_x_vld,
    input i_samples_x_last,
    input signed [DATA_WIDTH-1:0] i_samples_z_in,
    input i_samples_z_vld,
    input i_samples_z_last,
    input signed [DATA_WIDTH-1:0] i_data_samples_n, 
    output reg signed [DATA_WIDTH-1:0] o_theta0_out,
    output reg signed [DATA_WIDTH-1:0] o_theta1_out,
    output reg o_theta_out_vld
);

    reg signed [DATA_WIDTH-1:0] var_a; 
    reg signed [DATA_WIDTH-1:0] var_b; 
    reg signed [DATA_WIDTH-1:0] var_c, var_d, var_e;
    reg signed [DATA_WIDTH-1:0] nb_a2;

    reg signed [DATA_WIDTH-1:0] ram_x[0:RAM_DEPTH-1];
    reg signed [DATA_WIDTH-1:0] ram_z[0:RAM_DEPTH-1];
    reg signed [DATA_WIDTH-1:0] ram1[0:RAM_DEPTH-1];
    reg signed [DATA_WIDTH-1:0] ram2[0:RAM_DEPTH-1];
    reg signed [DATA_WIDTH-1:0] ram3[0:RAM_DEPTH-1];
    reg signed[DATA_WIDTH-1:0] ram4[0:RAM_DEPTH-1];

    wire [DATA_WIDTH-1:0] theta0_accum_1,theta1_accum_1;
    reg [DATA_WIDTH-1:0] theta0_accum, theta1_accum;
    reg [DATA_WIDTH-1:0] temp_theta0, temp_theta1;

    integer x_index, z_index;
    reg [2:0] state;
    integer i;

    always @(posedge i_clock or posedge i_reset) begin
        if (i_reset) begin
            var_a <= 0;
            var_b <= 0;
            var_c <= 0;
            var_d <= 0;
            var_e <= 0;
            nb_a2 <= 0;
            theta0_accum <= 0;
            theta1_accum <= 0;
            temp_theta0 <= 0;
            temp_theta1 <= 0;
            x_index <= 0;
            z_index <= 0;
            o_theta0_out <= 0;
            o_theta1_out <= 0;
            o_theta_out_vld <= 0;
            state <= 3'b000;
        end 
        else begin
            case (state)
                3'b000: begin
                    if (i_samples_x_vld && x_index < RAM_DEPTH) begin
                        ram_x[x_index] <= i_samples_x_in;
                        var_a <= var_a + i_samples_x_in;
                        var_b <= var_b + (i_samples_x_in * i_samples_x_in);
                        x_index <= x_index + 1;
                    end
                    if (i_samples_z_vld && z_index < RAM_DEPTH) begin
                        ram_z[z_index] <= i_samples_z_in;
                        z_index <= z_index + 1;
                    end
                    if (i_samples_x_last && i_samples_z_last) begin
                        state <= 3'b001;
                    end
                end

                3'b001: begin
                    var_c <= var_b;
                    var_d <= (-1)*(var_a);
                    var_e <= i_data_samples_n;
                    nb_a2 <= (i_data_samples_n * var_b) - (var_a * var_a);
                    state <= 3'b010;
                end

                3'b010: begin
                    for (i = 0; i < RAM_DEPTH; i = i + 1) begin
                        ram1[i] <= (var_d * ram_x[i]);
                        ram2[i] <= (var_e * ram_x[i]);
                    end
                    state <= 3'b011;
                end

                3'b011: begin
                    for (i = 0; i < RAM_DEPTH; i = i + 1) begin
                        ram3[i] <= (var_c + ram1[i]);
                        ram4[i] <= (var_d + ram2[i]);
                    end
                    state <= 3'b100;
                end

                3'b100: begin
                    temp_theta0 <= 0;
                    temp_theta1 <= 0;
                    for (i = 0; i < RAM_DEPTH; i = i + 1) begin
                        temp_theta0 <= temp_theta0 + (ram3[i] * ram_z[i]);
                        temp_theta1 <= temp_theta1 + (ram4[i] * ram_z[i]);
                    end
                    state <= 3'b101;
                end
                3'b101: begin
                    if (nb_a2 != 0) begin
                        theta0_accum <= theta0_accum_1;
                        theta1_accum <= theta1_accum_1;
                    end 
                    else begin
                        theta0_accum <= 0;
                        theta1_accum <= 0;
                    end
                    state <= 3'b110;
                end

                3'b110: begin
                    o_theta0_out <= theta0_accum;
                    o_theta1_out <= theta1_accum;
                    o_theta_out_vld <= 1;
                    state <= 3'b000;
                end 
                default: state <= 3'b000;
            endcase
        end
    end

    division divider(
        .dividend(temp_theta0),
        .divisor(nb_a2),
        .result(theta0_accum_1)
    );

    division divider_1(
        .dividend(temp_theta1),
        .divisor(nb_a2),
        .result(theta1_accum_1)
    );

endmodule

module division(
    input [31:0] divisor, dividend, 
    output reg [31:0] result
);

    integer i;
    reg [31:0] divisor_copy, dividend_copy;
    reg [31:0] temp;

    always @(divisor or dividend) begin
        divisor_copy = divisor;
        dividend_copy = dividend;
        temp = 0; 
        for(i = 0;i < 32;i = i + 1) begin
            temp = {temp[30:0], dividend_copy[31]};
            dividend_copy[31:1] = dividend_copy[30:0];
            temp = temp - divisor_copy;
            if(temp[31] == 1) begin
                dividend_copy[0] = 0;
                temp = temp + divisor_copy;
            end
            else begin
                dividend_copy[0] = 1;
            end
        end
        result = dividend_copy;
    end

endmodule