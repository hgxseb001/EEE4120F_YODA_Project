input_str = "hello cruel cruel world"

def string_to_bits(string):
    bits = []
    for char in string:
        byte = ord(char)
        for bit in range(8):
            bits.append((byte >> bit) & 1)
    return bits

bits = string_to_bits(input_str)

with open("input_string.mem", "w") as output_file:
    for bit in bits:
        output_file.write(str(bit) + "\n")