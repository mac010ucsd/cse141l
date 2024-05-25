# note: requires asstable.txt
#       requires assfile.txt (putyour assembly file here)
# output: output.txt

f = ""
assfile = ""
outfile = ""
with open("asstable.txt", "r") as t:
    f = t.read()

with open("assfile.txt", "r") as t:
    assfile = t.read()

ins_name = []
op_format = []
op_bits = []
opcode_bible = {}

lines = [i.strip() for i in f.split("\n")]
for i in range(len(lines)):
    if "bit op" in lines[i]:
        ins_name.append(lines[i-1])
        op_format.append(lines[i])
        op_bits.append(lines[i+1])

for i in range(len(ins_name)):
    if ins_name[i] not in opcode_bible:
        opcode_bible[ins_name[i]] = {}
    j = op_format[i].strip().split("] ")
    j = [k.strip() for k in j]
    print(j)
    opcode_bible[ins_name[i]][len(j)] = {
        "op_code": op_bits[i],
        "op_len": len(op_bits[i]),
        "op_1": int(j[1][1:2]),
        "op_2": 0 if len(j) <= 2 else int(j[2][1:2])
    }

# f"{z:b}"
assfile = assfile.strip()
assfile = assfile.replace("\n\n", "\n")
assfile = assfile.split("\n")

outfile = ""
for i in assfile:
    print(i)
    i = i.strip().split()
    print(i)
    # print(i[0][len(i)])
    outline = ""
    outline += opcode_bible[i[0]][len(i)]["op_code"] # + " "
    t = int(i[1]) if "reg" not in i[1] else int(str(i[1]).replace("reg", ""))
    outline += f"{t:09b}"[8 - opcode_bible[i[0]][len(i)]["op_1"]:-1] # + " "
    if len(i) > 2:
        t = int(i[2]) if "reg" not in i[2] else int(str(i[2]).replace("reg", ""))
        outline += f"{t:09b}"[8 - opcode_bible[i[0]][len(i)]["op_2"]:-1] # + " "
    outfile += outline + "\n"

print(outfile)

with open("output.txt", "w") as t:
    t.write(outfile)
