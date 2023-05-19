

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

  // register to indicate when done
  reg done_processing = 1'b0;
  // when reset signal transitions from low to high, reset
  always @(posedge reset) begin
    // show that not done
    done_processing =1'b0;
  end

  //everytime enable transitions from low to high
  always @(posedge enable) begin 
    // perform LSB steganography
    temp[7:0] = {imageByte[7:1], textBits[0:0]};
    // temp[7:0] = {imageByte[7:6], textBits[0:0], 5'b11};
    
    #1;
    
    // show that processing is done
    done_processing = 1'b1;
      
  end
  // connect temp register to output
  assign outByte[7:0] = temp[7:0];
  // connect the done processing bit to the output wire
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
  // define a register to indicate when processing is done
  reg [0:0] done_processing = 1'b0;

// when the reset signal transitions from low to high,
  always @(posedge reset) begin
// change to show that processing is not done
    done_processing = 1'b0;
  end

// when enabled, perform encryption on one bit of data
  always @(posedge enable) begin
    // discard first 3 bits of the hex value
    temp[3:1] = 3'b0;
    // perform encryption
    temp = txtBit ^ keyBit;
    
    #1;
    // indicate that the module is done
    done_processing = 1'b1;
    
    
  end
  // assign encryptedBit[3:1] = 3'b0;
  // wire data to output
  assign encyptedBit[3:0] = temp[3:0];
  // wire the processing status to the output
  assign done = done_processing;

endmodule

// module for testing
module parallel_tb();
    
//    define some constants
    reg clk, reset, enableEncrypt, enableDecrypt, enableISE;

    


    
// define constants, to be set as inputs in future
  parameter numImagePixels = 32*32*3;
  parameter numStringBits = 2528;
  parameter numKeyBits = 208;


// register to store the status of all instances
  reg processing_status [numImagePixels-1:0];

  // registers for storing file contents
  reg [7:0] imageFile [numImagePixels-1: 0];
  reg [3:0] textFile [numStringBits-1: 0];
  reg [3:0] keyFile [numKeyBits-1:0];

// define busses to store whether or not each module is done
  wire [numStringBits-1:0] encryptStatus;
  wire [numStringBits-1:0] decryptStatus;
  wire [numStringBits-1:0] processStatus;

// create wires to connect modules to eachother and observe the status of the system
  wire encryptDone;
  wire decryptDone;
  wire processDone;

// perform reduction and operation on the status busses to know when the processing is done
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

        // encrypt. enabled by the enableEncrypt signal
          EnDeCrypt encryption(clk, enableEncrypt, textFile[k], keyFile[k%numKeyBits], encryptStatus[k], encryptWire[k]);
          // decrypt. Enabled by the encryptDone wire so that only starts when done
          EnDeCrypt decryption(clk, encryptDone, encryptWire[k], keyFile[k%numKeyBits], decryptStatus[k], decryptWire[k]);
          // perform ISE. Enabled by the decryptDone wire so that only starts when done
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

    // define reset state
    reset = 1'b0;
    // set enable to low
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
    // reset all modules
    reset = 1'b1;
    #5
    // enable to high to start processing
    enableEncrypt = 1'b1;

// wait until processing is done
    while (processDone != 1'b1) begin
      #5;
    end
// write processed data to output file
    file = $fopen("output.txt", "w");
    for (i =0; i<numImagePixels; i = i +1) begin
        $fwrite(file, "%h\n", outBuffer[i]);
    end
    $fclose(file);
  end
endmodule
