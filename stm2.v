
module stm2 ( 
    input wire clk,
    input wire rst,
    input wire in,
    output reg out
); 

   //Moore machine //6 States Used
    reg [2:0] currentState, next_state;
    
    parameter S0 = 3'b000;
    parameter S1   = 3'b001;
    parameter S2 = 3'b010;
    parameter S3 = 3'b011;
    parameter S4 = 3'b100;
    parameter S5 = 3'b101;
     
    
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
        
        if (currentState == S3 || currentState == S4 || currentState == S5) begin
            out = 1'b1;
        end else begin
            out = 1'b0;
        end
        
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
                end else begin
                    next_state = S0;
                end
            end
            
            S3: begin
                
                out = 1'b1;
                
                
                if (in) next_state = S5;  
                else    next_state = S4; 
            end
            
            S4: begin
                if (in) begin
                    next_state = S3;      
                end else begin
                    next_state = S0;
                end
            end
            
            S5: begin
                if (in) begin
                    next_state = S1;      
                end else begin
                    next_state = S2;
                end
            end
            
            default: next_state = S0;
        endcase
        
        
        
        
    
    end
        
endmodule