import bitarray

# create list to store bits
l = []

# create bitarray object
bA = bitarray.bitarray()
# extract bits
bA.frombytes("L39kq,XRryh3pRL(!B{9dT;VfFj8d@.k@(3Ep4[Ww]Xg7Hke&7X/eyydy_7a_T-U,G*:}?:V%]EAD.[GS3/24{{6&u@L.Se?Bz;(N=MA;4$caH*;u,D*N2ba:iek+cLE%P:&Y-ge.UJ(G.X:z7pu,:?m[FDWaDaSA{];UD4,hA+5npg[b.5*-LNt_qm2Hc,i}T;3pfm)-TPK.VeEPhRjPD{r-#y4v#DgPwH.BC-@C($}@L[/;xY)z?d-zazDFS2D:krj.avfS/@&[J6jfuy}nBzLRhETLf7XJj:6YXq=DPBMa-nLNL&W}-123456".encode('utf-8'))
# create list of bits
l = bA.tolist()

# write bits to output file
with open("input_string.mem", "w") as output_file:
    for item in l:
        output_file.write(str(item) + "\n")
