# EEE4120F YODA Project
## Group 27
### Sebastian Haug (HGXSEB001)
### Gabriel Nichollas (NCHGAB001)
### Msimamisi Lushaba (MWNMSI001)
### Hope Ngwenya (NGWHOP001)

Please do not copy unless given explicit permission by the authors

## Important files:
1. string_encode.py: used for preprocessing the input string and generating the encryption key
2. ppm_to_mem.py: used for preprocessing the image for Verilog. Writes ppm image into a hex format.
3. parallelISE.v: Verilog testbench to simulate the FPGA in Vivado.
4. ISE.v: Verilog testbench golden measure to simulate sequential execution in vivado.
5. mem_to_ppm.py: reconstruct a ppm image from a processed .mem file
6. extract_message.py: Perform image steganography decoding on a given .ppm image

## How to run:
1. Generate the input string mem file using the string_encode script.
    Note that you will have to change the input string and output file path in code
    Open the generated file and take note of its length
2. Generate the encryption key mem file using the string_encode script.
    Note that you will have to change the key string and output file path in code
    Open the generated file and take note of its length
3. Generate the image mem file by running the PPM_to_mem script
    Inspect the original image and take note of its width and height in pixels
4. Perform encryption and encoding by running the parallelISE.v or ISE.v files in vivado or using   Iverilog compiler
    Note that you will need to change the numImagePixels, numStringBits and numKeyBits to the corresponding numbers observed earlier.
    It may also be necessary to change the output file path
5. Reconstruct the encoded image using the mem_to_ppm script.
    Note that you will need to input the image dimensions and path to the mem file generated in step 4.
6. To validate that the encoding is correct, run the exctract_message script to recover the message