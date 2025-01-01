`timescale 1ns / 1ps

module linear_regression_prediction_tb;

    parameter DATA_WIDTH = 32;
    parameter RAM_DEPTH = 6686;

    reg i_clock;
    reg i_reset;
    reg [DATA_WIDTH-1:0] i_samples_x_in;
    reg i_samples_x_vld;
    reg [DATA_WIDTH-1:0] i_theta0_out;
    reg [DATA_WIDTH-1:0] i_theta1_out;
    reg i_theta1_out_vld;
    wire o_predict_out_vld;
    wire [DATA_WIDTH-1:0] o_predict_out; 

    integer x_file, i;
    real temp_x_value;
    reg [DATA_WIDTH-1:0] x_values [0:RAM_DEPTH-1];

    linear_regression_prediction #(
        .N(DATA_WIDTH)
    ) uut (
        .i_clock(i_clock),
        .i_reset(i_reset),
        .i_samples_x_in(i_samples_x_in),
        .i_samples_x_vld(i_samples_x_vld),
        .i_theta0_out(i_theta0_out),
        .i_theta1_out(i_theta1_out),
        .i_theta1_out_vld(i_theta1_out_vld),
        .o_predict_out_vld(o_predict_out_vld),
        .o_predict_out(o_predict_out)
    );

    always #5 i_clock = ~i_clock;

    initial begin
        i_clock = 0;
        i_reset = 0;
        i_samples_x_in = 0;
        i_samples_x_vld = 0;
        i_theta0_out = 32'd69403;
        i_theta1_out = 32'd1111;

        #20 i_reset = 1;

        x_file = $fopen("D:/VS_Code/Verilog_folder/IEEE_internship/x_values_1.txt", "r");

        if (x_file == 0) begin
            $display("Error: Failed to open input file!");
            $stop;
        end

        i = 0;
        while (!$feof(x_file)) begin
            $fscanf(x_file, "%f\n", temp_x_value); 
            x_values[i] = temp_x_value;           
            i = i + 1;
        end
        $fclose(x_file);


        for (i = 0; i < RAM_DEPTH; i = i + 1) begin
            i_samples_x_vld = 1;
            i_theta1_out_vld = 1;
            i_samples_x_in = x_values[i];
            #10;
            $display("Theta0: %d, Theta1: %d, x: %d, y: %d", i_theta0_out, i_theta1_out, i_samples_x_in, o_predict_out);
            #10;
        end

        i_samples_x_vld = 0;

        #2000;
        $stop;
    end
endmodule
