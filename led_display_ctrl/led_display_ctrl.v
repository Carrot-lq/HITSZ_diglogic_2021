module led_display_ctrl (
    input  wire       clk   ,
	input  wire       rst   ,
	input  wire       button,
	output reg  [7:0] led_en,
	output reg        led_ca,
	output reg        led_cb,
    output reg        led_cc,
	output reg        led_cd,
	output reg        led_ce,
	output reg        led_cf,
	output reg        led_cg,
	output wire       led_dp 
);
    reg [19:0] cnt;
    wire cnt_end = (cnt == 20'd199_999);
    reg [31:0] sec_cnt;
    wire sec_cnt_end = (sec_cnt == 32'd99_999_999);
    reg [3:0] sec;
    reg [3:0] pos;
    reg start;

    assign led_dp = 1;
    
    //开始标志start
    always@(posedge clk)begin
        if(rst)start <= 0;
        else if(button)start <= 1;
        else start <= start;
    end
    
    //2ms计数变量cnt
    always@(posedge clk)begin
        if(rst)cnt <= 20'd0;
        else if (start)begin
            if(cnt_end)cnt <= 20'd0;
            else cnt <= cnt + 1;
        end
    end
    
   //1s计数变量sec_cnt
    always@(posedge clk)begin
        if(rst)sec_cnt <= 32'd0;
        else if (start)begin
            if(sec_cnt_end)sec_cnt <= 32'd0;
            else sec_cnt <= sec_cnt + 1;
        end
    end
    
    //倒计时变量sec
    always@(posedge clk)begin
        if(rst)sec <= 4'd10;
        else if(sec_cnt_end)begin
            if(sec == 4'd0)sec <= 4'd10;
            else sec <= sec - 1;
        end
    end
    
    //显示位置变量pos
    always@(posedge clk)begin
        if(rst)pos <= 4'd0;
        else if(cnt_end)begin
            if(pos == 4'd7)pos <= 0;
            else pos <= pos + 1;
        end
    end
    
    //led使能led_en及数码管显示对应位置数字
    always@(posedge clk)begin
        if(rst)led_en <= 8'hff;
        else if(start)begin
            case(pos)
                4'd0:begin
                    led_en <= 8'hfe;
                    led(2);
                end
                4'd1:begin
                    led_en <= 8'hfd;
                    led(3);
                end
                4'd2:begin
                    led_en <= 8'hfb;
                    led(1);
                end
                4'd3:begin
                    led_en <= 8'hf7;
                    led(0);
                end
                4'd4:begin
                    led_en <= 8'hef;
                    led(0);
                end
                4'd5:begin
                    led_en <= 8'hdf;
                    led(2);
                end
                4'd6:begin
                    led_en <= 8'hbf;
                    if(sec == 4'd10)led(0);
                    else led(sec);
                end
                4'd7:begin
                    led_en <= 8'h7f;
                    if(sec == 4'd10)led(1);
                    else led(0);
                end
            endcase
        end
    end
    
    //数码管显示数字task
    task led;
        input [4:0] num;
        case(num)
            4'd0:begin
                led_ca <= 0;
                led_cb <= 0;
                led_cc <= 0;
                led_cd <= 0;
                led_ce <= 0;
                led_cf <= 0;
                led_cg <= 1;
            end
            4'd1:begin
                led_ca <= 1;
                led_cb <= 0;
                led_cc <= 0;
                led_cd <= 1;
                led_ce <= 1;
                led_cf <= 1;
                led_cg <= 1;
            end
            4'd2:begin
                led_ca <= 0;
                led_cb <= 0;
                led_cc <= 1;
                led_cd <= 0;
                led_ce <= 0;
                led_cf <= 1;
                led_cg <= 0;
            end
            4'd3:begin
                led_ca <= 0;
                led_cb <= 0;
                led_cc <= 0;
                led_cd <= 0;
                led_ce <= 1;
                led_cf <= 1;
                led_cg <= 0;
            end
            4'd4:begin
                led_ca <= 1;
                led_cb <= 0;
                led_cc <= 0;
                led_cd <= 1;
                led_ce <= 1;
                led_cf <= 0;
                led_cg <= 0;
            end
            4'd5:begin
                led_ca <= 0;
                led_cb <= 1;
                led_cc <= 0;
                led_cd <= 0;
                led_ce <= 1;
                led_cf <= 0;
                led_cg <= 0;
            end
            4'd6:begin
                led_ca <= 0;
                led_cb <= 1;
                led_cc <= 0;
                led_cd <= 0;
                led_ce <= 0;
                led_cf <= 0;
                led_cg <= 0;
            end
            4'd7:begin
                led_ca <= 0;
                led_cb <= 0;
                led_cc <= 0;
                led_cd <= 1;
                led_ce <= 1;
                led_cf <= 1;
                led_cg <= 1;
            end
            4'd8:begin
                led_ca <= 0;
                led_cb <= 0;
                led_cc <= 0;
                led_cd <= 0;
                led_ce <= 0;
                led_cf <= 0;
                led_cg <= 0;
            end
            4'd9:begin
                led_ca <= 0;
                led_cb <= 0;
                led_cc <= 0;
                led_cd <= 1;
                led_ce <= 1;
                led_cf <= 0;
                led_cg <= 0;
            end
        endcase
    endtask
endmodule