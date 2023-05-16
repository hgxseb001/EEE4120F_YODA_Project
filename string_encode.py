import bitarray

# create list to store bits
l = []

# create bitarray object
bA = bitarray.bitarray()
# extract bits
bA.frombytes("Sample Text-Sample Text-Sample Text-Sample Text-Sample Text-Sample Text-Sample Text-Sample Text-Sample Text-Sample Text-Sample Text-Sample Text-Sample Text-Sample Text-Sample Text-Sample Text-Sample Text-Sample Text-Sample Text-Sample Text-Sample Text-Sample Text-Sample Text-Sample Text-Sample Text-Sample Text-Sample Text-Sample Text-Sample Text-Sample Text-Sample Text-".encode('utf-8'))
# create list of bits
l = bA.tolist()

# write bits to output file
with open("input_string.mem", "w") as output_file:
    for item in l:
        output_file.write(str(item) + "\n")
