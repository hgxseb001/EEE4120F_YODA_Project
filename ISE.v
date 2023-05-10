
// define module for Image Steganography Encoder
module ISE;
// define constants, to be set as inputs in future
  parameter numImagePixels = 32*32*3;
  parameter numStringBits = 344;

  // registers for storing file contents
  reg [7:0] imageFile [numImagePixels-1: 0];
  reg [3:0] textFile [numStringBits-1: 0];

  // buffer to temporarily store processed pixels
  reg [7:0] outBuffer [numImagePixels-1: 0];
  // reg  temp [23:0];

    // some integers 
    integer file;
    integer i;

// begin testing
  initial begin
    // read file content
    $readmemh("output.mem", imageFile);
    $readmemh("input_string.mem", textFile);
    // loop over colour channels
    for (i = 0; i < numImagePixels; i = i + 1) begin
      // while bits are still available in text file do LSB encoding
      if (i < numStringBits) begin

        outBuffer[i] <= {imageFile[i][7:1], textFile[i][0:0]};
        // $display(outBuffer[i]);
      end
      else begin
        // otherwise just image channels to output
        outBuffer[i] <= imageFile[i];
      end
    end

    #10000;

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