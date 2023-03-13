module vending_machine(
    input clk,
    input reset,
    input coin,
    input select,
    output reg [3:0] state,
    output reg [3:0] outputs
);

    parameter S_IDLE = 4'b0000;
    parameter S_COLLECTING = 4'b0001;
    parameter S_DISPENSING = 4'b0010;
    parameter S_CHANGE = 4'b0011;
    
    reg [3:0] next_state;
    reg [3:0] current_output;

    always @(*) begin
        case(state)
            S_IDLE: begin
                current_output = 4'b0000;
                if(select) begin
                    next_state = S_COLLECTING;
                end else begin
                    next_state = S_IDLE;
                end
            end
            
            S_COLLECTING: begin
                current_output = 4'b0001;
                if(coin) begin
                    next_state = S_DISPENSING;
                end else begin
                    next_state = S_COLLECTING;
                end
            end
            
            S_DISPENSING: begin
                current_output = 4'b0010;
                if(next_state == S_COLLECTING) begin
                    next_state = S_CHANGE;
                end else begin
                    next_state = S_IDLE;
                end
            end
            
            S_CHANGE: begin
                current_output = 4'b0011;
                next_state = S_IDLE;
            end
            
            default: next_state = S_IDLE;
        endcase
    end
    
    // Assign outputs
    always @(posedge clk, posedge reset) begin
        if(reset) begin
            state <= S_IDLE;
            outputs <= 4'b0000;
        end else begin
            state <= next_state;
            outputs <= current_output;
        end
    end
    
endmodule
