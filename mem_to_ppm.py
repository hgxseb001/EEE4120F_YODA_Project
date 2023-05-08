# function to reconstruct image
def mem_to_ppm(input_file, output_file, width, height):
    with open(input_file, "r") as mem_file, open(output_file, "wb") as ppm_file:
        # Write the header of the PPM file
        ppm_file.write(b"P6\n")
        ppm_file.write(f"{width} {height}\n".encode())
        ppm_file.write(b"255\n")

        # Write the RGB values to the output file
        for i in range(width * height):
            # extract pixels
            r = int(mem_file.readline().strip(), 16)
            g = int(mem_file.readline().strip(), 16)
            b = int(mem_file.readline().strip(), 16)
            
            #pixel = mem_file.readline().strip()
            #r, g, b = int(pixel[0:2], 16), int(pixel[2:4], 16), int(pixel[4:6], 16)
            # write bytes to file
            ppm_file.write(bytes([r, g, b]))


    print("PPM file created successfully!")

# call function
mem_to_ppm('output.txt', 'yoda_reconstructed.ppm', 1600, 1920)
