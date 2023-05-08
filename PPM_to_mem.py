#open file
with open("Yoda1.ppm", "rb") as ppm_file, open("output.mem", "w") as mem_file:
    # Read the header of the PPM file
    header = ppm_file.readline().decode().strip()
    # check that ppm file is valid
    if header != "P6":
        raise ValueError("Input file is not a PPM file!")
    # read image dimensions
    dimensions = ppm_file.readline().decode().split()
    width, height = int(dimensions[0]), int(dimensions[1])
    max_val = int(ppm_file.readline().decode().strip())

    # Write the RGB values to the output file as hex numbers
    for y in range(height):
        for x in range(width):
            r, g, b = ppm_file.read(3)
            # write one colour channel per line
            mem_file.write("{:02X}\n".format(r))
            mem_file.write("{:02X}\n".format(g))
            mem_file.write("{:02X}\n".format(b))

