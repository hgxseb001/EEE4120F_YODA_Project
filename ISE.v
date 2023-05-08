module ISE;
  parameter numImagePixels = 32 * 32;
  parameter numStringBits = 184;
  reg [23:0] imageFile [numImagePixels-1: 0];
  reg [3:0] textFile [numStringBits-1: 0];

  reg [23:0] outBuffer [numImagePixels-1: 0];
  // reg  temp [23:0];

    integer file;
    integer i;

  initial begin
    $readmemh("output.mem", imageFile);
    $readmemh("input_string.mem", textFile);
    for (i = 0; i < numImagePixels; i = i + 1) begin

      if (i < numStringBits) begin
        // temp = {imageFile[23:1][i], textFile[0:0][i]}; 
        // outBuffer[23:1][i] <= imageFile[23:1][i];
        // outBuffer[23:0][i] <= textFile[0:0][i];
        outBuffer[i] <= {imageFile[i][23:1], textFile[i][0:0]};
        // $display(outBuffer[i]);
      end
      else begin
        outBuffer[i] <= imageFile[i];
      end
    end

    #10000;


    file = $fopen("output.txt", "w");
    if (file == 0) begin
      $display("Error opening file!");
    // $finish;
    end
    for (i =0; i<numImagePixels; i = i +1) begin
      $fwrite(file, "%h\n", outBuffer[i]);
    end
    $fclose(file);
    
  end

endmodule