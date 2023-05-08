# string to encode
input_str = "I don't like sand. \
It's coarse and rough and irritating and it gets everywhere. \
Not like here. \
Here everything is soft and smooth."

# define function to split string into bits
def string_to_bits(string):
    # array to store bits
    bits = []
    # loop over characters
    for char in string:
        byte = ord(char)
        for bit in range(8):
            # for bit in byte, append bit to bits array
            bits.append((byte >> bit) & 1)
    # return the bits array
    return bits

# invoke the function
bits = string_to_bits(input_str)

# write bits to mem file
with open("input_string.mem", "w") as output_file:
    for bit in bits:
        output_file.write(str(bit) + "\n")