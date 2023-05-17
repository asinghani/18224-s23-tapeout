import os
import glob

sources = []

insts = ["" for _ in range(64)]

SKIP_DESIGNS = ["d10_wabib_tictactoe"]

# Populate all slots with placeholder
# which will be replaced if there exists a design
for i in range(64):
    insts[i] = ""
    insts[i] += f"// Design #{i}\n"
    insts[i] += f"// Unpopulated design slot\n"
    insts[i] += f"assign des_io_out[{i}] = 12'h000;\n"


for des in sorted(list(glob.glob("../designs/d*"))):
    name = os.path.basename(des)
    idx = int(name.split("_")[0].replace("d", ""))

    if name in SKIP_DESIGNS:
        print("Skipping", idx, name, des)
        continue

    sources.append(os.path.join(des, "flattened.v"))
    print(idx, name, des)
    insts[idx] = ""
    insts[idx] += f"// Design #{idx}\n"
    insts[idx] += f"// Design name {name}\n"
    insts[idx] += f"{name} inst{idx} (\n"
    insts[idx] += f"    .io_in({{des_reset[{idx}], clock, des_io_in[{idx}]}}),\n"
    insts[idx] += f"    .io_out(des_io_out[{idx}])\n"
    insts[idx] += f");\n"

insts = "\n\n".join(insts)

with open("insts.sv.template") as f:
    insts = f.read().replace(r"{INSTANCES}", insts)

with open("insts_generated.sv", "w+") as f:
    f.write(insts)

sources += ["multiplexer.sv", "insts_generated.sv"]

with open("sources.txt", "w+") as f:
    f.write(" ".join(sources))

os.system("sv2v "+(" ".join(sources))+" > merged.v")
os.system("yosys -p 'read_verilog merged.v; proc; flatten; select design_instantiations; write_verilog -selected design_instantiations_flattened.v;'")
