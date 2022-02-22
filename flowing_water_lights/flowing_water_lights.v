module flowing_water_lights (
    input  wire       clk   ,
	input  wire       rst   ,
	input  wire       button,
	output reg  [7:0] led
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
        if(rst) led[7:0] <= 8'h00;
        else if(button) led[7:0] <= 8'h01;
        else if(cnt_end) led[7:0] <= {led[6:0],led[7]};
    end
endmodule