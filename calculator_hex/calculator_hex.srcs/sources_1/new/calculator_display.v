module calculator_display(
    input wire clk,
    input wire rst,
    input wire button,
    input wire [31:0] cal_result,
    input wire flag_error,
    output reg [7:0] led_en,
    output reg led_ca,
    output reg led_cb,
    output reg led_cc,
    output reg led_cd,
    output reg led_ce,
    output reg led_cf,
    output reg led_cg,
    output reg led_dp
    );
    
    reg start;//开始标志
    reg [3:0] cal_num;//数码管显示数字
    reg [31:0] cnt;//显示位置轮换计数变量
    wire cnt_end = (cnt == 32'd10_000);//显示位置轮换计数结束标志
    reg [3:0] ena_cnt;//位置变量
    wire ena_cnt_end = (ena_cnt == 4'd7);//位置周期结束标志
        
    //开始标志start
    always@(posedge clk or posedge rst)begin
        if(rst) start <= 0;
        else if(button)start <= 1;
    end
    
    //cnt周期性累加
    always@(posedge clk or posedge rst)begin
        if(rst) cnt <= 0;
        else if(start)begin
            if(cnt_end)cnt <= 0;
            else cnt <= cnt + 1;
        end
    end
    
    //ena_cnt周期性累加
    always@(posedge clk or posedge rst)begin
        if(rst) ena_cnt <= 0;
        else if(cnt_end)begin
            if(ena_cnt_end)ena_cnt <= 0;
            else ena_cnt <= ena_cnt + 1;
        end
    end
    
    //led_en数码管显示位置
    always@(posedge clk or posedge rst)begin
        if(rst) led_en <= 8'b11111111;//异步重置
        else if(cnt_end)begin
            case(ena_cnt)//根据当前显示位置赋对应led_en
                4'd0:led_en <= 8'b11111110;
                4'd1:led_en <= 8'b11111101;
                4'd2:led_en <= 8'b11111011;
                4'd3:led_en <= 8'b11110111;
                4'd4:led_en <= 8'b11101111;
                4'd5:led_en <= 8'b11011111;
                4'd6:led_en <= 8'b10111111;
                4'd7:led_en <= 8'b01111111;
            endcase
        end
    end
    
    //数码管显示数字
    always@(posedge clk or posedge rst)begin
        if(rst) cal_num <= 0;//异步重置
        else if(start)begin
            case(ena_cnt)//根据当前显示位置将计算结果对应位赋给显示数字变量cal_num
                4'd0:cal_num <= cal_result[3:0];
                4'd1:cal_num <= cal_result[7:4];
                4'd2:cal_num <= cal_result[11:8];
                4'd3:cal_num <= cal_result[15:12];
                4'd4:cal_num <= cal_result[19:16];
                4'd5:cal_num <= cal_result[23:20];
                4'd6:cal_num <= cal_result[27:24];
                4'd7:cal_num <= cal_result[31:28];
            endcase
        end
    end
    
    //数码管显示
    always@(posedge clk or posedge rst)begin
        if(rst) begin
            led_ca <= 1;
            led_cb <= 1;
            led_cc <= 1;
            led_cd <= 1;
            led_ce <= 1;
            led_cf <= 1;
            led_cg <= 1;
        end
        else if (cnt_end) begin
            if(flag_error)begin//若存在错误，显示Error
                case(ena_cnt)
                4'd7:begin
                    led_ca <= 0;
                    led_cb <= 1;
                    led_cc <= 1;
                    led_cd <= 0;
                    led_ce <= 0;
                    led_cf <= 0;
                    led_cg <= 0;
                end
                4'd6:begin
                    led_ca <= 1;
                    led_cb <= 1;
                    led_cc <= 1;
                    led_cd <= 1;
                    led_ce <= 0;
                    led_cf <= 1;
                    led_cg <= 0;
                end
                4'd5:begin
                    led_ca <= 1;
                    led_cb <= 1;
                    led_cc <= 1;
                    led_cd <= 1;
                    led_ce <= 0;
                    led_cf <= 1;
                    led_cg <= 0;
                end
                4'd4:begin
                    led_ca <= 1;
                    led_cb <= 1;
                    led_cc <= 0;
                    led_cd <= 0;
                    led_ce <= 0;
                    led_cf <= 1;
                    led_cg <= 0;
                end
                4'd3:begin
                    led_ca <= 1;
                    led_cb <= 1;
                    led_cc <= 1;
                    led_cd <= 1;
                    led_ce <= 0;
                    led_cf <= 1;
                    led_cg <= 0;
                end
                default:begin
                    led_ca <= 1;
                    led_cb <= 1;
                    led_cc <= 1;
                    led_cd <= 1;
                    led_ce <= 1;
                    led_cf <= 1;
                    led_cg <= 1;
                end
            endcase
            end
            else begin
            case(cal_num)
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
                4'd10:begin
                    led_ca <= 0;
                    led_cb <= 0;
                    led_cc <= 0;
                    led_cd <= 1;
                    led_ce <= 0;
                    led_cf <= 0;
                    led_cg <= 0;
                end
                4'd11:begin
                    led_ca <= 1;
                    led_cb <= 1;
                    led_cc <= 0;
                    led_cd <= 0;
                    led_ce <= 0;
                    led_cf <= 0;
                    led_cg <= 0;
                end
                4'd12:begin
                    led_ca <= 1;
                    led_cb <= 1;
                    led_cc <= 1;
                    led_cd <= 0;
                    led_ce <= 0;
                    led_cf <= 1;
                    led_cg <= 0;
                end
                4'd13:begin
                    led_ca <= 1;
                    led_cb <= 0;
                    led_cc <= 0;
                    led_cd <= 0;
                    led_ce <= 0;
                    led_cf <= 1;
                    led_cg <= 0;
                end
                4'd14:begin
                    led_ca <= 0;
                    led_cb <= 1;
                    led_cc <= 1;
                    led_cd <= 0;
                    led_ce <= 0;
                    led_cf <= 0;
                    led_cg <= 0;
                end
                4'd15:begin
                    led_ca <= 0;
                    led_cb <= 1;
                    led_cc <= 1;
                    led_cd <= 1;
                    led_ce <= 0;
                    led_cf <= 0;
                    led_cg <= 0;
                end
            endcase
            end
        end
    end
endmodule
