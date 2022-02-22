module sequence_detection (
    input  wire       clk   ,
	input  wire       rst   ,
	input  wire       button,
	input  wire [7:0] switch,
	output reg        led
);
    wire rst_n = ~rst;
    reg [3:0]cnt;
    wire cnt_end = (cnt ==4'h7);
    reg start;

    always@(posedge clk or negedge rst_n)begin
        if(~rst_n) start <= 1'b0;
        else if(button)start <= 1'b1;
        else if(cnt_end)start <= 1'b0;
    end
    
    always@(posedge clk or negedge rst_n)begin
        if(~rst_n||button)cnt <= 4'h0;
        else if (cnt_end)cnt <= 4'h0;
        else if(start)cnt <= cnt + 1;
    end
    
    parameter IDLE = 6'b00001;
    parameter S1 = 6'b000010;
    parameter S2 = 6'b000100;
    parameter S3 = 6'b001000;
    parameter S4 = 6'b010000;
    parameter S5 = 6'b100000;
    
    reg [5:0]current_state;
    reg [5:0]next_state;
    reg current_switch;

    always@(posedge clk or negedge rst_n)begin
        if(~rst_n)current_state <= IDLE;
        else if(button)current_state <= IDLE;
        else if(start)current_state <= next_state;
        else current_state <= current_state;
    end
    
    always@(*)begin
        case(cnt)
            4'h0:current_switch = switch[7];
            4'h1:current_switch = switch[6];
            4'h2:current_switch = switch[5];
            4'h3:current_switch = switch[4];
            4'h4:current_switch = switch[3];
            4'h5:current_switch = switch[2];
            4'h6:current_switch = switch[1];
            4'h7:current_switch = switch[0];
        endcase
    end
    
    always@(*)begin
        case(current_state)
            IDLE : begin 
                    if(current_switch)next_state = S1;
                    else next_state = IDLE;
                end
            S1 : begin 
                    if(~current_switch)next_state = S2;
                    else next_state = S1;
                end
            S2 : begin 
                    if(~current_switch)next_state = S3;
                    else next_state = S1;
                end
            S3 : begin 
                    if(current_switch)next_state = S4;
                    else next_state = IDLE;
                end
            S4 : begin 
                    if(~current_switch)next_state = S5;
                    else next_state = S1;
                end
            S5 : begin 
                    next_state = next_state;
                end
        endcase
    end
    
    //Èôµ±Ç°×´Ì¬ÎªS5£¬µÆÁÁ
    always@(posedge clk or negedge rst_n)begin
        if(~rst_n)led <= 1'b0;
        else if(current_state == S5)led <= 1'b1;
        else led <= 1'b0;
    end
endmodule