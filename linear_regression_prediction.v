module linear_regression_prediction #(
	parameter N = 32
)
(
    input i_clock,
    input i_reset,
    input [N-1:0] i_samples_x_in,   
    input i_samples_x_vld, 
    input [N-1:0] i_theta0_out,    
    input [N-1:0] i_theta1_out,    
    input i_theta1_out_vld, 
    output reg  o_predict_out_vld, 
    output reg [N-1:0] o_predict_out    
);

    reg [N-1:0] theta1_x; 
    always @(posedge i_clock or negedge i_reset) begin
        if (!i_reset) begin
            o_predict_out = 32'd0;
            o_predict_out_vld = 1'b0;
            theta1_x = 32'd0;
        end 
        else begin
            if (i_samples_x_vld && i_theta1_out_vld) begin
                theta1_x = (i_theta1_out)* (i_samples_x_in);
                o_predict_out = theta1_x + i_theta0_out;
                o_predict_out_vld = 1'b1;    
            end 
            else begin
                o_predict_out_vld = 1'b0;
            end
        end
    end
endmodule
