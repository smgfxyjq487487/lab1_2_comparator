`timescale 1ns / 1ns
module comparator (
    input wire clk,      
    input wire key_a,    
    input wire key_b,    
    output wire led_lt,   
    output wire led_eq,   
    output wire led_gt    
);

    reg a=1'b0,b=1'b0;
    reg key_a_d=1'b1,key_b_d=1'b1;

    always @(posedge clk) begin
        key_a_d<=key_a;
        if(key_a_d && !key_a)a<=~a;
        key_b_d <= key_b;
        if(key_b_d && !key_b)b<=~b;     
    end

    wire lt,eq,gt;
    assign lt=(~a)&b;  // A < B
    assign eq=~(a^b);  // A = B
    assign gt=a&(~b);  // A > B

    assign led_lt =~lt;
    assign led_eq =~eq;
    assign led_gt =~gt;

endmodule
