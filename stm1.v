
module stm1 ( 
    input wire clk,
    input wire rst,
    input wire in,
    output reg out
); 

    //Mealy machine  //4 states Used
    reg [1:0] currentState, next_state;
    
    parameter S0 = 2'b00;
    parameter S1   = 2'b01;
    parameter S2 = 2'b10;
    parameter S3 = 2'b11; 
    
   always @(posedge clk or posedge rst) begin 
    if(rst)begin
     currentState <= S0;
     end
    else begin 
     currentState <= next_state;
     end
    end 
    
    
    always @(*) begin 
        next_state = currentState ;
        out = 1'b0;
        
        case (currentState)
            S0: begin
                if (in) next_state = S1;
                else    next_state = S0;
            end
            
            S1: begin
                if (in) next_state = S1;
                else    next_state = S2;
            end
            
            S2: begin
                if (in) begin
                    next_state = S3;
                    out = 1'b1;       
                end else begin
                    next_state = S0;
                end
            end
            
            S3: begin
                
                out = 1'b1;
                
                
                if (in) next_state = S1;  
                else    next_state = S2; 
            end
            
            default: next_state = S0;
        endcase
    
    end
        
endmodule