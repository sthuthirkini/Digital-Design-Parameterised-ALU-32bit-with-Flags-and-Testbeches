`timescale 1ns/1ps

module alu32bit_tv_tb();
    // Parameter definition for easy scalability (e.g., change to 8, 16, 64 etc.)
    parameter WIDTH = 32;

    logic clk, reset;
    logic [WIDTH-1:0] a, b;
    logic [1:0]       ALUControl;
    logic [WIDTH-1:0] Result;
    logic [WIDTH-1:0] yexpected;
    logic [31:0]      vectornum, errors;
    
    // Dynamic bit-width calculation: 
    // For WIDTH = 32, total width = 32 + 32 + 2 + 32 = 96 bits -> [95:0]
    localparam TV_WIDTH = (WIDTH * 3) + 2;
    logic [TV_WIDTH-1:0] testvectors [3:0];

    // Instantiate Device Under Test (DUT) with parameter override
    alu32bit #(.WIDTH(WIDTH)) dut (
        .a(a),
        .b(b),
        .ALUControl(ALUControl),
        .Result(Result)
    );

    // Generate clock
    always begin
        clk = 1; #5;
        clk = 0; #5;
    end

    // Load test vectors and pulse reset at startup
    initial begin
        $readmemb("alu32bit.tv", testvectors);
        vectornum = 0;
        errors = 0;
        reset = 1; #27;
        reset = 0;
    end

    // Apply test vectors on the rising edge of clk
    always @(posedge clk) begin
        if (!reset) begin
            {a, b, ALUControl, yexpected} = testvectors[vectornum];
        end
    end

    // Check results on the falling edge of clk
    always @(negedge clk) begin
        if (!reset) begin // skip during reset
            if (Result !== yexpected) begin
                $display("Error: inputs = a:%h, b:%h, control:%b", a, b, ALUControl);
                $display("  outputs = %h (%h expected)", Result, yexpected);
                errors = errors + 1;
            end
            vectornum = vectornum + 1;
            
            // Dynamically check against the total TV width instead of hardcoded 96'bx
            if (testvectors[vectornum] === {TV_WIDTH{1'bx}}) begin
                $display("%0d tests completed with %0d errors.", vectornum, errors);
                $finish;
            end
        end
    end

endmodule