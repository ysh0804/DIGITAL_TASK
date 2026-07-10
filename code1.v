module code1 (
    input wire clk,         
    input wire rst,        
    input wire in, 
    output reg done,  
    output reg parity_err,   
    output reg frame_err,           
    output reg [7:0] data_out     
);
    reg[2:0] state;
    reg[3:0] count;
    reg[7:0] tempReg;
    
    reg recieve;
    
    parameter start = 3'b000;
    parameter data = 3'b001;
    parameter checkParity = 3'b010;
    parameter frame = 3'b011;
    
    always@(posedge clk) begin
    if(rst)begin
            data_out   <= 8'b0;
            done       <= 1'b0;
            parity_err <= 1'b0;
            frame_err  <= 1'b0;
            recieve    <= 1'b0;
            count      <= 4'd0;
            tempReg    <= 8'd0; 
            end
    else begin 
            done       <= 1'b0;
            parity_err <= 1'b0;
            frame_err  <= 1'b0;
            
            
            if(!recieve)begin
            if(in ==1'b0) begin
                recieve <= 1'b1; //RECEIVED THE INPUT BIT 
                count = 4'b1;// COUNTER SET TO 1 
                end
            end
            else begin
            
            count <= count  + 1'b1;
           
            if(count >= 4'b0001 && count <= 4'b1000) //Bit positions 1 through 8: shift in data bits 
            begin
            tempReg <= {in, tempReg[7:1]};
            
            end
            
            else if(count == 4'b1001)begin 
            
                if((^tempReg ^ in) == 1'b1) parity_err <= 1'b1; //Checking for Parity Error!!
                else parity_err <= 1'b0;
                
                
            end
            else if(count == 4'b1010)begin 
            
                if(in == 1'b0) frame_err <= 1'b1; //Checking if if the stop bit is not 1
                else if(!parity_err) begin
                done <= 1'b1;
                data_out <= tempReg;
                end
                
                recieve <= 1'b0;
                count <= 4'd0;
                
            end
            
          end
    end        
    
    
    end
endmodule
