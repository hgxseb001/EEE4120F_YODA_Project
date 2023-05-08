

module hello_world;
    // string hello = "Hello, world!";
    parameter SIZE = 32*32;
    parameter numStringBits = 184;
    reg [23:0] rom_memory [SIZE-1:0];
    reg [3:0] textFile [numStringBits-1:0];

    reg [31:0] hex_val;
    integer file;

    initial begin
      $readmemh("output.mem", rom_memory);
      $readmemh("input_string.mem", textFile);

      hex_val = 32'hDEADBEEF;
      file = $fopen("output.txt", "w");
      if (file == 0) begin
      $display("Error opening file!");
      // $finish;
      end
      $fwrite(file, "%h", hex_val);
      $fclose(file);
      $display("Hex value written to file!");


        $display(rom_memory[0]);
        $display(textFile[0]);
        $display(textFile[3]);

        $finish;
    end

endmodule




// module encoder(
//   input clk, 
//   input enable, 
//   input [31:0] numPixels, 
//   input startAddress [31:0], 
//   input [31: 0] size, 
//   output [31: 0] outAddress,
//   output [23: 0] data
  
  
//   );

//   parameter SIZE = 32*32;
//   parameter numStringBits = 184;

//   output reg data [(size*24)-1: 0]
//   reg [23:0] imageFile [SIZE-1:0];
//   reg [3:0] textFile [numStringBits-1:0];

//   $readmemh("output.mem", rom_memory);
//   $readmemh("input_string.mem", textFile);

//   for (int i=0; i<SIZE; i++) begin
//     assign data [((i+1)*24)-1, (i*24)] <= {imageFile[startAddress+4-1:startAddress], textFile[0:0]};

//   end


// endmodule

// `timescale 1ns / 1ps

// module testBench;
//     reg clk;
//     wire [31:0] sine; //make bigger for amplitude 32
    
//     //initates and connects the sine generator to the testBench
//     sine_gen (
//         .clk (clk),
//         .sineOutput (sine)
//     );
    
    
//     //frequency control
// //    parameter freq = 100000000; //100 MHz
//     parameter freq_GHz = 0.1;
//     parameter SIZE = 1024; 
//     parameter clockRate = (1/(freq_GHz*SIZE*2));
// //    parameter clockRate = 0.2;
// //    parameter clockRate = 0.0048828125; //clock time (make this an output from the sine modules)
    
//     //Generate a clock with the above frequency control
//     initial
//     begin 
//     clk = 1'b0;
//     end
//     always #clockRate clk = ~clk; //#1 is one nano second delay (#x controlls the speed)
// endmodule

