module holiday_lights (
    input  wire        clk   ,
	input  wire        rst   ,
	input  wire        button,
    input  wire [ 2:0] switch,
	output reg  [15:0] led
);
    
    reg [31:0]cnt;
    reg cnt_inc;
    wire cnt_end;
    assign cnt_end = (cnt == 32'd100_000_000);
    
    //¼ÆÊıÆ÷
    always@(posedge clk or posedge rst)begin
        if(rst)cnt <= 32'd0;
        else if(cnt_end) cnt <= 32'd0;
        else if(cnt_inc) cnt <= cnt + 32'd1;
    end
    
    //°´Å¥
    always@(posedge clk or posedge rst)begin
        if(rst)cnt_inc <= 0;
        else if(button)cnt_inc <= 1;
    end
    
    //led
    always@(posedge clk or posedge rst)begin
        if(rst) led[15:0] <= 16'h0000;
        else if(button)begin
            case(switch)
                3'b000: led[15:0] <= 16'h0001;
                3'b001: led[15:0] <= 16'h0003;
                3'b010: led[15:0] <= 16'h0007;
                3'b011: led[15:0] <= 16'h000f;
                3'b100: led[15:0] <= 16'h001f;
                3'b101: led[15:0] <= 16'h003f;
                3'b110: led[15:0] <= 16'h007f;
                3'b111: led[15:0] <= 16'h00ff;
            endcase
        end
        else if(cnt_end) led[15:0] <= {led[14:0],led[15]};
    end
endmodule