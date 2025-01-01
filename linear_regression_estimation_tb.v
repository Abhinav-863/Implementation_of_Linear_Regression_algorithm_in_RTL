`timescale 1ns / 1ps

module linear_regression_estimation_tb;

    parameter DATA_WIDTH = 32;
    parameter RAM_DEPTH = 35;

    reg i_clock;
    reg i_reset;
    reg [DATA_WIDTH-1:0] i_samples_x_in;
    reg i_samples_x_vld;
    reg i_samples_x_last;
    reg [DATA_WIDTH-1:0] i_samples_z_in;
    reg i_samples_z_vld;
    reg i_samples_z_last;
    reg [DATA_WIDTH-1:0] i_data_samples_n;
    wire [DATA_WIDTH-1:0] o_theta0_out;
    wire [DATA_WIDTH-1:0] o_theta1_out;
    wire o_theta_out_vld;

    integer x_file, z_file, i;
    real temp_x_value;
    reg [DATA_WIDTH-1:0] x_values [0:RAM_DEPTH-1];
    reg [DATA_WIDTH-1:0] z_values [0:RAM_DEPTH-1];

    linear_regression_estimation #(
        .DATA_WIDTH(DATA_WIDTH),
        .RAM_DEPTH(RAM_DEPTH)
    ) uut (
        .i_clock(i_clock),
        .i_reset(i_reset),
        .i_samples_x_in(i_samples_x_in),
        .i_samples_x_vld(i_samples_x_vld),
        .i_samples_x_last(i_samples_x_last),
        .i_samples_z_in(i_samples_z_in),
        .i_samples_z_vld(i_samples_z_vld),
        .i_samples_z_last(i_samples_z_last),
        .i_data_samples_n(i_data_samples_n),
        .o_theta0_out(o_theta0_out),
        .o_theta1_out(o_theta1_out),
        .o_theta_out_vld(o_theta_out_vld)
    );

    always #5 i_clock = ~i_clock;

    initial begin
        i_clock = 0;
        i_reset = 1;
        i_samples_x_in = 0;
        i_samples_x_vld = 0;
        i_samples_x_last = 0;
        i_samples_z_in = 0;
        i_samples_z_vld = 0;
        i_samples_z_last = 0;

        #20 i_reset = 0;

        x_file = $fopen("D:/VS_Code/Verilog_folder/IEEE_internship/x_values_1.txt", "r");
        z_file = $fopen("D:/VS_Code/Verilog_folder/IEEE_internship/z_values_1.txt", "r");

        if (x_file == 0 || z_file == 0) begin
            $display("Error: Failed to open input files!");
            $stop;
        end

        i = 0;
        while (!$feof(x_file)) begin
            $fscanf(x_file, "%f\n", temp_x_value); 
            x_values[i] = temp_x_value;           
            i = i + 1;
        end

        i = 0;
        while (!$feof(z_file)) begin
            $fscanf(z_file, "%d\n", z_values[i]); 
            i = i + 1;
        end

        $fclose(x_file);
        $fclose(z_file);

        i_data_samples_n = RAM_DEPTH; 
        for (i = 0; i < RAM_DEPTH; i = i + 1) begin
            i_samples_x_in = x_values[i];
            i_samples_x_vld = 1;
            i_samples_x_last = (i == RAM_DEPTH-1);

            i_samples_z_in = z_values[i];
            i_samples_z_vld = 1;
            i_samples_z_last = (i == RAM_DEPTH-1);

            #10;
        end

        i_samples_x_vld = 0;
        i_samples_x_last = 0;
        i_samples_z_vld = 0;
        i_samples_z_last = 0;

        #2000;
        $display("Theta0: %d, Theta1: %d, Valid: %d", o_theta0_out, o_theta1_out, o_theta_out_vld);

        $stop;
    end
endmodule