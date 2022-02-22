module calculator_hex(
    input wire clk,
    input wire rst,
    input wire button,
    input wire [2:0] func,
    input wire [7:0] num1,
    input wire [7:0] num2,
    output reg [31:0] cal_result,
    output reg flag_error
    );
        
    reg [1:0] tmp;//用于控制每次按下button只进行一次计算
    reg start;//开始标志变量
    
    //开始标志
    always@(posedge clk or posedge rst)begin
        if(rst)start <= 0;
        else if(button) start <= 1;
    end
    
    //button为1的一段时间内tmp从0加至2，以tmp取1（仅一次）控制进行计算
    always @(posedge clk or posedge rst) begin
        if(rst | ~button) tmp <= 2'd0;
        else if(tmp == 2'd2) tmp <= tmp;
        else tmp <= tmp + 1;
    end

    always@(posedge clk or posedge rst)begin
        if(rst)begin
            flag_error <= 0;
            cal_result <= 32'd0;//异步重置
        end
        else if(~start)cal_result <= num1;//未开始计算时cal_result初始化为num1
        else if(tmp == 2'd1)begin//每次按下button开始运算
            case(func)
                3'b000:cal_result <= cal_result + num2;//加法
                3'b001:cal_result <= cal_result - num2;//减法
                3'b010:cal_result <= cal_result * num2;//乘法
                3'b011:begin
                    if(num2 == 0)flag_error <= 1;
                    else cal_result <= cal_result / num2;//除法
                end
                3'b100:begin
                    if(num2 == 0)flag_error <= 1;
                    else cal_result <= cal_result % num2;//模
                end
                3'b101:cal_result <= cal_result * cal_result;//平方
            endcase
        end
    end

endmodule
