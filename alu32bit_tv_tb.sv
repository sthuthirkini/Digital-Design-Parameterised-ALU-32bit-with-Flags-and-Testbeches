`timescale 1ns/1ps

module alu32bit_tb();
    logic clk, reset;
    logic [31:0] a, b;
    logic [1:0]  ALUControl;
    logic [31:0] Result;
    //3 extra inputs/outputs for the testbench to compare the expected output with the actual output
    logic [31:0] yexpected;
    logic [31:0] vectornum, errors;
    
    // Array to hold test vectors: {a, b, ALUControl, yexpected}
    // Total width = 32 + 32 + 2 + 32 = 96 bits wide (fixed math note: 32+32+2+32 = 96)
    logic [95:0] testvectors [3:0];
    //1000:0] allocates an array with space for 1,001 individual test vectors (indexed from 0 to 1000).


    //It means the array can store up to 1,000 separate test rows (from index 0 up to index 1000).   

    //This gives you plenty of room in memory to load small or large test vector files 
    //without overflowing the array.

    /*testvectors is an array that stores a list of test cases 
    (input data and expected correct outputs) 
    read from an external file (like alu32bit.tv)

    Instead of hardcoding values inside your testbench, 
    the testbench reads rows of binary numbers from a text 
    file and loads them into this testvectors array using $readmemb.

    During simulation, the testbench grabs one row at a time, 
    feeds the inputs (a, b, ALUControl) into your ALU, and compares the resulting output (Result) against the expected output (yexpected).*/

    // ADDED: Instantiate your ALU module here so Result gets calculated!
    alu dut (
        .a(a),
        .b(b),
        .ALUControl(ALUControl),
        .Result(Result)
    );

    always begin
        clk = 1; #5;
        clk = 0; #5;
    end

    initial begin
    $readmemb("alu32bit.tv", testvectors);
    vectornum = 0;
    errors = 0;
    reset = 1; #27;
    reset = 0;
end

/* $readmemb("alu32bit.tv", testvectors);
What it does: This is a Verilog system task 
that opens your external test vector file (alu32bit.tv) 
and reads all the binary test cases stored inside it, 
loading them sequentially into your testvectors array.
Why b: The b in $readmemb stands for binary. 
It tells the simulator that the numbers inside alu32bit.tv
 are formatted in binary base-2.
  (If your file used hexadecimal numbers, 
  you would use $readmemh instead).*/

  // Apply test vectors on rising edge of clk
  // (NOTE: The second duplicate always block below was removed to prevent multiple driver errors)
    always @(posedge clk) begin
        if (!reset) begin
            {a, b, ALUControl, yexpected} = testvectors[vectornum];//This uses Verilog's concatenation operator {} to unpack a single row from your test vector array.
        // Look at the current index number stored in vectornum (e.g., 0, then 1, then 2, etc.).
        // Fetch that 98-bit row from the testvectors array.
        // Automatically slice and split those 98 bits back into your individual test signals: the first 32 bits go to a, the next 32 bits go to b, the next 2 bits go to ALUControl, and the final 32 bits go to yexpected.
        end
    end

always @(negedge clk) begin
        if (!reset) begin // skip during reset
            if (Result !== yexpected) begin
                $display("Error: inputs = a:%h, b:%h, control:%b", a, b, ALUControl);
                $display("  outputs = %h (%h expected)", Result, yexpected);
                errors = errors + 1;
            end
            vectornum = vectornum + 1;
            if (testvectors[vectornum] === 96'bx) begin
                /*testvectors[vectornum]: Looks up the current row in your test vector array using your index tracker (vectornum)
                === (Case Equality): This is a special "case equality" operator in SystemVerilog.
                 Unlike the standard ==, === checks for exact bit-by-bit matches—including unknown (x)
                  and high-impedance (z) states.

                  If every value raeches a point where the next row in the testvectors array is all x's (unknown), 
                  it means you've reached the end of your test vector file.
                */

                $display("%0d tests completed with %0d errors.", vectornum, errors);
                $finish;
            end
        end
    end

endmodule