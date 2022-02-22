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
        
    reg [1:0] tmp;//���ڿ���ÿ�ΰ���buttonֻ����һ�μ���
    reg start;//��ʼ��־����
    
    //��ʼ��־
    always@(posedge clk or posedge rst)begin
        if(rst)start <= 0;
        else if(button) start <= 1;
    end
    
    //buttonΪ1��һ��ʱ����tmp��0����2����tmpȡ1����һ�Σ����ƽ��м���
    always @(posedge clk or posedge rst) begin
        if(rst | ~button) tmp <= 2'd0;
        else if(tmp == 2'd2) tmp <= tmp;
        else tmp <= tmp + 1;
    end

    always@(posedge clk or posedge rst)begin
        if(rst)begin
            flag_error <= 0;
            cal_result <= 32'd0;//�첽����
        end
        else if(~start)cal_result <= num1;//δ��ʼ����ʱcal_result��ʼ��Ϊnum1
        else if(tmp == 2'd1)begin//ÿ�ΰ���button��ʼ����
            case(func)
                3'b000:cal_result <= cal_result + num2;//�ӷ�
                3'b001:cal_result <= cal_result - num2;//����
                3'b010:cal_result <= cal_result * num2;//�˷�
                3'b011:begin
                    if(num2 == 0)flag_error <= 1;
                    else cal_result <= cal_result / num2;//����
                end
                3'b100:begin
                    if(num2 == 0)flag_error <= 1;
                    else cal_result <= cal_result % num2;//ģ
                end
                3'b101:cal_result <= cal_result * cal_result;//ƽ��
            endcase
        end
    end

endmodule
