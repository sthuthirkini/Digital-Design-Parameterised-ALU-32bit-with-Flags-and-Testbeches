module alu32bit #(parameter WIDTH = 32) (
    input  logic [WIDTH-1:0] a, 
    input  logic [WIDTH-1:0] b, 
    input  logic [1:0]       ALUControl, 
    output logic [WIDTH-1:0] Result
);
    logic [WIDTH-1:0] condinvb;
    logic [WIDTH:0]   sum; // One bit wider to capture carry/overflow cleanly

    // Conditional inversion for subtraction (ALUControl[0] is 1 for sub, 0 for add)
    assign condinvb = ALUControl[0] ? ~b : b;
    
    // Adder handles both addition and subtraction with carry-in
    assign sum = a + condinvb + ALUControl[0];

    always_comb begin
        casex (ALUControl[1:0])
            2'b0?: Result = sum[WIDTH-1:0]; // Covers both 2'b00 (add) and 2'b01 (sub)
            2'b10: Result = a & b;          // Bitwise AND
            2'b11: Result = a | b;          // Bitwise OR
            default: Result = '0;
        endcase
    end

endmodule


