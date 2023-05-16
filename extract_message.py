# import image library
from PIL import Image

# define a function
def decode_image(image_file):

    # containers to store data
    binary_data = ""
    message = ""

    #open the image and get size
    with Image.open(image_file) as img:
        width, height = img.size
        
        # loop over image pixels
        for y in range(height):
            for x in range(width):
                # read a pixel
                pixel = img.getpixel((x,y))
                # extract LSB
                binary_data += bin(pixel[0])[-1]
                binary_data += bin(pixel[1])[-1]
                binary_data += bin(pixel[2])[-1]
        
        # loop over all LSB's
        for i in range(0, len(binary_data), 8):
            # condense bits into string
            message += chr(int(binary_data[i:i+8], 2))
        
        # return the message
        return message

# instantiate object and extract message
image_file = "yoda_reconstructed.ppm"

encryption_key = "VERY_SECURE_ENCRYPTION_KEY"
keyLen = len(encryption_key)

import bitarray

# create list to store bits
l = []

# create bitarray object
bA = bitarray.bitarray()
# extract bits
bA.frombytes("VERY_SECURE_ENCRYPTION_KEY".encode('utf-8'))
# create list of bits
l = bA.tolist()
decrypted_string = ""
message = decode_image(image_file)
for i in range(len(message)):   
    decrypted_string += chr(message[i] ^ encryption_key[i%keyLen])


print("The hidden message is:", decrypted_string)