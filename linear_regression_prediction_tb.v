`timescale 1ns / 1ps
module linear_regression_prediction_tb;

    reg i_clock;
    reg i_reset;
    reg [31:0] i_samples_x_in;   
    reg i_samples_x_vld; 
    reg [31:0] i_theta0_out;    
    reg [31:0] i_theta1_out;    
    reg i_theta1_out_vld; 
    wire o_predict_out_vld; 
    wire [31:0] o_predict_out;    

    linear_regression_prediction uut (
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

    // Clock generation
    initial begin
        i_clock = 0;
        forever #5 i_clock = ~i_clock;
    end

    // Sample x values from the given table
    reg [31:0] samples_x_table [0:127];
    integer i; // Loop counter

    // Initialize the sample table with values
    initial begin
        samples_x_table[0] = 32'd5;
        samples_x_table[1] = 32'd3;
        samples_x_table[2] = 32'd15;
        samples_x_table[3] = 32'd7;
        samples_x_table[4] = 32'd20;
        samples_x_table[5] = 32'd2;
        samples_x_table[6] = 32'd12;
        samples_x_table[7] = 32'd4;
        samples_x_table[8] = 32'd1;
        samples_x_table[9] = 32'd10;
        samples_x_table[10] = 32'd3;
        samples_x_table[11] = 32'd18;
        samples_x_table[12] = 32'd6;
        samples_x_table[13] = 32'd14;
        samples_x_table[14] = 32'd2;
        samples_x_table[15] = 32'd16;
        samples_x_table[32] = 32'd7;
        samples_x_table[17] = 32'd12;
        samples_x_table[18] = 32'd0;
        samples_x_table[19] = 32'd22;
        samples_x_table[20] = 32'd5;
        samples_x_table[21] = 32'd19;
        samples_x_table[22] = 32'd2;
        samples_x_table[23] = 32'd9;
        samples_x_table[24] = 32'd13;
        samples_x_table[25] = 32'd3;
        samples_x_table[26] = 32'd11;
        samples_x_table[27] = 32'd1;
        samples_x_table[28] = 32'd15;
        samples_x_table[29] = 32'd6;
        samples_x_table[30] = 32'd25;
        samples_x_table[31] = 32'd4;
        samples_x_table[32] = 32'd3;
        samples_x_table[33] = 32'd10;
        samples_x_table[34] = 32'd20;
        samples_x_table[35] = 32'd2;
        samples_x_table[36] = 32'd7;
        samples_x_table[37] = 32'd14;
        samples_x_table[38] = 32'd1;
        samples_x_table[39] = 32'd21;
        samples_x_table[40] = 32'd5;
        samples_x_table[41] = 32'd18;
        samples_x_table[42] = 32'd3;
        samples_x_table[43] = 32'd8;
        samples_x_table[44] = 32'd13;
        samples_x_table[45] = 32'd2;
        samples_x_table[46] = 32'd5;
        samples_x_table[47] = 32'd16;
        samples_x_table[48] = 32'd11;
        samples_x_table[49] = 32'd0;
        samples_x_table[50] = 32'd22;
        samples_x_table[51] = 32'd7;
        samples_x_table[52] = 32'd12;
        samples_x_table[53] = 32'd19;
        samples_x_table[54] = 32'd3;
        samples_x_table[55] = 32'd9;
        samples_x_table[56] = 32'd2;
        samples_x_table[57] = 32'd17;
        samples_x_table[58] = 32'd4;
        samples_x_table[59] = 32'd7;
        samples_x_table[60] = 32'd23;
        samples_x_table[61] = 32'd3;
        samples_x_table[62] = 32'd12;
        samples_x_table[63] = 32'd21;
        samples_x_table[64] = 32'd1;
        samples_x_table[65] = 32'd10;
        samples_x_table[66] = 32'd19;
        samples_x_table[67] = 32'd5;
        samples_x_table[68] = 32'd8;
        samples_x_table[69] = 32'd18;
        samples_x_table[70] = 32'd6;
        samples_x_table[71] = 32'd11;
        samples_x_table[72] = 32'd16;
        samples_x_table[73] = 32'd2;
        samples_x_table[74] = 32'd14;
        samples_x_table[75] = 32'd10;
        samples_x_table[76] = 32'd22;
        samples_x_table[77] = 32'd6;
        samples_x_table[78] = 32'd20;
        samples_x_table[79] = 32'd3;
        samples_x_table[80] = 32'd8;
        samples_x_table[81] = 32'd13;
        samples_x_table[82] = 32'd0;
        samples_x_table[83] = 32'd24;
        samples_x_table[84] = 32'd2;
        samples_x_table[85] = 32'd10;
        samples_x_table[86] = 32'd2;
        samples_x_table[87] = 32'd15;
        samples_x_table[88] = 32'd21;
        samples_x_table[89] = 32'd6;
        samples_x_table[90] = 32'd11;
        samples_x_table[91] = 32'd3;
        samples_x_table[92] = 32'd18;
        samples_x_table[93] = 32'd25;
        samples_x_table[94] = 32'd7;
        samples_x_table[95] = 32'd12;
        samples_x_table[96] = 32'd22;
        samples_x_table[97] = 32'd1;
        samples_x_table[98] = 32'd10;
        samples_x_table[99] = 32'd20;
        samples_x_table[100] = 32'd5;
        samples_x_table[101] = 32'd8;
        samples_x_table[102] = 32'd19;
        samples_x_table[103] = 32'd5;
        samples_x_table[104] = 32'd13;
        samples_x_table[105] = 32'd16;
        samples_x_table[106] = 32'd3;
        samples_x_table[107] = 32'd7;
        samples_x_table[108] = 32'd14;
        samples_x_table[109] = 32'd2;
        samples_x_table[110] = 32'd15;
        samples_x_table[111] = 32'd9;
        samples_x_table[112] = 32'd22;
        samples_x_table[113] = 32'd6;
        samples_x_table[114] = 32'd0;
        samples_x_table[115] = 32'd6;
        samples_x_table[116] = 32'd15;
        samples_x_table[117] = 32'd20;
        samples_x_table[118] = 32'd3;
        samples_x_table[119] = 32'd10;
        samples_x_table[120] = 32'd17;
        samples_x_table[121] = 32'd25;
        samples_x_table[122] = 32'd5;
        samples_x_table[123] = 32'd11;
        samples_x_table[124] = 32'd16;
        samples_x_table[125] = 32'd2;
        samples_x_table[126] = 32'd9;
        samples_x_table[127] = 32'd1.5; 
    end

    // Main testbench logic
    initial begin
        // Initialize signals
        i_reset = 0;
        i_samples_x_in = 32'd0;
        i_samples_x_vld = 0;
        i_theta0_out = 32'd115313; // Constant theta0
        i_theta1_out = 32'd2;   // Constant theta1
        i_theta1_out_vld = 1;      // Theta valid

        // Reset the module
        #10;
        i_reset = 1;
        #10;

        // Test cases
        for (i = 0; i < 128; i = i + 1) begin
            i_samples_x_in = samples_x_table[i];  // Load next sample
            i_samples_x_vld = 1'b1;               // Valid signal asserted
            #10; // Wait for one clock cycle

            // Check output
            if (o_predict_out_vld) begin
                $display("Test case %0d: i_samples_x_in = %d, o_predict_out = %d", i + 1, i_samples_x_in, o_predict_out);
            end 
            else begin
                $display("Test case %0d failed: o_predict_out_vld is low.", i + 1);
            end
        end

        $finish; // End simulation
    end
endmodule
*/