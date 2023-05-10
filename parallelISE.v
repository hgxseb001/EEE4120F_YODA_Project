module ParallelISE(
  input clk,
  input enable,
  input [7:0] imageByte,
  input [3:0] textBits,
  
  output [7:0] outByte
  );
  // register to store ISE byte temporarily
  reg [7:0] temp;

  //everytime enable transitions from low to high
  always @(posedge enable) begin 
    // perform LSB steganography
    temp[7:0] = {imageByte[7:1], textBits[0:0]};
      
  end
  // connect temp register to output
  assign outByte[7:0] = temp[7:0];
    
endmodule

module parallel_tb();
    
//    define some constants
    reg clk, reset, enable;
    reg status = 1'b0;
    reg done_processing;

    
// define constants, to be set as inputs in future
  parameter numImagePixels = 32*32*3;
  parameter numStringBits = 1040;


// register to store the status of all instances
  reg processing_status [numImagePixels-1:0];

  // registers for storing file contents
  reg [7:0] imageFile [numImagePixels-1: 0];
  reg [3:0] textFile [numStringBits-1: 0];

  

  // buffer to temporarily store processed pixels

  wire [7:0] outBuffer [numImagePixels-1: 0];

// variable to store output file path
  integer file;

  // integer for looping
  integer i = 0;
//   variable for creating instances
  genvar k;
// generate multiple instances (one per colour channel)
  generate
    for (k=0; k<numImagePixels; k = k+1) begin
      // check for end of string message
      if (k < numStringBits) begin
        // do the processing
          ParallelISE name(clk, enable,imageFile[k],textFile[k],outBuffer[k]);
      end
      // if not longer, write image to output
      else begin
          assign outBuffer[k] = imageFile[k];
      end
    end
  endgenerate

// start testing
  initial begin
    // set enable low
    enable = 1'b0;
    clk = 1'b0;
    // read input file data
    $readmemh("output.mem", imageFile);
    $readmemh("input_string.mem", textFile);
// set enable high to start processing
    enable = 1'b1;
// delay
    #100
// write processed data to output file
    file = $fopen("output.txt", "w");
    for (i =0; i<numImagePixels; i = i +1) begin
        $fwrite(file, "%h\n", outBuffer[i]);
    end
    $fclose(file);
  end
endmodule