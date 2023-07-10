module dig_controller(
	input wire rst,
	input wire clk,

    input wire wen,
    input wire [31: 0] wdata,

	output reg [7:0] led,
	output reg [7:0] led_en
);

// always @(*) led = 8'b00000000;
// always @(*) led_en = 8'h00;

reg [15: 0] toggle_cnt;
always @(posedge rst or posedge clk) begin
    if(rst) begin
        toggle_cnt <= 16'h00000;
    end else begin
        toggle_cnt <= toggle_cnt + 1;
    end
end

wire toggle = toggle_cnt == 0;

always @(posedge rst or posedge clk) begin
//    led_en <= 8'b11101111;
    if(rst == 1'b1)
        led_en <= 8'b11111110;
    else if(toggle == 1'b1)
        led_en <= {led_en[6:0], led_en[7]};
    else
        led_en <= led_en;
end

reg [31: 0] nums;
always @(posedge rst or posedge clk) begin
    if(rst == 1'b1)
        nums <= 32'h00000000;
    else if(wen == 1'b1)
        nums <= wdata;
    else
        nums <= nums;
end

reg [3:0] now_num;
always @(*) begin
    case(led_en)
        8'b11111110: now_num = nums[3:0];
        8'b11111101: now_num = nums[7:4];
        8'b11111011: now_num = nums[11:8];
        8'b11110111: now_num = nums[15:12];
        8'b11101111: now_num = nums[19:16];
        8'b11011111: now_num = nums[23:20];
        8'b10111111: now_num = nums[27:24];
        8'b01111111: now_num = nums[31:28];
        default: now_num = 4'h0;
    endcase
end

// always @(posedge rst or posedge clk) begin
//     if(rst == 1'b1)
//         now_num <= 4'h0;
//     else begin
//         case(led_en)
//             8'b11111110: now_num <= nums[3:0];
//             8'b11111101: now_num <= nums[7:4];
//             8'b11111011: now_num <= nums[11:8];
//             8'b11110111: now_num <= nums[15:12];
//             8'b11101111: now_num <= nums[19:16];
//             8'b11011111: now_num <= nums[23:20];
//             8'b10111111: now_num <= nums[27:24];
//             8'b01111111: now_num <= nums[31:28];
//             default: now_num <= 4'h0;
//         endcase
//     end
// end

always @(*) begin
    case(now_num)
        4'h0: led = 8'b00000011;
        4'h1: led = 8'b10011111;
        4'h2: led = 8'b00100101;
        4'h3: led = 8'b00001101;
        4'h4: led = 8'b10011001;
        4'h5: led = 8'b01001001;
        4'h6: led = 8'b01000001;
        4'h7: led = 8'b00011111;
        4'h8: led = 8'b00000001;
        4'h9: led = 8'b00011001;
        4'ha: led = 8'b00010001;
        4'hb: led = 8'b11000001;
        4'hc: led = 8'b11100101;
        4'hd: led = 8'b10000101;
        4'he: led = 8'b01100001;
        4'hf: led = 8'b01110001;
       default:led = 8'b00000000;
    endcase
end

endmodule