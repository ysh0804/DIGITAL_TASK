module code2 (
    input wire clk,         
    input wire rst,        
    input wire in, 
    output reg done,  
    output reg parity_err,   
    output reg frame_err,           
    output reg [7:0] result_out     
);
    reg[2:0] state;
    reg[3:0] count;
    reg[7:0] testReg;
    reg[7:0] tempRegA;
    reg[7:0] tempRegB;
    reg[1:0] cmd;
    reg parity;
    
    reg recieve;
    
    parameter start = 3'b000;
    parameter data = 3'b001;
    parameter checkParity = 3'b010;
    parameter frame = 3'b011;
    
    always@(posedge clk) begin
    
    
    if(rst)begin
            result_out   <= 8'b0;
            done       <= 1'b0;
            parity_err <= 1'b0;
            frame_err  <= 1'b0;
            recieve    <= 1'b0;
            count      <= 4'b0;
            testReg <= 8'b0;
            tempRegA    <= 8'b0; 
            tempRegB    <= 8'b0;
            parity  <= 1'b0;
    end
    else begin 
            done       <= 1'b0;
                        
            if(!recieve)
            begin
            if(in ==1'b0)
                begin
                recieve <= 1'b1;
                count <= 4'b0001;
                parity <= 1'b0;
                end
            end
            else begin
            
            count <= count  + 1'b1;
            
            if(count >= 4'b0001 && count <= 4'b0010) begin
            cmd <= {cmd[0],in};
            end
            
            else if(count >=4'b0011 && count <= 4'b1010)begin
                 testReg <= {testReg[6:0],in};
                 parity <= parity^in;
            end
            else if(count == 4'b1011)begin
                 if(parity != in)begin
                 parity_err <= 1'b1;
                end 
            end
            else if(count == 4'b1100)
            begin
                 if(in == 1'b0) frame_err <= 1'b1;
            end    
            else if(count == 4'b1101)
            begin    
                 recieve <= 1'b0;
                 count <= 4'b0;
            
            if(!parity_err && !frame_err)
            begin
                done <= 1'b1;
                
                case (cmd)
                2'b00: begin
                        tempRegA <= testReg;
                        result_out <= testReg;
                        end
                2'b01: begin
                        tempRegB <= testReg;
                        result_out <= testReg;
                        end
                2'b10: begin
                        result_out <= tempRegA  + tempRegB;
                        end
                2'b11: begin
                        tempRegB <= 8'b0;  
                        result_out <= 8'b0;
                        tempRegA <= 8'b0;
                        end
                endcase
            end 
            else begin
                parity_err <= 1'b0;
                frame_err <= 1'b0;
            
            end
          end         
         end
       end
    end
  
    
endmodule
