module alu32bit_sc_tb();
    logic [31:0] a, b;
    logic [1:0]  ALUControl;
    logic [31:0] Result;

    // Instantiate device under test (DUT)
    alu dut (
        .a(a), 
        .b(b), 
        .ALUControl(ALUControl), 
        .Result(Result)
    );

    initial begin

        $dumpfile("alu32bit_waveform.vcd");
        $dumpvars(0, alu32bit_sc_tb);
        // 1. Test Addition (ALUControl = 2'b00): 5 + 3 = 8
        //32 bits hexadecimal representation has been used for the inputs and expected output
        //1 hexadecimal digit represents 4 bits, so 8 hexadecimal digits are used for 32 bits
        
        a = 32'h00000005; b = 32'h00000003; ALUControl = 2'b00; #10;
        assert (Result === 32'h00000008) else $error("Addition failed: 5 + 3 expected 8, got %0h", Result);

        // 2. Test Subtraction (ALUControl = 2'b01): 5 - 3 = 2
        a = 32'h00000005; b = 32'h00000003; ALUControl = 2'b01; #10;
        assert (Result === 32'h00000002) else $error("Subtraction failed: 5 - 3 expected 2, got %0h", Result);
        //placeholders syntax"%0h" is used to print the value of Result in hexadecimal format in the error message

        // 3. Test Bitwise AND (ALUControl = 2'b10)
        a = 32'hFFFF0000; b = 32'h0FF00FF0; ALUControl = 2'b10; #10;
        assert (Result === 32'h0FF00000) else $error("Bitwise AND failed, got %0h", Result);

        // 4. Test Bitwise OR (ALUControl = 2'b11)
        a = 32'hFFFF0000; b = 32'h0000FFFF; ALUControl = 2'b11; #10;
        assert (Result === 32'hFFFFFFFF) else $error("Bitwise OR failed, got %0h", Result);

        $display("All simulation tests completed successfully.");
        $finish;
    end

endmodule