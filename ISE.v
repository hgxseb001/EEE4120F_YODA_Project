
// define module for Image Steganography Encoder
module ISE;
// define constants, to be set as inputs in future
  parameter numImagePixels = 32*32*3;
  parameter numStringBits = 2976;
  parameter numKeyBits = 208;

  // registers for storing file contents
  reg [7:0] imageFile [numImagePixels-1: 0];
  reg [3:0] textFile [numStringBits-1: 0];
  reg [3:0] keyFile [numKeyBits-1:0];

  // buffer to temporarily store processed pixels
  reg [3:0] encryptedString [numStringBits-1:0];
  reg [3:0] decryptedString [numStringBits-1:0];
  
  reg [7:0] outBuffer [numImagePixels-1: 0];
  
  reg encryptStatus = 1'b0;
  reg decryptStatus = 1'b0;
  reg processStatus = 1'b0;
  // reg  temp [23:0];

    // some integers 
    integer file;
    integer i;

// begin testing
  initial begin
    // read file content
    $readmemh("output.mem", imageFile);
    $readmemh("input_string.mem", textFile);
    $readmemh("encryption_key.mem", keyFile);
    
    // loop over colour channels
    // show that encryption has started
    encryptStatus = 1'b1;
    for (i=0; i<numStringBits; i = i +1) begin

        // perform encryption:
        // write first 3 bits to 0 since working with 4 bit hex vals
        encryptedString [i][3:1] <= 3'b0;
        // perform encryption by XOR with symmetric key
        encryptedString[i] [0:0] <= textFile[i][0:0] ^ keyFile[i%numKeyBits][0:0]; 
        #1;   
    end
    // show that encryption has ended
    encryptStatus = 1'b0;
    
    // show that decryption has started
    decryptStatus = 1'b1;
    // loop over each color val
    for (i=0; i<numStringBits; i = i +1) begin
      // discard first 3 bits
        decryptedString [i][3:1] <= 3'b0;
        // perform decryption by XOR
        decryptedString[i] [0:0] <= encryptedString[i][0:0] ^ keyFile[i%numKeyBits][0:0]; 
        #1;   
    end
    // show that decryption has ended
    decryptStatus = 1'b0;
    
    // show that processing has started
    processStatus = 1'b1;
    for (i = 0; i < numImagePixels; i = i + 1) begin
      // while bits are still available in text file do LSB encoding
      if (i < numStringBits) begin

        outBuffer[i] <= {imageFile[i][7:1], decryptedString[i][0:0]};
        #1;
        // $display(outBuffer[i]);
      end
      else begin
        // otherwise just image channels to output
        outBuffer[i] <= imageFile[i];
        #1;
      end
    end
    
    processStatus = 1'b0;

    // write processed image to output file
    file = $fopen("output.txt", "w");

    // check that file opens correctly
    if (file == 0) begin
      $display("Error opening file!");
    // $finish;
    end

    // write encoded image to file
    for (i =0; i<numImagePixels; i = i +1) begin
      $fwrite(file, "%h\n", outBuffer[i]);
    end
    $fclose(file);
    
  end

endmodule