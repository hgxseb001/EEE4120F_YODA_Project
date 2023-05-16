

module ParallelISE(
  input reset,
  input enable,
  input [7:0] imageByte,
  input [3:0] textBits,
  
  output done,
  output [7:0] outByte
  );
  // register to store ISE byte temporarily
  reg [7:0] temp;
  reg done_processing = 1'b0;
  always @(posedge reset) begin
    done_processing =1'b0;
  end

  //everytime enable transitions from low to high
  always @(posedge enable) begin 
    // perform LSB steganography
    // temp[7:0] <= {imageByte[7:1], textBits[0:0]};
    temp[7:0] = {imageByte[7:3], textBits[0:0], 2'b0};
    
    #1;
    
    done_processing = 1'b1;
      
  end
  // connect temp register to output
  assign outByte[7:0] = temp[7:0];
  assign done = done_processing;
    
endmodule


// define a module for encryption and decryption
module EnDeCrypt(
    input reset,
    input enable,
    input [3:0] txtBit,
    input [3:0] keyBit,
    output done,
    output [3:0] encyptedBit
  );

  // register to temporarily store data
  reg [3:0] temp;
  reg [0:0] done_processing = 1'b0;

  always @(posedge reset) begin

    done_processing = 1'b0;
  end

// when enabled, perform encryption on one bit of data
  always @(posedge enable) begin
    
    temp[3:1] = 3'b0;
    // perform encryption
    temp = txtBit ^ keyBit;
    
    #1;
    
    done_processing = 1'b1;
    
    
  end
  // assign encryptedBit[3:1] = 3'b0;
  assign encyptedBit[3:0] = temp[3:0];
  assign done = done_processing;

endmodule


module parallel_tb();
    
//    define some constants
    reg clk, reset, enableEncrypt, enableDecrypt, enableISE;

    


    
// define constants, to be set as inputs in future
  parameter numImagePixels = 32*32*3;
  parameter numStringBits = 2976;
  parameter numKeyBits = 208;


// register to store the status of all instances
  reg processing_status [numImagePixels-1:0];

  // registers for storing file contents
  reg [7:0] imageFile [numImagePixels-1: 0];
  reg [3:0] textFile [numStringBits-1: 0];
  reg [3:0] keyFile [numKeyBits-1:0];

  wire [numStringBits-1:0] encryptStatus;
  wire [numStringBits-1:0] decryptStatus;
  wire [numStringBits-1:0] processStatus;

  wire encryptDone;
  wire decryptDone;
  wire processDone;

  assign encryptDone = &encryptStatus;
  assign decryptDone = &decryptStatus;
  assign processDone = &processStatus;

  

  // buffer to temporarily store processed pixels

  wire [7:0] outBuffer [numImagePixels-1: 0];

  wire [3:0] encryptWire [numStringBits-1:0];
  wire [3:0] decryptWire [numStringBits-1:0];

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

        // encrypt
          EnDeCrypt encryption(clk, enableEncrypt, textFile[k], keyFile[k%numKeyBits], encryptStatus[k], encryptWire[k]);
          // decrypt
          EnDeCrypt decryption(clk, encryptDone, encryptWire[k], keyFile[k%numKeyBits], decryptStatus[k], decryptWire[k]);
          // perform ISE
          ParallelISE ISEProcessor(clk, decryptDone,imageFile[k],decryptWire[k],processStatus[k], outBuffer[k]);
      end
      // if string shorter than image, write image to output
      else begin
          assign outBuffer[k] = imageFile[k];
      end
    end
  endgenerate

// start testing
  initial begin
    // set enable low

    reset = 1'b0;
    enableEncrypt = 1'b0;

    #5
    // enableDecrypt = 1'b0;
    // enableISE = 1'b0;

    clk = 1'b0;
    // read input file data
    $readmemh("output.mem", imageFile);
    $readmemh("input_string.mem", textFile);
    $readmemh("encryption_key.mem", keyFile);
// set enable high to start processing
    reset = 1'b1;
    #5
    enableEncrypt = 1'b1;

    while (processDone != 1'b1) begin
      #5;
    end
//    #100
//     enableDecrypt = 1'b1;
// //    #100
    
//     enableISE = 1'b1;
// delay
//    #100
// write processed data to output file
    file = $fopen("output.txt", "w");
    for (i =0; i<numImagePixels; i = i +1) begin
        $fwrite(file, "%h\n", outBuffer[i]);
    end
    $fclose(file);
  end
endmodule
