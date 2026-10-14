`timescale 1ns / 1ns
module comparator_tb;

    reg  clk = 0;
    reg  key_a = 1, key_b = 1;             
    wire led_lt, led_eq, led_gt;      
    reg a_t = 0, b_t = 0;
    integer errors = 0;

    comparator dut (
        .clk    (clk),
        .key_a  (key_a),
        .key_b  (key_b),
        .led_lt (led_lt),
        .led_eq (led_eq),
        .led_gt (led_gt)
    );

    always #10 clk = ~clk;   

    task press;
        input sel;    // 0 = A, 1 = B
        begin
            case (sel)
                0:key_a =0;
                1:key_b =0;
            endcase
            #40;
            case (sel)
                0:key_a =1;
                1:key_b =1;
            endcase
            #40;
        end
    endtask

    task set_state;
        input A,B;    
        begin
            if (a_t!== A) begin press(0); a_t=~a_t; end
            if (b_t!== B) begin press(1); b_t=~b_t; end
            #40;
            if ((led_lt !== ~((~A)&B))||
                (led_eq !== ~(~(A^B)))||
                (led_gt !== ~(A&(~B)))) begin
                $display("FAIL  A=%b B=%b -> lt=%b (exp %b), eq=%b (exp %b), gt=%b (exp %b)",
                        A,B,~led_lt,(~A)&B,
                        ~led_eq,~(A^B),~led_gt,A&(~B));
                errors=errors+1;
            end else begin
                $display("PASS A=%b B=%b -> lt=%b, eq=%b, gt=%b",
                        A,B,~led_lt,~led_eq,~led_gt);
            end
        end
    endtask

    initial begin
        $dumpfile("comparator_tb.vcd");
        $dumpvars(0, comparator_tb);

        // A=0 B=0 -> A=B 
        set_state(0, 0);
        // A=0 B=1 -> A<B 
        set_state(0, 1);
        // A=1 B=0 -> A>B 
        set_state(1, 0);
        // A=1 B=1 -> A=B  
        set_state(1, 1);

        if (errors == 0)
            $display("ALL 4 CASES PASSED");
        else
            $display("%0d CASE(S) FAILED", errors);

        #40 $finish;
    end

endmodule
