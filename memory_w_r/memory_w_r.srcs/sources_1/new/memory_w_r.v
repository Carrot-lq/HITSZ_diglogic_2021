`timescale 1ns / 1ps

module memory_w_r(
    input wire clk,
    input wire rst,
    input wire button,
    input wire[15:0] mem_douta,
    output reg mem_ena,
    output reg mem_wea,
    output reg[3:0] mem_addra,
    output reg[15:0] mem_dina,
    output reg[15:0] led
    );
    
    reg [31:0] cnt;
    reg [7:0] cnt_write;
    reg [7:0] cnt_read;
    reg [3:0] pre_cnt;
    wire one_before_pre_cnt_end = (pre_cnt==4'd2);
    wire pre_cnt_end = (pre_cnt==4'd3);
    wire one_before_cnt_end =(cnt == 32'd9999998);
    wire cnt_end =(cnt == 32'd9999999);
    reg start;
        
    always@(posedge clk) begin
        if(rst) start <= 0;
        else if(button) start <= 1;
        else start <= start;
    end
    
    always@(posedge clk)begin
        if(rst||button)cnt <= 32'd0;
        else if(cnt_write == 8'd16)begin
            if(cnt_end)cnt <= 32'd0;
            else cnt <= cnt + 1;
        end
        else cnt <= cnt;
    end
    
    always@(posedge clk)begin
        if(rst||button)pre_cnt <= 4'd0;
        else if(start)begin
            if(pre_cnt_end)pre_cnt <= 4'd0;
            else pre_cnt <= pre_cnt + 1;
        end
        else pre_cnt <= pre_cnt;
    end
    
    always@(posedge clk)begin
        if(rst||button)cnt_write <= 4'd0;
        else if(pre_cnt_end)begin
            if(cnt_write == 8'd16)cnt_write <= cnt_write;
            else cnt_write = cnt_write + 1;
        end
        else cnt_write <= cnt_write;
    end
    
    always@(posedge clk)begin
        if(rst||button)cnt_read <= 4'd0;
        else if(cnt_end)begin
            if(cnt_read == 4'd15)cnt_read <= cnt_read;
            else cnt_read <= cnt_read + 1;
        end
    end

    always@(posedge clk) begin
        if(rst||button) mem_ena <= 0;
        else if(start)begin
            if(one_before_pre_cnt_end||one_before_cnt_end)mem_ena <= 1;
            else mem_ena <= 0;
        end
        else mem_ena <= mem_ena;
    end
    
    always@(posedge clk) begin
        if(rst||button)mem_wea <= 0;
        else if(start)begin
            if(cnt_write == 8'd16)mem_wea <= 0;
            else mem_wea <= 1;
        end
        else mem_wea <= mem_wea;
    end
    
    always@(posedge clk) begin
        if(rst||button) mem_addra <= 4'b0000;
        else if(start)begin
            if(cnt_write == 8'd16)mem_addra <= cnt_read;
            else mem_addra <= cnt_write;
        end
    end
    
    always@(posedge clk) begin
    if(rst||button)mem_dina <= 16'h0000;
    else if(start && ~(cnt_write == 8'd16))begin
            case(cnt_write)
                4'd0: mem_dina <= 16'h0001;
                4'd1: mem_dina <= 16'h0003;
                4'd2: mem_dina <= 16'h0007;
                4'd3: mem_dina <= 16'h000f;
                4'd4: mem_dina <= 16'h001f;
                4'd5: mem_dina <= 16'h003f;
                4'd6: mem_dina <= 16'h007f;
                4'd7: mem_dina <= 16'h00ff;
                4'd8: mem_dina <= 16'h01ff;
                4'd9: mem_dina <= 16'h03ff;
                4'd10: mem_dina <= 16'h07ff;
                4'd11: mem_dina <= 16'h0fff;
                4'd12: mem_dina <= 16'h1fff;
                4'd13: mem_dina <= 16'h3fff;
                4'd14: mem_dina <= 16'h7fff;
                4'd15: mem_dina <= 16'hffff;
                default:mem_dina <= mem_dina;
            endcase
        end
    end
    
    always@(posedge clk)begin
        if(rst||button) led <= 16'h0000;
        else if(cnt_write == 8'd16) led <= cnt_write;
        else led <= led;
    end
endmodule
